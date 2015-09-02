module CucumberBoosterConfig

  class Injection

    SEMAPHORE_PROFILE = "semaphoreci: --format json --out=features_report.json"
    DEFAULT_PROFILE = "default: --format pretty --profile semaphoreci features"

    CUCUMBER_FILES = [
      "cucumber.yml",
      "config/cucumber.yml"
    ]

    def initialize(path, options = {})
      @path = path
      @dry_run = options.fetch(:dry_run, false)
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

      lines = read_file_lines(path)

      lines = ["#{SEMAPHORE_PROFILE}\n"] + lines

      output = File.new(path, "w")
      lines.each { |line| output.write line }
      output.close
    end

    def include_semaphore_profile(path)
      puts "Appending Semaphore profile to default profile"
      lines = read_file_lines(path)

      default_profile_found = false

      File.open(path, "w") do |file|
        lines.each do |line|
          if line =~ /default:/
            default_profile_found = true
            line = "#{line.gsub("\n", "")} --profile semaphoreci"
          end

          file.puts line
        end

        if !default_profile_found
          puts "No definition for default profile found, appending one now"
          file.puts DEFAULT_PROFILE
        end
      end
    end

    def run
      find_profile_files.each do |path|
        define_semaphore_profile(path)
        include_semaphore_profile(path)
      end
    end

    private

    def dry_run?
      !!@dry_run
    end

    def read_file_lines(path)
      File.open(path, "r") { |f| f.readlines }
    end

    def cucumber_file_path(file_name)
      File.join(@path, file_name)
    end
  end
end
