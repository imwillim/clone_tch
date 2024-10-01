# frozen_string_literal: true

VCR.configure do |config|
  config.cassette_library_dir = 'spec/vcr'
  config.hook_into :faraday
  config.allow_http_connections_when_no_cassette = true
  config.configure_rspec_metadata!
  config.default_cassette_options = { record: :once, match_requests_on: %i[method uri query] }
  config.filter_sensitive_data('<MAP_BOX_ACCESS_TOKEN>') { Mapbox::BaseRequest::ACCESS_TOKEN }
end
