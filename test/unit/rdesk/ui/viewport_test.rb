require "test/test_helper.rb"

module Rdesk
  module Ui
    class ViewportTest < Test::Unit::TestCase
      def setup
        @buffer=Buffer.new(:text=>"hello\nworld\ngoodbye\n")
        @target=Viewport.new(@buffer)
        @target.height=20
      end

      def test_copy_all
        @target.select(0,0,3,0)
        result=@target.copy
        assert_equal("hello:world:goodbye",result.join(":"))
      end
      def test_copy_line

        result=@target.select(BufferRegion.new( 1,0,2,0)).copy
        assert_equal("world",result.join("*"))

      end
      def test_copy

        result=@target.select(BufferRegion.new( 1,1,1,3)).copy
        assert_equal("orl",result.join("*"))

      end


      def test_delete_all

        @target.select(BufferRegion.new( 0,0,3,0)).delete
        assert_equal("",@target.text)

      end
      def test_delete_line

        @target.select(BufferRegion.new(1,0,2,0,:buffer=>@buffer)).delete
        assert_equal("hello\ngoodbye\n",@target.text)


      end
      def test_delete

        @target.select(BufferRegion.new( 1,1,1,3)).delete
        assert_equal("hello\nwld\ngoodbye\n",@target.text)

      end
      def test_insert
        
        @target.set_cursor(BufferPosition.new(1,3)).insert(["123"])
        assert_equal("hello\nwor123ld\ngoodbye\n",@target.text)
        assert_position(1,6,@target.cursor)

      end
      def test_insert_chars
        @buffer=Buffer.new()
        @target=Viewport.new(@buffer)
        
        @target.insert(['a'])
        @target.insert(['b'])
        @target.insert(['c'])
        assert_equal("abc",@target.text)
        assert_position(0,3,@target.cursor)

      end
      def test_multiple_inserts
        
        @target.set_cursor(BufferPosition.new(1,3)).insert(["123"])
        @target.insert(["456"])
        @target.insert(["789"])
        assert_equal("hello\nwor123456789ld\ngoodbye\n",@target.text)


      end
      
      def test_insert_rows
        
        @target.set_cursor(BufferPosition.new(1,3)).insert(["123","abc"])
        assert_equal("hello\nwor123\nabcld\ngoodbye\n",@target.text)


      end
      def test_insert_into_empty_alot
        @target=Viewport.new(Buffer.new())
        10.times{|i|@target.insert(i.to_s)}
        assert_equal("0123456789",@target.text)
        10.times{|i|@target.insert(i.to_s)}
        assert_equal("01234567890123456789",@target.text)
        
      end
      def test_insert_into_empty
        @target=Viewport.new(Buffer.new())
        @target.insert("1")
        assert_equal("1",@target.text)
        @target.insert("2")
        assert_equal("12",@target.text)
        @target.insert("3")
        assert_equal("123",@target.text)
        @target.set_cursor(0,0).insert("abc")
        assert_equal("abc123",@target.text)
      end

      def test_view
        assert_equal("hello*world*goodbye",@target.view.join("*"))

      end

      def test_notification
        @target.add_observer(self)
        @update_called=false
        @target.set_cursor(0,0).insert("abc")
        assert( @update_called)


      end

      def update(src,update_type=invalidate,more=nil)
        @update_called=true
      end

      def test_set_cursor
        @target.set_cursor(1,4)
        assert_position(1,4,@target.cursor)
      end
      def test_set_mark
        @target.set_cursor(1,4)
        @target.set_mark
        assert_position(1,4,@target.cursor)
        assert_position(1,4,@target.mark)
        assert_region(1,4,1,4,@target.region)
        @target.set_cursor(2,8)
        assert_position(2,8,@target.cursor)
        assert_position(1,4,@target.mark)
        assert_region(1,4,2,8,@target.region)
        @target.set_cursor(0,1)
        assert_position(0,1,@target.cursor)
        assert_position(1,4,@target.mark)
        assert_region(0,1,1,4,@target.region)
        @target.unmark
        assert_position(0,1,@target.cursor)
        assert_nil(@target.mark)
        assert_region(0,1,0,1,@target.region)

      end
    end
  end
end
