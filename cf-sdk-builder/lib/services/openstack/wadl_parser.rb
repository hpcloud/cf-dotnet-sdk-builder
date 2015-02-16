
module SDKBuilder
  class OpenStackWADLParser

    def initialize(wadl_file)
      @wadl_file = wadl_file
      @wadl_dir = File.expand_path('../', wadl_file)
    end

    def load_action_list
      f = File.open(@wadl_file)
      doc = Nokogiri::XML(f)
      doc.remove_namespaces!

      hash = {}
      doc.xpath('/application/resources/resource').each do |node|
        process_resource(node, nil, hash)
      end

      hash
    end

    private

    # Processes request or response nodes in a method
    def process_body_node(method_node, type)
      body_node = method_node.xpath(type)
      body = ''

      if body_node
        json_sample = body_node.xpath("representation[@mediaType='application/json']/doc/code/@href")

        if json_sample and json_sample.count > 0
          json_file = File.expand_path(json_sample[0].value, @wadl_dir)
          body = File.open(json_file).read
        else
          $log.debug("Could not find a json #{type} sample for method '#{method_node['id']}'")
        end
      end

      body
    end

    def process_resource(node, parent_path, hash)
      id = node['id']
      path = node['path']
      full_path = parent_path ? [parent_path, path].join('/') : path
      methods = node.xpath('method')

      resource_type = node['type']
      if resource_type
        resource_type_nodes = node.document.xpath("/application/resource_type[@id='#{resource_type.gsub(/#/, '')}']")
        if resource_type_nodes.count == 1
          methods = methods + resource_type_nodes[0].xpath('method')
        else
          if resource_type_nodes.count == 0
            $log.warn("Did not find any resource types with href '#{resource_type}'.")
          else
            msg = "Detected inconsistency for resource type with href '#{resource_type}' - it matches #{resource_type_nodes.count} elements. It should match exactly 1."
            $log.error(msg)
          end
        end
      end

      if methods.count > 0
        methods.each do |method|

          method_nodes = node.document.xpath("/application/method[@id='#{method['href'].gsub(/#/, '')}']")
          if method_nodes.count == 1
            method_node = method_nodes[0]
            method_name = method_node['id']


            request_body = process_body_node(method_node, 'request')
            response_body = process_body_node(method_node, 'response')

            if method_name == 'resizeServer'
               puts request_body
            end

            hash[method_name] = {
                'http_method' => method_node['name'],
                'route' => full_path,
                'description' => '',
                'fields' => {},
                'parameters' => {},
                'requests' => {
                    'request' => [{
                        'request_method' => method_node['name'],
                        'request_path' => full_path,
                        'request_body' => request_body,
                        'request_headers' => '{}',
                        'request_query_parameters' => '{}',
                        'request_content_type' => nil,
                        'response_status' => method_node.xpath('response')[0]['status'],
                        'response_body' => response_body,
                        'response_headers' => '{}',
                        'response_content_type' => ''
                                  }]
                }
            }
          else
            if method_nodes.count == 0
              $log.warn("Did not find any methods with href '#{method['href']}'.")
            else
              msg = "Detected inconsistency for method with href '#{method['href']}' - it matches #{method_node.count} elements. It should match exactly 1."
              $log.error(msg)
            end
          end
        end
      end

      if node.xpath('resource')
        node.xpath('resource').each do |child|
          process_resource(child, full_path, hash)
        end
      end
    end

  end
end