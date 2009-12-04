          @key_map= {
            'z'[0] => lambda{|o| o[:window].viewport.scroll(1)},
            'x'[0] => lambda{|o| @mode = :extended},
            'j'[0] => lambda{|o| o.viewport.move_cursor(1,0)  },
            'k'[0] => lambda{|o| o.viewport.move_cursor(-1,0)  },
            'h'[0] => lambda{|o| o.viewport.move_cursor(0,-1)  },
            'l'[0] => lambda{|o| o.viewport.move_cursor(0,1)  },
            '1'[0] => lambda{|o| raise @main.viewport.to_s },
            '2'[0] => lambda{|o| white(@main, @main.viewport.text) },
            'c'[0] => lambda{|o| @valid=false},
            'h'[0] => lambda{|o| show_help},
            'i'[0] => lambda{|o| @mode = :insert}
          }
