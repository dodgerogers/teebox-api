require "spec_helper"

describe ReportRepository do
  describe "generate" do
    context 'with no previous report' do
      before(:each) do
        @question = create(:question)
        @answer = create(:answer, question: @question)
      end
      
      it 'generates new report' do
        report = Report.new
        repo = ReportRepository.generate(report) 
        
        repo.should eq true
        report = Report.last
        
        report.questions_total.should eq 1
        report.answers_total.should eq 1
        report.users_total.should eq 2
        report.questions.should eq 1
        report.answers.should eq 1
        report.users.should eq 2
      end
    end
    
    context 'with previous report with same values' do
      before(:each) do
        @report = create(:report)
        @question = create(:question)
        @answer = create(:answer, question: @question)
      end
      
      it 'does not generate report' do
        report = Report.new
        repo = ReportRepository.generate(report) 
        
        repo.should eq false
        Report.all.size.should eq 1
      end
    end
    
    context 'with previous report with different values' do
      before(:each) do
        @report = create(:report)
        3.times { create(:question) }
      end
      
      it 'generates report' do
        report = Report.new
        repo = ReportRepository.generate(report) 
        
        repo.should eq true
        Report.all.size.should eq 2
      end
    end
  end
  
  describe "errors" do
    it "raises Argument Error when not supplied a report object" do
      expect { 
        ReportRepository.generate("string argument") 
      }.to raise_error(ArgumentError, "ReportRepository error: must supply a valid report object")
    end
  end
end