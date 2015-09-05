class MaxIntSet
  def initialize(max)
    @store = Array.new(max, false)
    @max = max
  end

  def insert(num)
    validate!(num)
    store[num] = true
  end

  def remove(num)
    validate!(num)
    store[num] = false
  end

  def include?(num)
    validate!(num)
    store[num]
  end

  private
  attr_reader :store, :max

  def is_valid?(num)
    num.between?(0, max)
  end

  def validate!(num)
    raise "Out of bounds" unless is_valid?(num)
  end
end


class IntSet
  def initialize(num_buckets = 20)
    @num_buckets = num_buckets
    @store = Array.new(num_buckets) { Array.new }
  end

  def insert(num)
    @store[idx(num)] << num
  end

  def remove(num)
    arr = @store[idx(num)]
    arr.delete_at(arr.index(num))
  end

  def include?(num)
    @store[idx(num)].include?(num)
  end

  private
  attr_reader :size, :num_buckets
  def [](num)
    # optional but useful; return the bucket corresponding to `num`
  end

  def idx(num)
    num % num_buckets
  end

  # def num_buckets
  #   @store.length
  # end
end

class ResizingIntSet
  attr_reader :count

  def initialize(num_buckets = 20)
    @store = Array.new(num_buckets) { Array.new }
    @count = 0
  end

  def insert(num)
    resize! if count == num_buckets

    self.count = count + 1

    self[num] << num
  end

  def remove(num)
    self.count = count - 1
    idx = self[num].index(num)
    self[num].delete_at(idx)
  end

  def include?(num)
    self[num % num_buckets].include?(num)
  end

  private
  attr_writer :count
  attr_accessor :store

  def [](num)
    # optional but useful; return the bucket corresponding to `num`
    @store[num % num_buckets]
  end

  def num_buckets
    @store.length
  end

  def resize!
    old_store = store
    self.store = Array.new(num_buckets * 2) { [] }
    self.count = 0
    old_store.each do |bucket|
      bucket.each do |data|
        self.insert(data)
      end
    end
  end
end
