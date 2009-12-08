module Rdesk
  module Stage
    class KeyMapNode
      attr_reader :key_sequence
      attr_reader :command
      attr_reader :children
      attr_reader :parent

      
      def initialize(parent=nil,key_sequence=nil,command=nil)
        @key_descriptions={
          27 => "ESC"
        }
        @children=[]
        key_sequence=KeyMapNode.arrayify(key_sequence)
        if parent==nil and (key_sequence==nil || key_sequence.length==0)
          #this is a root node
          @key_sequence=[]
          return
          
        end
        if parent
          @parent=parent
          

        end
        parent_sequence=parent.key_sequence if parent
        parent_sequence ||=[]
        @key_sequence=key_sequence[0..parent_sequence.length]

        if @key_sequence.length==key_sequence.length
          @command=command
        else
          insert(key_sequence,command)
        end

        
      end

      #1 string
      #2 array of strings (should be one char each)
      #3 array of ascii char codes
      #return array of ascii char codes
      def self.arrayify(sequence)
        return nil if sequence==nil
        result=[]
        if sequence.is_a? Array
          sequence.each do |k|
            if k.is_a? String
              result << k[0]
            else
              result << k
            end
          end
        else
          #string
          sequence.each_char{|c|result << c[0]}
        end
        result
      end
      def insert(key_sequence,command_or_name=nil,&block)
        key_sequence=KeyMapNode.arrayify(key_sequence)
        command=command_or_name if command_or_name.is_a? Command
        
        if command==nil && command_or_name && command_or_name.is_a?(String)
          
          if block_given?
            command=Command.new(command_or_name,nil,&block)
          end
        end
        raise "no command to insert" unless command
        if key_sequence==@key_sequence
          @command=command
        else
          
          @children.each do | child |

            if child.key_sequence==key_sequence[0..child.key_sequence.length-1]

              child.insert(key_sequence,command)
              return;
            end
          end
          child=KeyMapNode.new(self,key_sequence,command)
          @children << child
        end
      end
      #return command if there is an exact match to a command node
      #return array of KeyMapNodes if there are command nodes that
      #might match.
      #otherwise return nil
      def find(key_sequence)
        key_sequence=KeyMapNode.arrayify(key_sequence)
        return nil if key_sequence.length < @key_sequence.length
        if key_sequence.length > @key_sequence.length

          if self.key_sequence[0..@key_sequence.length-1]==@key_sequence
            @children.each do | child|
              result =child.find(key_sequence)
              return result if result
            end
          end
          
        elsif @key_sequence==key_sequence

          
          return self
        end
        
        return nil
      end

      def get_descendant_command_nodes
        return [self] if @command
        result=[]
        @children.each{|c|result.concat(c.get_descendant_command_nodes)}
        result
      end
      def handle(next_key)
        
      end

      def list
      end

      def to_s
        result="["

        result << key_sequence.map{|k| @key_descriptions[k] ||(  k<255 ?  k.chr : k.to_s)}.join(" ")
        result << "]"

        result<< " " << @command.name if @command and @command.name
        result
      end

      def dump(indent=0)
        result="  "*indent + to_s
        @children.each{|c| result<< "\n"+ c.dump(indent+1)}
        result
      end
    end
  end
end
