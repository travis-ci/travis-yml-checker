RSpec.describe Checker::ConfigWorker do
  let(:config) { File.read(File.expand_path('../gatekeeper.yml', __FILE__)) }
  let(:build_id) { 1000 }
  let(:request_id) { 2000 }

  shared_examples 'result' do
    it 'saves result attributes' do
      subject.perform(config, request_id, 3, 'User', 2)
      result = Result.last
      expect(result.attributes.symbolize_keys).to include(
        original_config: config,
        request_id: request_id,
        repo_id: 3,
        owner_type: 'User',
        owner_id: 2
      )
    end
  end

  describe 'creates a new result record' do
    include_examples 'result'
  end

  describe 'updates a placeholder result record' do
    before do
      Result.create(build_id: build_id, request_id: request_id)
    end
    include_examples 'result'
  end

  it 'saves the parsed config' do
    subject.perform(config, request_id, 3, 'User', 2)
    result = Result.last
    expect(result.parsed_config).to be_a Hash
  end

  it 'queues a librato metrics job' do
    expect {
        subject.perform(config, request_id, 3, 'User', 2)
      }.to change(Checker::LibratoWorker.jobs, :size).by(1)
  end

end
