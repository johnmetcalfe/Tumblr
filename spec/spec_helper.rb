require 'rspec'
require 'selenium-webdriver'
require 'tumblr_client'
require 'yaml'
RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
  config.shared_context_metadata_behavior = :apply_to_host_groups
end

def url(path)
  'https://www.tumblr.com' + path
end

def blog_url(username)
  'http://' + username + '.tumblr.com'
end

def login
  @driver.find_element(id: "signup_login_button").click
  @driver.find_element(id: "signup_determine_email").send_keys @email
  @driver.find_element(id: "signup_forms_submit").click
  sleep 1
  @driver.find_element(id: "signup_password").send_keys @password
end
