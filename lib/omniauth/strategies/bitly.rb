require 'omniauth-oauth2'
require 'multi_json'

module OmniAuth
  module Strategies
    class Bitly < OmniAuth::Strategies::OAuth2
      # NOTE: code might not be up to date, Initial last commit on forked gem is 9 years ago.
      option :name, "bitly"
      option :client_options, {
        :site => 'https://api-ssl.bitly.com/',
        :authorize_url => 'https://bitly.com/oauth/authorize',
        :token_url => 'https://api-ssl.bitly.com/oauth/access_token',
        # https://gitlab.com/oauth-xx/oauth2/-/blob/main/lib/oauth2/client.rb?ref_type=heads&blame=0#L35
        # bitly responds with 401 when basic auth is set.
         auth_scheme: :request_body
      }

      uid { access_token.params['login'] }

      info do
        {
          'login' => access_token.params['login'],
          'api_key' => access_token.params['apiKey'],
          'display_name' => raw_info['name'],
          'full_name' => raw_info['name'],
          'profile_image' => nil,
          'profile_url'=> nil
        }
      end

      extra do
        {:raw_info => raw_info}
      end

      # https://dev.bitly.com/api-reference/#getUser
      def raw_info
        @raw_info ||= MultiJson.decode(access_token.get('/v4/user').body)
      end

      def request_phase
        super
      end

      # NOTE: if you want to debug oauth issues
      # put a breakpoint into this call and follow the code:
      # 1. https://github.com/omniauth/omniauth-oauth2/blob/v1.8.0/lib/omniauth/strategies/oauth2.rb#L84C11-L84C25
      # 2. For the client see https://gitlab.com/oauth-xx/oauth2/-/tree/main?ref_type=heads
      def callback_phase
        super
      end
    end
  end
end
OmniAuth.config.add_camelization 'bitly', 'Bitly'
