# describe "Tumblr" do
#
#  before(:all) do
#    @driver = Selenium::WebDriver.for :chrome
#    @url = "https://tumblr.com"
#    @driver.get @url
#    @email = "john.metcalfe@skybettingandgaming.com"
#    @password = File.read('./details.txt')
#    @username = "boldlyspookylady"
#    @post_title = "Hello World!"
#    @post_body = "This is the body of the blog post"
#    @tags = "Hello\n"
#    @client = Tumblr::Client.new({
#      :consumer_key => '06ip5ssmlR1rl7WAZra4fMLnLgEcjXd1ukp510Z7XEOPi2Iu3l',
#      :consumer_secret => 'JpBIPNPEOaIzRObEv9TDkq5M6L4yXxGruiHeOF8Q3F3jc15WVZ',
#      :oauth_token => 'qfHtOWJ7lCBUv53z65cNPSQ5hsExO8ectMdPWXmKphRjPwTqmX',
#    })
#  end
#
#  it "Log in to tumblr" do
#
#
#    @driver.find_element(id: "signup_login_button").click
#    @driver.find_element(id: "signup_determine_email").send_keys @email
#    @driver.find_element(id: "signup_forms_submit").click
#    sleep 1
#    @driver.find_element(id: "signup_password").send_keys @password
#
#    hello = @client.text("boldlyspookylady.tumblr.com", {:title => @post_title, :body => @post_body, :tags => @tags})
#    @id = hello['id']
#    #Sleeping to wait for post to submit
#    @driver.get "http://#{@username}.tumblr.com/post/#{@post_title}"
#    foo = @driver.page_source.match @post_body
#    expect(foo.to_s).to include @post_body
#
#  end
#
#  after(:all) do
#
#    @client.delete("boldlyspookylady.tumblr.com", @id)
#    @driver.quit
#
#  end
#
#
# end
describe "The Tumblr API" do


  @data = YAML.load(File.open("details.yml"))

  before(:each) do
    @email = @data["login_details"]["email"]
    @password = @data["login_details"]["password"]
    @username = "seitgrads16"
    @client = Tumblr::Client.new({
          :consumer_key => '06ip5ssmlR1rl7WAZra4fMLnLgEcjXd1ukp510Z7XEOPi2Iu3l',
          :consumer_secret => 'JpBIPNPEOaIzRObEv9TDkq5M6L4yXxGruiHeOF8Q3F3jc15WVZ',
          :oauth_token => 'qfHtOWJ7lCBUv53z65cNPSQ5hsExO8ectMdPWXmKphRjPwTqmX',
        })
  end



  it 'should log in with correct details' do
    # Try to log in with correct details via UI automation
    # Assert we are on the dashboard via UI automation
    browser
    login

    dashboard = @driver.page_source.match @username
    expect(dashboard.to_s).to include @username

  end

  it 'should show an error on login with incorrect details' do
    # Try to log in with incorrect details via UI automation
    # Assert we see an error message and are still on login page via UI automation
    broswer
    @driver.find_element(id: "signup_determine_email").send_keys "#{@email}\n"
    sleep 1
    @driver.find_element(id: "signup_password").send_keys "wrongpass\n"
    error = @driver.page_source
    sleep 1
    expect(error.to_s).to include "Your email or password were incorrect."
  end

  it 'should post a text post successfully' do
    # Setup: Login via helper method via UI automation
    # Create a text post via UI automation
    # Assert that the creation modal has gone away
    # Visit the front-end and check the post is displaying the correct data
    # Teardown: Delete the post (either via API or via UI automation)
    browser
    login
    @driver.get url("/new/text")
    @driver.find_element(class: "post-form--form").find_element(class: "editor-plaintext").send_keys @post_title
    @driver.find_element(class: "post-form--form").find_element(class: "editor-richtext").send_keys @post_body
    @driver.find_element(class: "post-form--footer").find_element(class: "editor-plaintext").send_keys @tags
    @driver.find_element(class: "create_post_button").click
    sleep 1
    @driver.get blog_url(@username, "/post/#{@post_title}")
    foo = @driver.page_source.match @post_body
    expect(foo.to_s).to include @post_body
    @driver.get url("/blog/#{@username}")
    @driver.find_element(class: "post_control_menu").click
    @driver.find_element(class: "delete").click
    @driver.find_element(class: "init_focus").find_element(class: "ui_button").click

  end

  it 'should allow me to add tags to an existing text post' do
    # Setup: Create a post via API
    # Setup: Login via helper method via UI automation
    # Edit the post and add some tags via UI automation
    # Assert that the tags show on the front end
    # Teardown: Delete the post via API
    browser
    hello = @client.text("boldlyspookylady.tumblr.com", {:title => @post_title, :body => @post_body, :tags => @tags})
    @id = hello['id']
    @driver.get url("/blog/#{@username}")
    @driver.find_element(class: "post_control_menu").click
    @driver.find_element(class: "edit").click
    @driver.find_element(class: "post-form--footer").find_element(class: "editor-plaintext").send_keys "Edited\n"
    @driver.find_element(class: "create_post_button").click
    @client.delete("#{@username}.tumblr.com", @id)


  end

  it 'should allow me to delete a post from the dashboard' do
    # Setup: Create a post via API
    # Setup: Login via helper method via UI automation
    # Find the post on the dashnboard via UI Automation
    # Assert that the Delete button shows
    # Delete the post via UI automation
    # Assert that it's dissapeared from the dashboard
    # Assert that it's dissapeared from the front-end too
    browser
    @client.text("boldlyspookylady.tumblr.com", {:title => @post_title, :body => @post_body, :tags => @tags})
    @driver.get url("/blog/#{@username}")
    @driver.find_element(class: "post_control_menu").click
    @driver.find_element(class: "delete").click
    @driver.find_element(class: "init_focus").find_element(class: "ui_button").click
  end


  it 'should allow me to edit the body and title of an existing text post' do
    # Setup: Create a post via API
    # Setup: Login via helper method via UI automation
    # Edit the post and achange the body and title via UI automation
    # Assert the new stuff exisits on the front-end
    # Teardown: Delete the post
    browser
    @client.text("boldlyspookylady.tumblr.com", {:title => @post_title, :body => @post_body, :tags => @tags})
    @driver.get url("/blog/#{@username}")
    @driver.find_element(class: "post_control_menu").click
    @driver.find_element(class: "edit").click
    @driver.find_element(class: "post-form--form").find_element(class: "editor-plaintext").send_keys "Edited"
    @driver.find_element(class: "post-form--form").find_element(class: "editor-richtext").send_keys "Edited body"
    @driver.find_element(class: "create_post_button").click
    @driver.find_element(class: "post_control_menu").click
    @driver.find_element(class: "delete").click
    @driver.find_element(class: "init_focus").find_element(class: "ui_button").click

  end

  it 'should not allow me to post a text post without any inputs' do
    browser
    login
    @driver.find_element(:class, "icon_post_text").click
    post_button = @driver.find_element(:class, "button-area").find_element(:class, "create_post_button").find_element(:class, "disabled")
    assert(post_button)
  end

  it 'should post an image post' do
    # Setup: Login via helper method via UI automation
    # Create an image post via UI automation
    # Assert that the creation modal has gone away
    # Visit the front-end and check the post is displaying the correct image
    # Teardown: Delete the post (either via API or via UI automation)
    browser
    login
    @driver.find_element(id: "new_post_label_photo").click
    elem = @driver.find_element(name: "photo")
    elem.sendKeys("./test-data/tumblr-test.jpg");
    @driver.find_element(class: "create_post_button").click
    @driver.get blog_url(@username, "")




  end
  after(:all) do

      #@client.delete("boldlyspookylady.tumblr.com", @id)
      @driver.quit

    end
end

# Possible Refactoring
# 1. Build a wrapper for the API to make the interface used within the tests as simplistic as possible.
# 2. Write helper methods to visit the URL of a post on the front end etc
# 3. Write helper methods to login and logout. Ideally, the login method will only log in if the current session is logged out, and vice versa.
# 4. Write helper methods to visit the dashboard page of a specific blog and the front-end of a specific blog.
#
# Bonus points
# 1. Add some more tests. There's loads of stuff we can test. Different post types, Creating new blogs. etc.
