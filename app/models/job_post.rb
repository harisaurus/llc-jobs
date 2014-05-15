class JobPost < ActiveRecord::Base
  belongs_to :category
  belongs_to :job_type
  belongs_to :user
  belongs_to :admin

  has_many :job_applications
  has_many :transactions

  acts_as_taggable

  default_scope { order(created_at: :desc) }

  scope :by_category, lambda { |category_id| where("category_id = ?", category_id) }
  scope :by_job_type, lambda { |job_type_id| where("job_type_id = ?", job_type_id) }
  scope :active, lambda { where("state = 'active'") }
  scope :expired, lambda { where("expires_at < ?", Time.now) }

  validates_presence_of :title, :description, :job_type_id, :category_id, :due_date, :city, :country, :company, :how_to_apply

  state_machine :initial => :not_approved do
    before_transition [:not_approved, :rejected, :expired] => :active, :do => [:set_expiry_date, :set_old_date]

    event :activate do
      transition [:not_approved, :rejected, :expired] => :active
    end

    event :reject do
      transition all => :rejected
    end

    event :expire do
      transition all => :expired
    end

    event :hide do
      transition :active => :hidden
    end

    event :show do
      transition :hidden => :active
    end
  end

  def publishable?
    not_approved? or expired?
  end

  def charge(token, email)
    charge = Stripe::Charge.create(
      :amount => 3000,
      :currency => "cad",
      :card => token,
      :description => "#{email} paid for #{title}"
    )

    if charge["paid"] && !charge["failure_code"]
      transactions.create(stripe_response: charge)
      activate
      UserMailer.confirmation_email(email, self).deliver
    elsif charge["failure_message"]
      raise StandardError, "Credit card charge failed with this message: #{charge["failure_message"]}"
    end
  end

  def is_fresh?
    Time.now.to_date < old_at.to_date
  end

  def expires_in
    (expires_at.to_date - Time.now.to_date).to_i
  end

  def self.hide_expired
    JobPost.expired.each { |post| post.expire }
  end

  private
  def set_old_date
    update(old_at: 3.days.from_now)
  end

  def set_expiry_date
    update(expires_at: 30.days.from_now)
  end
end
