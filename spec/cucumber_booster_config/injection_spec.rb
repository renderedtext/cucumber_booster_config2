require "spec_helper"

describe CucumberBoosterConfig::Injection do

  context "blank cucumber.yml in root" do

    before do
      File.open("cucumber.yml", "w") {|f| }
    end

    it "inserts semaphoreci profile" do
      CucumberBoosterConfig::Injection.new(".").run

      lines = []
      File.open("cucumber.yml", "r") { |f| lines = f.readlines }

      expect(lines.size).to eql(1)
      expect(lines[0].chomp).to eql(CucumberBoosterConfig::Injection::SEMAPHORE_PROFILE)
    end

    after do
      FileUtils.rm("cucumber.yml")
    end
  end

  context "config/cucumber.yml with a default profile" do
    
    before do
      FileUtils.mkdir_p("config")
      File.open("config/cucumber.yml", "w") do |f|
        f.puts "default: <%= common %>"
      end
    end

    it "inserts semaphoreci profile and appends it to default profile" do
      CucumberBoosterConfig::Injection.new(".").run

      lines = []
      File.open("config/cucumber.yml", "r") { |f| lines = f.readlines }

      expect(lines.size).to eql(2)
      expect(lines[0].chomp).to eql(CucumberBoosterConfig::Injection::SEMAPHORE_PROFILE)
      expect(lines[1].chomp).to eql("default: <%= common %> --profile semaphoreci")
    end

    after do
      FileUtils.rm_rf("config")
    end
  end
end
