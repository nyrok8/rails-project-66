class CreateRepositoryChecks < ActiveRecord::Migration[7.2]
  def change
    create_table :repository_checks do |t|
      t.string :aasm_state, default: 'created', null: false
      t.string :commit_id
      t.boolean :passed
      t.json :result

      t.references :repository, null: false, foreign_key: true

      t.timestamps
    end
  end
end
