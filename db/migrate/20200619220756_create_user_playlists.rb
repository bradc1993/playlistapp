class CreateUserPlaylists < ActiveRecord::Migration[6.0]
  def change
    create_table :user_playlists do |t|
      t.belongs_to :user
      t.belongs_to :playlist
      t.timestamps
    end
  end
end
