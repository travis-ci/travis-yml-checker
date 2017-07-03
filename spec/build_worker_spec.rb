RSpec.describe Checker::BuildWorker do
  let(:build_id) { 1000 }
  let(:request_id) { 2000 }
  let(:time) { Time.now + 1 }

  it 'creates a placeholder result record' do
    subject.perform_in(time, build_id, request_id)
    result = Result.last
    expect(result.attributes.symbolize_keys).to include(
      original_config: nil,
      request_id: request_id,
      repo_id: nil,
      owner_type: nil,
      owner_id: nil,
      build_id: build_id
    )
  end

  it 'saves the build id to existing result record' do
    result = Result.create(
      original_config: '--- foo',
      request_id: request_id,
      repo_id: 1,
      owner_type: 'User',
      owner_id: 45
    )
    subject.perform_in(time, build_id, request_id)
    result.reload
    expect(result.build_id).to eq build_id
  end
end
