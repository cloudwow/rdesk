require 'observer'
module Rdesk
  module Stage
    module Actor
      include Observable
      def update(src,update_type=:invalidate,more=nil)
        changed
        notify_observers(self,update_type,more)
      end
      
      def log(message)
        update(self,:log,message)
      end

      def invalidate
        update(self,:invalidate,nil)
      end

      def push_change(change_command)
        @change_stack ||= []
        @change_stack.unshift(change_command)
      end
      
      def checkpoint
        @do_stack||=Rdesk::Ui::DoStack.new
        @do_stack.push(@change_stack.clone)
        @change_stack=[]
      end

      def undo
        @do_stack.undo
      end

      def redo
        @do_stack.redo
      end
      

    end
  end
end
