module Rdesk
  module Ui
    module BufferRegionImmutableMethods

      def start_pos=(val)
        raise "this object is immutable"
      end

      def end_pos=(val)
        raise "this object is immutable"

      end
      
      def mutable!
        extend BufferRegionMutableMethods
        #these members may have been passed in as immutable so make copies
        @start_pos=@start_pos.to_mutable
        @end_pos=@end_pos.to_mutable

      end
      def immutable!
      end

      def to_immutable
        self
      end
    end
    module BufferRegionMutableMethods
      def start_pos=(val)
        @start_pos=val.to_mutable
      end
      def end_pos=(val)
        @end_pos=val.clone.to_mutable
      end
      def mutable!

      end
      def immutable!
        extend BufferRegionImmutableMethods
        @start_pos=@start_pos.to_immutable
        @end_pos=@end_pos.to_immutable
      end
      def to_immutable
        result=deep_clone
        result.immutable!
        result        
      end

    end

    #holds the text.  may be attached to a file
    class BufferRegion
      


      
      include BufferRegionImmutableMethods
      attr_reader :start_pos
      attr_reader :end_pos

      def initialize(*args)

        if args[0].is_a? BufferRegion
          @start_pos=args[0].start_pos
          @end_pos=args[0].end_pos
        else

          @start_pos=args.shift_buffer_position
          @end_pos=args.shift_buffer_position
        end

        if @start_pos > @end_pos
          tmp=@end_pos
          @end_pos=@start_pos
          @start_pos=tmp
        end
      end

      def union(pos)
        if pos.is_a? BufferRegion
          new_start_pos=@start_pos
          new_end_pos=@end_pos
          new_start_pos=pos if start_pos>pos
          new_end_pos=pos if end_pos <pos
          BufferRegion.new(buffer,new_start_pos,new_end_pos)
        else
          union(pos.start_pos).union(end_pos)
        end
      end


      def to_s
        "buffer_region( #{@start_pos.row},#{@start_pos.column} - #{@end_pos.row},#{@end_pos.column} )"
      end
      
      def empty?
        @start_pos.eql?(@end_pos)
      end

      def eql?(other)
        other.start_pos.eql?(@start_pos) && other.end_pos.eql?(@end_pos) 
      end


      def within_region?(*args)
        other=args.shift_buffer_region
        self.end_pos<=other.end_pos && self.start_pos>=other.start_pos
      end
      def deep_clone
        BufferRegion.new(@start_pos.clone,@end_pos.clone)
      end
      def to_mutable
        result=deep_clone
        result.mutable!
        result
        
      end
      def move(rows,columns)
        BufferRegion.new(@start_pos.move(rows,columns) ,@end_pos.move(rows,columns))
      end
      
    end
  end
end
