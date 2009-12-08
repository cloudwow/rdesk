
module Rdesk
  module Ui
    #holds the text.  may be attached to a file
    class Buffer
      include Rdesk::Stage::Actor
      attr_reader :name
      attr_reader :rows
      attr_reader :file_path
      
      def initialize(options={})
        @name=options[:name]
        
        @file_path=options[:file_path]
        @file_system=options[:file_system]
        
        if options.has_key? :text
          t=options[:text]
          self.text=t
        end
        if options[:rows]
          @rows=options[:rows].dup
          @rows.map{|r|r.chomp}
        end
        @rows=[""] if @rows==nil || @rows.empty?
        
      end

      def text=(t)
        @rows=[]

        t.each_line{|l|@rows << l.chomp}

        
        if t.length>0 and @rows.last.length>0
          #add extra to accept new input
          @rows << ""
        end
        invalidate
      end
      def move_cursor_back(from_pos,char_count)


        enforce_valid from_pos
        return move_cursor(from_pos,-char_count) if char_count<0
        cursor=from_pos.to_mutable
        line=self.rows[cursor.row]
        
        while cursor.column<char_count

          char_count-=cursor.column

          
          cursor.row-=1
          line=self.rows[cursor.row]
          raise "cursor can't be moved before start of buffer" unless line
          cursor.column=line.length

        end
        if cursor.row<0
          cursor=BufferPosition.new(0,0)
        else
          
          cursor.column-=char_count
        end
        return cursor.to_immutable

      end
      def move_cursor(from_pos,char_count)
        enforce_valid from_pos
        return move_cursor_back(from_pos,-char_count) if char_count<0
        cursor=from_pos.to_mutable
        line=self.rows[cursor.row]
        
        while (line.length-cursor.column)<char_count

          char_count-=(line.length-cursor.column)

          
          cursor.row+=1
          line=self.rows[cursor.row]
          raise "cursor can't be moved beyond end of buffer" unless line
          cursor.column=0

        end
        cursor.column+=char_count

        return cursor.to_immutable
      end
      def move_lines(start_pos,line_count)
        row_index=start_pos.row+line_count
        raise "destination row (#{row_index})  is beyond end (#{@rows.length}) of buffer" if row_index>=@rows.length
        raise "destination row (#{row_index})  is before beginning of buffer" if row_index<0
        column=start_pos.column
        #trim column back
        column=[column,  @rows[row_index].last_char_index].min
        BufferPosition.new(row_index,column)
      end
      

      def copy(*args)
        region=args.shift_buffer_region
        result=[]
        (region.start_pos.row..region.end_pos.row).each do  |row_index|
          cursor_row=@rows[row_index]
          next unless cursor_row 
          delete_from=nil
          delete_to=nil
          if row_index==region.start_pos.row

            delete_from=region.start_pos.column if region.start_pos.column>0
          end
          if row_index==region.end_pos.row
            delete_to=region.end_pos.column 
          end

          if delete_from!=nil && delete_to==nil
            result << cursor_row.slice(delete_from..-1)

          elsif delete_from==nil && delete_to!=nil
            result << cursor_row.slice(0..delete_to) if delete_to>0
          elsif delete_from!=nil && delete_to!=nil
            result << cursor_row.slice(delete_from..delete_to)
          else
            result << cursor_row.clone

          end
        end
        if result.length>0 && result.last.empty?
          result.pop
        end
        result
      end
      
      def text
        if @rows.length>0
          @rows.join("\n")

        else
          ""
        end
        
      end
      
      def modify(target_region,new_content=[])
        
        delete_region(target_region)
        insert(target_region.start_pos,new_content)
        
      end

      def delete(*args)
        region=args.shift_buffer_region
        deleted_row_count=0
        hanging_end=nil
        hanging_begin_index=nil

        (region.start_pos.row..region.end_pos.row).each do  |row_index|
          cursor_row_index=row_index-deleted_row_count
          cursor_row=@rows[cursor_row_index]
          next unless cursor_row
          cursor_row=cursor_row.clone

          delete_from=nil
          delete_to=nil

          if row_index==region.start_pos.row
            delete_from=region.start_pos.column if region.start_pos.column>0
          end

          if row_index==region.end_pos.row
            delete_to=region.end_pos.column-1
          end

          if delete_from!=nil && delete_to==nil

            cursor_row.slice!(delete_from..-1)
            modify_row(cursor_row_index,cursor_row)
            hanging_begin_index=cursor_row_index

          elsif delete_from==nil && delete_to!=nil

            if delete_to>=0
              hanging_end=cursor_row.slice(delete_to+1..-1) 
              
              delete_row(cursor_row_index)
              deleted_row_count+=1
            end

          elsif delete_from!=nil && delete_to!=nil

            cursor_row.slice!(delete_from..delete_to) if delete_to>=delete_from
            modify_row(cursor_row_index,cursor_row)

          else

            delete_row(cursor_row_index)
            
            deleted_row_count+=1
          end

        end
        if hanging_begin_index && hanging_end

          combined_row=@rows[hanging_begin_index]+hanging_end
          modify_row( hanging_begin_index,combined_row)
        end

        invalidate
      end
      #text will be inserted after pos
      def insert(pos,content)
        content=rowify(content)
        
        enforce_valid(pos)

        if pos.is_a? BufferRegion
          unless pos.empty?
            delete(pos)
          end
          cursor=pos.start_pos.to_mutable
        end
        cursor ||= pos.to_mutable
        hanging_line=nil
        row=nil
        content.each do |new_line|


          row=@rows[cursor.row]
          row = row.clone if row

          if hanging_line!=nil
            #this is a wholly new line
            row=new_line.clone
            add_row(cursor.row,row)

          else

            hanging_line =  row.slice!(cursor.column..-1)
            row << new_line
            modify_row(cursor.row,row)
          end

          if  row.chomp!
            row=""
            add_row(cursor.row+1,row)


            cursor.next_row!
          end
          cursor.next_row! unless new_line==content.last
        end


        if hanging_line
          cursor.column=row.length
          row << hanging_line
          modify_row(cursor.row,row)

        end

        invalidate       
        cursor.to_immutable
      end
      
      def to_s
        r="Buffer:::::::::::\n"
        line_index=1
        @rows.each{|l|
          r << line_index.to_s <<  l << "\n"
          line_index+=1}
        r << ":::::::::::::::::\n"

        r
      end

      def append(text)
        new_rows=rowify(text)
        new_rows.each{|r|add_row(@rows.length,r)}

        invalidate
      end

      def rowify(text)

        text=text.split("\n") if text.is_a? String
        text
      end
      
      def edit_row(row_index)
        push_row(row_index)
        result=yield @rows[row_index]
        
        @rows[row_index]=result if result
        delete_row(row_index) unless result
        
      end
      
      def region
        return BufferRegion.new(0,0,0,0) if empty?
        BufferRegion.new(0,0,@rows.length-1,@rows.last.length)
      end
      def row_length(row_index)
        raise "invalid row: #{row_index}" if row_index<0 || row_index>=@rows.length
        return @rows[row_index].length
      end

      def make_position_legal(position)
        return if self.rows.length==0
        row=[self.rows.length-1,position.row].min
        row=[0 ,row].max

        row_length=self.row_length row
        column=[row_length,position.column].min
        column=[0,column].max
        position=BufferPosition.new(row,column)
      end


      
      def empty?
        @rows.empty?
      end

      def enforce_valid(*args)
        
        args.each do |item|
          if item.respond_to?(:within_region?)
            
            unless item.within_region?(self.region)
              raise "#{item.class.name} is not within buffer boundaries. boundaries=#{self.region}.  item=#{item}"
            end
          end
        end
      end

      def contains?(*args)
        while !args.empty?
          pos=args.shift_buffer_position
          return false unless pos.within_region?(self.region)
        end
        return true
      end

      def row_exists?(row_index)
        return row_index>=0  && row_index<@rows.length
      end


      def modify_row(row_index,new_content)

        old_content=@rows[row_index].clone
        new_content=new_content.clone
        change=ChangeCommand.new(self)
        change.when_do{@rows[row_index]=new_content}
        change.when_undo{

          @rows[row_index]=old_content}
        change.execute
        push_change change
        update(self,:content_change,nil)

      end
      def add_row(row_index,content)
        content=content.clone
        change=ChangeCommand.new(self)
        change.when_do{@rows.insert(row_index,content)}
        change.when_undo{
          @rows.delete_at(row_index)}
        change.execute

        
        push_change(change)
        update(self,:content_change,nil)

      end

      
      def delete_row(row_index)

        deleted_row=@rows.delete_at(row_index).clone

        change=ChangeCommand.new(self)
        change.when_do{@rows.delete_at(row_index)}
        change.when_undo{
          @rows.insert(row_index,deleted_row)}


        
        push_change(change)
        update(self,:content_change,nil)
      end

      
    end

  end

end
