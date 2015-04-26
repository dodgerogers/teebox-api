require "spec_helper"

describe Tag do
  before(:each) do
    @tag = create(:tag, name: "Driver")
  end
  
  subject { @tag }
  
  it { should respond_to(:name) }
  it { should respond_to(:explanation) }
  it { should respond_to(:updated_by) }
  it { should have_many(:taggings)}
  it { should have_many(:questions).through(:taggings)}
  it { should validate_presence_of(:name)}
  it { should validate_length_of(:name).is_at_least(2) }
  it { should validate_uniqueness_of(:name)}
  
  describe 'name' do
     before { subject.name = nil }
     it { should_not be_valid }
   end
   
   describe "obscenity filter name" do
     before { subject.name = "shit" }
     it { should_not be_valid }
   end
   
   describe "validates explanation" do
     before { subject.explanation = "fuck" }
     it { should_not be_valid }
   end
   
   describe "tag_cloud" do
     it "lists most popular tags" do
       @question = create(:question)
       @tagging = create(:tagging, question_id: @question.id, tag_id: @tag.id)
       Tag.cloud.should include(@tag)
     end
   end
   
   describe "Tag#tokens" do
     it "creates new tag attributes when no similar tags found" do
       token = Tag.tokens("putter").first
       
       token.should be_kind_of(Hash)
       token[:id].should eq "<<<putter>>>" 
       token[:name].should eq "New: \"putter\""
     end
     
     it "returns tags when a match is found" do
       Tag.tokens("driver").should include(@tag)
     end
   end
   
   describe "text_search" do
     before(:each) do
       @tag2 = create(:tag, name: "Putting")
     end
      
     it 'should return similar tags' do
       Tag.text_search("driver").should include(@tag)
     end
     
     it "shoud return an empty array when no matches found" do
       Tag.text_search("No matches").should eq []
     end
   end
end