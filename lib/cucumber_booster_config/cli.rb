require "thor"

module CucumberBoosterConfig
  class CLI < Thor
    desc "inject", "inject Semaphore's Cucumber configuration"
    option :dry_run, :type => :boolean
    def inject(path)
      puts "Running in #{path}"
      Injection.new(path, :dry_run => options[:dry_run]).run
    end
  end
end
