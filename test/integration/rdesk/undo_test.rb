require "test/test_helper.rb"
require 'observer'


module Rdesk

  class UndoTest < Test::Unit::TestCase
    def setup
      @window=Rdesk::Ui::Window.new
      @viewport=Rdesk::Ui::Viewport.new(Rdesk::Ui::Buffer.new())
      @window.show(@viewport)
      
      @window.add_observer(self)
      @window.viewport.height=30


    end


    def update(src,update_type=:invalidate,more=nil)
      case update_type
      when :invalidate


        @valid=false
      when :content_change
        @content_change=true
        @valid=false
      end
      
    end


    def test_2_deep
      @viewport.insert("hello")
      assert_equal("hello",@viewport.text)
      @viewport.buffer.checkpoint
      @viewport.insert(" world")

      assert_equal("hello world",@viewport.text)
      @viewport.buffer.checkpoint
      @viewport.buffer.undo
      assert_equal("hello",@viewport.text)
      @viewport.buffer.undo
      assert_equal("",@viewport.text)

    end
    def test_1_deep
      @viewport.insert("123")
       @viewport.buffer.checkpoint
      @viewport.buffer.undo
      assert_equal("",@viewport.text)

    end
    
    def test_2_deep_rows
      @viewport.insert("hello\n0123456\nwassup")

      @viewport.buffer.checkpoint
      
      @viewport.insert("?")
      @viewport.buffer.checkpoint
      @viewport.set_cursor(1,3)
      @viewport.insert("bingo\ndog")
      @viewport.buffer.checkpoint
      @viewport.set_cursor(0,0)
      @viewport.delete_row
      @viewport.buffer.checkpoint
      assert_equal( "012bingo\ndog3456\nwassup?" , @viewport.text)
      @viewport.buffer.undo
      assert_equal( "hello\n012bingo\ndog3456\nwassup?" , @viewport.text)
      @viewport.buffer.undo

      assert_equal( "hello\n0123456\nwassup?" , @viewport.text)
      @viewport.buffer.undo
      assert_equal( "hello\n0123456\nwassup" , @viewport.text)

      @viewport.buffer.redo
      assert_equal( "hello\n0123456\nwassup?" , @viewport.text)
      @viewport.buffer.redo
      assert_equal( "hello\n012bingo\ndog3456\nwassup?" , @viewport.text)
      @viewport.buffer.redo
      
      assert_equal( "012bingo\ndog3456\nwassup?" , @viewport.text)
      
    end

  end

end


