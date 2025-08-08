require 'rails_helper'

RSpec.describe InterviewService do
  let(:service) { described_class.new }
  let(:job_application) { create(:job_application) }

  describe '#find_all_interviews_by_user' do
    let(:user1) { create(:user) }
    let(:user2) { create(:user) }

    let!(:job_application1) { create(:job_application, user: user1) }
    let!(:job_application2) { create(:job_application, user: user2) }

    before do
      create_list(:interview, 2, job_application: job_application1)
      create_list(:interview, 3, job_application: job_application2)
    end

    it 'returns interviews for job applications belonging to the user' do
      result = service.find_all_interviews_by_user(user1)
      expect(result.size).to eq(2)
      expect(result.pluck(:job_application_id).uniq).to eq([ job_application1.id ])
    end
  end

  describe '#find_all_interviews_by_job_application' do
    let(:user) { create(:user) }
    let(:job_application) { create(:job_application, user: user) }

    before { create_list(:interview, 3, job_application: job_application) }

    it 'returns all interviews for a job application owned by the user' do
      result = service.find_all_interviews_by_job_application(job_application.id, user)
      expect(result.size).to eq(3)
      expect(result.pluck(:job_application_id).uniq).to eq([ job_application.id ])
    end

    it 'raises error if job application does not belong to user' do
      other_user = create(:user)
      expect {
        service.find_all_interviews_by_job_application(job_application.id, other_user)
      }.to raise_error(ActiveRecord::RecordNotFound, "Job Application not found")
    end

    it 'raises error if job application is not found' do
      expect {
        service.find_all_interviews_by_job_application(SecureRandom.uuid, user)
      }.to raise_error(ActiveRecord::RecordNotFound, "Job Application not found")
    end
  end

  describe '#find_interview' do
    let(:interview) { create(:interview, job_application: job_application) }

    it 'finds interview' do
      found = service.find_interview(interview.id)
      expect(found).to eq(interview)
    end

    it 'raises error if not found' do
      expect {
        service.find_interview(SecureRandom.uuid)
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe '#create_interview' do
    it 'creates interview with valid params' do
      params = attributes_for(:interview).merge(job_application_id: job_application.id)
      result = service.create_interview(params)

      expect(result).to be_persisted
      expect(result.job_application_id).to eq(job_application.id)
    end

    it 'raises error for missing fields' do
      expect {
        service.create_interview({})
      }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe '#update_interview' do
    let(:interview) { create(:interview, job_application: job_application) }

    it 'updates the interview' do
      updated = service.update_interview(interview.id, { location: "Updated Location" })
      expect(updated.location).to eq("Updated Location")
    end

    it 'raises error if invalid' do
      expect {
        service.update_interview(interview.id, { interview_date: nil })
      }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'raises error if not found' do
      expect {
        service.update_interview(SecureRandom.uuid, { location: "Nope" })
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe '#destroy_interview' do
    let!(:interview) { create(:interview, job_application: job_application) }

    it 'soft deletes the interview' do
      expect {
        service.destroy_interview(interview.id)
      }.to change { Interview.count }.by(-1)
    end

    it 'raises error if not found' do
      expect {
        service.destroy_interview(SecureRandom.uuid)
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
