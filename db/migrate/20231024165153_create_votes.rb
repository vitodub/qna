class CreateVotes < ActiveRecord::Migration[6.1]
  def change
    create_table :votes do |t|
      t.boolean :liked, default: false

      t.belongs_to :votable, polymorphic: true
      t.belongs_to :user, foreign_key: true
      t.timestamps
    end
  end
end
