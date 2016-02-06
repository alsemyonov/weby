require 'spec_helper'

RSpec.describe Weby::Resource do
  let(:site_url) { 'http://example.com' }
  let(:url) { '/index.html' }
  let(:site_data) { Hashie::Mash.new(site: { url: site_url }) }
  let(:data) { { url: url, site_data: site_data } }
  subject(:resource) do
    resource = double(data)
    resource.extend Weby::Resource
    resource
  end

  it { should respond_to(:canonical_url) }
  it { should respond_to(:resource_base_url) }
  its(:canonical_url) { should == URI.parse('http://example.com/index.html') }
  its(:resource_base_url) { should == '/index' }
end
