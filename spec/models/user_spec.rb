require 'spec_helper'

describe User do
  before(:each) do
    @user = create(:user)
    User.any_instance.unstub(:send_on_create_confirmation_instructions)
    Devise::Mailer.stub(:delay).and_return(Devise::Mailer)
  end
  
  subject { @user }

   it { should respond_to(:email)}
   it { should respond_to(:password)}
   it { should respond_to(:password_confirmation)}
   it { should respond_to(:remember_me)}
   it { should respond_to(:reputation)}
   it { should respond_to(:rank)}
   it { should respond_to(:notifications)}
   it { should respond_to(:authentication_token)}
   it { should have_many(:questions)}
   it { should have_many(:articles)}
   it { should have_many(:videos)}
   it { should have_many(:comments)}
   it { should have_many(:answers)}
   it { should have_many(:votes)}
   it { should have_many(:tags)}
   it { should have_many(:points) }

 describe 'email' do
   before { subject.email = nil }
   it { should_not be_valid }
 end
 
  describe "password" do
    before { subject.password = nil }
    it { should_not be_valid }
  end
 
  describe "password_confirmation" do
    before { subject.password_confirmation = 'password1' }
    it { should_not be_valid }
  end
  
  describe "passwords match" do
    before { subject.password == subject.password_confirmation }
    it { should be_valid }
  end 
  
  describe "to_param" do
    it "returns id and username string" do
      subject.to_param.should eq "#{@user.id}-#{@user.username}"
    end
  end
  
  describe "admin?" do
    it "returns true for admin user" do
      subject.admin?.should be true
    end
    
    it "returns true for admin user" do
      user = create(:user, role: User::STANDARD)
      user.admin?.should be false
    end
  end
  
  describe "preferences" do
    it "returns serialized hash" do
      subject.preferences.should be_a(Hash)
    end
    
    it "notifications set to true by default" do
      subject.notifications.should eq "1"
    end
  end
  
  describe "ensure_authentication_token" do
    it "creates token" do
      subject.authentication_token.should_not be_blank
    end
  end
  
  describe "create_welcome_notification" do
    it "triggers ActivityRepository#generate" do
      ActivityRepository.any_instance.should_receive(:generate)
      subject.create_welcome_notification
    end
  end
       
  describe "user mail triggers" do
    it 'send_on_create_confirmation_instructions' do
      Devise::Mailer.should_receive(:confirmation_instructions)
      create(:user)
    end
  end
  
  describe "ranking" do
    describe "rank_by_reputation" do
      it "returns hash, rep as key, array of ids as values" do
        User.rank_by_reputation.should include(200=>[subject.id]) 
      end
   end
    
    describe "rank_users" do
      it "updates subject rank to 1" do
        User.rank_users
        subject.reload
        subject.rank.should eq 1
      end
    end
  end
end