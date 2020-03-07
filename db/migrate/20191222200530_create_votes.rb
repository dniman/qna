class CreateVotes < ActiveRecord::Migration[5.2]
  def change
    create_table :votes do |t|
      t.references :votable, polymorphic: true, index: true
      t.references :user, foreign_key: { to_table: :users }, index: true
      t.integer :yes, default: 0

      t.timestamps
    end
  end
end
