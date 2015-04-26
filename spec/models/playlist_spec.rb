require "spec_helper"

describe Playlist do
  it { should belong_to(:video)}
  it { should belong_to(:question)}
end