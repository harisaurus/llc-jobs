class UserMailer < ActionMailer::Base
  default from: "no-reply@canadalearningcode.ca"

  def confirmation_email(email, job_post)
    @job_post = job_post
    mail(to: email, subject: "Your Job Post with Canada Learning Code")
  end

  def confirmation_email_for_feature(email, job_post)
    @job_post = job_post
    mail(to: email, subject: "Your Job Post has been Featured")
  end
end
