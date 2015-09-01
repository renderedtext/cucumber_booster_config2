require "thor"

module CucumberBoosterConfig
  class CLI < Thor
    desc "inject", "inject Semaphore's Cucumber configuration"
    def inject(path)
      puts "Running in #{path}"
    end
  end
end
