module Hueshift
  class Server
    DEFAULT_POLLING_INTERVAL = 30 # seconds

    def start
      polling_interval = (ENV.fetch "POLLING_INTERVAL", DEFAULT_POLLING_INTERVAL).to_i
      @thread = Thread.new do
        loop do
          redshift_safe
          sleep polling_interval
        end
      end
    end

    def stop
      @thread.exit
    end

    def restart
      stop
      start
    end

    private ####################################################################

    def redshift_safe
      begin
        redshift
      rescue Exception => e
        puts "#{Time.now}: Received #{e.class}: #{e.message}"
        e.backtrace.each { |line| puts "\t#{line}" }
      end
    end

  end
end
