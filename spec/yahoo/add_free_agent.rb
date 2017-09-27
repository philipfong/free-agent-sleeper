require 'spec_helper'

def login_yahoo(username, password)
  find('#login-username').set(username)
  find('#login-signin').click
  find('#login-passwd').set(password)
  find('#login-signin').click
  if page.has_link?('Cancel') # Sometimes Yahoo! will ask to secure your account, so we skip this.
    find_link('Cancel').click
  end
end

def add_drop(free_agent, abbrev, droppable)
  find('#playersearchtext').set(free_agent)
  find('.Btn-primary[value="Search"]').click
  if page.has_link?(free_agent) && page.has_css('a[title="Add Player"]')
    find('a[title="Add Player"]').click
    page.should have_text('Select a player to drop')
    find('td.player', :text => abbrev).find(:xpath, '..').find('button.add-drop-trigger-btn').click
    if page.has_css?('#submit-add-drop-button[value^="Create claim"]')
      puts 'Waivers have not cleared'
    else
      find('#submit-add-drop-button[value="Add %s, Drop %s"]' % [free_agent, droppable]).click
      puts 'Congratulations! Add successful.'
      sleep 10
    end
  else
    puts 'Sorry, someone else probably got %s.' % free_agent
  end
end

feature "Add free agents to Fantasy Football league" do

  background do
    yahoo_players = 'https://football.fantasysports.yahoo.com/f1/726755/players' # Replace with Players page of your league
    visit yahoo_players
    login_yahoo('taco', 'passwordistaco') # Replace with your username and password
  end

  after(:each) do
    Capybara.current_session.driver.quit
  end

  scenario "Log in and add/drop players" do
    add_drop('Chris Johnson', 'S. Perine', 'Samaje Perine')
  end

end