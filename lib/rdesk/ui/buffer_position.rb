module Rdesk
  module Ui
    module BufferPositionImmutableMethods
      def next_row!
        raise "this object is immutable"
      end

      def column=(val)
        raise "this object is immutable"
      end

      def row=(val)
        raise "this object is immutable"
      end
      def to_immutable
        self
      end
      def immutable!

      end

      def mutable!
        extend BufferPositionMutableMethods
      end
    end
    module BufferPositionMutableMethods
      def next_row!
        @row+=1
        @column=0
      end
      
      def column=(val)
        @column=val
      end
      
      def row=(val)
        @row=val
      end
      
      def to_immutable
        BufferPosition.new(@row,@column)
      end
      
      def immutable!
        extend BufferPositionImmutableMethods
      end

      def mutable!

      end
    end
    
    #holds the text.  may be attached to a file
    class BufferPosition
      
      include BufferPositionImmutableMethods
      attr_reader :row,:column
      def initialize(row,column)
        raise "row must be non-negative" if row <0
        raise "column must be non-negative" if column <0
        @row=row
        @column=column
        

      end


      def to_s
        "buffer_position( #{@row},#{@column})"
      end

      def eql?(*args)
        other=args.shift_buffer_position
        other.row==@row && other.column==@column 
      end

      def > (other)
        return @column > other.column if @row==other.row
        @row > other.row
      end

      def < (other)
        return @column< other.column if @row==other.row
        @row < other.row
      end

      def >= (other)
        return @column >= other.column if @row==other.row
        @row >= other.row
      end

      def <= (other)
        return @column<= other.column if @row==other.row
        @row <= other.row
      end

      def next_row
        result=dup
        result.next_row!
        result
      end
      
      
      def within_region?(*args)
        region=args.shift_buffer_region
        self<=region.end_pos && self>=region.start_pos
      end

      def to_mutable
        result=dup
        result.mutable!
        result
        
      end

      def move(rows,columns)
        BufferPosition.new(@row+rows,@column+columns)
      end
      
    end
    
  end
end
