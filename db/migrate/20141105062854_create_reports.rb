class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.string :sha1
      t.string :title
      t.date :createdOn
      t.date :updatedOn
      t.references :reportable, polymorphic: true
      t.string :mimeType
      t.integer :size
      t.string :file

      t.timestamps
    end
  end
end
