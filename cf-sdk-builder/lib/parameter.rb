module SDKBuilder
  class Parameter
    attr_reader :name, :description, :type, :is_array, :is_index_hash, :method

    def initialize(name, method, description, raw_data = nil)
      @name = name
      @raw = raw_data
      @description = description
      @is_array = is_array?
      @is_index_hash = is_index_hash?
      @method = method
      @type = @raw ? SDKBuilder::DataClass.new('', self, raw_data) : SDKBuilder::DataClass.new('', self, name)
    end

    def definition
      if is_array
        Config.types.array(type.name)
      elsif is_index_hash
        Config.types.hash(Config.types.integer, type.name)
      else
        type.name
      end
    end

    private

    def is_array?
      if @raw and @raw.is_json?
        obj = JSON.parse(@raw)
        obj.is_a?(Array)
      else
        false
      end
    end

    def is_index_hash?
      if @raw and @raw.is_json?
        obj = JSON.parse(@raw)
        obj.is_a?(Hash) and (obj.keys.all? {|k| k.is_a?(Integer) or (k.is_a?(String) and k.is_integer?) }) and obj.keys.count > 0
      else
        false
      end
    end
  end
end
