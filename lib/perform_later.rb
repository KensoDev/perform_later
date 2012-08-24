require 'active_support/dependencies'
require 'perform_later/version'
require 'perform_later/config'
require 'perform_later/payload_helper'
require 'perform_later/args_parser'
require 'perform_later/plugins'
require 'resque'
require 'resque_scheduler'
require 'active_record'
require 'resque_mailer_patch'
require 'object_perform_later'
require 'perform_later/workers/base'
require 'perform_later/workers/active_record/worker'
require 'perform_later/workers/active_record/lone_worker'
require 'perform_later/workers/objects/worker'
require 'perform_later/workers/objects/lone_worker'

module PerformLater
  def self.config
    PerformLater::Config
  end
end

module Resque
  module Plugins
    module Later
      autoload :Method, 'resque/plugins/later/method'
    end
  end
end

ActiveSupport.on_load(:active_record) do
  include Resque::Plugins::Later::Method
end
