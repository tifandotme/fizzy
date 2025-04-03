class CreateBubbleEngagements < ActiveRecord::Migration[8.1]
  def change
    create_table :bubble_engagements do |t|
      t.references :bubble, index: true

      t.timestamps
    end
  end
end
