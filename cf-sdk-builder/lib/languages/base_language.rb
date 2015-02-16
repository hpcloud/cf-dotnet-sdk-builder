module SDKBuilder
  LANGUAGE = interface {
    required_methods :types, :class_template, :data_class_template, :file_extension,
                     :data_directory, :string_to_http_method, :pretty_name,
                     :request_class_suffix, :response_class_suffix, :data_class_prefix
  }

  BASE_TYPE = interface {
    required_methods :string, :number, :hash, :guid, :integer, :default, :boolean, :array
  }
end