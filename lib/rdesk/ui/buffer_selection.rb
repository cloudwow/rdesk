module Rdesk
  module Ui
    #holds the text.  may be attached to a file
    class BufferSelection
      attr_reader :start_pos
      attr_reader :end_pos
      attr_reader :options
      def initialize(*args)
        
        @options={}
        @options=args.pop if  args[-1].is_a? Hash
        if args.length==4
          
          @start_pos=BufferPosition.new(args[0],args[1])
          @end_pos=BufferPosition.new(args[2],args[3])
        elsif args.length==2

            @start_pos=args[0]
            @end_pos=args[1]
        else
          raise "unrecognized argument list"
        end
        @buffer=options[:buffer]
      end
      def grow(pos)
        new_start_pos=@start_pos
        new_end_pos=@end_pos
        new_start_pos=pos if start_pos>pos
        new_end_pos=pos if end_pos <pos
        BufferSelection.new(buffer,new_start_pos,new_end_pos)
      end
    end
  end
end
