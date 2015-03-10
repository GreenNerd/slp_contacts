require "slp_contacts/engine"

module SlpContacts
  mattr_accessor :contact_class

  def self.contact_class
    @@contact_class.constantize
  end
end
