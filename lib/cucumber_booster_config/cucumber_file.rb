module CucumberBoosterConfig

  class CucumberFile

    SEMAPHORE_PROFILE = "semaphoreci: --format json --out=features_report.json"
    DEFAULT_PROFILE = "default: --format pretty --profile semaphoreci features"

    def initialize(path, dry_run)
      @user_file_path = path
      @dry_run = dry_run

      if dry_run?
        @tempfile = Tempfile.new("cucumber.yml")
        @path = @tempfile.path
        @tempfile.close
      else
        @path = @user_file_path
        @tempfile = nil
      end
    end

    def configure_for_autoparallelism
      if dry_run?
        load_tempfile
        puts "Content before:"
        puts "---"
        puts read_file_lines(@path)
        puts "---"
      end

      define_semaphore_profile
      include_semaphore_profile

      if dry_run?
        puts "Content after:"
        puts "---"
        puts read_file_lines(@path)
        puts "---"
      end
    end

    private

    def dry_run?
      !!@dry_run
    end

    def read_file_lines(path)
      File.open(path, "r") { |f| f.readlines }
    end

    def load_tempfile
      original_lines = read_file_lines(@user_file_path)
      File.open(@path, "w") { |f| original_lines.each { |line| f.puts line } }
    end

    def define_semaphore_profile
      puts "Inserting Semaphore configuration at the top"

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
          puts "No definition for default profile found, inserting new one"
          file.puts DEFAULT_PROFILE
        end
      end
    end
  end
end
