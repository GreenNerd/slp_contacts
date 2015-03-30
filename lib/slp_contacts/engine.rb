require "kaminari"
require "jquery-rails"
require "jbuilder"

module SlpContacts
  class Engine < ::Rails::Engine
    isolate_namespace SlpContacts

    config.generators do |g|
      g.helper false
      g.assets false
      g.javascripts false
      g.template_engine :slim
      g.test_framework :rspec,
        fixture: true,
        view_specs: false,
        helper_specs: false,
        routing_specs: false,
        controller_specs: true,
        request_specs: false
      g.fixture_replacement :fabrication
    end

    initializer 'slp_contacts.model' do |app|
      if SlpContacts.contact_class || Rails.env.production?
        SlpContacts.contact_class.send :include, SlpContacts::ModelHooks
      else
        puts 'Need to set the contact_class for SlpContacts(config/initializer/slp_contacts.rb).'
      end

      if SlpContacts.namespace_class || Rails.env.production?
        SlpContacts.namespace_class.send :include, SlpContacts::NamespaceHooks
      else
        puts 'Need to set the namespace_class for SlpContacts(config/initializer/slp_contacts.rb).'
      end
    end

    initializer 'SlpContacts precompile hook', group: :all do |app|
      app.config.assets.precompile += %w(
        slp_contacts/application.css
        slp_contacts/application.js
      )

    end
  end
end
