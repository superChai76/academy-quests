class CreateQuests < ActiveRecord::Migration[8.0]
  def change
    create_table :quests do |t|
      t.text :description
      t.boolean :is_done

      t.timestamps
    end
  end
end
