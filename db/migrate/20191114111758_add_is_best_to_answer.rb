class AddIsBestToAnswer < ActiveRecord::Migration[5.2]
  def change
    add_column :answers, :best_answer, :boolean, null: false, default: false
  end
end
