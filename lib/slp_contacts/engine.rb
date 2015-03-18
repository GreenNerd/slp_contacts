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
      SlpContacts.contact_class.send :include, SlpContacts::ModelHooks
      SlpContacts.namespace_class.send :include, SlpContacts::NamespaceHooks
    end
  end
end
