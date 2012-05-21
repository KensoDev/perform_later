require 'active_support/dependencies'
require 'perform_later/version'
require 'resque'
require 'resque-loner'
require 'perform_later/args_parser'
require 'active_record'
require 'resque_mailer_patch'
require 'object_worker'
require 'object_perform_later'
require 'perform_later/workers/active_record/worker'
require 'perform_later/workers/active_record/lone_worker'

module PerformLater
  extend self

  def enabled=(value)
    @enabled = value
  end

  def enabled?
    @enabled || false
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


