class AddColumnUserIdToBounties < ActiveRecord::Migration[5.2]
  def change
    add_reference :bounties, :user, foreign_key: { to_table: :users }, index: true
  end
end
