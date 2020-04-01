require "sinatra/base"
require 'http'
require 'pry'
require 'pp'



class CoronaBot < Sinatra::Base
  use Rack::TwilioWebhookAuthentication, ENV['TWILIO_AUTH_TOKEN'], '/bot'

  get '/' do
    CurrentStatus.summary
    message = <<-END_MESSAGE
      This is a
      multiline,
      as is String!
      END_MESSAGE
    message
  end
  post '/status' do
    body = params["Body"].downcase
    user_request = body.split(" ")
    response = Twilio::TwiML::MessagingResponse.new
    response.message do |message|
      if user_request.size == 1
        stat = CurrentStatus.country("drc")
        stat = stat.first
        cases = stat[:cases]
        current_status = <<~END_MESSAGE
          *Country:* RD Congo | #{stat[:day]}
          -----------------------------------
          ```
          confirmed:  #{cases[:total]}
          new cases:  #{cases[:new]}
          critical:   #{cases[:critical]}
          recovered:  #{cases[:recovered]}
          deaths:     #{stat[:deaths][:total]}
          ```
        END_MESSAGE
        message.body(current_status)
      end

      if user_request.size == 2 && body.include?("status") &&  body.include?("bref")
        stat = CurrentStatus.summary
        countries_message = <<~END_MESSAGE
          Summary | #{stat.first[:day]}
          -----------------------------------
        END_MESSAGE

        stat.each do |country_stat|
          country_cases =  country_stat[:cases]
          current_status = <<~END_MESSAGE
            - #{country_stat[:country]}
            ```
            confirmed:  #{country_cases[:total]}
            new cases:  #{country_cases[:new]}
            critical:   #{country_cases[:critical]}
            recovered:  #{country_cases[:recovered]}
            deaths:     #{country_stat[:deaths][:total]}
            *********************
            ```
          END_MESSAGE
          
          # binding.pry
          countries_message = countries_message + current_status
        end
        message.body(countries_message)
        
      end

      if user_request.size == 2 && user_request[0] == "status" && !body.include?("bref")
        stat = CurrentStatus.country(user_request[1])
        if stat.any?
          stat = stat.first
          cases = stat[:cases]
          current_status = <<~END_MESSAGE
            *Country:* #{stat[:country]} | #{stat[:day]}
            -----------------------------------
            ```
            confirmed:  #{cases[:total]}
            new cases:  #{cases[:new]}
            critical:   #{cases[:critical]}
            recovered:  #{cases[:recovered]}
            deaths:     #{stat[:deaths][:total]}
            ```
          END_MESSAGE
          message.body(current_status)
        else
          message.body("Country not found, please check your spelling and try again! 😔")
        end
        
      end
      # if body.include?("cat")
      #   # add cat fact and picture to the message
      # end
      if !(body.include?("status"))
        message.body("I can only give status about corona in DRC, Rwanda and Italy for now")
      end
    end
    content_type "text/xml"
    response.to_xml
  end
end

module CurrentStatus
  def self.country(country_name)
    country_name = "drc" if country_name == "rdc"
    response = HTTP.headers(
      "X-RapidAPI-Host": "covid-193.p.rapidapi.com", 
      "X-RapidAPI-Key": "e94dd17ef0msh1d050392c26f7bfp1a13dfjsn88c5d28cfec9"
    )
    .get("https://covid-193.p.rapidapi.com/statistics?country=#{country_name}")
    
    JSON.parse(response.to_s, symbolize_names: true )[:response]
  end

  def self.summary
    summary_response = ["drc", "rwanda", "italy"].map do |country|
      response = HTTP.headers(
        "X-RapidAPI-Host": "covid-193.p.rapidapi.com", 
        "X-RapidAPI-Key": "e94dd17ef0msh1d050392c26f7bfp1a13dfjsn88c5d28cfec9"
      )
      .get("https://covid-193.p.rapidapi.com/statistics?country=#{country}")
  
      JSON.parse(response.to_s, symbolize_names: true )[:response].first
    end
    summary_response
  end

  def self.picture
    response = HTTP.get("https://dog.ceo/api/breeds/image/random")
    JSON.parse(response.to_s)["message"]
  end
end
