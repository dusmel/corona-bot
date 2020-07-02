# frozen_string_literal: true
require_relative "../api"
require_relative "../helpers/texts"

module V1
  include Text

  extend self

  def call(body)
    user_request = body.split(" ")
    text = get_texts(body)
    return "⚠️ Language not supported right now" if text[:language] == :swa || text[:language] == :kin
    if user_request.size == 1
      if text
        stat = CurrentStatus.country("drc")
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

    if user_request.size == 2 && text && body.include?("bref")
      stat = CurrentStatus.summary
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
      stat = CurrentStatus.country(user_request[1])
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
        message.body("I couldn't process your request,
          please check for typos and try again 😔 or send *help* for more  details")
      end
    end
  end

  def get_texts(body)
    keywords = {
      french: 'statut',
      english: 'status',
      swahili: 'hali',
      kinyarwanda: 'imiterere',
    }
    if body.include?(keywords[:english])
      TEXT[:eng]
    elsif body.include?(keywords[:french])
      TEXT[:fr]
    elsif body.include?(keywords[:kinyarwanda])
      TEXT[:kin]
    elsif body.include?(keywords[:swahili])
      TEXT[:swa]
    end
  end
end
