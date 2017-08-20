require 'rest-client'
require 'json'
require 'date'

$key = "AIzaSyDUJJHLXCEebThDcAy9eZu29UoOvfFUtX0"
$destination="300 W. Renner Road Richardson TX"
$origin="1738 Big Canyon Trl Carrollton"
$traffic_model="pessimistic"
$avoid="tolls"

#Get Current Date and Time, Determine Day of week, Add days to reach specified day of the week.

CurrentDate = Date.today()
CurrentYear = CurrentDate.year
CurrentMonth = CurrentDate.mon
CurrentDay = CurrentDate.mday
NextMonday = 7-CurrentDate.cwday+1
CurrentDateTimeMorning = DateTime.new(CurrentYear,CurrentMonth,CurrentDay,7,30,0,Rational(-5,24)) #Year, Month, Day, Hour, Minute, Second, RATIONAL(Offset from UTC, 24 Hour Days)
$CommuteDateTimeMorning = CurrentDateTimeMorning+NextMonday
CurrentDateTimeEvening = DateTime.new(CurrentYear,CurrentMonth,CurrentDay,16,30,0,Rational(-5,24)) #Year, Month, Day, Hour, Minute, Second, RATIONAL(Offset from UTC, 24 Hour Days)
$CommuteDateTimeEvening = CurrentDateTimeEvening+NextMonday
EpochDateTime = DateTime.new(1970,1,1) #Epoch Time
option=0
$index=0
$CommuteDateTimeEvening.strftime("%a at %l:%M %p")
EpochDateTime.strftime("%a at %l:%M %p")
def GrabCommute(origin,destination)
  system "clear"
  puts "From #{origin} To #{destination}"
  puts "---------------------------------------------"
  5.times do
    puts "#{$CommuteDateTimeMorning.strftime("%a at %l:%M %p")}"
    resourceMorning = RestClient.get 'https://maps.googleapis.com/maps/api/directions/json', {params:{key:$key, origin: origin,destination: destination,departure_time: (($CommuteDateTimeMorning-EpochDateTime)*24*60*60).to_i, mode: "driving", traffic_model: $traffic_model, avoid: $avoid}}
    hashMorning = JSON.parse(resourceMorning.body)
    puts "---------------------------------------------"
    puts "You will travel a distance of #{hashMorning["routes"][0]["legs"][0]["distance"]["text"]}"
    puts "Without traffic your commute would be #{hashMorning["routes"][0]["legs"][0]["duration"]["text"]}"
    puts "With Traffic your commute would be #{hashMorning["routes"][0]["legs"][0]["duration_in_traffic"]["text"]}"
    puts "---------------------------------------------"
    puts "#{$CommuteDateTimeEvening.strftime("%a at %l:%M %p")}"
    resourceEvening = RestClient.get 'https://maps.googleapis.com/maps/api/directions/json', {params:{key:$key, origin: origin,destination: destination,departure_time: (($CommuteDateTimeEvening-EpochDateTime)*24*60*60).to_i, mode: "driving", traffic_model: $traffic_model, avoid: $avoid}}
    hashEvening = JSON.parse(resourceEvening.body)
    puts "---------------------------------------------"
    puts "You will travel a distance of #{hashEvening["routes"][0]["legs"][0]["distance"]["text"]}"
    puts "Without traffic your commute would be #{hashEvening["routes"][0]["legs"][0]["duration"]["text"]}"
    puts "With Traffic your commute would be #{hashEvening["routes"][0]["legs"][0]["duration_in_traffic"]["text"]}"
    puts "---------------------------------------------"
    $CommuteDateTimeEvening+=1
    $CommuteDateTimeMorning+=1
  end
  puts "---------------------------------------------"
  puts "Press ENTER to return to the main menu"
  gets.chomp
  $CommuteDateTimeMorning = CurrentDateTimeMorning+NextMonday
  $CommuteDateTimeEvening = CurrentDateTimeEvening+NextMonday
