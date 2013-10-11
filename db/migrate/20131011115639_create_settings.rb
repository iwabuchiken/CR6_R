class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.mobile_view :boolean

      t.timestamps
    end
  end
end
