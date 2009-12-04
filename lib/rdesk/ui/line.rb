module Rdesk
  module Ui
    class Line 
      
      def initialize(content="",clean_content=nil)
        @content=content.clone
        @clean_content=clean_content || @content
      end
      def content=(str)
        @content=str.to_s
      end
      def checkpoint
        @clean_content=@content        
      end
      def save_to_memento
        Mememto.new(self,@content)
      end
      def undo_from_memento(m)
        @content=@clean_content=m.state
      end
      def clone
        Line.new(@content,@clean_content)

      end
      def method_missing(method,*args,&block)
        @content.send(method,*args,&block)

      end
      def eql?(o)
        return o.to_s==@content
      end
      def dirty?
        return @clean_content==@content
      end
      def ==(o)
        return @content==o.to_s
      end
      def to_s
        @content
      end
    end
  end
end

