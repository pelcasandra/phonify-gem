class CreatePhones < ActiveRecord::Migration
  def self.up
    create_table :phonify_phones do |t|
      t.references :owner, polymorphic: true
      t.string :token
    end
  end

  def self.down
    drop_table :phonify_phones
  end
end
