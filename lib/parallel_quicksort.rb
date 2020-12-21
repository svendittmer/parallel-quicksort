# frozen_string_literal: true

require "parallel_quicksort/version"

module ParallelQuicksort
  RACTOR_COUNT = 4
  class Error < StandardError; end

  def parallel_sort(enumerable)
    enumerable = enumerable.to_a

    return enumerable if enumerable.length <= 1
    
    length = enumerable.length
    slice_size = length / RACTOR_COUNT + 1
    pivot = enumerable.first

    ractors = Array.new(RACTOR_COUNT) do |index|
      slice_start = index * slice_size + 1
      slice = enumerable[slice_start, slice_size]

      unless slice.nil? || slice.empty?
        Ractor.new(pivot, slice) do |pivot, slice|
          if slice.nil? || slice.empty?
            []
          else
            partitioned = slice.partition { |element| element <= pivot }
            # p partitioned
            Ractor.yield partitioned
          end
        end
      else
        nil
      end
    end

    partitioned = ractors.compact.map(&:take)

    parallel_sort(partitioned.flat_map { |a| a.fetch(0, []) }) + [pivot] + parallel_sort(partitioned.flat_map { |a| a.fetch(1, []) })
  end
end
