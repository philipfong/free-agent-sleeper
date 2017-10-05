<!--
  Title: Free Agent Sleeper for Fantasy Football Leagues
  Description: Automatically add free agents in fantasy football leagues. Written in Ruby leveraging Selenium Webdriver.
  Author: Philip Fong
  -->

# free-agent-sleeper
Automate adding of free agents in fantasy football leagues.

This was developed to automate the adding and dropping of players on a fantasy football team. This allows users to automate this process so that when waivers clear (normally around 4 AM Eastern Time), fantasy owners can continue to sleep in their beds.

### How to use ###

1. Install Ruby
2. Clone this repo
3. Install and run bundler gem:
* `gem install bundler`
* `bundle install`
4. Modify your script to log into fantasy sites along with adding/dropping players.
5. Run RSpec: `rspec spec\yahoo\add_free_agent.rb`

### Scheduling ###

This spec does not schedule execution on its own. It is recommended that you run RSpec via cron job or scheduled Windows Task.  A Windows Task would look something like:

* Start a program: `C:\Ruby22-x64\bin\rspec.bat`
* With arguments: `\spec\yahoo\add_free_agent.rb > free-agent-sleeper.log`
* Start in: `<root directory of repo>`
