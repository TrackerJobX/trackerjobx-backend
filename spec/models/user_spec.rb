# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#generate_username' do
    context 'when username already present' do
      it 'does not change the existing username' do
        user = User.new(username: 'customuser', first_name: 'John', last_name: 'Doe', email: 'john@example.com')
        user.send(:generate_username)
        expect(user.username).to eq('customuser')
      end
    end

    context 'when username is blank and name is present' do
      it 'generates username from name' do
        user = User.new(first_name: 'Jane', last_name: 'Smith', email: 'jane@example.com')
        user.send(:generate_username)
        expect(user.username).to eq('janesmith')
      end
    end

    context 'when name is blank but email is present' do
      it 'generates username from email prefix' do
        user = User.new(email: 'testuser@example.com')
        user.send(:generate_username)
        expect(user.username).to eq('testuser')
      end
    end

    context 'when generated username already exists' do
      before do
        User.create!(username: 'janesmith', email: 'existing@example.com', password: 'password', password_confirmation: 'password')
      end

      it 'adds number suffix to make username unique' do
        user = User.new(first_name: 'Jane', last_name: 'Smith', email: 'jane2@example.com')
        user.send(:generate_username)
        expect(user.username).to match(/^janesmith\d+$/)
      end
    end

    context 'when generate user with roles' do
      it 'generate username' do
        user = User.new(first_name: 'Jane', last_name: 'Smith', email: 'jane2@example.com', role: 'admin')
        user.send(:generate_username)
        expect(user.username).to match("janesmith")
      end

      it 'generate username' do
        user = User.new(first_name: 'Jane', last_name: 'Smith', email: 'jane2@example.com', role: 'member')
        user.send(:generate_username)
        expect(user.username).to match("janesmith")
      end

      it 'raises error for invalid role' do
        expect {
          User.new(first_name: 'Jane', last_name: 'Smith', email: 'jane2@example.com', role: 'guest')
        }.to raise_error(ArgumentError, "'guest' is not a valid role")
      end
    end
  end
end
