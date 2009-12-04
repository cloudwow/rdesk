          @key_map= {
            'z' => lambda{|o| o[:window].viewport.scroll(1)},
            'x' => lambda{|o| @mode =: extended},
            '0' => lambda{|o| red(@cmd,@cmd.viewport.text)  },
            '1' => lambda{|o| raise @main.viewport.to_s },
            '2' => lambda{|o| white(@main, @main.viewport.text) },
            'c' => lambda{|o| @valid=false},
            'h' => lambda{|o| show_help},
            'i' => lambda{|o| @mode = :insert}
          }
