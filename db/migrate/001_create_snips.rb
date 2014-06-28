class CreateSnips < ActiveRecord::Migration
  def change
    create_table :snips do |t|
      t.string :name
      t.string :description
      t.text :code
	  t.string :codetype
      t.string :tag
      t.string :ref
      t.string :author
      t.string :last_modified_by
      t.datetime :last_modified
    end
  end
end
