require 'spec_helper'
require 'rake'
TeeboxNetwork::Application.load_tasks

describe "rank_users" do
  it "should rank the users" do
      Rake::Task['user:rank'].invoke
  end
end

describe "rm_test_users" do
  it "should rank the users" do
      Rake::Task['user:rm_test'].invoke
  end
end

describe "rm_tags" do
  it " should delete all tags" do
    Rake::Task['db:rm_tags'].invoke
  end
end

describe "social_statistics" do
  it "invoke Social new" do
    Rake::Task['db:social_statistics'].invoke
  end
end

describe "generate_report" do
  it "creates record" do
      Rake::Task['db:generate_report'].invoke
  end
end

describe "delete_capybara" do
  it "deletes tmp capybara files" do
      Rake::Task['delete_capybara'].invoke
  end
end

describe "delete_tmp_files" do
  it "deletes tmp video screenshots" do
      Rake::Task['delete_tmp_files'].invoke
  end
end