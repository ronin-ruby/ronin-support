require 'spec_helper'
require 'ronin/templates/template'

require 'templates/classes/example_template'
require 'templates/helpers/data'

describe Templates::Template do
  let(:example_template) { File.join(Helpers::TEMPLATE_DIR,'templates','example.erb') }
  let(:relative_template) { File.join(Helpers::TEMPLATE_DIR,'includes','_relative.erb') }

  subject { ExampleTemplate.new }

  it "should return the result of the block when entering a template" do
    expect(subject.enter_example_template { |path|
      'result'
    }).to eq('result')
  end

  it "should be able to find templates relative to the current one" do
    subject.enter_example_template do |path|
      expect(path).to eq(example_template)
    end
  end

  it "should be able to find static templates" do
    subject.enter_relative_template do |path|
      expect(path).to eq(relative_template)
    end
  end

  it "should raise a RuntimeError when entering an unknown template" do
    expect {
      subject.enter_missing_template { |path| }
    }.to raise_error(RuntimeError)
  end

  it "should be able to read templates relative to the current one" do
    subject.read_example_template do |contents|
      expect(contents).to eq(File.read(example_template))
    end
  end

  it "should be able to find static templates" do
    subject.read_relative_template do |contents|
      expect(contents).to eq(File.read(relative_template))
    end
  end

  it "should raise a RuntimeError when entering an unknown template" do
    expect {
      subject.read_missing_template { |path| }
    }.to raise_error(RuntimeError)
  end
end
