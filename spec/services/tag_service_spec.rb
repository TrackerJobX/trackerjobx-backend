require 'rails_helper'

RSpec.describe TagService, type: :service do
  let(:service) { described_class.new }

  describe '#find_all_tags' do
    it 'returns all tags' do
      create_list(:tag, 3)
      expect(service.find_all_tags.count).to eq(3)
    end
  end

  describe '#find_tag' do
    it 'returns the tag with given id' do
      tag = create(:tag)
      expect(service.find_tag(tag.id)).to eq(tag)
    end
  end

  describe '#find_tag' do
    it 'raises error when tag not found' do
      expect {
        service.find_tag(SecureRandom.uuid)
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe '#create_tag' do
    it 'creates a new tag with valid params' do
      tag = service.create_tag(name: 'Backend')
      expect(tag).to be_persisted
    end

    it 'raises error when name is missing' do
      expect {
        service.create_tag(name: nil)
      }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe '#update_tag' do
    it 'updates the tag name' do
      tag = create(:tag)
      updated = service.update_tag(tag.id, name: 'Updated Name')
      expect(updated.name).to eq('Updated Name')
    end
  end

  describe '#update_tag' do
    it 'raises error when updating non-existent tag' do
      expect {
        service.update_tag(SecureRandom.uuid, name: 'NewName')
      }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'raises error when update is invalid' do
      tag = create(:tag)
      expect {
        service.update_tag(tag.id, name: nil)
      }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe '#destroy_tag' do
    it 'soft deletes the tag' do
      tag = create(:tag)
      service.destroy_tag(tag.id)
      expect(Tag.with_deleted.find(tag.id).deleted_at).not_to be_nil
    end
  end

  describe '#destroy_tag' do
    it 'raises error when tag does not exist' do
      expect {
        service.destroy_tag(SecureRandom.uuid)
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
