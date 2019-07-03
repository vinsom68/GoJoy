# GoJoy

Download Ruby    https://rubyinstaller.org/downloads/

Download ChromeDriver and put it into c:\\Windows :      https://sites.google.com/a/chromium.org/chromedriver/downloads

At command line run:   
gem install watir
gem install rotp

Create a .bat file with: ruby "YourPathToGoJoyScript\GoJoy.rb"  YourLoginEmail YourPassword GoogleSecret

Set up task scheduler to run every hour the bat file above
