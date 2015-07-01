
module SDKBuilder
  class Endpoint
    attr_reader :name, :description, :methods

    def initialize(name, raw_endpoint)
      File.open(name, 'w') {|f| f.write(raw_endpoint.to_json) }

      @name = name
      @methods = []
      # TODO: vladi: figure out if we need a description here
      @description = ''
      raw_endpoint.keys.each do |method|
        if SDKBuilder::Config.entities["excluded_methods"].include? method
          $log.info("---> Skipping method '#{method}'")
          next
        end
        methods.push(SDKBuilder::Method.new(method, self, raw_endpoint[method]))
      end
    end
  end
end
