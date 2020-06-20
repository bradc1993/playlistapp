class RemoveUserIdFromPlaylists < ActiveRecord::Migration[6.0]
  def change
    remove_column :playlists, :user_id
  end
end
