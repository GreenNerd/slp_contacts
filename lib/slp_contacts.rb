require "slp_contacts/engine"
require "slp_contacts/model_hooks"

module SlpContacts
  mattr_accessor :contact_class

  def self.contact_class
    @@contact_class.constantize
  end
end
