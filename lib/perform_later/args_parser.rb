require 'json'

module PerformLater
  class ArgsParser
    # inspired by DelayedJob
    CLASS_STRING_FORMAT = /^CLASS\:([A-Z][\w\:]+)$/
    AR_STRING_FORMAT    = /^AR\:([A-Z][\w\:]+)\:(\d+)$/
    YAML_STRING_FORMAT  = /\A---/

    def self.args_to_resque(args)
      return nil unless args
      return arg_to_resque(args) unless args.is_a?(Array)
      return args.map { |o| arg_to_resque o }
    end
    
    def self.args_from_resque(args)
      args = args.map { |o|
        if o
          o = args_from_resque(o) if o.is_a?(Array)
          case o
          when CLASS_STRING_FORMAT  then $1.constantize
          when AR_STRING_FORMAT     then $1.constantize.find_by_id($2)
          when YAML_STRING_FORMAT   then YAML.load(o)
          else o
          end
        end
      } if args
    end

  private

    def self.arg_to_resque(arg)
      case arg
      when ActiveRecord::Base
        "AR:#{arg.class.name}:#{arg.id}"
      when Class, Module
        "CLASS:#{arg.name}"
      when Hash
        arg.to_yaml
      else
        arg
      end
    end
  end
end