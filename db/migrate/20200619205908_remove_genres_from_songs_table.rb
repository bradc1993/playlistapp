class RemoveGenresFromSongsTable < ActiveRecord::Migration[6.0]
  def change
    remove_column :songs, :genre
  end
end
