class AddCanCreateUserToUsers < ActiveRecord::Migration
  def up
    add_column :users, :can_create_user, :boolean, default: false, null: false
  end

  def down
    remove_column :users, :can_create_user
  end
end
