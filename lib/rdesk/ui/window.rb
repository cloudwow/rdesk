
module Rdesk
   module Ui
      class Window

         include Rdesk::Stage::Actor

         attr_accessor :viewport
         attr_accessor :native_window
         
         def initialize(options={})
            @native_window=options[:native_window]
         end

         def show(viewport)
            @viewport.delete_observer(self) if @viewport
            @viewport=viewport
            @viewport.add_observer(self)
            
            invalidate
         end

         def size=(w,h)
            @viewport.size=w,h
         end
      end
   end
end
