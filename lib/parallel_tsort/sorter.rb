require "tsort"

module ParallelTsort
  class Sorter
    include TSort

    def initialize
      @deps = []
    end

    def add_dependency(name, deps=[])
      raise SelfDependentNode if deps.include?(name)
      @deps << [name, deps]
    end

    def run(parallel=false)
      result = tsort
      return result unless parallel

      groups = []
      used   = []
      result.each_with_index do |node, i|
        next if used.include?(node)

        parallel_nodes = result[i..-1].reject do |other_node|
          next if other_node == node
          next if used.include?(other_node)

          is_dependent? node, other_node
        end

        used.concat(parallel_nodes)
        groups << parallel_nodes
      end

      groups
    end

    private

    def is_dependent?(node, other_node)
      other_node = @deps.detect { |dep| dep.first == other_node }
      dependencies = other_node[1]

      dependencies.include?(node) || dependencies.detect { |n| is_dependent?(node, n) }
    end

    def tsort_each_node(&block)
      @deps.map(&:first).each(&block)
    end

    def tsort_each_child(node, &block)
      node = @deps.detect { |dep| dep.first == node }
      raise MissingNode if node.nil?

      node[1].each(&block)
    end
  end
end
