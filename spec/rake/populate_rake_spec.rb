require 'spec_helper'
require 'rake'
TeeboxNetwork::Application.load_tasks

describe "populate" do
  it "populates the database" do
    Rake::Task['db:populate'].invoke
  end
end