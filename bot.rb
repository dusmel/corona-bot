# frozen_string_literal: true

require 'sinatra/base'
require 'http'
require 'pry'
require 'pp'
require './languages/english'
require './helpers/texts'
require './versions/v1'

class CoronaBot < Sinatra::Base
  use Rack::TwilioWebhookAuthentication, ENV['TWILIO_AUTH_TOKEN'], '/bot'
  include Text

  get '/' do
    p TEXT
    # CurrentStatus.summary
    message = <<-END_MESSAGE
      This is a
      multiline,
      as is String!
    END_MESSAGE
    message
  end

  get '/test' do
    V1.test
  end

  post '/status' do
    body = params['Body'].downcase
    response = Twilio::TwiML::MessagingResponse.new
    response.message do |message|
      content = V1.call(body)
      puts content
      message.body(content)
    end
    content_type 'text/xml'
    response.to_xml
  end
end
