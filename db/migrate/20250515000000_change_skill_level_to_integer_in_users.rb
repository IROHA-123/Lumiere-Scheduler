# SQLiteとPostgreSQLの両方で動く安全な書き方
class ChangeSkillLevelToIntegerInUsers < ActiveRecord::Migration[7.1]
  def up
    if sqlite?
      # 一時列を作って値を詰め替え → 元の列を置き換える
      add_column :users, :skill_level_tmp, :integer, default: 0, null: false

      execute <<~SQL
        UPDATE users
        SET skill_level_tmp =
          CASE
            WHEN skill_level IS NULL OR TRIM(skill_level) = '' THEN 0
            WHEN TRIM(skill_level) GLOB '[0-9]*' THEN CAST(skill_level AS INTEGER)
            ELSE 0
          END
      SQL

      remove_column :users, :skill_level
      rename_column :users, :skill_level_tmp, :skill_level

      change_column_default :users, :skill_level, 0
      change_column_null :users, :skill_level, false, 0
    else
      # PostgreSQL 等なら従来の :using が使える
      change_column :users, :skill_level, :integer, using: 'skill_level::integer', default: 0
      change_column_null :users, :skill_level, false, 0
    end
  end

  def down
    if sqlite?
      add_column :users, :skill_level_tmp, :string
      execute "UPDATE users SET skill_level_tmp = CAST(skill_level AS TEXT)"
      remove_column :users, :skill_level
      rename_column :users, :skill_level_tmp, :skill_level
    else
      change_column :users, :skill_level, :string
    end
  end

  private

  def sqlite?
    ActiveRecord::Base.connection.adapter_name.downcase.include?('sqlite')
  end
end
