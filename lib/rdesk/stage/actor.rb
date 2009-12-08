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
        changed
        notify_observers(self,:log,message)
      end

      def invalidate
        changed
        notify_observers(self,:invalidate,nil)
      end

      def push_change(change_command)
        @undo_stack ||= []
        @undo_stack.unshift(change_command)
      end
      
      def checkpoint
        return unless @undo_stack
        @change_stack||=Rdesk::Ui::DoStack.new
        @change_stack.push(@undo_stack.clone)
        @undo_stack=nil
      end

      def undo
        return unless @change_stack
        @change_stack.undo
        changed
        notify_observers(self,:undo)
      end

      def redo
        return unless @change_stack
        @change_stack.redo
        changed
        notify_observers(self,:redo)
      end
      

    end
  end
end
