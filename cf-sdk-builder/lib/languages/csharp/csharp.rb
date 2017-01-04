module SDKBuilder
  class CSharp
    def types
      SDKBuilder::CSharpTypes.new
    end

    def class_template
      ERB.new(IO.read(File.expand_path('../templates/class_template.erb', __FILE__)))
    end

    def data_class_template
      ERB.new(IO.read(File.expand_path('../templates/data_class_template.erb', __FILE__)))
    end

    def data_class_deserialization_test_template
      ERB.new(IO.read(File.expand_path('../templates/data_class_deserialization_test_template.erb', __FILE__)))
    end

    def data_class_serialization_test_template
      ERB.new(IO.read(File.expand_path('../templates/data_class_serialization_test_template.erb', __FILE__)))
    end

    def class_test_template
      ERB.new(IO.read(File.expand_path('../templates/class_test_template.erb', __FILE__)))
    end

    def file_extension
      'cs'
    end

    def data_directory
      'Data'
    end

    def test_directory
      'Test'
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

      val.split(/[_|(|)]|(?=[A-Z])/).map do |s|

        dict.each do |key, value|
          if s.downcase == key.downcase
            s = value
          end
        end

        #capitalize first letter. leave rest untouched
        s.slice(0,1).capitalize + (s.slice(1..-1) || "")
      end.compact.join('').gsub('-', '').gsub(',','').gsub("'", '')
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
	
    def release_version
      '250'
    end
    implements LANGUAGE
  end
end