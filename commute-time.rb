require 'rest-client'
require 'json'
require 'date'

$key = "AIzaSyDUJJHLXCEebThDcAy9eZu29UoOvfFUtX0"
$destination="300 W. Renner Road Richardson TX"
$origin="1738 Big Canyon Trl Carrollton"
#Get Current Date and Time, Determine Day of week, Add days to reach specified day of the week.

CurrentDate = Date.today()
CurrentYear = CurrentDate.year
CurrentMonth = CurrentDate.mon
CurrentDay = CurrentDate.mday
NextMonday = 7-CurrentDate.cwday+1
CurrentDateTimeMorning = DateTime.new(CurrentYear,CurrentMonth,CurrentDay,7,30,0,Rational(-5,24)) #Year, Month, Day, Hour, Minute, Second, RATIONAL(Offset from UTC, 24 Hour Days)
CommuteDateTimeMorning = CurrentDateTimeMorning+NextMonday
CurrentDateTimeEvening = DateTime.new(CurrentYear,CurrentMonth,CurrentDay,16,30,0,Rational(-5,24)) #Year, Month, Day, Hour, Minute, Second, RATIONAL(Offset from UTC, 24 Hour Days)
CommuteDateTimeEvening = CurrentDateTimeEvening+NextMonday
EpochDateTime = DateTime.new(1970,1,1) #Epoch Time
option=0
CommuteDateTimeEvening.strftime("%a at %l:%M %p")
EpochDateTime.strftime("%a at %l:%M %p")
def GrabCommute(origin,destination)
  system "clear"
  puts "From #{origin} To #{destination}"
  puts "---------------------------------------------"
  puts "#{CommuteDateTimeMorning.strftime("%a at %l:%M %p")}"
  resourceMorning = RestClient.get 'https://maps.googleapis.com/maps/api/directions/json', {params:{key:$key, origin: origin,destination: destination,departure_time: ((CommuteDateTimeMorning-EpochDateTime)*24*60*60).to_i, mode: "driving", traffic_model: "pessimistic", avoid: "tolls"}}
  hashMorning = JSON.parse(resourceMorning.body)
  puts "---------------------------------------------"
  puts "You will travel a distance of #{hashMorning["routes"][0]["legs"][0]["distance"]["text"]}"
  puts "Without traffic your commute would be #{hashMorning["routes"][0]["legs"][0]["duration"]["text"]}"
  puts "With Traffic your commute would be #{hashMorning["routes"][0]["legs"][0]["duration_in_traffic"]["text"]}"
  puts "---------------------------------------------"
  puts "#{CommuteDateTimeEvening.strftime("%a at %l:%M %p")}"
  resourceEvening = RestClient.get 'https://maps.googleapis.com/maps/api/directions/json', {params:{key:$key, origin: origin,destination: destination,departure_time: ((CommuteDateTimeEvening-EpochDateTime)*24*60*60).to_i, mode: "driving", traffic_model: "pessimistic", avoid: "tolls"}}
  hashEvening = JSON.parse(resourceEvening.body)
  puts "---------------------------------------------"
  puts "You will travel a distance of #{hashEvening["routes"][0]["legs"][0]["distance"]["text"]}"
  puts "Without traffic your commute would be #{hashEvening["routes"][0]["legs"][0]["duration"]["text"]}"
  puts "With Traffic your commute would be #{hashEvening["routes"][0]["legs"][0]["duration_in_traffic"]["text"]}"
  puts "---------------------------------------------"
  puts "Press ENTER to return to the main menu"
  gets.chomp
end

#this works https://maps.googleapis.com/maps/api/directions/json?origin=Plano+TX&destination=Richardson+TX&departure_time=1503405000&mode=driving&key=AIzaSyDUJJHLXCEebThDcAy9eZu29UoOvfFUtX0&avoid=tolls&traffic_model=pessimistic

while option != 5 do
  system "clear"
  puts "---------------------------------------------"
  puts "Current Origin:      #{$origin}"
  puts "Current Destination: #{$destination}"
  puts "---------------------------------------------"
  puts "1: Change Home Address"
  puts "2: Change Work Address"
  puts "3: Execute"
  puts "4: Directions"
  puts "5: Quit"
  puts "---------------------------------------------"
  option=Integer(gets.chomp())
  case option
  when 1
    system "clear"
    puts "Change Home Address"
    puts "---------------------------------------------"
    puts "Enter Home Address "
    puts "---------------------------------------------"
    $origin= gets.chomp()
  when 2
    system "clear"
    puts "Change Work Address"
    puts "---------------------------------------------"
    puts "Enter Work Address"
    $destination=gets.chomp()
  when 3
    GrabCommute($origin,$destination)
  when 4
    system "clear"
    puts "Directions"
    puts "---------------------------------------------"
    resourceMorning = RestClient.get 'https://maps.googleapis.com/maps/api/directions/json', {params:{key:$key, origin: $origin, destination: $destination,departure_time: ((CommuteDateTimeMorning-EpochDateTime)*24*60*60).to_i, mode: "driving", traffic_model: "pessimistic", avoid: "tolls"}}
    hashMorning = JSON.parse(resourceMorning.body)
    hashMorning["routes"][0]["legs"][0]["steps"].each do |step|
       puts "#{step["html_instructions"].gsub(%r{</?[^>]+?>}, '')} for #{step["distance"]["text"]}"
    end
    puts "---------------------------------------------"
    puts "Total Distance:#{hashMorning["routes"][0]["legs"][0]["distance"]["text"]}"
    puts "---------------------------------------------"
    puts "Press ENTER to return to the main menu"
    gets.chomp()
  when 5
    system "clear"
  end

# Commute time
end
