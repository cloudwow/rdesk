require "test/test_helper.rb"

module Rdesk
  module Stage
    class ViewportTest < Test::Unit::TestCase
      def setup
        @target=KeyMapNode.new(nil,"123",Command.new("hello"){puts "hello"})

        assert_equal(1,@target.children.length)
        @child=@target.children[0]
        assert_equal(1,@child.children.length)
        @grand_child=@child.children[0]
        assert_equal(0,@grand_child.children.length)

        assert_equal(KeyMapNode.arrayify("1"),@target.key_sequence)
        assert_equal(KeyMapNode.arrayify("12"),@child.key_sequence)
        assert_equal(KeyMapNode.arrayify("123"),@grand_child.key_sequence)

        result=@target.find("123")
        assert_equal(@grand_child.to_s,result.to_s)

        #should get an array
        result=@target.find("12")

        assert("1 2 ",result.to_s)
        assert_equal(@grand_child,result.get_descendant_command_nodes()[0])
        
        #should get an array
        result=@target.find("1")
        assert("1 ",result.to_s)


        assert_equal(@grand_child,result.get_descendant_command_nodes[0])

      end
      def test_1_deep
        x=KeyMapNode.new(nil,[1],Command.new("hello"){puts "hello"})
      end
      def test_2_deep
        x=KeyMapNode.new(nil,[1,2],Command.new("hello"){puts "hello"})
        assert_equal(1,x.children.length)
        assert_equal(0,x.children[0].children.length)

        assert_equal([1],x.key_sequence)
        assert_equal([1,2],x.children[0].key_sequence)

      end
      def test_insert
        @target.insert("11","duh"){|o|puts "123"}
        result=@target.find("11")

        assert_equal("[1 1] duh",result.to_s)
        
        @target.insert("124","dee"){|o|puts "123"}
        result=@target.find(["1"[0],"2"[0],"4"[0]])

        assert_equal("[1 2 4] dee",result.to_s)
        

      end
      def test_match_multiple

        @target.insert("124","duh"){|o|puts "123"}

        result=@target.find("12")


        assert_equal(2,result.get_descendant_command_nodes().length)
        assert_equal("[1 2 3] hello",result.get_descendant_command_nodes()[0].to_s)
        assert_equal("[1 2 4] duh",result.get_descendant_command_nodes()[1].to_s)
        

      end
    end
  end
end

