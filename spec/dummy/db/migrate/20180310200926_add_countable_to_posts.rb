class AddCountableToPosts < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :countable, :boolean, null: false, default: false
  end
end
