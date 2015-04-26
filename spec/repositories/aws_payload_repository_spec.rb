require "spec_helper"

describe AwsVideoPayloadRepository do
  before(:each) do
    @video = create(:video)
  end
  
  describe "retrieve_payload" do
    describe "success when state COMPLETED" do
      it "creates attributes hash" do
        attributes_hash = AwsVideoPayloadRepository.retrieve_payload(JSON.parse(success_json_response, symbolize_names: true))
        
        attributes_hash.should be_a(Hash)
        attributes_hash.length.should eq 5
        
        attributes_hash[:job_id].should eq "1395783182474-246e34"
        attributes_hash[:status].should eq "COMPLETED"
        attributes_hash[:duration].should eq 10
        attributes_hash[:file].should eq "http://teebox-network-dev.s3.amazonaws.com/uploads/video/ca14ba7a-c442-4f9f-a75a-c45cfedb8947/IMG_0587.mp4"
        attributes_hash[:screenshot].should eq "http://teebox-network-dev.s3.amazonaws.com/uploads/video/ca14ba7a-c442-4f9f-a75a-c45cfedb8947/IMG_0587-00001.jpg"
      end
      
      it "creates attributes hash from parsed json string" do
        attributes_hash = AwsVideoPayloadRepository.retrieve_payload(json_response_with_string_message)
        
        attributes_hash.should be_a(Hash)
        attributes_hash.length.should eq 5
        
        attributes_hash[:job_id].should eq "1410722934359-0z1qw1"
        attributes_hash[:status].should eq "COMPLETED"
        attributes_hash[:duration].should eq 10
        attributes_hash[:file].should eq "http://teebox-network-dev.s3.amazonaws.com/uploads/video/b59657e5-eb4a-4304-a0b1-bb6169a55f59/Good_7iron-1.mp4"
        attributes_hash[:screenshot].should eq "http://teebox-network-dev.s3.amazonaws.com/uploads/video/b59657e5-eb4a-4304-a0b1-bb6169a55f59/Good_7iron-00001.jpg"
       end 
    end
  
    describe "failure" do
      it "saves error status" do
        attributes_hash = AwsVideoPayloadRepository.retrieve_payload(JSON.parse(err_json_response, symbolize_names: true))
        
        attributes_hash.should be_a(Hash)
        attributes_hash.length.should eq 2
        
        attributes_hash[:job_id].should eq "1395783182474-246e34"
        attributes_hash[:status].should eq "ERROR"
      end
    end
  end
  
  
  def success_json_response
    '{
        "Type": "Notification",
        "MessageId": "fa12b8a4-3c7d-5a48-9927-f308e33212ae",
        "TopicArn": "arn:aws:sns:us-east-1:377092858912:Teebox_processing_DEV",
        "Subject": "Amazon Elastic Transcoder has finished transcoding job 1395842307445-2sfq4p.",
        "Message": {
            "state": "COMPLETED",
            "version": "2012-09-25",
            "jobId": "1395783182474-246e34",
            "pipelineId": "1395619455453-yghva8",
            "input": {
                "key": "uploads/video/ca14ba7a-c442-4f9f-a75a-c45cfedb8947/IMG_0587.MOV",
                "frameRate": "auto",
                "resolution": "auto",
                "aspectRatio": "auto",
                "interlaced": "auto",
                "container": "auto"
            },
            "outputKeyPrefix": "uploads/video/ca14ba7a-c442-4f9f-a75a-c45cfedb8947/",
            "outputs": [
                {
                    "id": "1",
                    "presetId": "1395783135978-fq7lgp",
                    "key": "IMG_0587.mp4",
                    "thumbnailPattern": "IMG_0587-{count}",
                    "rotate": "auto",
                    "status": "Complete",
                    "duration": 10,
                    "width": 270,
                    "height": 480
                }
            ]
        }
    }'
  end
  
  def json_response_with_string_message
    {
      :Type=>"Notification", 
      :MessageId=>"7ba13301-3720-5a40-979e-7f8ed9e1818c", 
      :TopicArn=>"arn:aws:sns:us-east-1:377092858912:Teebox_video_processing_PRODUCTION", 
      :Subject=>"Amazon Elastic Transcoder has finished transcoding job 1410722934359-0z1qw1.", 
      :Message=>"{\n  \"state\" : \"COMPLETED\",\n  \"version\" : \"2012-09-25\",\n  \"jobId\" : \"1410722934359-0z1qw1\",\n  \"pipelineId\" : \"1395625126367-oqk7mn\",\n  \"input\" : {\n    \"key\" : \"uploads/video/b59657e5-eb4a-4304-a0b1-bb6169a55f59/Good_7iron.m4v\",\n    \"frameRate\" : \"auto\",\n    \"resolution\" : \"auto\",\n    \"aspectRatio\" : \"auto\",\n    \"interlaced\" : \"auto\",\n    \"container\" : \"auto\"\n  },\n  \"outputKeyPrefix\" : \"uploads/video/b59657e5-eb4a-4304-a0b1-bb6169a55f59/\",\n  \"outputs\" : [ {\n    \"id\" : \"1\",\n    \"presetId\" : \"1395783135978-fq7lgp\",\n    \"key\" : \"Good_7iron-1.mp4\",\n    \"thumbnailPattern\" : \"Good_7iron-{count}\",\n    \"rotate\" : \"auto\",\n    \"status\" : \"Complete\",\n    \"duration\" : 10,\n    \"width\" : 640,\n    \"height\" : 360\n  } ]\n}", 
      :Timestamp=>"2014-09-14T19:29:05.383Z", 
      :SignatureVersion=>"1", 
      :Signature=>"uZwwlOATFGA81/VxMLLPtcnBHlEKcwJXpFsMPmj2Hp2SDIMigvhAS5Sk2zjnBYKuRjUQbsBxNm3lgP+7bWUEjEjtvHe+5QAMXF8qT3sH5FNSleTQYOVXlP455xFtbCoUgaXwoHWucQQq5aAsVvfW2Tet6u7d/LzT6NXoela7HeFpHB6otiIKVq9oAlc/3KRYeseWpMGdr7MzCTTwo8BmQgQgafBxdBN9Iv8U7KbZ3z344Cr1uXeGXk+9eNBRtLr8hRXjGq/MEF7D7s6owrQEk9MbX1WkkuhAuJpAYYNy94NcHM6TiYFr9Zu7BUMAWzGOdoLOYyH/jALQV/1z4Dnwqg==", 
      :SigningCertURL=>"https://sns.us-east-1.amazonaws.com/SimpleNotificationService-d6d679a1d18e95c2f9ffcf11f4f9e198.pem", 
      :UnsubscribeURL=>"https://sns.us-east-1.amazonaws.com/?Action=Unsubscribe&SubscriptionArn=arn:aws:sns:us-east-1:377092858912:Teebox_video_processing_PRODUCTION:5c16487f-32f6-41c9-acf2-d060621a951c"
    }
  end
  
  def err_json_response
    '{
        "Type" : "Notification", 
        "MessageId" : "fa12b8a4-3c7d-5a48-9927-f308e33212ae", 
        "TopicArn" : "arn:aws:sns:us-east-1:377092858912:Teebox_processing_DEV", 
        "Subject" : "AmazoElastic Transcoder has finished transcoding job 1395842307445-2sfq4p.", 
        "Message" : {
            "state" : "ERROR", 
            "version" : "2012-09-25", 
            "jobId" : "1395783182474-246e34", 
            "pipelineId" : "1395619455453-yghva8", 
            "input" : { 
              "key" : "uploads/video/ca14ba7a-c442-4f9f-a75a-c45cfedb8947/IMG_0587.MOV",   
              "frameRate" : "auto",   
              "resolution" : "auto",   
              "aspectRatio" : "auto",   
              "interlaced" : "auto",   
              "container" : "auto" 
            }, 
            "outputKeyPrefix" : "uploads/video/ca14ba7a-c442-4f9f-a75a-c45cfedb8947/",
            "outputs" : [ 
                {
                  "id" : "1",
                   "presetId" : "1395783135978-fq7lgp",   
                   "key" : "IMG_0587.mp4",   
                   "thumbnailPattern" : "IMG_0587-{count}",   
                   "rotate" : "auto",   
                   "status" : "ERROR",   
                   "duration" : 10,   
                   "width" : 270,   
                   "height" : 480 
                } 
              ]
          } 
      }'
  end
end