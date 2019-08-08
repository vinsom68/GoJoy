

require 'rubygems'
require 'rotp'
require 'watir'

b = Watir::Browser.new :chrome
totp = ROTP::TOTP.new(ARGV[2])


b.goto "https://passport.gojoy.com/login?redirect=https%3A%2F%2Fmember.gojoy.com%2Fwallet"

useEmail=b.links :class => "use-email"
useEmail[0].exists?
useEmail[0].click
sleep(2)

b.text_field(:id, 'email').set(ARGV[0])
b.text_field(:id, 'password-email').set(ARGV[1])


login = b.buttons :class => "btn btn-block btn-info d-flex justify-content-center"
login[0].exists?
login[0].click
sleep(2)

b.text_field(:id, 'googleAuthCode').set(totp.now)
GAuth = b.buttons :class => "btn btn-block btn-info d-flex justify-content-center"
GAuth[0].exists?
GAuth[0].click
sleep(3)

b.goto "https://member.gojoy.com/rewards"
sleep(5)
l = b.buttons :class => "btn font-size-24 d-flex justify-content-between align-items-center rounded btn-danger btn-block"
l[0].exists?
l[0].click
sleep(2)

b.close