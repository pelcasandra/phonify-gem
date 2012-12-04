class CreatePhonifySubscriptions < ActiveRecord::Migration
  def self.up
    create_table :phonify_subscriptions do |t|
      t.references :owner, :polymorphic => true
      t.integer :phone_id
      t.string :campaign_id
      t.string :token
      t.boolean :active
    end
    add_index :phonify_subscriptions, [:owner_id, :owner_type]
    add_index :phonify_subscriptions, [:campaign_id, :token]
  end

  def self.down
    drop_table :phonify_subscriptions
  end
end
