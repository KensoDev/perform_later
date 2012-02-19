require 'perform_later'
require 'rspec'

RSpec.configure do |config|
  config.color_enabled = true
  config.formatter     = 'documentation'
end
