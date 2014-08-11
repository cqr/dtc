require 'bundler'
ENV['RACK_ENV'] ||= 'development'
Bundler.require(:default, (ENV['RACK_ENV'].downcase.intern))
$: << File.dirname(__FILE__)

class Environment

  def self.reload!
    [:models, :lib].each do |dir|
      Dir[File.join(dir.to_s, '*')].each do |file|
        send(ENV['RACK_ENV'] == 'development' ? :load : :require, file) unless File.directory? file
      end
    end
    Dir[File.join('config', '*.yml')].each do |yaml_file|
      Config.set(File.basename(yaml_file).sub(/\.yml$/,'').intern,YAML.load(File.read(yaml_file)))
    end
    ActiveRecord::Base.establish_connection Config.database[ENV['RACK_ENV'].downcase.underscore]
  end

  module Config
    class << self
      def set(key, value)
        @store ||= {}
        @store[key.to_sym] = value
      end

      def get(key)
        @store[key.to_sym]
      end

      def [](key)
        get(key)
      end

      def []=(key, value)
        set(key, value)
      end

      def method_missing(key)
        get(key)
      end
    end
  end

end

Environment.reload!

configure :development do
  before do
    Environment.reload!
  end
end

helpers TeamFun::Helpers

set :root, File.dirname(__FILE__)