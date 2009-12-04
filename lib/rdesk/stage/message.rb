module Rdesk
  module Stage
    class Message
      attr_reader :source
      attr_reader :content
      def initialize(source,content)
        @source=source
        @content=content
      end
    end
  end
end
