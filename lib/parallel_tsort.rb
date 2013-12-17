require "parallel_tsort/version"
require "parallel_tsort/sorter"

module ParallelTsort
  class MissingNode < StandardError ; end
  class SelfDependentNode < StandardError ; end
end
