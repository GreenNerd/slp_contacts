require 'rails/generators/active_record'

module SlpContacts
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration
      attr_accessor :contact_class_name, :contact_table_name

      desc 'Setup contacts app.'

      source_root File.expand_path('../templates', __FILE__)

      def self.next_migration_number(path)
        Time.now.utc.strftime("%Y%m%d%H%M%S")
      end

      def set_contact_class_name
        @contact_class_name = ask('The class_name of contact?[User]')
        @contact_class_name = 'User' if @contact_class_name.blank?
        @contact_class_name = @contact_class_name.camelize
        @contact_table_name = @contact_class_name.underscore.pluralize
      end

      def copy_migration_files
        migration_template 'create_slp_contacts_favorites.rb', 'db/migrate/create_slp_contacts_favorites.rb'
        migration_template 'add_contact_public_to_users.rb', 'db/migrate/add_contact_public_to_users.rb'
      end

      def copy_config_files
        template 'slp_contacts.rb', 'config/initializers/slp_contacts.rb'
      end
    end
  end
end
