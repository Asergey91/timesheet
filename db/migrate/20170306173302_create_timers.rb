class CreateTimers < ActiveRecord::Migration
  def change
    create_table :timers do |t|
      
      t.belongs_to :user
      t.belongs_to :activity
      
      t.integer :timer_status, :default => 0
      t.datetime :timer_paused_at, :default => nil
      t.datetime :timer_started_at, :default => nil
      t.integer :timer_elapsed_time, :default => 0
      
    end
  end
end
