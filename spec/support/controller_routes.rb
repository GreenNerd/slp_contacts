module SlpContacts
  module RSpec
    module ControllerRoutes
      extend ActiveSupport::Concern
      included do
        routes { ::SlpContacts::Engine.routes }
      end
    end
  end
end

RSpec.configure do |c|
  c.include SlpContacts::RSpec::ControllerRoutes, type: :controller
end

