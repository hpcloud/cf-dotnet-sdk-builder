class String
  def pretty_name
    SDKBuilder::Config.language.pretty_name(self)
  end

  def is_json?
    begin
      !!JSON.parse(self)
    rescue
      false
    end
  end

  def is_guid?
    !!(self =~ /^(guid-)?[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i)
  end

  def is_number?
    true if Float(self) rescue false
  end

  def is_integer?
    true if Integer(self) rescue false
  end

  def to_http_method
    SDKBuilder::Config.language.string_to_http_method(self)
  end

  def clean_guids
    self.gsub(/guid-([0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12})/, '\1')
        .gsub(/(?<=guid":\s")\S+(?=")/, SecureRandom.uuid)
  end
end

class ::Hash
  def deep_merge(second)
    merger = proc { |key, v1, v2| Hash === v1 && Hash === v2 ? v1.merge(v2, &merger) : v2 }
    self.merge(second, &merger)
  end
end