require "test_helper"
require "active_record"

ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")

ActiveRecord::Schema.define do
  create_table :users, force: true do |t|
    t.integer :status, null: false
  end
end

class User < ActiveRecord::Base
  include ::ActiveRecord::EnumTranslation

  enum(
    status: %i[
      active
      inactive
    ]
  )
  human_enum_name_reader_for :status
end

I18n.backend.store_translations(
  :en,
  YAML.load(<<-YAML)
    activerecord:
      attributes:
        user:
          status:
            active: Active
            inactive: Inactive
  YAML
)

class EnumTranslationTest < Minitest::Test
  def test_human_enum_name_for
    user = ::User.new(status: :active)
    actual = user.human_enum_name_for(:status)
    assert_equal actual, "Active"
  end

  def test_human_enum_name_reader_for
    user = ::User.new(status: :active)
    actual = user.human_enum_name_for_status
    assert_equal actual, "Active"
  end
end
