require 'spec_helper'
require 'rake'
TeeboxApi::Application.load_tasks

describe "populate" do
  it "populates the database" do
    Rake::Task['db:populate'].invoke
  end
end