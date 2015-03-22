module SlpContacts
  module ApplicationHelper
    def i18n_field_type
      result = []
      CustomField.field_types.each do |type|
        result << [type.first, I18n.t(type.first)]
      end
      result
    end
  end
end
