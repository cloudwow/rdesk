require "rubygems"
require "ncurses"
require 'observer'
require "rdesk/text/line.rb"
require "coderay"
module Rdesk
  module Stage
    class Stage

      (1..26).each do |i|
        eval  "CTRL_"+(i+96).chr+" = #{i}"
      end
      CTRL_space=0
      BACKSPACE=127
      ESCAPE=27
      include Rdesk::Text::Line

      def initialize()
        @mode=:command
        @command_sequence=[]
        @styler=Rdesk::Ui::RubyStyler.new
        @tokenizer=CodeRay
        @highlighter=Rdesk::Ui::Highlighter.new(@tokenizer,@styler)

        @buffers=[]
        @clipboard=[]
      end

      def create_buffer(options={})
        buffer=nil
        file_path=options[:file_path]
        if file_path!=nil
          @buffers.each do |b|
            if b.file_path==file_path
              return buffer
              break;
            end
          end

          file_base_name=File.basename(file_path)
          name = create_unique_buffer_name(file_base_name)
          
          buffer = Rdesk::Ui::Buffer.new(:rows => File.open(file_path).readlines,
                                         :file_path => file_path,
                                         :name => name)
          
        else 
          name = create_unique_buffer_name(options[:name])
          buffer =  Rdesk::Ui::Buffer.new(:name => name)
          
        end
        buffer
      end
      
      def create_unique_buffer_name(starter_name=nil)
        starter_name ||= "buffer"
        name=nil
        v_index=1
        v=""
        while name==nil
          name=starter_name+v
          @buffers.each do |b|
            if b.name==name
              name=nil
              v_index+=1
              v="(#{v_index})"
              break;
            end
            
          end
        end
        name
      end
      def screen_height
        Ncurses.LINES()
      end

      def screen_width
        Ncurses.COLS()
      end

      def curses_on
        @screen=Ncurses.initscr
        Ncurses.cbreak           # provide unbuffered input
        Ncurses.noecho           # turn off input echoing
        Ncurses.nonl             # turn off newline translation
        Ncurses.start_color
        Ncurses.stdscr.keypad(true)     # turn on keypad mode

        @color_pairs={}
        make_color_pair( 224, Ncurses::COLOR_BLACK,:orange)
        make_color_pair( Ncurses::COLOR_RED, Ncurses::COLOR_BLACK,:red)
        make_color_pair( Ncurses::COLOR_GREEN, Ncurses::COLOR_BLACK,:green)
        make_color_pair( Ncurses::COLOR_CYAN, Ncurses::COLOR_BLACK,:cyan)
        make_color_pair( Ncurses::COLOR_WHITE, Ncurses::COLOR_BLACK,:white);
        make_color_pair( Ncurses::COLOR_BLACK, Ncurses::COLOR_YELLOW,:black_on_yellow)
        make_color_pair( Ncurses::COLOR_MAGENTA, Ncurses::COLOR_BLACK,:magenta)
        make_color_pair( Ncurses::COLOR_BLACK, Ncurses::COLOR_WHITE,:black_on_white)
        make_color_pair( Ncurses::COLOR_BLUE, Ncurses::COLOR_BLACK,:blue)
        make_color_pair( Ncurses::COLOR_YELLOW, Ncurses::COLOR_BLACK,:yellow)
        250.times do |i|
          name="q_#{i}".to_sym
          new_pair=make_color_pair( i+20, Ncurses::COLOR_BLACK,name)

        end

        
      end

      def make_color_pair(foreground,background,symbol)
        @next_color_pair_index ||=1
        Ncurses.init_pair(@next_color_pair_index, foreground,background);
        @color_pairs[symbol]=@next_color_pair_index
        @next_color_pair_index+=1
        @next_color_pair_index-1
      end

      def create_window(buffer,x,y,w,h,options={})
        curses_win = Ncurses::WINDOW.new(h,w,y,x )

        curses_win.intrflush(false) # turn off flush-on-interrupt
        curses_win.keypad(true)     # turn on keypad mode
        curses_win.nodelay(true)
        curses_win.move(1,1)
        
        window=Rdesk::Ui::Window.new
        viewport=Rdesk::Ui::Viewport.new(buffer,options)
        window.show(viewport)
        window.native_window=curses_win
        window.add_observer(self)
        window.viewport.height=h-1
        window
      end

      def bind_key_sequence(key_sequence,name=nil,&command)
        expanded_sequence=[]
        key_sequence.each do |k|
          if k.is_a?(String)
            k.each_char{|c|expanded_sequence << c[0] }
          else
            expanded_sequence << k
          end
        end
        @key_tree ||=KeyMapNode.new
        @key_tree.insert(expanded_sequence,name,&command)
      end
      
      def start(file_path=nil)
        curses_on
        begin
          main_buffer=create_buffer(:file_path => file_path)
          @main=create_window(main_buffer,0,0,screen_width,screen_height-4,:highlighter => @highlighter)
          @cmd=create_window(create_buffer,0,screen_height-3,screen_width,3,:auto_scroll=>true)
          @cmd.viewport.auto_scroll=true
          @modeline=create_window(create_buffer,0,screen_height-4,0,1)

          bind_key_sequence([CTRL_z],""){|o| o[:window].viewport.scroll(1)}
          bind_key_sequence([":"],""){|o| @mode = :extended}
          bind_key_sequence([CTRL_j],""){|o| o[:window].viewport.move_lines(1)  }
          #          bind_key_sequence([CTRL_k],""){|o| o[:window].viewport.move_lines(-1)  }
          bind_key_sequence([CTRL_h],""){|o| o[:window].viewport.move_chars(-1)  }
          bind_key_sequence([CTRL_l],""){|o| o[:window].viewport.move_chars(1)  }
          bind_key_sequence([ESCAPE,79,67],""){|o| o[:window].viewport.move_chars(1)  }
          bind_key_sequence([ESCAPE,79,68],""){|o| o[:window].viewport.move_chars(-1)  }
          bind_key_sequence([ESCAPE,79,66],""){|o| o[:window].viewport.move_lines(1)  }
          bind_key_sequence([ESCAPE,79,65],""){|o| o[:window].viewport.move_lines(-1)  }
          bind_key_sequence([27,91,54],""){|o| o[:window].viewport.page_down}
          bind_key_sequence([27,91,53],""){|o| o[:window].viewport.page_up}
          bind_key_sequence([CTRL_a],""){|o| o[:window].viewport.move_to_beginning_of_line}
          bind_key_sequence([CTRL_e],""){|o| o[:window].viewport.move_to_end_of_line}
          bind_key_sequence([CTRL_k],""){|o| clip delete_until_end_of_line(o) }
          bind_key_sequence([BACKSPACE],""){|o| backspace(o) }
          bind_key_sequence([CTRL_x,"x"],""){|o| delete_char(o)  }
          bind_key_sequence([CTRL_x,'s'],""){|o| save() }
          bind_key_sequence([CTRL_w],""){|o| clip o[:window].viewport.delete() }
          bind_key_sequence([ESCAPE,"w"],""){|o| clip o[:window].viewport.copy() }
          bind_key_sequence([ESCAPE,"y"],""){|o| yank() }
          bind_key_sequence([CTRL_y],""){|o| yank() }
          bind_key_sequence([CTRL_space],""){|o| o[:window].viewport.set_mark }
          bind_key_sequence('ex',"crash"){|o| raise @key_tree.dump }
          bind_key_sequence('es',"duh"){|o| raise "duh" }
          bind_key_sequence(['c'],""){|o| @valid=false}

          bind_key_sequence([CTRL_x,'u'],""){|o| undo()}
          bind_key_sequence([ESCAPE,'u'],""){|o| self.redo()}
          bind_key_sequence([CTRL_u],""){|o|
            count=capture_integer("count")
            command=capture_command
            count.times{|x|execute_command(command)}
          }

          @insert_command= Command.new("insert"){|context|
            @main.viewport.insert(context[:last_key_pressed].chr)

          }
          while true
            render
            execute_next_command
            
          end
        ensure
          Ncurses.echo
          Ncurses.nocbreak
          Ncurses.nl
          Ncurses.endwin
        end

      end
      def render_window(w)
        w.native_window.erase
        w.native_window.refresh
        row_index=0
        w.viewport.view.each do |row|

          w.native_window.move(row_index,0)
          
          if row.is_a? String
            white(w,row)
          else
            #it is a set of toekns and style
            row.each do |token_style|
              token=token_style[0]
              style=token_style[1]
              style=[style] unless style.is_a? Array
              if token.is_a? String
                color=style[0]

                colored(w,color,token,style[1..-1])

              end
            end
          end


          row_index+=1
        end
        w.viewport.selection_rows.each do |row_region|
          row_region=w.viewport.translate_to_viewport(row_region)
          char_count=row_region.end_pos.column-row_region.start_pos.column

          w.native_window.mvchgat(row_region.start_pos.row, row_region.start_pos.column, char_count, Ncurses::A_REVERSE,140 , nil) 
        end

        vc=w.viewport.view_cursor
        
        w.native_window.mvchgat(vc.row, vc.column, 1, Ncurses::A_REVERSE ,ncurses_color_index(:white) , nil) 

        

        # 10.times do |x|
        #   16.times do |y|

        #     w.native_window.mvchgat(y, x, 1, Ncurses::A_REVERSE ,x+y*10 , nil)

        #   end
        # end

        w.native_window.refresh


      end
      
      def render
        unless @valid
          render_window(@main)
          render_window(@cmd)
          @modeline.native_window.erase
          mode_name=@mode.to_s
          cursor_msg=" (#{@main.viewport.cursor.row},#{@main.viewport.cursor.column}) #{@main.viewport.buffer.name}"
          
          modeline_msg=cursor_msg+(" "*(screen_width-mode_name.length-cursor_msg.length-1))+mode_name+" "
          @modeline.native_window.move(1,0)

          @modeline.native_window.attrset(Ncurses::A_REVERSE);
          
          white(@modeline, modeline_msg)
          @modeline.native_window.attroff(Ncurses::A_REVERSE);

          #                    @modeline.native_window.curs_bkgd(Ncurses.COLOR_PAIR(5))
          @modeline.native_window.refresh

          @valid=true
        end
      end

      def handle_command_key(c)
        if c==ESCAPE and @command_sequence.length>0 && @command_sequence.last==ESCAPE
          #two escapes in a row mean quit command mode
          clear_command_sequence
          return
        end
        
        @mode=:command
        @command_sequence << c
        key_mapping=@key_tree.find(@command_sequence)
        if key_mapping
          if key_mapping.command

            clear_command_sequence

            return key_mapping.command

          else
            unless @command_sequence.length==1 &&@command_sequence[0]==27
              help key_mapping.get_descendant_command_nodes.join(" | ")
            end

          end
        else
          help @command_sequence.join(" , ")+" is not bound"
          clear_command_sequence


        end
        return nil

      end
      
      def handle_messages
        c=STDIN.getc

        @last_key_pressed=c


        if (c!=13 &&
            (c<32 || c>=128) ) || @mode==:command
          return handle_command_key(c)
        else

          return @insert_command

        end

      end

      def next_command
        command=nil
        while(command==nil)
          command=handle_messages
        end
        command
      end

      def execute_next_command
        execute_command(next_command)
      end
      
      def execute_command(command,options=nil)
        my_options={
          :stage => self,
          :window => @main,
          :viewport => @main.viewport,
          :buffer => @main.viewport.buffer,
          :last_key_pressed=> @last_key_pressed}
        my_options.merge(options) if options
        command.execute(my_options)
        checkpoint
      end
      
      def clear_command_sequence
        @mode=:insert

        @command_sequence=[]
      end

      def update(src,update_type=:invalidate,more=nil)
        case update_type
        when :invalidate


          @valid=false
        when :content_change
          @content_change=true
          @valid=false
        when :log
          log(more)
          @valid=false

        end
        
      end
      def log(message)
        @cmd.viewport.buffer.text= message
        
      end
      def black_one_yellow(window,str)
        colored(window,:black_on_yellow,str)      
      end
      def black_on_cyan(window,str)
        colored(window,:cyan,str)      
      end
      def white(window,str)
        colored(window,:white,str)      
      end
      def cyan(window,str)
        colored(window,:cyan,str)      
      end
      def blue(window,str)
        colored(window,:blue,str)      
      end

      def red(window,str)
        colored(window,:red,str)      
      end
      def orange(window,str)
        colored(window,:orange,str)      
      end

      def green(window,str)
        colored(window,:green,str)      
      end

      def  ncurses_color(color)
        Ncurses::COLOR_PAIR(ncurses_color_index(color))
      end
      def  ncurses_color_index(color)
        @color_pairs[color]
      end
      def colored(window,color,str,attributes=[])
        window.native_window.attron(ncurses_color(color))
        attributes.each{|a|
          attribute=eval "Ncurses::A_"+a.to_s.upcase
          window.native_window.attron(attribute)
        }
        window.native_window.addstr str
        attributes.each{|a|
          attribute=eval "Ncurses::A_"+a.to_s.upcase
          window.native_window.attroff(attribute)
        }
        
        window.native_window.attron(ncurses_color(:white))
        Ncurses.curs_set(0)
        window.native_window.refresh

      end
      def yank
        text=@clipboard.pop
        @main.viewport.insert text if text
      end
      def clip(text)
        @clipboard << text
        @clipboard.shift while @clipboard.length>300
      end
      
      def save()
        File.open(@main.viewport.buffer.file_path,"w") do |f|
          @main.viewport.buffer.rows.each{|row|
            f.write(row)

          }
        end
      end
      def undo
        @main.viewport.buffer.undo
      end
      def redo
        @main.viewport.buffer.redo
      end
      def checkpoint
        if @main && @main.viewport && @content_change
          @main.viewport.buffer.checkpoint
          @content_change=false
        end
      end

      def capture_command
        return next_command
      end

      def capture_integer(name,min=0,max=1000)
        popup=Popup.new("#{name}:",@screen)
        return popup.get_integer(min,max)
      end
      def capture_string(name)
        popup=Popup.new("#{name}:",@screen)
        return popup.get_string(0,30)
      end
      def help(message)
        @cmd.viewport.buffer.text= message
        render_window(@cmd)
      end
    end
    
  end
end
