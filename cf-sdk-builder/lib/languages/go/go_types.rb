module SDKBuilder
  class GoTypes
    def string
      'string'
    end

    def boolean
      'bool'
    end

    def number
      'double'
    end

    def hash(key, value)
      "map[#{key}]#{value}"
    end

    def array(type)
      "[]#{type}"
    end

    def guid
      'string'
    end

    def integer
      'int'
    end

    def default
      'string'
    end

    implements SDKBuilder::BASE_TYPE
  end
end