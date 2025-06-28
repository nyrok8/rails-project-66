class CreateRepositories < ActiveRecord::Migration[7.2]
  def change
    create_table :repositories do |t|
      t.string :name
      t.bigint :github_id, null: false
      t.string :full_name
      t.string :language
      t.string :clone_url
      t.string :ssh_url

      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :repositories, [:user_id, :github_id], unique: true
  end
end
