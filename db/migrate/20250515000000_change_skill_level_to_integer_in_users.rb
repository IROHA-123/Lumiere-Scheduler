class ChangeSkillLevelToIntegerInUsers < ActiveRecord::Migration[7.1]
  def up
    change_column :users, :skill_level, :integer, using: 'skill_level::integer', default: 0
  end

  def down
    change_column :users, :skill_level, :string, default: nil
  end
end
