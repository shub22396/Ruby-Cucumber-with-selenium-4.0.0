require 'yaml'
require 'selenium/webdriver'
require 'capybara/cucumber'

# monkey patch to avoid reset sessions
class Capybara::Selenium::Driver < Capybara::Driver::Base
  def reset!
    if @browser
      @browser.navigate.to('about:blank')
    end
  end
end

TASK_ID = (ENV['TASK_ID'] || 0).to_i
CONFIG_NAME = ENV['CONFIG_NAME'] || 'single'

CONFIG = YAML.load(File.read(File.join(File.dirname(__FILE__), "../../config/#{CONFIG_NAME}.config.yml")))
CONFIG['user'] = ENV['LT_USERNAME'] || CONFIG['user']
CONFIG['key'] = ENV['LT_ACCESS_KEY'] || CONFIG['key']
CONFIG_NAME='jenkins'

Capybara.register_driver :lambdatest do |app|
  @caps = CONFIG['common_caps'].merge(CONFIG['browser_caps'][TASK_ID])

puts @caps.inspect
b= @caps["browser"].inspect
v= @caps["version"].inspect
p= @caps["platform"].inspect


browserName= b.gsub("\"", "")
browserVersion= v.gsub("\"", "")
platformName= p.gsub("\"", "")
puts browserName 

 




if (CONFIG_NAME=='jenkins')
puts ENV['LT_GRID_URL']
lt_browser = ENV['LT_BROWSER_NAME']	
lt_os = ENV['LT_PLATFORM']
lt_browser_version = ENV['LT_BROWSER_VERSION']
lt_res = ENV['LT_RESOLUTION']

@caps={ 
  
"LT:Options" => {

  "user" => "shubhamr",
  "accessKey" => "",
  "build" => "your",
  "name" => "your te",
  "platformName" => platformName
},
"browserName" => browserName,
"browserVersion" => browserVersion





# "browserName"=>lt_browser, 
# "version"=>lt_browser_version,
# "platform"=>lt_os, 
# "resolution"=>lt_res, 
# "build"=>"capybara-lambdatest", 
# "name"=>"single-Test-Jenkins",
# "video"=>true, 
# "network"=>true,
#  "console"=>true, 
#  "visual"=>true 
}



Capybara::Selenium::Driver.new(app,
	    :browser => :remote,
	    :url => "https://shubhamr:@hub.lambdatest.com/wd/hub",
      #:url => "https://webhook.site/1192b2fd-de75-4175-b892-6b447e8e36b2",
      
	    :capabilities => @caps
	  )

else 
  @caps={ 
  
"LT:Options" => {

 
  "build" => "your0000",
  "name" => " name00",
  "platformName" => lt_os
},
"browserName" => lt_browser,
"browserVersion" => lt_browser_version





# "browserName"=>lt_browser, 
# "version"=>lt_browser_version,
# "platform"=>lt_os, 
# "resolution"=>lt_res, 
# "build"=>"capybara-lambdatest", 
# "name"=>"single-Test-Jenkins",
# "video"=>true, 
# "network"=>true,
#  "console"=>true, 
#  "visual"=>true 
}
  Capybara::Selenium::Driver.new(app,
    :browser => :remote,
    #:url => "https://#{CONFIG['user']}:#{CONFIG['key']}@#{CONFIG['server']}/wd/hub",
    :url => "https://webhook.site/1192b2fd-de75-4175-b892-6b447e8e36b2",
    :capabilities => @caps
  )
end
end

Capybara.default_driver = :lambdatest
Capybara.run_server = false
