module Rdesk
  module Ui

    class RubyStyler
      def initialize
        @color_map={ 
          :content =>  [:red,:underline],
          :delimiter => :blue ,
          :ident => :green,
          :operator => :blue,
          :constant => :cyan,
          :integer => [:red,:bold],
          :comment => :yellow


        }
      end
      def style_of(x)
        @color_map[x] || :green
      end
    end
  end
end
