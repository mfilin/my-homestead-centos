require 'json'

def load_config
    config = {}
    if File.exists?(File.expand_path "./config.json")
        config = JSON.parse(File.read(File.expand_path "./config.json"))
        return config
    else
        print "Error, the file is not exist, please make a call config.json"
    end
end

load_config
