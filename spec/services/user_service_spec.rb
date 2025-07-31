# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserService, type: :service do
  let(:service) { described_class.new }
  let!(:user) { create(:user) }

  describe '#find_all_users' do
    it 'returns all users' do
      users = service.find_all_users
      expect(users).to include(user)
    end
  end

  describe '#find_user' do
    it 'returns the user when found' do
      expect(service.find_user(user.id)).to eq(user)
    end

    it 'raises ActiveRecord::RecordNotFound when user does not exist' do
      expect {
        service.find_user(SecureRandom.uuid)
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe '#create_user' do
    let(:valid_params) {
      attributes_for(:user)
    }

    let(:invalid_params) {
      attributes_for(:user, email: nil)
    }

    it 'creates a new user with valid params' do
      new_user = service.create_user(valid_params)
      expect(new_user).to be_persisted
      expect(new_user.email).to eq(valid_params[:email])
    end

    it "raises an error when params are invalid" do
      expect {
        service.create_user(invalid_params)
      }.to raise_error(ActiveRecord::RecordInvalid, /Email can't be blank/)
    end
  end

  describe '#update_user' do
    let(:update_params) { { username: 'updatedname' } }

    it 'updates the user and returns it' do
      updated_user = service.update_user(user.id, update_params)
      expect(updated_user.username).to eq('updatedname')
    end

    it 'raises error if user not found' do
      expect {
        service.update_user(SecureRandom.uuid, update_params)
      }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'raises error if update is invalid' do
      expect {
        service.update_user(user.id, { email: nil })
      }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe '#destroy_user' do
    it 'soft deletes the user' do
      expect {
        service.destroy_user(user.id)
      }.to change { User.with_deleted.count }.by(0) # tetap 1 tapi deleted_at berubah

      expect(User.with_deleted.find_by(id: user.id).deleted_at).not_to be_nil
    end

    it 'raises error if user not found' do
      expect {
        service.destroy_user(SecureRandom.uuid)
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
