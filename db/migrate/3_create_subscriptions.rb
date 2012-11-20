class CreateSubscriptions < ActiveRecord::Migration
  def self.up
    create_table :phonify_subscriptions do |t|
      t.references :owner, polymorphic: true
      t.string :token
    end
  end

  def self.down
    drop_table :phonify_subscriptions
  end
end
