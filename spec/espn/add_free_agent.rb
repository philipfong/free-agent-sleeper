require 'spec_helper'

ESPN_USERNAME = 'taco'
ESPN_PASSWORD = 'passwordistaco'
ESPN_PLAYERS = 'http://games.espn.com/ffl/freeagency?leagueId=442780&teamId=7&seasonId=2018' # Replace with Players page of your league

def login_espn(username, password)
  # uncomment out lines below if your league is public
  #click_link('Log In')
  #within('.global-user-container') do
  #  click_link('Log In')
  #end
  within_frame 'disneyid-iframe' do
    find('input[type="email"][placeholder="Username or Email Address"]').set(username)
    find('input[type="password"][placeholder="Password (case sensitive)"]').set(password)
    click_button('Log In')
    page.should_not have_css('.loading-indicator')
  end
end

def add_drop(free_agent, droppable)
  find('#lastNameInput').set(free_agent)
  click_button('Search')
  page.should have_css('.playertablePlayerName', :count => 1)
  if page.has_link?('Claim')
    puts 'Waivers have not cleared yet'
  elsif page.has_link?(free_agent) && page.has_link?('Add')
    click_link('Add')
    find('td.playertablePlayerName', :text => droppable).find(:xpath, '..').find('.playertableCheckbox input[type="checkbox"]').click
    click_button('Submit Roster')
    page.should have_text('Drop %s' % droppable)
    page.should have_text('Add %s' % free_agent)
    click_button('Confirm')
    puts 'Congratulations! %s was added.' % free_agent
    sleep 10
  else
    puts 'Sorry, someone else probably got %s.' % free_agent
  end
end

feature "Add free agents to Fantasy Football league" do

  background do
    visit 'http://espn.com/fantasy/football'
    find('#global-user-trigger').hover
    find('.account-management').click_link('Log In')
    login_espn(ESPN_USERNAME, ESPN_PASSWORD)
    visit ESPN_PLAYERS
  end

  after(:each) do
    Capybara.current_session.driver.quit
  end

  scenario "Log in and add/drop player" do
    add_drop('Joe Flacco', 'Deshaun Watson') # Replace with players you want to add and drop
    # Do not insert additional calls to add_drop() -- Create new scenarios for more players
  end

  scenario "Log in and add/drop another player" do
    add_drop('Leonard Fournette', 'Alex Collins') # Replace with players you want to add and drop
  end

end
