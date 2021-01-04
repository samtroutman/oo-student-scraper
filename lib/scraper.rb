require 'open-uri'
require 'pry'
require 'nokogiri'

class Scraper
  attr_accessor :student

  # @@all - []

  def self.scrape_index_page(index_url)
    html = open("https://learn-co-curriculum.github.io/student-scraper-test-page/")
    page = Nokogiri::HTML("https://learn-co-curriculum.github.io/student-scraper-test-page/")
    
    students = []

    page.css("div.student-card").each do |student|

      students << {
        :location => student.css("p.student-location").text,
        :name => student.css("h4.student-name").text,
        :profile_url => student.children[1].attributes["href"].value
      }
    end
    students
  end

  def self.scrape_profile_page(profile_url)
    page = Nokogiri::HTML(open(profile_url))

    student_page = {}

    social_links = page.css(".social-icon-container").css('a').collect {|x| x.attributes["href"].value}
    social_links.detect do |x|
      student_page[:twitter] = x if x.include?("twitter")
      student_page[:linkedin] = x if x.include?("linkedin")
      student_page[:github] = x if x.include?("github")
    end

    student_page[:blog] = social_links[3] if social_links[3] != nil
    student_page[:profile_quote] = page.css(".profile-quote")[0].text
    student_page[:bio] = page.css(".description-holder").css('p')[0].text
    student_page
  end
    
end

