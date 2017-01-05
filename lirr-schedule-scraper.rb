# require 'selenium-webdriver'
# require 'capybara'
#
# Capybara.default_driver = :chrome
#
# Capybara.register_driver :chrome do |app|
#   Capybara::Selenium::Driver.new(app, :browser => :chrome)
# end
#
# session = Capybara::Session.new(:chrome)

# Updated 12/30/16

STATIONS = [
'Albertson',
'Amagansett',
'Amityville',
'Atlantic Terminal',
'Auburndale',
'Babylon',
'Baldwin',
'Bay Shore',
'Bayside',
'Bellerose',
'Bellmore',
'Bellport',
'Belmont',
'Bethpage',
'Brentwood',
'Bridgehampton',
'Broadway',
'Carle Place',
'Cedarhurst',
'Central Islip',
'Centre Avenue',
'Cold Spring Harbor',
'Copiague',
'Country Life Press',
'Deer Park',
'Douglaston',
'East Hampton',
'East New York',
'East Rockaway',
'East Williston',
'Far Rockaway',
'Farmingdale',
'Floral Park',
'Flushing Main Street',
'Forest Hills',
'Freeport',
'Garden City',
'Gibson',
'Glen Cove',
'Glen Head',
'Glen Street',
'Great Neck',
'Great River',
'Greenlawn',
'Greenport',
'Greenvale',
'Hampton Bays',
'Hempstead',
'Hempstead Gardens',
'Hewlett',
'Hicksville',
'Hollis',
'Hunterspoint Avenue',
'Huntington',
'Inwood',
'Island Park',
'Islip',
'Jamaica',
'Kew Gardens',
'Kings Park',
'Lakeview',
'Laurelton',
'Lawrence',
'Lindenhurst',
'Little Neck',
'Locust Manor',
'Locust Valley',
'Long Beach',
'Long Island City',
'Lynbrook',
'Malverne',
'Manhasset',
'Massapequa',
'Massapequa Park',
'Mastic Shirley',
'Mattituck',
'Meadowlands',
'Medford',
'Merillon Avenue',
'Merrick',
'Mets-Willets Point',
'Mineola',
'Montauk',
'Murray Hill',
'Nassau Boulevard',
'New Hyde Park',
'Northport',
'Nostrand Avenue',
'Oakdale',
'Oceanside',
'Oyster Bay',
'Patchogue',
'Penn Station',
'Pinelawn',
'Plandome',
'Port Jefferson',
'Port Washington',
'Queens Village',
'Riverhead',
'Rockville Centre',
'Ronkonkoma',
'Rosedale',
'Roslyn',
'Sayville',
'Sea Cliff',
'Seaford',
'Smithtown',
'Southampton',
'Southold',
'Speonk',
'St. Albans',
'St. James',
'Stewart Manor',
'Stony Brook',
'Syosset',
'Valley Stream',
'Wantagh',
'West Hempstead',
'Westbury',
'Westhampton',
'Westwood',
'Woodmere',
'Woodside',
'Wyandanch',
'Yaphank'
]


require 'capybara/poltergeist'

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app)
end

session = Capybara::Session.new(:poltergeist)

puts ''
puts "Where are you coming from?"

departure = gets.chomp.downcase.split.map(&:capitalize).join(' ')

until STATIONS.include?(departure)
  puts ''
  puts "Sorry that is not a valid station."
  puts "Where are you coming from?"
  departure = gets.chomp.downcase.split.map(&:capitalize).join(' ')
end

puts ''
puts "Where are you going?"

arrival = gets.chomp.downcase.split.map(&:capitalize).join(' ')

until STATIONS.include?(arrival)
  puts ''
  puts "Sorry that is not a valid station."
  puts "Where are you going?"
  departure = gets.chomp.downcase.split.map(&:capitalize).join(' ')
end

puts ''
puts "When are you leaving? ex. 04:30 ('now' for current time)"

time = gets.chomp

if time == 'now'
  time = Time.now.strftime('%I:%M')
end

hour = time.split(":")[0]
minutes = time.split(":")[1].to_i

case minutes
when (0..14)
    time = hour + ':' + '00'
  when (15..29)
    time = hour + ':' + '15'
  when (30..44)
    time = hour + ':' + '30'
  else
    time = hour + ':' + '45'
end

lirr_site = "http://lirr42.mta.info"

session.visit(lirr_site)

session.select departure, from: 'FromStation '

session.select arrival, from: 'ToStation '

session.select time, from: 'RequestTime'

session.find(:xpath, '//*[@id="sftrip"]/form/table/tbody/tr[5]/td[2]/input[1]').click

date = session.find(:xpath, '//*[@id="contentbox"]/div[1]/div[1]').text.split(" ")[2..5].join(" ")

departures = []
arrivals = []

i = 4

3.times do
  d = session.find(:xpath, '//*[@id="contentbox"]/div[1]/div[1]/table[2]/tbody/tr[' + i.to_s + ']/td[2]').text
  departures << d
  i += 1
end

j = 4

3.times do
  a = session.find(:xpath, '//*[@id="contentbox"]/div[1]/div[1]/table[2]/tbody/tr[' + j.to_s + ']/td[4]').text
  arrivals << a
  j += 1
end

session.find(:xpath, '//*[@id="contentbox"]/div[1]/div[1]/table[1]/tbody/tr/td[2]/a').click

i = 2

5.times do
  d = session.find(:xpath, '//*[@id="contentbox"]/div[1]/div[1]/table[2]/tbody/tr[' + i.to_s + ']/td[2]').text
  departures << d
  i += 1
end

j = 2

5.times do
  a = session.find(:xpath, '//*[@id="contentbox"]/div[1]/div[1]/table[2]/tbody/tr[' + j.to_s + ']/td[4]').text
  arrivals << a
  j += 1
end


c = 0

puts ''
puts date
puts ''
puts departure + ' to ' + arrival
puts ''

num = departures.length

num.times do
  puts '//////////////////'
  puts ''
  puts 'Departure: ' + departures[c]
  puts 'Arrival: ' + arrivals[c]
  puts ''
  c += 1
end

puts '//////////////////'
puts ''
