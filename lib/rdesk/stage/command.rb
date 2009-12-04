module Rdesk
  module Stage
    class Command
      attr_reader :block
      attr_reader :name
      attr_reader :help
      attr_reader  :key_sequences
      def initialize(name,help=nil,&block)
        @name=name
        @help=help
        @block=block
        @key_sequences =[]
      end
      def execute(context={})
        
        block.call(context)
      end
      def add_key_sequence(key_sequence)
        @key_sequences << @key_sequence
      end
    end
  end
end
