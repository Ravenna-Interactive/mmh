module Authlogic
  module Session
    module ApiKey
      def self.included(klass)
        klass.class_eval do
          extend Config
          include InstanceMethods
          attr_accessor :single_access
          persist :persist_by_api_key
        end
      end
      
      # Configuration for the params / single access feature.
      module Config

        def api_key_name(value = nil)
          rw_config(:api_key_name, value, 'X-ACCESS-TOKEN')
        end
        alias_method :api_key_name=, :api_key_name
        
      end
      
      # The methods available for an Authlogic::Session::Base object that make up the params / single access feature.
      module InstanceMethods
        private
          def persist_by_api_key
            return false if !api_key_enabled?
            self.unauthorized_record = search_for_record("find_by_single_access_token", api_key_credentials)
            self.single_access = valid?
          end
          
          def api_key_enabled?
            api_key_credentials && klass.column_names.include?("single_access_token")
          end
          
          def api_key_credentials
            controller.request.headers[api_key_name]
          end
                    
          def api_key_name
            build_key(self.class.api_key_name)
          end
          
      end
    end
  end
end