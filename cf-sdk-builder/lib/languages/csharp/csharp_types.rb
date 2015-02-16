module SDKBuilder
  class CSharpTypes
    def string
      'string'
    end

    def boolean
      'bool?'
    end

    def number
      'double?'
    end

    def hash(key, value)
      "Dictionary<#{key}, #{value}>"
    end

    def array(type)
      "#{type}[]"
    end

    def guid
      'Guid?'
    end

    def integer
      'int?'
    end

    def default
      'dynamic'
    end

    implements SDKBuilder::BASE_TYPE
  end
end