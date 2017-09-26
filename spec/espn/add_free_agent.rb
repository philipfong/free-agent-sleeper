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
  if page.has_css?('a[title="Claim"]')
    puts 'It looks like waivers have not cleared'
  elsif page.has_text?('No players were found')
    puts 'Player is unavailable. Someone may have picked him up.'
  else
    find('a[title="Add Player"]').click # I am not sure yet if this is what the button next to free agents is titled
    find('td.playertablePlayerName', :text => droppable).find(:xpath, '..').find('.playertableCheckbox input[type="checkbox"]').click
    find('input[type="button"][value="Submit Roster"]').click
    find('input[value="Confirm"]').click
    puts 'Congratulations! Your free agent was added.'
    sleep 10
  end
end

feature "Add free agents to Fantasy Football league" do

  scenario "Log in and add/drop players" do
    espn_players = 'http://games.espn.com/ffl/freeagency?leagueId=442780&teamId=7&seasonId=2017'
    visit espn_players
    login_espn('taco', 'passwordistaco') # Replace with your username and password
    add_drop('Chris Johnson', 'Cooper Kupp')
  end

end