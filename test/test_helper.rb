require "test/unit"
require "rdesk"
class Test::Unit::TestCase
  def assert_region(s_r,s_c,e_r,e_c,actual)
    assert_not_nil(actual)
    assert_equal(s_r,actual.start_pos.row)
    assert_equal(s_c,actual.start_pos.column)
    assert_equal(e_r,actual.end_pos.row)
    assert_equal(e_c,actual.end_pos.column)
    
  end

  def assert_position(r,c,actual)
    assert_not_nil(actual)
    assert_equal(r,actual.row)
    assert_equal(c,actual.column)
    
  end

end
