module SDKBuilder
  class Go
    def types
      SDKBuilder::GoTypes.new
    end

    def class_template
      ERB.new(IO.read(File.expand_path('../templates/class_template.erb', __FILE__)))
    end

    def data_class_template
      ERB.new(IO.read(File.expand_path('../templates/data_class_template.erb', __FILE__)))
    end

    def data_class_test_template
      ERB.new(IO.read(File.expand_path('../templates/data_class_test_template.erb', __FILE__)))
    end

    def file_extension
      'go'
    end

    def data_directory
      'data'
    end

    def test_directory
      'test'
    end

    def string_to_http_method(str)
      if %w(GET PUT POST DELETE HEAD OPTIONS TRACE).include? str.upcase
        return "HttpMethod.#{str.capitalize}"
      elsif str.upcase == 'PATCH'
        return 'new HttpMethod("PATCH")'
      end
      nil
    end

    def pretty_name(str)
      dict = SDKBuilder::Config.dictionary
      val = str

      val.split(/[_|(|)]/).map do |s|

        dict.each do |key, value|
          if s.downcase == key.downcase
            s = value
          end
        end
        s.capitalize
      end.compact.join('').gsub('-', '').gsub(',','')
    end

    def request_class_suffix
      'Request'
    end

    def response_class_suffix
      'Response'
    end

    def data_class_prefix
      'DataClass'
    end

    implements LANGUAGE
  end
end