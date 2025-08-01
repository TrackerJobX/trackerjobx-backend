require 'rails_helper'

RSpec.describe JobApplicationService do
  let(:service) { described_class.new }
  let(:user) { create(:user) }

  describe '#create_job_application' do
    context 'with valid params' do
      it 'creates a job application' do
        job_params = attributes_for(:job_application).merge(user_id: user.id)
        job_app = service.create_job_application(job_params)

        expect(job_app).to be_persisted
        expect(job_app.user_id).to eq(user.id)
      end
    end

    context 'with missing required fields' do
      it 'raises error' do
        expect {
          service.create_job_application({})
        }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'with invalid status' do
      it 'raises error on unknown status' do
        job_params = attributes_for(:job_application, status: 'invalid_status').merge(user_id: user.id)
        expect {
          service.create_job_application(job_params)
        }.to raise_error(ArgumentError, /is not a valid status/)
      end
    end

    context 'with non-existent user_id' do
      it 'raises ActiveRecord::RecordInvalid' do
        params = attributes_for(:job_application).merge(user_id: SecureRandom.uuid)

        expect {
          service.create_job_application(params)
        }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'with tag_ids' do
      it 'assigns tags correctly' do
        tags = create_list(:tag, 2)
        job_params = attributes_for(:job_application).merge(user_id: user.id, tag_ids: tags.map(&:id))

        job_app = service.create_job_application(job_params)

        expect(job_app.tags.map(&:id)).to match_array(tags.map(&:id))
      end
    end
  end

  describe '#find_job_application' do
    let(:job_app) { create(:job_application, user: user) }

    it 'returns job application if exists' do
      result = service.find_job_application(job_app.id)
      expect(result).to eq(job_app)
    end

    it 'raises error if job application not found' do
      expect {
        service.find_job_application(SecureRandom.uuid)
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe '#update_job_application' do
    let(:job_application) { create(:job_application, user: user) }

    it 'updates the application' do
      updated = service.update_job_application(job_application.id, { company_name: "Updated Company" })
      expect(updated.company_name).to eq("Updated Company")
    end

    it 'raises error when invalid' do
      expect {
        service.update_job_application(job_application.id, { company_name: nil })
      }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'raises error if job application not found' do
      expect {
        service.update_job_application(SecureRandom.uuid, { company_name: "Nope" })
      }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'updates tags correctly' do
      job_app = create(:job_application, user: user)
      new_tags = create_list(:tag, 3)

      updated = service.update_job_application(job_app.id, { tag_ids: new_tags.map(&:id) })

      expect(updated.tags.map(&:id)).to match_array(new_tags.map(&:id))
    end
  end

  describe '#destroy_job_application' do
    let!(:job_application) { create(:job_application, user: user) }

    it 'soft deletes the record' do
      expect {
        service.destroy_job_application(job_application.id)
      }.to change { JobApplication.count }.by(-1)
    end

    it 'raises error if job application not found' do
      expect {
        service.destroy_job_application(SecureRandom.uuid)
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
