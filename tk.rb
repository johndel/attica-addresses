# http://www.taxidromikoskodikas.gr/
# test.attributes.attributes.first.last.value
# -*- coding: utf-8 -*-

require 'rubygems'
require 'mechanize'
require 'pry'

agent = Mechanize.new
agent.get("http://www.taxidromikoskodikas.gr/")

# Write all areas to a .txt file
areas = []
agent.page.search("#perioxes_id table td a").each do |link|
  areas << link.text
end
File.open("areas.txt", 'w') { |file| file.write(areas.join("---").gsub("---", "\n")) }


# Write each address to a .txt file
agent.page.search("#perioxes_id table td a").each do |link|
  tmp_address = []
  current_page = agent.page.link_with(text: link.text).click
  tr_count = current_page.search("#info_id table tr").count
  current_page.search("#info_id table tr").each_with_index do |table_row, index|
    next if index == 0
    break if index == tr_count - 1
    if table_row.search("td[2]").text.strip != ""
      tmp_address << table_row.search("td[2]").text.strip
    end
  end
  File.open("#{link.text}.txt", 'w') { |file| file.write(tmp_address.join("---").gsub("---", "\n")) }
end

