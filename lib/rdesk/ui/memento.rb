module Rdesk
  module Ui

    class Memento
      attr_reader :originator
      attr_reader :state

      attr_reader :children
      def initialize(originator,state,children=[])
        @originator=originator
        @state=state
        @children=children
      end

      def add_child(child)
        raise "child must be a memento" unless child.is_a?(Memento)
        @children << child
      end

      def undo
        self.originator.undo_from_memento(self)
        self.children.each{|c|c.undo}
      end

      def eql?(other)
        return false unless other.is_a? Memento
        return false unless other.originator==self.originator
        return false unless other.state.eql?(self.state)
        return  other.children==self.children

      end
    end
  end
end
