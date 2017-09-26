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
5. From the root of the repository folder, run RSpec: `rspec spec\yahoo\add_free_agent.rb`

It is strongly recommended that you run RSpec via cron job or Windows task scheduler.  This spec does not schedule execution on its own.
