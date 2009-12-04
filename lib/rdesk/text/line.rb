module Rdesk
  module Text
    module Line
      def delete_until_end_of_line(context)

        if context[:viewport].cursor_row.length>0
          
          context[:viewport].select(
                                    context[:viewport].cursor,
                                    context[:viewport].cursor.row,
                                    context[:viewport].cursor_row.length+1).delete
        else

          context[:viewport].delete_row
        end
        return "deleted until end of line"
      end
      def delete_char(context)
        context[:viewport].delete_char
        
      end
      def backspace(context)
        unless context[:viewport].cursor.eql?(0,0)
          context[:viewport].move_chars(-1)
          delete_char(context)
        end
        
      end
    end
  end
end

