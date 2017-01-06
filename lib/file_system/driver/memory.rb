require 'pathname'

module Semble
  module FileSystem
    module Driver
      class Memory < Interface
        def initialize
          @root = Node.new do |node|
            node.type = :directory
          end
        end

        def read(path)
          node = locate_node(path)
          node ? node.content : nil
        end

        def write(path, content)
          create_node(path, :file).content = content
          nil
        end

        def scan(pattern)
          enumerate.select { |node| File.fnmatch(pattern, node.path, File::FNM_DOTMATCH) }
        end

        def copy(source, target)
          node = locate_node(source)
          raise "Source node #{source} doesn't exist" unless node
          target_node = locate_node(target)
          raise "Target node #{target} already exists" unless target_node
          # todo recursive clone
        end

        def mkdir(path)
          create_node(path, :directory)
        end

        private
        def locate_node(path)
          normalized_path = Pathname.new(path).each_filename.to_a
          node = @root
          while node and not normalized_path.empty?
            node = node.child(normalized_path.shift)
          end
          node
        end

        def create_node(path, type)
          normalized_path = Pathname.new(path).each_filename.to_a
          pairs = normalized_path.map { |name| [name, :directory] }
          pairs[pairs.size - 1][1] = type
          cursor = @root
          pairs.each do |pair|
            name, type = pair
            if cursor.children[name]
              if cursor.children[name].type != :directory
                raise "#{cursor.child(name).path} is not a directory, can't create #{path}"
              end
            else
              cursor.children[name] = Node.new do |node|
                node.name = name
                node.parent = cursor
                node.type = type
              end
            end
            cursor = cursor.children[name]
          end
          if cursor.type != type
            raise "Node #{path} already exists with type #{cursor.type}"
          end
          cursor
        end

        def enumerate
          #todo
        end

        class Node
          attr_accessor :name
          attr_accessor :parent
          attr_accessor :type
          attr_accessor :content
          attr_accessor :children

          def initialize(&block)
            @children = {}
            block.call(self) if block_given?
          end

          def path
            nodes = []
            cursor = parent
            while cursor
              nodes.unshift(cursor)
              cursor = cursor.parent
            end
            Pathname.new('/').join(*nodes)
          end

          def child(name)
            @children[name]
          end

          def enumerate_children
            # todo
          end
        end
      end
    end
  end
end