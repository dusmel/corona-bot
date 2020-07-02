# frozen_string_literal: true
require_relative "../api"
require_relative "../helpers/texts"
require_relative "../constants/keywords"

module V1
  include Text
  include Keywords

  extend self

  def call(body)
    user_request = body.split(" ")
    text = get_texts(body)
    return "⚠️ #{LANGUAGES[@current_language].capitalize} not supported right now" if text && (
      text[:language] == :swa ||
      text[:language] == :kin
    )
    if user_request.size == 1
      if text
        stat = API.country("drc")
        puts stat
        stat = stat.first
        cases = stat[:cases]
        return <<~END_MESSAGE
          *#{text[:country]}:* RD Congo | #{stat[:day]}
          -----------------------------------
          ```
          #{text[:confirmed]}:  #{cases[:total]}
          #{text[:new_cases]}:  #{cases[:new]}
          #{text[:critical]}:   #{cases[:critical]}
          #{text[:recovered]}:  #{cases[:recovered]}
          #{text[:deaths]}:     #{stat[:deaths][:total]}
          ```
        END_MESSAGE
      end
    end

    if text && body.include?("bref")
      stat = API.summary
      summary_content = <<~END_MESSAGE
        #{text[:summary].capitalize} | #{stat.first[:day]}
          -----------------------------------
      END_MESSAGE

      stat.each do |country_stat|
        country_cases =  country_stat[:cases]
        current_status = <<~END_MESSAGE
          - #{country_stat[:country]}
          ```
          #{text[:confirmed]}:  #{country_cases[:total]}
          #{text[:new_cases]}:  #{country_cases[:new]}
          #{text[:critical]}:   #{country_cases[:critical]}
          #{text[:recovered]}:  #{country_cases[:recovered]}
          #{text[:deaths]}:     #{country_stat[:deaths][:total]}
          *********************
          ```
        END_MESSAGE
        summary_content += current_status
      end
      return summary_content
    end

    if user_request.size == 2 && text && !body.include?("bref")
      stat = API.country(user_request[1])
      if stat.any?
        stat = stat.first
        cases = stat[:cases]
        return <<~END_MESSAGE
          *#{text[:country].capitalize} :* #{stat[:country]} | #{stat[:day]}
          -----------------------------------
          ```
          #{text[:confirmed]}:  #{cases[:total]}
          #{text[:new_cases]}:  #{cases[:new]}
          #{text[:critical]}:   #{cases[:critical]}
          #{text[:recovered]}:  #{cases[:recovered]}
          #{text[:deaths]}:     #{stat[:deaths][:total]}
          ```
        END_MESSAGE
      else
        return text[:country_not_found]
      end

    end

    unless body.include?("status")
      if body.include?("😂") || body.include?("😝") || body.include?("😤")
        "Ndaku bomola Benie 😡😡"
      elsif body.include?("help")
        <<~END_MESSAGE
          *Commands*
          -----------------------------------
          ```
          <status> : current situation DRC \n
          <status [country]> : check for specific country | eg: status egypt \n
          <status bref> : give summary for DRC, Rwanda, USA \n
          <status | statut | hali | imiterere> : change language \n
          <help> : command options \n
          ```
        END_MESSAGE
      else
        "I couldn't process your request, please check for typos and try again 😔 or send *help* for more  details"
      end
    end
  end

  def get_texts(body)
    KEYWORDS.each do |language, key|
      if body.include?(key)
        @current_language = language
        return TEXT[language.to_sym]
      end
    end
    nil
  end
end
