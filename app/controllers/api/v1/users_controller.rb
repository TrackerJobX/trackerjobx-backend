# frozen_string_literal: true

class Api::V1::UsersController < Api::V1::BaseController
  def index
    @users = service.find_all_users
    render json: {
      status: "success",
      data: UserBlueprint.render_as_hash(@users)
    }, status: :ok
  end

  def show
    @user = service.find_user(params[:id])
    render json: {
      status: "success",
      data: UserBlueprint.render_as_hash(@user)
    }, status: :ok
  end

  def create
    @user = service.create_user(user_params)
    render json: {
      status: "success",
      data: UserBlueprint.render_as_hash(@user)
    }, status: :created
  end

  def update
    @user = service.update_user(params[:id], user_params)
    render json: {
      status: "success",
      data: UserBlueprint.render_as_hash(@user)
    }, status: :ok
  end

  def destroy
    @user = service.destroy_user(params[:id])
    render json: {
      status: "success"
    }, status: :no_content
  end

  private

  def user_params
    params.permit(:username, :email, :password, :first_name, :last_name, :phone, :role)
  end

  def service
    @service ||= UserService.new
  end
end
