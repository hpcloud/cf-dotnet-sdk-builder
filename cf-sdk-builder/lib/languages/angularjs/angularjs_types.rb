module SDKBuilder
  class AngularJSTypes
    def string
      'string'
    end

    def boolean
      'boolean'
    end

    def number
      'number'
    end

    def hash(key, value)
      'any'
    end

    def array(type)
      "Array<#{type}>"
    end

    def guid
      'string'
    end

    def integer
      'number'
    end

    def default
      'any'
    end

    implements SDKBuilder::BASE_TYPE
  end
end
