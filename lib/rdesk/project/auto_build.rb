

class Project

    def initialize(name,root_dir,source_dirs,build_command,error_regexes)
        @name=name
        @root_dir=root_dir
        @source_dirs=source_dirs
        @build_command=build_command
        @error_regexes=error_regexes
        @last_build_time=Time.now
    end

    def is_modified?
        @source_dirs.each do |src_dir|
            path=File.join(@root_dir,src_dir)
            return true if is_directory_modified?(path)
        end
        false
    end

    def is_directory_modified?(dir)
        Dir.entries(dir).each do |entry|
            next if entry=="." || entry==".."
            path=File.join(dir,entry)
            if File.stat(path).directory?
                return true if is_directory_modified?(path)
            else
                return true if is_file_modified?(path)
            end

        end
        false
    end

    def is_file_modified?(path)
        if File.stat(path).mtime>@last_build_time
            puts "&&&&&&&&&&&&& modified file: #{path}"
            return true
        end
        return false
    end

    def build
        Dir.chdir(@root_dir) do
            IO.popen(@build_command+" 2>&1") do |pipe|
                while line=pipe.gets
                    @error_regexes.each do |err_regex|
                        if err_regex.match(line)
                            puts "********"+line
                        end
                    end
                end
            end


        end
        @last_build_time=Time.now
    end
end

# p=Project.new("GC",
#     "/Users/david/workspace/davidknight/GlobalCoordinate2",
#     ["app","lib","config","test"],
#     "rake test",
#     [/error/]  )


# while true
#     if p.is_modified?
#         p.build
#     end
#     sleep 3
# end
