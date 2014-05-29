require File.expand_path('../boot', __FILE__)

require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

Bundler.require(:default, Rails.env)

module Eajobsboard
  class Application < Rails::Application

    config.assets.precompile += %w(*.png *.jpg *.jpeg *.gif)
    config.autoload_paths += %W(#{config.root}/lib)

    config.action_mailer.delivery_method   = :postmark
		config.action_mailer.postmark_settings = { :api_key => ENV['POSTMARK_API_KEY'] }

  end
end
