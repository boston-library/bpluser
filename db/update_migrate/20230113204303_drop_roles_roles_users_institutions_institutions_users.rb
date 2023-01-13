# frozen_string_literal: true

class DropRolesRolesUsersInstitutionsInstitutionsUsers < ActiveRecord::Migration[6.0]
  def change
    drop_table :roles_users
    drop_table :roles
    drop_table :institutions_users
    drop_table :institutions
  end
end
