require "spec_helper"

describe Tagging do
  it { should belong_to(:tag)}
  it { should belong_to(:question)}
end