require 'observer'
module Rdesk
  module Ui
    class DoStack
      MAX_UNDO=500

      def initialize
        @changes=Array.new(MAX_UNDO)
        @cursor=0
        @last_change_index=-1
      end

      def push(change_commands)
        change_commands=[change_commands] unless change_commands.is_a? Array
        
        @changes[@cursor]=change_commands
        if @cursor==MAX_UNDO
          @changes.shift
          cursor-=1
        end
        @last_change_index=@cursor
        @cursor+=1
      end

      def undo
        if @cursor>0
          @cursor-=1
          @changes[@cursor].each{|c|c.undo}
        end
      end
      
      def redo
        if @cursor<= @last_change_index
          
          @changes[@cursor].reverse.each{|c|c.execute}
          @cursor+=1
        end
      end

    end
  end
end
