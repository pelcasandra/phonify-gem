class CreatePhonifyMessages < ActiveRecord::Migration
  def self.up
    create_table :phonify_messages do |t|
      t.references :owner, :polymorphic => true
      t.integer :subscription_id
      t.integer :phone_id
      t.string :campaign_id
      t.string :token
    end
    add_index :phonify_messages, [:owner_id, :owner_type]
    add_index :phonify_messages, [:campaign_id, :token]
  end

  def self.down
    drop_table :phonify_messages
  end
end
