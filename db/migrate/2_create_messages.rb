class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :phonify_messages do |t|
      t.references :owner, polymorphic: true
      t.string :token
    end
  end

  def self.down
    drop_table :phonify_messages
  end
end
