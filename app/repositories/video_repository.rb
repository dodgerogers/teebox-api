class VideoRepository < BaseRepository
  
  def self.find_by_job_and_update(attrs)
    raise ArgumentError, "#{attrs.class} is not a valid args hash" unless attrs.is_a?(Hash)
    video = Video.where(job_id: attrs[:job_id]).first
    
    if video && attrs[:status] == AwsVideoPayloadRepository::COMPLETED_STATUS
      aws = AWS::S3.new
      p aws.buckets
      bucket = aws.buckets[CONFIG[:s3_bucket]]
      p bucket
      object = bucket.objects[video.aws_file_key]
      p object
      object.delete if object
 
      attrs.merge!(file: attrs[:file], screenshot: attrs[:screenshot])
    end
    video.update_attributes(attrs.except(:job_id))
  end
end