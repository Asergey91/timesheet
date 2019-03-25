class TimeTrackingToUser < ActiveRecord::Migration
  def change
    add_column(:users, :timer_status, :integer, :default => 0)
    add_column(:users, :timer_paused_at, :datetime, :default => nil)
    add_column(:users, :timer_started_at, :datetime, :default => nil)
    add_column(:users, :timer_elapsed_time, :integer, :default => 0)
    add_column(:users, :timer_activity, :integer, :default => 0)
  end
end
