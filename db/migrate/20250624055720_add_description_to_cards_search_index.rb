class AddDescriptionToCardsSearchIndex < ActiveRecord::Migration[8.1]
  def change
    drop_virtual_table :cards_search_index, "fts5", ["title"]
    create_virtual_table :cards_search_index, "fts5", ["title", "description"]
  end
end
