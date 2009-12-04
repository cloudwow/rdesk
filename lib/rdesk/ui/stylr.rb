module Rdesk
  module Ui

    class Style
      def initialize
        @color_map={ 
          :content =>  [:red,:underline],
          :delimiter => :cyan ,
          :ident => :orange,
          :operator => :blue,
          :integer => [:red,:bold],
          :comment => :yellow


        }
      end
      def color_of(x)
        @color_map[x] || :green
      end
    end
  end
end
