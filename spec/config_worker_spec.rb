RSpec.describe Checker::ConfigWorker do
  let(:config) { File.read(File.expand_path('../gatekeeper.yml', __FILE__)) }

  it 'creates a result record' do
    subject.perform(config, 2, 3, 'User', 2)
    expect(Result.last.attributes.symbolize_keys).to include(
      original_config: config,
      request_id: 2,
      repo_id: 3,
      owner_type: 'User',
      owner_id: 2,
      build_id: nil
    )
  end

  it 'saves the parsed config' do
    subject.perform(config, 2, 3, 'User', 2)
    result = Result.last
    expect(result.parsed_config).to be_a Hash
  end
end
