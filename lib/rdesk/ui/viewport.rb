require 'observer'
module Rdesk
  module Ui

    #represents a view onto part of a buffer
    class Viewport
      include Rdesk::Stage::Actor

      attr_reader :buffer
      attr_reader :first_line_index
      attr_reader :height#how many rows visible
      attr_reader :width#width
      attr_reader :mark
      attr_reader :cursor
      attr_reader :highlighter
      attr_accessor :auto_scroll

      def initialize(buffer,options={})
        @buffer=buffer
        @first_line_index=0
        @cursor=BufferPosition.new(0,0)
        @buffer.add_observer(self)
        @height=options[:height] || 12
        @auto_scroll=options[:auto_scroll] || false
        @highlighter=options[:highlighter]


      end

      def scroll(delta)
        @first_line_index+=delta
        max_first_line_target=@buffer.rows.length- @height 
        @first_line_index=[@first_line_index,max_first_line_target].min
        @first_line_index=0 if @first_line_index<0
        invalidate
        self
      end

      def scroll_view_to_cursor
        if @cursor.row<@first_line_index
          scroll(@cursor.row - @first_line_index)
          
        end
        
        if @cursor.row > @first_line_index+@height
          scroll( @cursor.row-@first_line_index-@height-1)
        end
        return self
      end
      def select(*args)
        if args[0].is_a?(BufferRegion)
          r=args.shift
          self.mark=r.start_pos
          self.cursor=r.end_pos
        else
          self.mark=args.shift_buffer_position
          self.cursor=args.shift_buffer_position
        end
        @buffer.enforce_valid(@mark)
        @buffer.enforce_valid(@cursor)

        self
      end

      def height=(val)
        @height=val
        invalidate
      end

      def cursor=(*args)
        set_cursor(*args)
      end
      
      def set_cursor(*args)
        command=ChangeCommand.new(self)
        new_value=args.shift_buffer_position.clone

        @cursor=new_value
        scroll_view_to_cursor
        self
      end
      
      def move_lines(line_count)
        return unless  @buffer.row_exists?( @cursor.row+line_count)
        self.cursor=@buffer.move_lines(@cursor,line_count)
        
        invalidate

      end
      def move_chars(char_count)
        
        self.cursor=@buffer.move_cursor(@cursor,char_count)
        invalidate

      end

      def delete_char

        @buffer.delete(@cursor,@cursor.move(0,1))

      end

      def unmark
        self.mark=nil
        invalidate
        self
      end

      def mark=(*args)
        set_mark(*args)
      end
      
      def set_mark(new_value=@cursor)
        command=ChangeCommand.new(self)

        new_value=new_value.clone unless new_value.nil?
        old_value=@mark
        old_value=old_value.clone unless old_value.nil?
        
        command.when_do{
          @mark=new_value
        }
        command.when_undo{
          @mark=old_value
        }
        push_change(command)
        command.execute
      end
      
      def region
        BufferRegion.new(@mark || @cursor, @cursor)
      end
      
      def copy
        @buffer.copy(region)
      end

      def cursor_row
        @buffer.rows[@cursor.row].clone
      end
      def delete_row(row_index=@cursor.row)
        @buffer.delete_row(row_index)
        self.cursor=BufferPosition.new(row_index,0)
      end
      def delete(*args)
        
        what=args.shift_buffer_region || region
        @buffer.delete(what)
        self.cursor=region.start_pos
      end

      def insert(text)
        self.cursor=@buffer.insert(region,text)
        #            log("old selection=#{@selection}")
        self.mark=nil
        #            log("new selection=#{@selection}")
        #            log("new text='#{@buffer.text}'")
        invalidate
      end

      def text=(t)
        set_cursor(0,0)
        self.mark=nil
        @buffer.text=t
      end
      
      def text
        @buffer.text
      end


      def translate_to_buffer(arg)
        arg.move(@first_line_index,0)
      end
      def translate_to_viewport(arg)
        arg.move(@first_line_index,0)
      end

      def view_cursor
        translate_to_viewport(@cursor)
      end
      def view
        
        view_region=nil
        view_end=@first_line_index +  @height
        view_end=[view_end , @buffer.rows.length].min
        view_region=BufferRegion.new(@first_line_index,0,view_end,0)

        result=@buffer.copy(view_region)

        result.map!{|row|
          @highlighter.highlight(row)
        } if @highlighter

        
        result
      end

      
      def edit_row(row_index=@cursor.row,&block)
        @buffer.edit_row(row_index,&block)
        
        
      end

      def size=(w,h)
        invalidate
      end

      def to_s
        r="Viewport( selection=#{region.to_s}, view from #{@first_line_index} to #{@first_line_index+@height} ):#{view.inspect}\n"

      end
      def checkpoint
        result=[ChangeCommand.new(self,@buffer.checkpoint.concat(super))]

      end
      

    end
  end
end
