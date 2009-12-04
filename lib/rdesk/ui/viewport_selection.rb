module Rdesk
  module Ui
    #holds the text.  may be attached to a file
    class BufferSelection
      attr_reader :start_pos
      attr_reader :end_pos
      def initialize(viewport,start_pos,end_pos)
        @viewport=viewport
        @start_pos=start_pos
        @end_pos=end_pos
        @buffer.when_modified do |start_pos,end_pos,new_content|
          #?
        end
      end
    end
  end
end
