class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.string :title
      t.string :org
      t.boolean :internship
      t.date :postdate
      t.date :filldate
      t.string :location
      t.text :description
      t.string :link

      t.timestamps
    end
  end
end
