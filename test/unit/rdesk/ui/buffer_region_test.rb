require "test/test_helper.rb"
require 'observer'

module Rdesk
  module Ui
    class BufferRegionTest < Test::Unit::TestCase
      
      def test_new
        a=BufferRegion.new(1,2,3,4)
        assert_region(1,2,3,4,a)

        b=BufferRegion.new(BufferPosition.new(1,2),BufferPosition.new(3,4))
        assert_region(1,2,3,4,b)

        c=[1,2,3,4].shift_buffer_region
        assert_region(1,2,3,4,c)

        d=[BufferPosition.new(1,2),BufferPosition.new(3,4)].shift_buffer_region
        assert_region(1,2,3,4,d)

      end

      
      def test_within_region
        
        r1=BufferRegion.new(0,0,9,9)

        assert(BufferRegion.new(0,0,9,9).within_region?(r1))
        assert(BufferRegion.new(0,50,9,9).within_region?(r1))
        assert(BufferRegion.new(0,0,9,0).within_region?(r1))
        assert(BufferRegion.new(8,50,9,9).within_region?(r1))

        assert_equal(false,BufferRegion.new(8,50,9,10).within_region?(r1))
        assert_equal(false,BufferRegion.new(8,50,10,1).within_region?(r1))
        assert_equal(false,BufferRegion.new(8,50,10,0).within_region?(r1))

        r1=BufferRegion.new(9,0,9,9)

        assert(BufferRegion.new(9,0,9,9).within_region?(r1))
        assert(BufferRegion.new(9,5,9,9).within_region?(r1))
        assert(BufferRegion.new(9,0,9,1).within_region?(r1))
        assert(BufferRegion.new(9,1,9,1).within_region?(r1))
        assert(BufferRegion.new(9,9,9,9).within_region?(r1))
        assert(BufferRegion.new(9,0,9,0).within_region?(r1))
        assert(BufferRegion.new(9,1,9,2).within_region?(r1))

        assert_equal(false,BufferRegion.new(8,50,9,1).within_region?(r1))
        assert_equal(false,BufferRegion.new(1,1,10,5).within_region?(r1))
        assert_equal(false,BufferRegion.new(9,1,9,10).within_region?(r1))
        assert_equal(false,BufferRegion.new(9,0,9,10).within_region?(r1))
        assert_equal(false,BufferRegion.new(8,5,9,2).within_region?(r1))
        assert_equal(false,BufferRegion.new(8,0,9,0).within_region?(r1))

      end

      
      def test_immutable_should_refuse_set
        r1=BufferRegion.new(9,0,9,9)

        assert_raises RuntimeError do
          r1.start_pos=BufferPosition.new(0,0)
        end
        assert_raises RuntimeError do
          r1.end_pos=BufferPosition.new(0,0)
        end
        assert_raises RuntimeError do
          r1.end_pos.column=3
        end
        assert_raises RuntimeError do
          r1.end_pos.row=3
        end
      end

      def test_mutable_should_allow_set
        start_pos=BufferPosition.new(0,1)
        end_pos=BufferPosition.new(2,3)
        r1=BufferRegion.new(start_pos,end_pos)

        r1.mutable!
        assert_region(0,1,2,3,r1)
        r1.start_pos=BufferPosition.new(4,5)


        r1.end_pos=BufferPosition.new(6,7)

        assert_region(4,5,6,7,r1)

        r1.start_pos.row=8
        r1.start_pos.column=9
        r1.end_pos.row=10
        r1.end_pos.column=11

        assert_region(8,9,10,11,r1)

        #make sure original immutgable positions have not changed
        assert_position(0,1,start_pos)
        assert_position(2,3,end_pos)

        
      end
      
    end
  end
end

