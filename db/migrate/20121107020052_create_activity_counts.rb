class CreateActivityCounts < ActiveRecord::Migration
  def up
    create_table 'activity_counts' do |t|
      t.timestamp 'time'
      t.integer 'count'
      t.integer 'user_id'
      end
  end

  def down
    drop_table 'activity_counts'
  end
end
