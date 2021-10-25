class CreateSubscriptions < ActiveRecord::Migration[5.2]
  def change
    create_table :subscriptions do |t|
      t.references :subscriptionable, polymorphic: true, index: { name: :idx_subscriptions_on_type_and_id } 
      t.references :user, foreign_key: { to_table: :users }, index: true

      t.timestamps
    end
  end
end
