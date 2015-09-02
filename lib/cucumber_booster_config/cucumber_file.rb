module CucumberBoosterConfig

  class CucumberFile

    SEMAPHORE_PROFILE = "semaphoreci: --format json --out=features_report.json"
    DEFAULT_PROFILE = "default: --format pretty --profile semaphoreci features"

    def initialize(path, dry_run)
      @path = path
      @dry_run = dry_run
    end

    def configure_for_autoparallelism
      define_semaphore_profile
      include_semaphore_profile
    end

    private

    def dry_run?
      !!@dry_run
    end

    def read_file_lines(path)
      File.open(path, "r") { |f| f.readlines }
    end

    def define_semaphore_profile
      puts "Inserting Semaphore configuration at the top of #{@path}"

      if dry_run?
        puts SEMAPHORE_PROFILE
        return
      end

      lines = read_file_lines(@path)

      lines = ["#{SEMAPHORE_PROFILE}\n"] + lines

      output = File.new(@path, "w")
      lines.each { |line| output.write line }
      output.close
    end

    def include_semaphore_profile
      puts "Appending Semaphore profile to default profile"
      lines = read_file_lines(@path)

      default_profile_found = false

      File.open(@path, "w") do |file|
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
  end
end
