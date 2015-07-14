module SDKBuilder
  class NodeJsTypes
    def string
      'var'
    end

    def boolean
      'var'
    end

    def number
      'var'
    end

    def hash(key, value)
      "var"
    end

    def array(type)
      "var"
    end

    def guid
      'var'
    end

    def integer
      'var'
    end

    def default
      'var'
    end

    implements SDKBuilder::BASE_TYPE
  end
end