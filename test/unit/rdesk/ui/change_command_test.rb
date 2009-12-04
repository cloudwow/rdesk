require "test/test_helper.rb"


module Rdesk
  module Ui
    class ChangeCommandTest < Test::Unit::TestCase
      def test_1
        x=1
        @target=ChangeCommand.new(self)
        @target.when_do{x=2}
        @target.when_undo{x=3}
        assert_equal(1,x)
        @target.execute
        assert_equal(2,x)
        @target.undo
        assert_equal(3,x)
        @target.execute
        assert_equal(2,x)
        
        
      end
      def test_child
        x=1
        @target=ChangeCommand.new(self)
        @target.when_do{x=2}
        @target.when_undo{x=3}
        
        y=1
        @target_2=ChangeCommand.new(self,[@target])
        @target_2.when_do{y=2}
        @target_2.when_undo{y=3}
        assert_equal(1,x)
        assert_equal(1,y)
        @target_2.execute
        assert_equal(2,x)
        assert_equal(2,y)
        @target_2.undo
        assert_equal(3,x)
        assert_equal(3,y)
        @target_2.execute
        assert_equal(2,x)
        assert_equal(2,y)

        
        
      end
    end
  end
end
