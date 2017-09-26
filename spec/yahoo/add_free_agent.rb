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
  if page.has_link?(free_agent)
    find('a[title="Add Player"]').click
    page.should have_text('Select a player to drop')
    find('td.player', :text => abbrev).find(:xpath, '..').find('button.add-drop-trigger-btn').click
    find('#submit-add-drop-button[value="Add %s, Drop %s"]' % [free_agent, droppable])#.click #Uncomment to really make work. Otherwise, leave alone for testing.
    sleep 5
    puts 'Congratulations! Add successful.'
  elsif page.has_text?('No players found.')
    puts 'Someone else probably got him.'
  end
end

feature "Add free agents to Fantasy Football league" do

  scenario "Log in and add/drop players" do
    yahoo_players = 'https://football.fantasysports.yahoo.com/f1/726755/players'
    visit yahoo_players
    login_yahoo('taco', 'passwordistaco') # Replace with your username and password
    add_drop('Chris Johnson', 'S. Perine', 'Samaje Perine')
  end

end