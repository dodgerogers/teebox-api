class Video < ActiveRecord::Base
  
  #attr_accessible :file, :screenshot, :job_id, :status, :name, :duration, :location
  
  has_many :questions, through: :playlists, counter_cache: true
  has_many :playlists
  belongs_to :user
  
  validates_presence_of :user_id, :file
  
  default_scope { order('created_at DESC') }
    
  def to_param
    "#{id} - #{File.basename(self.file)}".parameterize
  end
  
  # ========= Should be in the AWS Repo ============== 
  def aws_file_key(attribute=:file)
    self.send(attribute).gsub("http://#{CONFIG[:s3_bucket]}.s3.amazonaws.com/", '') if self.send(attribute)
  end
  
  def delete_aws_key
    folder = File.split(self.file)[0].split("/")[3..-1].join("/")
    AWS::S3.new.buckets[CONFIG[:s3_bucket]].objects.with_prefix(folder).delete_all
  end
end