class AddIsBestToAnswer < ActiveRecord::Migration[5.2]
  def change
    add_column :answers, :is_best, :int, null: false, default: 0
  end
end
