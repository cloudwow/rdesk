require "test/test_helper.rb"

module Rdesk
  module Ui
    class BufferPositionTest < Test::Unit::TestCase

      def test_less_than
        a=BufferPosition.new(5,5)

        assert_equal(false,a<BufferPosition.new(5,5))
        assert_equal(false,a<BufferPosition.new(5,4))
        assert_equal(false,a<BufferPosition.new(5,0))
        assert_equal(false,a<BufferPosition.new(4,6))
        assert_equal(false,a<BufferPosition.new(4,5))
        assert_equal(false,a<BufferPosition.new(4,0))
        assert_equal(false,a<BufferPosition.new(0,0))
        assert_equal(false,a<BufferPosition.new(0,5))
        assert_equal(false,a<BufferPosition.new(0,10))
        

        assert(a<BufferPosition.new(5,6))
        assert(a<BufferPosition.new(6,5))
        assert(a<BufferPosition.new(6,6))
        assert(a<BufferPosition.new(6,3))
        assert(a<BufferPosition.new(6,0))
      end

      def test_greater_than
        a=BufferPosition.new(5,5)

        assert_equal(false,a>BufferPosition.new(5,5))

        assert(a>BufferPosition.new(5,4))
        assert(a>BufferPosition.new(5,0))
        assert(a>BufferPosition.new(4,6))
        assert(a>BufferPosition.new(4,5))
        assert(a>BufferPosition.new(4,0))
        assert(a>BufferPosition.new(0,0))
        assert(a>BufferPosition.new(0,5))
        assert(a>BufferPosition.new(0,10))
        

        assert_equal(false,a>BufferPosition.new(5,6))
        assert_equal(false,a>BufferPosition.new(6,5))
        assert_equal(false,a>BufferPosition.new(6,6))
        assert_equal(false,a>BufferPosition.new(6,3))
        assert_equal(false,a>BufferPosition.new(6,0))
      end

      def test_eql
        a=BufferPosition.new(5,5)

        assert(a.eql?(BufferPosition.new(5,5)))

        assert_equal(false,a.eql?(BufferPosition.new(5,6)))
        assert_equal(false,a.eql?(BufferPosition.new(5,4)))
        assert_equal(false,a.eql?(BufferPosition.new(5,0)))

        assert_equal(false,a.eql?(BufferPosition.new(6,6)))
        assert_equal(false,a.eql?(BufferPosition.new(6,5)))
        assert_equal(false,a.eql?(BufferPosition.new(6,4)))
        assert_equal(false,a.eql?(BufferPosition.new(6,0)))

        assert_equal(false,a.eql?(BufferPosition.new(4,6)))
        assert_equal(false,a.eql?(BufferPosition.new(4,5)))
        assert_equal(false,a.eql?(BufferPosition.new(4,4)))
        assert_equal(false,a.eql?(BufferPosition.new(4,0)))


        assert_equal(false,a.eql?(BufferPosition.new(0,6)))
        assert_equal(false,a.eql?(BufferPosition.new(0,5)))
        assert_equal(false,a.eql?(BufferPosition.new(0,4)))
        assert_equal(false,a.eql?(BufferPosition.new(0,0)))




      end

      def test_zero
        a=BufferPosition.new(0,0)

        assert(a.eql?(BufferPosition.new(0,0)))

        assert_equal(false,a.eql?(BufferPosition.new(0,1)))

        assert_equal(false,a.eql?(BufferPosition.new(1,0)))

      end

      def test_within_region
        region=BufferRegion.new(0,0,9,9)

        assert(BufferPosition.new(4,6).within_region?(region))
        assert(BufferPosition.new(0,0).within_region?(region))
        assert(BufferPosition.new(9,9).within_region?(region))
        assert(BufferPosition.new(0,1).within_region?(region))
        assert(BufferPosition.new(9,0).within_region?(region))
        assert(BufferPosition.new(0,10).within_region?(region))
        
        region=BufferRegion.new(3,0,4,0)

        assert(BufferPosition.new(3,0).within_region?(region))
        assert(BufferPosition.new(4,0).within_region?(region))
        assert(BufferPosition.new(3,1).within_region?(region))
        assert_equal(false,BufferPosition.new(0,5).within_region?(region))
        assert_equal(false,BufferPosition.new(2,5).within_region?(region))
        assert_equal(false,BufferPosition.new(2,0).within_region?(region))
        assert_equal(false,BufferPosition.new(0,0).within_region?(region))
        assert_equal(false,BufferPosition.new(4,1).within_region?(region))
        
        region=BufferRegion.new(3,4,3,4)

        assert(BufferPosition.new(3,4).within_region?(region))
        assert_equal(false,BufferPosition.new(3,0).within_region?(region))
        assert_equal(false,BufferPosition.new(3,3).within_region?(region))
        assert_equal(false,BufferPosition.new(3,5).within_region?(region))
        assert_equal(false,BufferPosition.new(0,5).within_region?(region))
        assert_equal(false,BufferPosition.new(2,5).within_region?(region))
        assert_equal(false,BufferPosition.new(2,0).within_region?(region))
        assert_equal(false,BufferPosition.new(0,0).within_region?(region))
        assert_equal(false,BufferPosition.new(4,1).within_region?(region))
        
        region=BufferRegion.new(3,4,3,6)

        assert(BufferPosition.new(3,5).within_region?(region))
        
      end
      
      def test_immutable_should_refuse_set
        assert_raises RuntimeError do
          BufferPosition.new(3,0).column=3
        end
        assert_raises RuntimeError do
          BufferPosition.new(3,0).row=3
        end
        assert_raises RuntimeError do
          BufferPosition.new(3,0).next_row!
        end
      end
      def test_mutable_should_allow_set
        a=BufferPosition.new(3,0)
        a.mutable!
        a.row=5
        a.column=6
        assert_position(5,6,a)
        a.next_row!
        assert_position(6,0,a)
        
      end

    end
  end
end
