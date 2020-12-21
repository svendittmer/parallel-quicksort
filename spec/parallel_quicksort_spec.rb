# frozen_string_literal: true

RSpec.describe ParallelQuicksort do
  include described_class

  it "has a version number" do
    expect(ParallelQuicksort::VERSION).not_to be nil
  end

  context "when given an empty enumerable" do
    specify { expect(parallel_sort([])).to eq([]) }
    specify { expect(parallel_sort(0...0)).to eq([]) }
  end

  context "when given an enumerable with only 1 element" do
    specify { expect(parallel_sort([0])).to eq([0]) }
    specify { expect(parallel_sort(0...1)).to eq([0]) }
  end

  it "sorts an enumerable" do
    expect(parallel_sort([2, 1])).to eq([1, 2])
  end

  it "sorts an enumerable" do
    sorted = (1..7).to_a
    expect(parallel_sort(sorted.shuffle)).to eq(sorted)
  end

  it "sorts a pre-sorted enumerable" do
    sorted = 1..100
    expect(parallel_sort(sorted)).to eq(sorted.to_a)
  end

  it "sorts a reverse-sorted enumerable" do
    enum = 100.downto(1)
    expect(parallel_sort(enum)).to eq(enum.sort)
  end
end
