require File.join(File.dirname(__FILE__), '..', 'mustachio')
require 'sinatra/base'

module Mustachio
  class App < Sinatra::Base
    DEMO_IMAGE = 'http://www.librarising.com/astrology/celebs/images2/QR/queenelizabethii.jpg'
    
    set :static, true
    set :public, 'public'
    
    configure :production do
      require 'newrelic_rpm' if ENV['NEW_RELIC_ID']
    end
    
    before do
      app_host = ENV['MUSTACHIO_APP_DOMAIN']
      if app_host && request.host != app_host
        request_host_with_port = request.env['HTTP_HOST']
        redirect request.url.sub(request_host_with_port, app_host), 301
      end
    end
    
    
    get "/" do 
      src = params[:src]
      if src
        # use the specified stache, otherwise fall back to random
        image = Magickly.process_src params[:src], :mustachify => true
        image.to_response(env)
      else
        @stache_num = 1
        @site = Addressable::URI.parse(request.url).site
        erb :index
      end
    end
      
  end
end
