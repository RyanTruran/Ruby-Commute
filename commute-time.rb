require 'rest-client'
require 'json'
require 'date'

$key = "AIzaSyDUJJHLXCEebThDcAy9eZu29UoOvfFUtX0"
$destination="300 W. Renner Road Richardson TX"
$origin="300 W. Renner Road Richardson TX"
#Get Current Date and Time, Determine Day of week, Add days to reach specified day of the week.
CurrentDate = Date.today()
CurrentYear = CurrentDate.year
CurrentMonth = CurrentDate.mon
CurrentDay = CurrentDate.mday
NextMonday = 7-CurrentDate.cwday+1
CurrentDateTime = DateTime.new(CurrentYear,CurrentMonth,CurrentDay,6,30,0,Rational(-5,24)) #Year, Month, Day, Hour, Minute, Second, RATIONAL(Offset from UTC, 24 Hour Days)
CommuteDateTime = CurrentDateTime+NextMonday
EpochDateTime = DateTime.new(1970,1,1) #Epoch Time

option=0
querry = false

#this works https://maps.googleapis.com/maps/api/directions/json?origin=Plano+TX&destination=Richardson+TX&departure_time=1503405000&mode=driving&key=AIzaSyDUJJHLXCEebThDcAy9eZu29UoOvfFUtX0&avoid=tolls&traffic_model=pessimistic

while option != 3 do
  system "clear"
  puts "---------------------------------------------"
  puts "Current Origin:      #{$origin}"
  puts "Current Destination: #{$destination}"
  puts "---------------------------------------------"
  puts "1: Change Origin Address"
  puts "2: Change Destination Location"
  puts "3: Exit"
  puts "---------------------------------------------"
  option=Integer(gets.chomp())
case option
when 1
    puts "---------------------------------------------"
    puts "Enter Origin Address "
    puts "---------------------------------------------"
    $origin= gets.chomp()
    querry=true
  when 2
    puts "Configure new destination"
    puts "---------------------------------------------"
    puts "Enter Destination Address"
    $destination=gets.chomp()
    querry=true
  when 3
    querry=false
    system "clear"
  end
  if querry==true
    system "clear"
    SecondsBetween ||= ((CommuteDateTime-EpochDateTime)*24*60*60).to_i
    puts "From #{$origin} To #{$destination} On #{CommuteDateTime}"
    resource = RestClient.get 'https://maps.googleapis.com/maps/api/directions/json', {params:{key:$key, origin: $origin,destination: $destination,departure_time: SecondsBetween,traffic_model: "pessimistic", mode: "driving", avoid: "tolls"}}
    hash = JSON.parse(resource.body)
    puts "---------------------------------------------"
    puts "You will travel a distance of #{hash["routes"][0]["legs"][0]["distance"]["text"]}"
    puts "Without traffic your commute would be #{hash["routes"][0]["legs"][0]["duration"]["text"]}"
    puts "With Traffic your commute would be #{hash["routes"][0]["legs"][0]["duration_in_traffic"]["text"]}"
    puts "---------------------------------------------"
    puts "Press ENTER to return to the main menu"
    gets.chomp

  end
# Commute time
end