end
#this works https://maps.googleapis.com/maps/api/directions/json?origin=Plano+TX&destination=Richardson+TX&departure_time=1503405000&mode=driving&key=AIzaSyDUJJHLXCEebThDcAy9eZu29UoOvfFUtX0&avoid=tolls&traffic_model=pessimistic

while option != "6" do
  system "clear"
  puts "---------------------------------------------"
  puts "Current Origin:        #{$origin.capitalize}"
  puts "Current Destination:   #{$destination.capitalize}"
  puts "Current Traffic Model: #{$traffic_model.capitalize}"
  puts "Current Restrictions:  #{$avoid.capitalize}"

  puts "---------------------------------------------"
  puts "1: Change Home Address"
  puts "2: Change Work Address"
  puts "3: Execute"
  puts "4: Directions"
  puts "5: Routing Options"
  puts "6: Quit"
  puts "---------------------------------------------"
  option = gets.chomp()
  case option
  when "1"
    system "clear"
    puts "Change Home Address"
    puts "---------------------------------------------"
    puts "Enter Home Address "
    puts "---------------------------------------------"
    $origin= gets.chomp()
  when "2"
    system "clear"
    puts "Change Work Address"
    puts "---------------------------------------------"
    puts "Enter Work Address"
    $destination=gets.chomp()
  when "3"
    GrabCommute($origin,$destination)
  when "4"
    system "clear"
    puts "Directions"
    puts "---------------------------------------------"
    resourceMorning = RestClient.get 'https://maps.googleapis.com/maps/api/directions/json', {params:{key:$key, origin: $origin, destination: $destination,departure_time: (($CommuteDateTimeMorning-EpochDateTime)*24*60*60).to_i, mode: "driving", traffic_model: $traffic_model, avoid: $avoid}}
    hashMorning = JSON.parse(resourceMorning.body)
    hashMorning["routes"][0]["legs"][0]["steps"].each do |step|
       puts "#{step["html_instructions"].gsub(%r{</?[^>]+?>}, '')} for #{step["distance"]["text"]}"
    end
    puts "---------------------------------------------"
    puts "Total Distance to work: #{hashMorning["routes"][0]["legs"][0]["distance"]["text"]}"
    puts "---------------------------------------------"
    puts "Press ENTER to return to the main menu"
    gets.chomp()
  when "5"
    system "clear"
    puts "---------------------------------------------"
    puts "Current Routing Options"
    puts "---------------------------------------------"
    puts "1. Traffic Model: #{$traffic_model.capitalize}"
    puts "2. Avoids: #{$avoid.capitalize}"
    puts "---------------------------------------------"
    puts "Enter the option number that you would like to change"

    case gets.chomp()
    when "1"
      system "clear"
      puts "Which traffic model would you like to use"
      puts "---------------------------------------------"
      puts "1: Best Guess"
      puts "2: Worst Case"
      puts "3: Best Case"
      puts "---------------------------------------------"
      case gets.chomp()
      when "1"
        $traffic_model="best_guess"
      when "2"
        $traffic_model="pessimistic"
      when "3"
        $traffic_model="optimistic"
      end
    when "2"
      system "clear"
      puts "Which Restriction would you like to put in place?"
      puts "---------------------------------------------"
      puts "1: Tolls"
      puts "2: Highways"
      puts "3: Ferries"
      puts "4: Indoors"
      puts "5: No Restrictions"
      puts "---------------------------------------------"
      case gets.chomp()
      when "1"
        $avoid = "tolls"
      when "2"
        $avoid = "highways"
      when "3"
        $avoid = "ferries"
      when "4"
        $avoid = "indoor"
      when "5"
        $avoid = "none"
      end
      puts "your route will avoid #{$avoid.capitalize}"
    end
  when "6"
    system "clear"
  end
# Commute time
end
