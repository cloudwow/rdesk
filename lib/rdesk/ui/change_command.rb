module Rdesk
  module Ui

    class ChangeCommand
      attr_reader :originator
      attr_reader :undo_command
      attr_reader :do_command
      attr_reader :children
      def initialize(originator,children=[])
        @originator=originator
        @children=children
      end

      def when_do(&block)
        @do_command=block
      end
      def when_undo(&block)
        @undo_command=block
      end
      
      def add_child(child)
        raise "child must be a memento" unless child.is_a?(Memento)
        @children << child
      end

      def undo
        @undo_command.call if @undo_command
        self.children.each{|c|c.undo}
      end

      def execute
        @do_command.call if @do_command
        self.children.reverse.each{|c|c.execute}

      end
      
    end
  end
end
