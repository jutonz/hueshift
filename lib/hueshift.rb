require_relative "hueshift/version"
require_relative "hueshift/user_settings"
require_relative "hueshift/server"
require "hue"

class Numeric
  def scale(from: 0, to: 0)
    from_min = from.first
    from_max = from.last
    to_min   = to.first
    to_max   = to.last

    ((to_max - to_min) * (self - from_min)) / (from_max - from_min) + to_min
  end
end

module Hueshift
  LAT        = (ENV.fetch "LAT", 35.779).to_f
  LON        = (ENV.fetch "LON", -78.6465).to_f
  DAY_TEMP   = (ENV.fetch "DAY_TEMP", 5500).to_i
  NIGHT_TEMP = (ENV.fetch "NIGHT_TEMP", 1900).to_i

  def redshift
    client = Hue::Client.new

    lights = client.lights
    lights.each do |light|
      next unless light.on? # Only adjust lights that are already on

      transition_time = 10 * 10 # Transition times are in 1/10 second
      state = { color_temperature: redshift_temperature }
      light.set_state state, transition_time
    end
  end

  def redshift_server(sleepytime: 30)
    loop do
      begin
        redshift
      rescue Exception => e
        puts "#{Time.now}: Received #{e.class}: #{e.message}"
        e.backtrace.each { |line| puts "\t#{line}" }
        #puts e.backtrace
      end
      sleep sleepytime
    end
  end

  def redshift_temperature
    check_redshift!
    output = `redshift -l #{LAT}:#{LON} -t #{DAY_TEMP}:#{NIGHT_TEMP} -p`

    # Output looks like this:
    #   Period: Night
    #   Color temperature: 1900K
    #   Brightness: 1.00
    #
    # We just care about the color temperature
    temperature    = output.lines[1].split.last.to_i

    redshift_range = DAY_TEMP..NIGHT_TEMP
    hue_range      = Hue::Light::COLOR_TEMPERATURE_RANGE

    temperature.scale from: redshift_range, to: hue_range
  end

  def check_redshift!
    raise "You need to 'brew install redshift'" unless redshift_installed?
  end

  def redshift_installed?
    not `which redshift`.empty?
  end
end
