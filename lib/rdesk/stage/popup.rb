require "rubygems"
require "ncurses"


module Rdesk
  module Stage
    class Popup
      attr_reader :text
      def initialize(text,screen)
        @text=text
        @screen=screen
      end

      def get_integer(min=0,max=1000)
        result=create_window(text,Ncurses::Form::TYPE_INTEGER,0,min,max)
        result.to_i
        
      end

      def create_window(text,field_type=nil,*args)
        #create some fields
        fields = Array.new
        fields.push(Ncurses::Form.new_field(1,10,4,18,0,0))
        fields[0].set_field_type(field_type, *args) if field_type!=nil

        # set field options
        Ncurses::Form.set_field_back(fields[0], Ncurses::A_UNDERLINE)
        Ncurses::Form.field_opts_off(fields[0], Ncurses::Form::O_AUTOSKIP)


        # create a form  
        form = Ncurses::Form.new_form(fields)

        # post the form and refresh the screen
        Ncurses::Form.post_form(form)
        @screen.refresh()

        Ncurses.mvprintw(4, @text.length, @text)

        @screen.refresh()

        # Loop through to get user requests
        while((ch = @screen.getch()) != 13) do
          case(ch)
          when Ncurses::KEY_DOWN
            # Go to next field
            Ncurses::Form.form_driver(form, Ncurses::Form::REQ_NEXT_FIELD)
            # Go to the end of the present buffer
            # Leaves nicely at the last character
            Ncurses::Form.form_driver(form, Ncurses::Form::REQ_END_LINE)
            
          when Ncurses::KEY_UP
            #Go to previous field
            Ncurses::Form.form_driver(form, Ncurses::Form::REQ_PREV_FIELD)
            Ncurses::Form.form_driver(form, Ncurses::Form::REQ_END_LINE);
          else                                                                   
            # If this is a normal character, it gets Printed
            Ncurses::Form.form_driver(form, ch)
          end
        end

        Ncurses::Form.form_driver(form, Ncurses::Form::REQ_NEXT_FIELD)

        result=fields[0].field_buffer(0)


        # unpost and free form
        Ncurses::Form.unpost_form(form);
        Ncurses::Form.free_form(form)
        Ncurses::Form.free_field(fields[0]);
        Ncurses::Form.free_field(fields[1]);

        result
      end

    end
  end
end
