class AddFeaturedToJobPosts < ActiveRecord::Migration
  def change
    add_column :job_posts, :featured, :boolean
  end
end
