require "active_support/concern"
require "activerecord/enum_translation/version"

module ActiveRecord
  module EnumTranslation
    extend ::ActiveSupport::Concern

    # Translates enum identifiers into a more human format, such as `"Active"` instead of `:active`.
    # @param [Symbol] enum_name
    # @param [Symbol, String, nil] default
    # @return [String, nil]
    # @example
    #   User.new(status: :active).human_enum_name_for(:status) #=> "Active"
    #   User.new.human_enum_name_for(:status) #=> nil
    #   User.new.human_enum_name_for(:status, default: "Unknown") #=> "Unknown"
    #   User.new.human_enum_name_for(:status, default: :"common.unknown") #=> "Unknown"
    def human_enum_name_for(enum_name, default: nil)
      enum_value = public_send(enum_name)
      defaults = []
      if enum_value
        defaults += self.class.lookup_ancestors.map do |ancestor|
          :"activerecord.attributes.#{ancestor.model_name.i18n_key}.#{enum_name}.#{enum_value}"
        end
      else
        defaults << nil
      end
      defaults << default if default
      ::I18n.t(defaults.shift, default: defaults.empty? ? nil : defaults)
    end

    module ClassMethods
      # Defines handy reader method for enum translation.
      # @param [Symbol] enum_name
      # @param [Symbol, String, nil] default
      # @example
      #   class User < ApplicationRecord
      #     human_enum_name_reader_for :status
      #   end
      #
      #   User.new(status: :active).human_enum_name_for_status #=> "Active"
      def human_enum_name_reader_for(enum_name, default: nil)
        define_method("human_enum_name_for_#{enum_name}") do
          human_enum_name_for(enum_name, default: default)
        end
      end
    end
  end
end
