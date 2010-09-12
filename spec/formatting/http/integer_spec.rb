require 'spec_helper'
require 'ronin/formatting/extensions/http/integer'

describe Integer do
  subject { ' ' }

  it "should provide String#uri_encode" do
    should respond_to(:uri_encode)
  end

  it "should provide String#uri_escape" do
    should respond_to(:uri_escape)
  end

  describe "uri_encode" do
    let(:uri_encoded) { '%20' }

    it "should URI encode itself" do
      subject.uri_encode.should == uri_encoded
    end
  end

  describe "uri_escape" do
    let(:uri_escaped) { '+' }

    it "should URI escape itself" do
      subject.uri_escape.should == uri_escaped
    end
  end
end