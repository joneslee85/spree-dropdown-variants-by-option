class AddPositionToOptionTypes < ActiveRecord::Migration
  def self.up
    add_column :option_types, :display_as_dropdown, :boolean, :default => false
   end

  def self.down
    remove_column :option_types, :display_as_dropdown
   end
end