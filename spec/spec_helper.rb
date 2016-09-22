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

def blog_url(username, path)
  'http://' + username + '.tumblr.com' + path
end

#def delete
#  delete_url = "https://www.tumblr.com/blog/boldlyspookylady"
#  @driver.get delete_url
#  title_check = @driver.find_element class: "post_title"
#  post_item = @driver.find_element class: "post_control_menu"
#  post_item.click
#  delete = @driver.find_element class: "delete"
#  delete.click
#  delete_confirm_outer = @driver.find_element class: "init_focus"
#  delete_confirm = delete_confirm_outer.find_element class: "ui_button"
#  delete_confirm.click
#end
# def login
#   @driver.find_element(id: "signup_login_button").click
#   @driver.find_element(id: "signup_determine_email").send_keys @email
#   @driver.find_element(id: "signup_forms_submit").click
#   sleep 1
#   @driver.find_element(id: "signup_password").send_keys @password
# end
def login
 unless @driver.page_source.include? @username
   @driver.find_element(id: "signup_determine_email").send_keys "#{@email}\n"
   password_el = @driver.find_element id: "signup_password"
   @driver.manage.timeouts.implicit_wait = 1
   password_el.send_keys "#{@password}\n"
 end
end

def browser
  if @driver
    @driver.get "http://tumblr.com/logout"
  else
    @driver = Selenium::WebDriver.for :chrome
    @url = "https://tumblr.com/login"
    @driver.get @url
  end

end
