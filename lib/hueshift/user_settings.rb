module Hueshift
  USER_SETTINGS_FILE = ".hueshift"
  USER_SETTINGS_PATH = File.expand_path USER_SETTINGS_FILE, Dir.home

  ##
  # Load the settings in USER_SETTINGS_PATH, if it exists.
  #
  # @return whether USER_SETTINGS_PATH exists
  def load_user_settings
    if (exists = File.exist? USER_SETTINGS_PATH)
      require "dotenv"
      Dotenv.load USER_SETTINGS_PATH
    end
    exists
  end
end
