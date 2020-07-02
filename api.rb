# frozen_string_literal: true
module API
  def self.country(country_name)
    country_name = "drc" if country_name == "rdc"
    response = HTTP.headers(
      "X-RapidAPI-Host": ENV['API_HOST'],
      "X-RapidAPI-Key": ENV['API_KEY']
    )
      .get("https://covid-193.p.rapidapi.com/statistics?country=#{country_name}")

    JSON.parse(response.to_s, symbolize_names: true)[:response]
  end

  def self.summary
    summary_response = ["drc", "rwanda", "usa"].map do |country|
      response = HTTP.headers(
        "X-RapidAPI-Host": ENV['API_HOST'],
        "X-RapidAPI-Key": ENV['API_KEY']
      )
        .get("https://covid-193.p.rapidapi.com/statistics?country=#{country}")

      JSON.parse(response.to_s, symbolize_names: true)[:response].first
    end
    summary_response
  end
end
