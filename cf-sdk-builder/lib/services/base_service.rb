module SDKBuilder

  # This method has to return a hash that contains the following:
  # {
  #   "endpoint_name" => <Endpoint instance>
  # }
  #
  # An endpoint is created using the following constructor: SDKBuilder::Endpoint.new(endpoint_name, method_hash)
  # The methods hash (in JSON form) looks like this:
  # {
  #   "list_all_routes": {
  #     "resource": "Routes",
  #     "http_method": "GET",
  #     "route": "\/v2\/routes",
  #     "description": "List all Routes",
  #     "explanation": null,
  #     "fields": {
  #       "field": [
  #         {
  #           "name": "guid",
  #           "deprecated": false,
  #           "readonly": true,
  #           "required": true,
  #           "description": "The guid of the route.",
  #           "default": null,
  #           "valid_values": null,
  #           "example_values": null
  #         }
  #       ]
  #     },
  #     "parameters": {
  #       "parameter": [
  #         {
  #           "name": "q",
  #           "deprecated": false,
  #           "description": "Description for param",
  #           "valid_values": null,
  #           "example_values": {
  #             "example_value": [
  #               "q=filter:value",
  #               "q=filter>value",
  #               "q=filter IN a,b,c"
  #             ]
  #           }
  #         }
  #       ]
  #     },
  #     "requests": {
  #       "request": [
  #         {
  #           "request_method": "GET",
  #           "request_path": "\/v2\/routes",
  #           "request_body": null,
  #           "request_headers": "{\"Authorization\"=>\"bearer foobar", \"Host\"=>\"example.org\", \"Cookie\"=>\"\"}",
  #           "request_query_parameters": "{}",
  #           "request_content_type": null,
  #           "response_status": "200",
  #           "response_status_text": "OK",
  #           "response_body": "{\n  \"total_results\": 1,\n }",
  #           "response_headers": "{\"Content-Type\"=>\"application\/json;charset=utf-8\"}",
  #           "response_content_type": "application\/json;charset=utf-8",
  #         }
  #       ]
  #     }
  #   }
  # }

  BASE_SERVICE = interface {
    required_methods :compile_endpoints
  }
end