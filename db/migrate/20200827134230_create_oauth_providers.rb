class CreateOauthProviders < ActiveRecord::Migration[5.2]
  def change
    create_table :oauth_providers do |t|
      t.references :user, foreign_key: true
      t.string :provider
      t.string :uid

      t.timestamps
    end

    add_index :oauth_providers, [:provider, :uid]
  end
end
