require "active_support/concern"
require "activerecord/enum_translation/version"

module ActiveRecord
  module EnumTranslation
    extend ::ActiveSupport::Concern

    # Translates enum identifiers into a more human format, such as `"Active"` instead of `:active`.
    # @param [Symbol] enum_name
    # @param [Integer] count
    # @param [Symbol, String, nil] default
    # @return [String, nil]
    # @example
    #   User.new(status: :active).human_enum_name_for(:status) #=> "Active"
    #   User.new.human_enum_name_for(:status) #=> nil
    #   User.new.human_enum_name_for(:status, default: "Unknown") #=> "Unknown"
    #   User.new.human_enum_name_for(:status, default: :"common.unknown") #=> "Unknown"
    def human_enum_name_for(enum_name, count: 1, default: nil)
      options = { count: count }
      enum_value = public_send(enum_name)
      scope = "#{self.class.i18n_scope}.attributes"

      defaults = []
      if enum_value
        defaults += self.class.lookup_ancestors.map do |ancestor|
          :"#{scope}.#{ancestor.model_name.i18n_key}.#{enum_name}.#{enum_value}"
        end
        defaults << :"attributes.#{enum_name}.#{enum_value}"
      else
        defaults << nil
      end
      defaults << default if default
      defaults << enum_value.humanize if enum_value

      key = defaults.shift
      options[:default] = defaults.empty? ? nil : defaults
      ::I18n.t(key, **options)
    end

    module ClassMethods
      # Defines handy reader method for enum translation.
      # @param [Symbol] enum_name
      # @param [Hash] options
      # @example
      #   class User < ApplicationRecord
      #     human_enum_name_reader_for :status
      #   end
      #
      #   User.new(status: :active).human_enum_name_for_status #=> "Active"
      def human_enum_name_reader_for(enum_name)
        define_method("human_enum_name_for_#{enum_name}") do |**options|
          human_enum_name_for(enum_name, **options)
        end
      end
    end
  end
end
