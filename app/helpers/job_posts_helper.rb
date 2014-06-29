module JobPostsHelper
  def expiry_info(job_post)
    if job_post.expires_in > 0
      "Active for another #{pluralize(job_post.expires_in, "day")}"
    else
      "Will expire today"
    end
  end

  def show_publish?(job_post)
    job_post.publishable? && job_post.by_user? && current_user.id == job_post.user_id
  end

  def show_feature?(job_post)
    job_post.active? && job_post.by_user? && current_user.id == job_post.user_id && !job_post.featured
  end
end
