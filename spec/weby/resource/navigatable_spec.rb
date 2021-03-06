require 'spec_helper'

RSpec.describe Weby::Resource::Navigatable do

end

RSpec.describe Weby::Resource::Navigatable::Navigation do
  let(:resource) { double(Middleman::Sitemap::Resource) }
  subject(:navigation) { described_class.new(resource) }

  {
    { url: '/', path: 'index.html', title: 'My Site', data: {} } =>
      { data_lookup_path: 'navigation', menu?: true, data: {} },
    { url: '/about/', path: 'about.html', title: 'About', data: {} } =>
      { data_lookup_path: 'navigation.about', menu?: true },
    { url: '/2008.html', path: '2008.html', title: 'About', data: {} } =>
      { data_lookup_path: 'navigation.2008', menu?: true },
    { url: '/cv/', path: 'cv/index.html', title: 'CV', data: {} } =>
      { data_lookup_path: 'navigation.cv', menu?: true },
    { url: '/about/me', path: 'me.html', title: 'About Me', data: { menu: false } } =>
      { data_lookup_path: 'navigation.about.me', menu?: false }
  }.each do |resource_attributes, checks|
    context resource_attributes.to_json do
      checks.each do |name, value|
        specify "#{name} == #{value.inspect}" do
          attributes = resource_attributes.dup
          attributes[:site_data] = double('app.data', data_for_path: attributes[:site_data] || nil)
          attributes[:data_lookup_path] = checks[:data_lookup_path].gsub(/^navigation.?/, '').presence
          attributes[:paginated?] = false
          resource = double(Middleman::Sitemap::Resource, attributes)
          allow(resource).to receive(:try).and_return(nil)
          navigation = Weby::Resource::Navigatable::Navigation.new(resource)

          expect(navigation.public_send(name)).to eq(value)
        end
      end
    end
  end

  it { is_expected.to respond_to(:menu?) }
  it { is_expected.to respond_to(:data_lookup_path) }
  it { is_expected.to respond_to(:data) }
  it { is_expected.to respond_to(:title) }
  it { is_expected.to respond_to(:url) }
  it { is_expected.to respond_to(:path) }
end
