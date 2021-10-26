class CreateSubscriptions < ActiveRecord::Migration[5.2]
  def change
    create_table :subscriptions do |t|
      t.references :question, foreign_key: { to_table: :questions }, index: true 
      t.references :user, foreign_key: { to_table: :users }, index: true

      t.timestamps
    end
  end
end
