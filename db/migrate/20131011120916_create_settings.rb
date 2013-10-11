class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.boolean :mobile_view

      t.timestamps
    end
  end
end
