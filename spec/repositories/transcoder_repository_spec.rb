require "spec_helper"

describe TranscoderRepository do
  before(:each) do
    @user = create(:user)
    @video = create(:video, user_id: @user.id)
  end
  
  describe "#generate" do  
    it "updates video attributes" do
      TranscoderRepository.stub(:create_transcoder_job).and_return(job_id: "1234567", status: "NEW_STATUS")
      TranscoderRepository.generate(@video)
      
      @video.reload
      @video.job_id.should eq("1234567")
      @video.status.should eq("NEW_STATUS")
    end
    
    it "raises Argument Error when not supplied a video object" do
      expect { 
        TranscoderRepository.generate("string argument") 
        }.to raise_error(ArgumentError, "TranscoderRepository error: not a valid video object")
    end
  end
  
  describe "#create_transcoder_job" do
    before(:each) do
      @response_hash = { job: { id: 1, status: "COMPLETED" } }
      @transcoder = double "transcoder", create_job: "creating..."
      @job = double "data", data: @response_hash
    end
    
    it "returns attributes hash from job" do 
      AWS::ElasticTranscoder::Client.stub(:new).and_return(@transcoder)
      @transcoder.should_receive(:create_job).and_return(@job)
      
      TranscoderRepository.create_transcoder_job({random: "value"}).should eq({job_id: 1, status: "COMPLETED"})
    end
  end
  
  describe "#options" do
    it "creates an attributes hash" do
      transcoder = TranscoderRepository.options(@video)
      
      transcoder.should be_a(Hash) 
      transcoder.length.should eq 4
      transcoder.should have_key(:pipeline_id)
      transcoder.should have_key(:output_key_prefix)
      transcoder.should have_key(:input)
      transcoder[:input].length.should eq 6
    end
  end
end