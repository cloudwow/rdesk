require "rdesk/ui/buffer_position.rb"
require "rdesk/ui/buffer_region.rb"
class Array
  
  def shift_buffer_position
    return nil if self.empty? 
    if first.is_a? Rdesk::Ui::BufferPosition
      return self.shift
    else
      raise "not enough elements to create buffer position" if self.length < 2
      return Rdesk::Ui::BufferPosition.new(self.shift,self.shift)
    end
  end

  def shift_buffer_region
    return nil if self.empty?  || self.first==nil
    if first.is_a? Rdesk::Ui::BufferRegion
      return self.shift
    else
      return Rdesk::Ui::BufferRegion.new(shift_buffer_position,shift_buffer_position)
    end
  end
  
end
