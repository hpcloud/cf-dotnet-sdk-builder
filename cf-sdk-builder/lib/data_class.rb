module SDKBuilder
  class DataClass

    attr_reader :description, :properties, :name, :parameter
    $data_class_idx = 0

    def initialize(description, parameter, raw_data = nil)
      unless raw_data
        raise 'A DataClass cannot be initialized without raw data associated with it.'
      end

      @parameter = parameter
      @description = description
      @raw = raw_data
      @properties = get_properties

      if raw_data.is_json?
        if @parameter.name == 'value'
          name = "#{@parameter.method.name.pretty_name}#{Config.language.request_class_suffix}"
        elsif @parameter.name == '@return'
          name = "#{@parameter.method.name.pretty_name}#{Config.language.response_class_suffix}"
        else
          $data_class_idx = $data_class_idx + 1
          name = "#{Config.language.data_class_prefix}#{$data_class_idx}"
        end
      else
        name = DataClass.get_simple_type(raw_data)
      end
      @name = name

    end

    def ==(o)
      return false if self.description != o.description
      (self.properties.keys & o.properties.keys == self.properties.keys) && (self.properties.values & o.properties.values == self.properties.values)
    end

    private

    def self.get_simple_type(name, sample_data = nil)
      if name.end_with? 'guid'
        return Config.types.guid
      elsif !sample_data.nil?
        if sample_data.is_a?(Hash)
          key_class = DataClass.get_simple_type("HashKey!#{name}", sample_data.keys.first)

          #value_types = sample_data.values.map {|value| DataClass.get_simple_type("HashValue!#{name}", value)}.uniq
          #value_class = value_types.count == 1 ? value_types[0] : Config.types.default

          #documentation does not cover all posible values (service binding credentials can contain other hashes)
          value_class = Config.types.default

          return Config.types.hash(key_class, value_class)
        elsif sample_data.is_a?(Array)
          value_types = sample_data.map {|value| DataClass.get_simple_type("Array!#{name}", value)}.uniq
          value_class = value_types.count == 1 ? value_types[0] : Config.types.default

          return Config.types.array(value_class )
        elsif sample_data.is_a?(Integer)
          return Config.types.integer
        elsif sample_data.is_a?(Fixnum) || sample_data.is_a?(Float)
          return Config.types.number
        elsif !!sample_data == sample_data
          return Config.types.boolean
        elsif sample_data.is_a?(String)
          if sample_data.is_guid?
            return Config.types.guid
          else
            return Config.types.string
          end
        else
          raise "Cannot determine type for data class '#{name}'. Sample data: '#{sample_data}'"
        end
      elsif name.end_with? 'index'
        return Config.types.integer
      else
        Config.types.default
      end
    end

    def get_properties
      obj = nil
      properties = {}
      if @raw.is_json?
        obj = JSON.parse(@raw)

        if obj.is_a?(Array)
          obj = obj.first
        elsif obj.is_a?(Hash)
          if obj.keys.all? {|k| k.is_a?(Integer) or (k.is_a?(String) and k.is_integer?) } and obj.keys.count > 0
            obj = obj[obj.keys[0]]
          end
        else
          raise "Cannot determine properties for data class '#{@name}'"
        end

        return {} if obj.nil?
          
        obj.keys.inject({}) do |hash, key|
          property = {}
          property[:type] = DataClass.get_simple_type(key, obj[key])
          property[:description] = "The #{(key.pretty_name.split /(?=[A-Z])/).join(" ")}"
          properties[key] = property
        end

        if @parameter.name == 'value'
          @parameter.method.fields.each do |name, f|
             unless properties[name]
              property = {}
              property[:type] = DataClass.get_simple_type(name, f[:value])
              property[:description] = f[:description]
              properties[name] = property
            else
              properties[name][:description] = f[:description]
            end
          end

          @parameter.method.body_parameters.each do |name, f|
            unless properties[name]
              property = {}
              property[:type] = DataClass.get_simple_type(name, f[:value])
              property[:description] = f[:description]
              properties[name] = property
            else
              properties[name][:description] = f[:description]
            end
          end
        end

        properties

      else
        {}
      end
    end
  end
end
