module SDKBuilder
  class CloudFoundry
    def compile_endpoints
      raw_data = list_api
      endpoints = {}

      raw_data.each do |endpoint, method_list|
        endpoints[endpoint] = SDKBuilder::Endpoint.new(endpoint, method_list)
      end

      endpoints
    end

    private

    def get_actions(api)
      dir = File.join(Config.in_dir, api)
      parser = Nori.new
      Dir[File.join(dir, '*.html')].inject({}) do |hash, file|
        action_name = File.basename(file, '.html')
        f = File.open(file)
        doc = Nokogiri::XML(f)
        action_example = parser.parse(doc.to_s)['example'] 
        f.close

        version_ok = SDKBuilder::Config.service_versions.any? {|version| action_example['route'].start_with? "/#{version}" }

        unless version_ok
          $log.info("CF: [Ignored] Version not included for route: '#{action_example['route']}'")
          next
        end

        $log.info("CF: Version ok for route: '#{action_example['route']}'")

        hash[action_name] = action_example

        #make sure arrays are everywhere where expected
        hash.each do |action_name, action|
          if action['requests'] && action['requests']['request']
            if action['requests']['request'].class.to_s == 'Hash'
              h = action['requests']['request']
              action['requests']['request'] = []
              action['requests']['request'].push(h)
            end
          end

          if action['fields'] && action['fields']['field']
            if action['fields']['field'].class.to_s == 'Hash'
              h = action['fields']['field']
              action['fields']['field'] = []
              action['fields']['field'].push(h)
            end
          end
        end

        hash
      end
    end

    def list_api
      Dir.entries(Config.in_dir).inject({}) do |hash, entry|
        if File.directory? File.join(Config.in_dir, entry) and !(entry =='.' || entry == '..')
          actions = get_actions(entry)
          if actions != nil and actions.size > 0
            hash[entry.gsub(/[(|)]/, '_')] = actions
          end
        end
        hash
      end
    end

    implements SDKBuilder::BASE_SERVICE
  end
end