require 'spec_helper'

def login_espn(username, password)
  click_link('Log In')
  sleep 3
  within_frame 'disneyid-iframe' do
    find('input[type="email"]').set(username)
    find('input[type="password"]').set(password)
    click_button('Log In')
    page.should_not have_css('.loading-indicator')
  end  
end

def add_drop(free_agent, droppable)
  find('#lastNameInput').set(free_agent)
  find('#lastNameSubmit').click
  page.should have_css('.playertablePlayerName', :count => 1)
  if page.has_link?(free_agent) && page.has_css?('a[title="Add"]')
    find('a[title="Add"]').click
    find('td.playertablePlayerName', :text => droppable).find(:xpath, '..').find('.playertableCheckbox input[type="checkbox"]').click
    find('input[type="button"][value="Submit Roster"]').click
    find('input[value="Confirm"]').click
    puts 'Congratulations! %s was added.' % free_agent
    sleep 10
  else
    puts 'Sorry, someone else probably got %s.' % free_agent
  end
end

feature "Add free agents to Fantasy Football league" do

  background do
    espn_players = 'http://games.espn.com/ffl/freeagency?leagueId=442780&teamId=7&seasonId=2017' # Replace with Players page of your league
    visit espn_players
    login_espn('taco', 'passwordistaco') # Replace with your username and password
  end

  after(:each) do
    Capybara.current_session.driver.quit
  end

  scenario "Log in and add/drop players" do
    add_drop('Jared Goff', 'Carson Wentz')
  end

end