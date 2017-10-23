require 'spec_helper'

YAHOO_USERNAME = 'taco'
YAHOO_PASSWORD = 'passwordistaco'
YAHOO_PLAYERS = 'https://football.fantasysports.yahoo.com/f1/726755/players' # Replace with Players page of your league

def login_yahoo(username, password)
  click_link('Sign in') if page.has_link?('Sign in')
  find('#login-username').set(username)
  find('#login-signin').click
  find('#login-passwd').set(password)
  find('#login-signin').click
  click_link('Cancel') if page.has_link?('Cancel') # Sometimes Yahoo will ask to secure your account, so we skip this.
  find('.skip-now').click if page.has_text?('secure my account') # Sometimes Yahoo will ask to add a phone number, so we skip this.
end

def add_drop(free_agent, abbrev, droppable)
  find('#playersearchtext').set(free_agent)
  sleep 5 # Sometimes, the autocomplete dropdown interferes with clicking the Search button, so we wait a little
  click_button('Search')
  page.should have_css('.First.Last', :count => 1)
  if page.has_link?(free_agent) && page.has_link?('Add Player')
    click_link('Add Player')
    page.should have_text('Select a player to drop')
    find('td.player', :text => abbrev).find(:xpath, '..').find('button.add-drop-trigger-btn').click
    if page.has_css?('#submit-add-drop-button[value^="Create claim"]')
      puts 'Waivers have not cleared'
    else
      find('#submit-add-drop-button[value="Add %s, Drop %s"]' % [free_agent, droppable]).click
      puts 'Congratulations! %s was added.' % free_agent
      sleep 10
    end
  else
    puts 'Sorry, someone else probably got %s.' % free_agent
  end
end

feature "Add free agents to Fantasy Football league" do

  background do
    visit YAHOO_PLAYERS
    login_yahoo(YAHOO_USERNAME, YAHOO_PASSWORD) # Replace with your username and password
  end

  after(:each) do
    Capybara.current_session.driver.quit
  end

  scenario "Log in and add/drop player" do
    add_drop('Robby Anderson', 'A. Kamara', 'Alvin Kamara') # Replace with players you want to add and drop
    # Do not insert additional calls to add_drop() -- Create new scenarios for more players
  end

  scenario "Log in and add/drop another player" do
    add_drop('Terrance West', 'W. Gallman', 'Wayne Gallman') # Replace with players you want to add and drop
  end

end
