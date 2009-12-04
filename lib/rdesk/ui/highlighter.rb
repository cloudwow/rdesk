module Rdesk
  module Ui

  #tokenizes text and attaches style to each token
    class Highlighter
      attr_accessor :tokenizer
      attr_accessor :styler

      def initialize(tokenizer,styler)
        @tokenizer=tokenizer
        @styler=styler
      end
      
      def highlight(line)
        if @styler && @tokenizer

          line_tokens=@tokenizer.scan(line,:ruby)
          line_tokens.each do |x|
            x[1]=@styler.style_of(x[1])
          end

        end
      end
    end
  end
end

