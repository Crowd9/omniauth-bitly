require 'spec_helper'

describe OmniAuth::Strategies::Bitly do
  subject do
    OmniAuth::Strategies::Bitly.new({})
  end

  context "client options" do
    it 'should have correct name' do
      subject.options.name.should eq("bitly")
    end

    it 'should have correct site' do
      subject.options.client_options.site.should eq('https://api-ssl.bitly.com/')
    end

    it 'should have correct authorize url' do
      subject.options.client_options.authorize_url.should eq('https://bitly.com/oauth/authorize')
    end
  end
end
