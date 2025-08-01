require 'rails_helper'

RSpec.describe AttachmentService do
  let(:service) { described_class.new }
  let(:user) { create(:user) }
  let(:job_application) { create(:job_application, user: user) }
  let!(:attachments) { create_list(:attachment, 3, job_application: job_application) }

  describe '#find_all_by_job_application' do
    it 'returns all attachments for a job application' do
      result = service.find_all_by_job_application(job_application.id)
      expect(result.size).to eq(3)
      expect(result.pluck(:id)).to match_array(attachments.map(&:id))
    end

    it 'returns empty array if no attachments exist' do
      new_job = create(:job_application, user: user)
      result = service.find_all_by_job_application(new_job.id)
      expect(result).to be_empty
    end
  end

  describe '#find_by_id' do
    it 'returns the attachment if it exists' do
      attachment = attachments.first
      result = service.find_by_id(attachment.id)
      expect(result).to eq(attachment)
    end

    it 'raises error if attachment not found' do
      expect {
        service.find_by_id(SecureRandom.uuid)
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe '#create_attachment' do
    context 'with valid params' do
      it 'creates an attachment' do
        params = {
          job_application_id: job_application.id,
          attachment_type: 'resume',
          attachment_url: 'https://example.com/resume.pdf',
          version: 'v1'
        }

        attachment = service.create_attachment(params)
        expect(attachment).to be_persisted
        expect(attachment.attachment_type).to eq('resume')
      end
    end

    context 'with missing job_application_id' do
      it 'raises ActiveRecord::RecordInvalid' do
        expect {
          service.create_attachment({ attachment_url: 'https://example.com/doc.pdf' })
        }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end

  describe '#destroy_attachment' do
    let!(:attachment) { create(:attachment, job_application: job_application) }

    it 'soft deletes the attachment' do
      expect {
        service.destroy_attachment(attachment.id)
      }.to change { Attachment.count }.by(-1)
    end

    it 'raises error if not found' do
      expect {
        service.destroy_attachment(SecureRandom.uuid)
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
