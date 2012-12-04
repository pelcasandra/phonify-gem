class CreatePhonifyPhones < ActiveRecord::Migration
  def self.up
    create_table :phonify_phones do |t|
      t.references :owner, :polymorphic => true
      t.string :campaign_id
      t.string :token
    end
    add_index :phonify_phones, [:owner_id, :owner_type]
    add_index :phonify_phones, [:campaign_id, :token]
  end

  def self.down
    drop_table :phonify_phones
  end
end
