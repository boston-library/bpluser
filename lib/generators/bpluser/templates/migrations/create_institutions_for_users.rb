# -*- encoding : utf-8 -*-
class CreateInstitutionsForUsers < ActiveRecord::Migration
  def self.up
    create_table :user_institutions do |t|
      t.string :pid
      t.references :user

      t.timestamps
    end
    add_index :user_institutions, :user_id
  end

  def self.down
    drop_table :user_institutions
  end
end