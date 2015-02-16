require "singleton"

module SDKBuilder
  class Config
    include Singleton

    attr_reader :entities, :dictionary
    attr_accessor :language, :service, :in_dir, :out_dir

    def self.config_dir
      File.expand_path('../../config/', __FILE__)
    end

    def self.dictionary
      Config.instance.dictionary
    end

    def self.entities
      Config.instance.entities
    end

    def self.service=(service)
      Config.instance.service = service
    end

    def self.service
      case Config.instance.service
        when 'cloudfoundry'
          SDKBuilder::CloudFoundry.new
        when 'openstack'
          SDKBuilder::OpenStack.new
        else
          raise "Invalid service '#{Config.instance.openstack}'."
      end
    end

    def self.in_dir=(in_dir)
      Config.instance.in_dir = in_dir
    end

    def self.in_dir
      Config.instance.in_dir
    end

    def self.out_dir=(out_dir)
      Config.instance.out_dir = out_dir
    end

    def self.out_dir
      Config.instance.out_dir
    end

    def self.language=(language)
      Config.instance.language = language
    end

    def self.language
      case Config.instance.language
        when 'csharp'
          SDKBuilder::CSharp.new
        when 'go'
          SDKBuilder::Go.new
        else
          raise "Invalid language '#{Config.instance.language}'."
      end
    end

    def self.types
      language.types
    end

    def initialize
      config_file = File.join(Config.config_dir, 'entities.yml')
      @entities = YAML.load_file(config_file)

      config_file = File.join(Config.config_dir, 'dictionary.yml')
      @dictionary = YAML.load_file(config_file)

      @language = nil
    end
  end
end