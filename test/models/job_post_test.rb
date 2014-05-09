require 'test_helper'

class JobPostTest < ActiveSupport::TestCase
  def setup
    @job_post = job_posts(:posting)
  end

  test "#hide_expired hides expired job postings" do
    @job_post.activate
    @job_post.update_attributes!(expires_at: Time.now - 1.hour)

    JobPost.hide_expired

    assert @job_post.reload.expired?
  end

  test "#activate sets expiry date to 30 days from now" do
    @job_post.reject
    @job_post.activate

    assert_equal (Time.now+30.days).utc.to_s(:db), @job_post.reload.expires_at.to_s(:db)
  end
end
