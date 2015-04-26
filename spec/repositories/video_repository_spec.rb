require "spec_helper"

describe VideoRepository do
  before(:each) do
    @video = create(:video, job_id: "1234")
    @object = double("object", delete: true)
    @bucket = double("bucket", objects: { @video.aws_file_key => @object })
    @aws = double('aws', buckets: { CONFIG[:s3_bucket] => @bucket})
    AWS::S3.stub(:new).and_return @aws
  end
  
  describe "#find_by_job_and_update" do
    it "successfully finds video and updates with attributes" do
      VideoRepository.find_by_job_and_update(attributes_hash)
      
      @video.reload
      @video.file.should eq "new_file.mp4"
      @video.screenshot.should eq "new_screenshot.jpg"
      @video.status.should eq "COMPLETED"
    end
    
    it "successfully finds video and updates with state when an error occurs" do
      VideoRepository.find_by_job_and_update(err_attributes_hash)
      
      @video.reload
      @video.status.should eq "ERROR"
      @video.file.should_not eq "new_file.mp4"
      @video.screenshot.should_not eq "new_screenshot.jpg"
    end
    
    it "raises error when attrs is not a hash" do
      string_arg = "invalid args"
      expect { 
        VideoRepository.find_by_job_and_update(string_arg) 
      }.to raise_error(ArgumentError, "#{string_arg.class} is not a valid args hash")
    end
  end
  
  def attributes_hash
    {
      job_id: "1234",
      file: "new_file.mp4",
      screenshot: "new_screenshot.jpg",
      status: "COMPLETED",
    }
  end
  
  def err_attributes_hash
    {
      job_id: "1234",
      status: "ERROR",
    }
  end
end