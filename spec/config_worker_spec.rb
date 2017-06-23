RSpec.describe Checker::ConfigWorker do
  let(:config) { "--- foo" }

  it "creates a config record" do
    subject.perform(config, 2, 3, 'User', 2)
    expect(Config.last.attributes.symbolize_keys).to include(
      original_config: config,
      parsed_config: nil,
      request_id: 2,
      repo_id: 3,
      owner_type: 'User',
      owner_id: 2,
      build_id: nil
    )
  end
end
