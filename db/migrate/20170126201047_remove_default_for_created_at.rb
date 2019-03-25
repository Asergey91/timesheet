class RemoveDefaultForCreatedAt < ActiveRecord::Migration
  def change
    change_column_default(:tasks, :created_at, nil)
    change_column_default(:tasks, :updated_at, nil)
  end
end
