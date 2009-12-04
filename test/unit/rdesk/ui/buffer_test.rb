require "test/test_helper.rb"
require 'observer'

module Rdesk
  module Ui
    class BufferTest < Test::Unit::TestCase

      def update(src,mssage_type,more)
        @update_called=true
      end

      
      def setup
        @target=Buffer.new(:text=>"hello\nworld\ngoodbye\n")
      end

      def test_copy_all

        result=@target.copy(BufferRegion.new(0,0,4,0))
        assert_equal("hello:world:goodbye",result.join(":"))

      end

      def test_copy_line

        result=@target.copy(BufferRegion.new( 1,0,2,0))
        assert_equal("world",result.join("*"))

      end

      def test_copy
        
        result = @target.copy(BufferRegion.new( 1,1,1,3))
        assert_equal("orl",result.join("*"))

      end


      def test_delete_all

        @target.delete(BufferRegion.new( 0,0,4,0))
        assert_equal("",@target.text)

      end
      def test_delete_line

        @target.delete(BufferRegion.new( 1,0,2,0))
        assert_equal("hello\ngoodbye\n",@target.text)

      end
      def test_delete_across_rows
        @target.delete(BufferRegion.new(1,3,2,3))
        assert_equal("hello\nwordbye\n",@target.text)

      end

      def test_delete

        @target.delete(BufferRegion.new( 1,1,1,3))
        assert_equal("hello\nwld\ngoodbye\n",@target.text)

      end
      
      def test_insert
        
        result=@target.insert(BufferPosition.new(1,3),["123"])
        assert_equal("hello\nwor123ld\ngoodbye\n",@target.text)
        assert_equal(1,result.row)
        assert_equal(6,result.column)

      end
      def test_insert_rows
        
        @target.insert(BufferPosition.new(1,3),["123","abc"])
        assert_equal("hello\nwor123\nabcld\ngoodbye\n",@target.text)


      end

      def test_insert_into_empty
        @target=Buffer.new()
        @target.insert(BufferPosition.new(0,0),"123")
        assert_equal("123",@target.text)
        @target.insert(BufferPosition.new(0,0),"abc")
        assert_equal("abc123",@target.text)
      end
      def test_insert_over
        
        @target.insert(BufferRegion.new(1,3,1,5),["123"])
        assert_equal("hello\nwor123\ngoodbye\n",@target.text)


      end
      def test_insert_rows_over

        @target.insert(BufferRegion.new(1,3,2,3),["123","abc"])
        assert_equal("hello\nwor123\nabcdbye\n",@target.text)


      end

      def test_notification
        @target.add_observer(self)
        @update_called=false
        @target.insert(BufferRegion.new(1,3,2,3),["123","abc"])
        assert( @update_called)


      end
      
      def test_move_chars_back_1

        pos=BufferPosition.new(1,4)
        
        actual=@target.move_cursor(pos,-1)
        assert_position(1,3,actual)
        
      end
      def test_move_chars_forward_1
        pos=BufferPosition.new(1,4)
        actual=@target.move_cursor(pos,1)
        assert_position(1,5,actual)
        
      end

      def test_undo_insert
        
        @target.insert(BufferPosition.new(1,3),["123"])
        @target.checkpoint
        @target.undo()
        assert_equal("hello\nworld\ngoodbye\n",@target.text)
      end
      def test_undo_insert_rows
        @target.insert(BufferPosition.new(1,3),["123","abc"])
        m=@target.checkpoint
        @target.undo()

        assert_equal("hello\nworld\ngoodbye\n",@target.text)

        
      end
      def test_undo_delete
        @target.delete(BufferRegion.new( 1,1,1,3))
        m=@target.checkpoint
        @target.undo()

        assert_equal("hello\nworld\ngoodbye\n",@target.text)


      end
      def test_undo_delete_rows
        @target.delete(BufferRegion.new(1,3,2,3))
        m=@target.checkpoint
        @target.undo()

        assert_equal("hello\nworld\ngoodbye\n",@target.text)

      end
      
    end
  end
end
