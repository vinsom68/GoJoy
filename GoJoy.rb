

require 'rubygems'
require 'rotp'
require 'watir'

#b = Watir::Browser.new :chrome

b = Watir::Browser.new(:chrome,
                      :prefs => {:password_manager_enable => false, :credentials_enable_service => false},
                      :switches => ["disable-infobars", "no-sandbox"])

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

#b.goto "https://member.gojoy.com/rewards"
b.link(:text =>"积分奖励").when_present.click
#b.link(:text =>"Claim Rewards").when_present.click
sleep(5)


#l = b.buttons :class => "btn font-size-24 d-flex justify-content-between align-items-center rounded btn-danger btn-block"
#l[0].exists?
#l[0].click

if b.button(:text =>"立即领取").present?
    b.button(:text =>"立即领取").click
    #b.button(:text =>"CLAIM NOW").when_present.click
    sleep(2)
end


##### convert JUSD to JOY
b.link(:text =>"钱包").when_present.click
#b.link(:text =>"My Assets").when_present.click
sleep(3)
puts 'BACK TO MY ASSETS'

numJoyDollar=b.divs(class: "font-weight-bold")[1].child().text
valJoy=b.tds(class: "text_center")[1].child().text
valJoy[0]=''

rate=numJoyDollar.to_f/valJoy.to_f

puts numJoyDollar
puts valJoy
puts rate

if numJoyDollar.to_f>0.01

    #show textbox to put amount of joy to buy
    b.divs(class: "lock_unlock_button unlock_button")[1].child().when_present.click
    sleep(1)

    #fill textbox
    b.div(:text, '买入数量').following_sibling(index: 0).text_field(:class, 'van-field__control').set(rate)
    sleep(1)

    #click buy Joy
    buyJoy = b.buttons :class => "font_medium font_size_16 van-button van-button--warning van-button--large"
    buyJoy[1].exists?
    buyJoy[1].click
    sleep(1)

    #confirm buy joy
    if b.button(:text =>"确认").present?  
        b.button(:text =>"确认").click
        sleep(2)
    end

    #confirm 2 buy joy
    if b.div(:text =>"确认").present?
        b.div(:text =>"确认").click
        sleep(2)
    end

end

#lock joy
b.divs(class: "item_lock")[0].child().child().following_sibling(index: 0).click  
sleep(2)

#confirm lock joy
lockJoy = b.buttons :class => "font_medium font_size_16 van-button van-button--danger van-button--large"
lockJoy[0].exists?
lockJoy[0].click
sleep(1)

b.close