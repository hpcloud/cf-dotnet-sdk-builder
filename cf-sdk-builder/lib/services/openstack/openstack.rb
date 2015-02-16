module SDKBuilder
  class OpenStack
    def compile_endpoints
      endpoints = {}

      # get the WADLs from wadl dir

      src_dir = File.join(Config.in_dir, 'wadl')

      Dir[File.join(src_dir, '*.wadl')].inject(endpoints) do |hash, file|
        parser = SDKBuilder::OpenStackWADLParser.new(file)
        method_hash = parser.load_action_list

        endpoint = File.basename(file, '.wadl')

        hash[endpoint] = SDKBuilder::Endpoint.new(endpoint,  method_hash)

        hash
      end

      # get the WADLs from ext

      endpoints
    end

    implements SDKBuilder::BASE_SERVICE
  end
end