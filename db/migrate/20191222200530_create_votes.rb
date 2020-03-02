class CreateVotes < ActiveRecord::Migration[5.2]
  def change
    create_table :votes do |t|
      t.references :votable, polymorphic: true, index: true
      t.references :user, foreign_key: { to_table: :users }, index: true
      t.boolean :yes, default: false

      t.timestamps
    end
  end
end
