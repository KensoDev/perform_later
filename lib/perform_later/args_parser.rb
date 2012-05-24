require 'json'

module PerformLater
  class ArgsParser
    # inspired by DelayedJob
    CLASS_STRING_FORMAT = /^CLASS\:([A-Z][\w\:]+)$/
    AR_STRING_FORMAT    = /^AR\:([A-Z][\w\:]+)\:(\d+)$/
    YAML_STRING_FORMAT  = /\A---/

    def self.args_to_resque(*args)
      args = args.flatten.map { |o|
        case o
          when ActiveRecord::Base
            "AR:#{o.class.name}:#{o.id}"
          when Class, Module
            "CLASS:#{o.name}"
          when Hash
            o.to_yaml
          else
            o
        end
      } if args
    end
    
    def self.args_from_resque(args)
      args = args.flatten.map { |o|
        if o
          case o
          when CLASS_STRING_FORMAT  then $1.constantize
          when AR_STRING_FORMAT     then $1.constantize.find_by_id($2)
          when YAML_STRING_FORMAT   then YAML.load(o)
          else o
          end
        end
      } if args      
    end
  end
end