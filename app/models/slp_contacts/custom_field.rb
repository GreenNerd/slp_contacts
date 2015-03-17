module SlpContacts
  class CustomField < ActiveRecord::Base
    belongs_to :namespace, class_name: SlpContacts.namespace_class.to_s
  end
end
