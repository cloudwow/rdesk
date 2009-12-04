require 'rake'
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << "lib"
  t.test_files = FileList['./test/**/*test.rb']
  t.verbose = true
end

task :emacs  do
  files = FileList['**/*.rb'].exclude("vendor")

  puts "Making Emacs TAGS file"

  puts "ctags -f #{files}"
  sh "ctags -e #{files}", :verbose => false

end

