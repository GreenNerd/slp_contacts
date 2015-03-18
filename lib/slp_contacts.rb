require "slp_contacts/engine"
require "slp_contacts/model_hooks"
require "slp_contacts/namespace_hooks"

module SlpContacts
  mattr_accessor :contact_class
  mattr_accessor :namespace_class

  def self.contact_class
    @@contact_class.constantize if @@contact_class
  end

  def self.namespace_class
    @@namespace_class.constantize
  end

end

