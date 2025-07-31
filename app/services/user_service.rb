# frozen_string_literal: true

class UserService
  def initialize ; end
  def find_all_users
    User.all
  end

  def find_user(id)
    User.find(id)
  end

  def create_user(user_params)
    User.create(user_params)
  end

  def update_user(id, user_params)
    user = User.find(id)
    user.update!(user_params)
    user
  end

  def destroy_user(id)
    User.find(id).destroy
  end
end
