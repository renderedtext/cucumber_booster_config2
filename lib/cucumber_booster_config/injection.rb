module CucumberBoosterConfig

  class Injection

    SEMAPHORE_PROFILE = "semaphoreci: --format json --out=features_report.json"
    CUCUMBER_FILES = [
      "cucumber.yml",
      "config/cucumber.yml"
    ]

    def initialize(path, options = {})
      @path = path
      @dry_run = options.fetch(:dry_run, false)
    end

    def dry_run?
      !!@dry_run
    end

    def cucumber_file_path(file_name)
      File.join(@path, file_name)
    end

    def find_profile_files
      profile_files = []

      CUCUMBER_FILES.map { |file_name| cucumber_file_path(file_name) }.each do |file|
        if File.exist?(file)
          puts "Found Cucumber profile file: #{file}"
          profile_files << file
        end
      end

      profile_files
    end

    def define_semaphore_profile(path)
      puts "Inserting Semaphore configuration at the top of #{path}"

      if dry_run?
        puts SEMAPHORE_PROFILE
        return
      end

      f = File.open(path, "r")
      lines = f.readlines
      f.close

      lines = ["#{SEMAPHORE_PROFILE}\n"] + lines

      output = File.new(path, "w")
      lines.each { |line| output.write line }
      output.close
    end

    def include_semaphore_profile(path)
      puts "Appending Semaphore profile to default profile"
      file = File.open(path, "r")
      lines = file.readlines
      file.close

      File.open(path, "w") do |file|
        lines.each do |line|
          if line =~ /default:/
            line = "#{line.gsub("\n", "")} --profile semaphoreci\n"
          end

          file.puts line
        end
      end
    end

    def run
      find_profile_files.each do |path|
        define_semaphore_profile(path)
        include_semaphore_profile(path)
      end
    end
  end
end
