class CreateBounties < ActiveRecord::Migration[5.2]
  def change
    create_table :bounties do |t|
      t.string :name
      t.belongs_to :question, foreign_key: true

      t.timestamps
    end
  end
end
