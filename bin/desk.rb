require "rubygems"
require "rdesk.rb"
#comment

path=nil



path=ARGV[0] if ARGV.length>0



stage=Rdesk::Stage::Stage.new()



stage.start(path)







