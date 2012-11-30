module Metaforce
  module Metadata
    class Client < Metaforce::Client
      def list(*args)
        queries = { :type => args.map(&:to_s).map(&:camelize) }
        response = request(:list_metadata) do |soap|
          soap.body = { :queries => queries }
        end
        Hashie::Mash.new(response.body).list_metadata_response.result
      end

      def describe(version=nil)
        response = request(:describe_metadata) do |soap|
          soap.body = { :api_version => version } unless version.nil?
        end
        Hashie::Mash.new(response.body).describe_metadata_response.result
      end

    private

      def endpoint
        metadata_server_url
      end

      def wsdl
        Metaforce.configuration.metadata_wsdl
      end

      def session_id
        @options[:session_id]
      end

      def metadata_server_url
        @options[:metadata_server_url]
      end
    end
  end
end