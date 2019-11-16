class AddIsBestToAnswer < ActiveRecord::Migration[5.2]
  def change
    add_column :answers, :is_best, :boolean, null: false, default: false
  end
end
