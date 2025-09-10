class AddUniqueIndexToShiftRequests < ActiveRecord::Migration[7.1]
  def change
    add_index :shift_requests, [:user_id, :project_id], unique: true
  end
end

