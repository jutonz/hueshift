module Hueshift
  USER_SETTINGS_FILE = ".hueshift"

  def load_user_settings
    settings_file = File.expand_path USER_SETTINGS_FILE, Dir.home
    if File.exist? settings_file
      require "dotenv"
      Dotenv.load settings_file
    end
  end
end
