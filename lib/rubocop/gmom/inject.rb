require 'yaml'

module RuboCop
  module Gmom
    module Inject
      DEFAULT_FILE = File.expand_path('../../../../config/default.yml', __FILE__)

      def self.defaults!
        hash = YAML.load_file(DEFAULT_FILE)
        config = ConfigLoader.merge_with_default(hash, DEFAULT_FILE)
        ConfigLoader.instance_variable_set(:@default_configuration, config)
      end
    end
  end
end