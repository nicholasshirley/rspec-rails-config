# Add additional requires below this line. Rails is not loaded until this point!
require 'database_cleaner'
require 'webmock/rspec'

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

# Disable external API calls
WebMock.disable_net_connect!(allow_localhost: true)

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods

  # Not included in Gemfile for this config, but included on almost
  # every project requiring auth so I just put it here as a reminder
  # config.include Devise::Test::IntegrationHelpers, type: :request

  # Configure DatabaseCleaner
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
    DatabaseCleaner.strategy = :transaction
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end

  ## Sample WebMock block for reference (getting an oauth token)
  ## You will need to stub out every call indidividually or extract
  ## this to a helper
  #
  # config.before(:each) do
  #  stub_request(:post, 'https://example.com/oauth/token')
  #    .with(
  #  body: {
  #    "client_id"=>"X3wGRid8oFeMLTNERVIZnL1kqXXfGlkiYVon7dY9",
  #    "client_secret"=>"hH78wuLPDkBipSAIIduecepjwYX6IiqlFL33qTFJ",
  #    "code"=>nil,
  #    "grant_type"=>"authorization_code",
  #    "redirect_uri"=>"http://localhost:3000/clio/oauth/token"
  #  },
  #  headers: {
  #    'Accept'=>'*/*',
  #    'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
  #    'Content-Type'=>'application/x-www-form-urlencoded',
  #    'User-Agent'=>'Faraday v0.15.3'
  #  })
  #    .to_return(status: 200, body: "", headers: {})
