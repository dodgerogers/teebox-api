require "spec_helper"

describe Impression do
  before(:each) do
    @question = build(:question)
    @impression = build(:impression, impressionable: @question)
  end
  
  subject { @impression }
  
  it { should belong_to(:impressionable) }
  it { should respond_to(:impressionable_id) }
  it { should respond_to(:impressionable_type) }
  it { should respond_to(:ip_address) }
  it { should validate_uniqueness_of(:ip_address).scoped_to(:impressionable_id)}
end