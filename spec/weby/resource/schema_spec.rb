require 'spec_helper'

RSpec.shared_context 'Testing Schema', schema: true do
  let(:data) { {} }
  let(:resource_properties) { {data: data} }
  let(:resource) { double(Middleman::Sitemap::Resource, resource_properties) }
  let(:schema) { Weby::Resource::Schema.new(resource) }
end

RSpec.describe Weby::Resource::Schema, schema: true do
  subject { schema }

  it { should respond_to(:type) }
  it { should respond_to(:to_html_attributes) }
  {
    'page' => ['http://schema.org/ItemPage'],
    'article' => ['http://schema.org/BlogPosting'],
    'about' => ['http://schema.org/AboutPage'],
    'year' => ['http://schema.org/CollectionPage'],
    'month' => ['http://schema.org/CollectionPage'],
    'day' => ['http://schema.org/CollectionPage'],
    'tag' => ['http://schema.org/CollectionPage'],
  }.each do |resource_type, properties|
    schema_type = properties.first
    describe resource_type do
      let(:resource_properties) { {data: data, resource_type: resource_type} }

      its(:type) { should == schema_type }
    end
  end
end

RSpec.describe Weby::Resource, schema: true do
  subject { resource }

  #it { should respond_to(:schema) }
end
