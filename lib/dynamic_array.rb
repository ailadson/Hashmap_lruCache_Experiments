class StaticArray
  attr_reader :length

  def initialize(capacity)
    @store = Array.new(capacity)
    @length = capacity
  end

  def [](i)
    validate!(i)
    @store[i]
  end

  def []=(i, val)
    validate!(i)
    @store[i] = val
  end

  private

  def validate!(i)
    raise "Overflow error" unless i.between?(0, @store.length - 1)
  end
end

class DynamicArray
  include Enumerable
  attr_reader :count

  def initialize(capacity = 8)
    @store = StaticArray.new(capacity)
    @count = 0
    @start_idx = 0
  end

  def [](i)
    return nil if i.abs > count
    return @store[0] if i.abs == -count
    i = count - i.abs if i < 0
    @store[i]
  end

  def []=(i, val)
    return nil if i.abs > count
    i = count - i.abs if i < 0
    @store[i] = val
  end

  def capacity
    @store.length
  end

  def include?(val)
    any?{ |v| v == val }
  end

  def push(val)
    resize! if @count == capacity
    self[@count] = val
    @count += 1
  end

  def unshift(val)
    count.downto(1) do |i|
      @store[i] = @store[i-1]
    end
    @store[0] = val
  end

  def pop
    return nil if @count.zero?
    @count -= 1
    val = @store[@count]
    @store[@count] = nil
    val
  end

  def shift
    return nil if @count.zero?
    val = @store[0]
    1.upto(@count){ |i| @store[i-1] = @store[i] }
    @count -=1
    val
  end

  def first
    @store[0]
  end

  def last
    @store[@count-1]
  end

  def each
    @count.times { |i| yield(@store[i]) }
  end

  def to_s
    "[" + inject([]) { |acc, el| acc << el }.join(", ") + "]"
  end

  def ==(other)
    return false unless [Array, DynamicArray].include?(other.class)
    # ...
    count.times{ |i| return false unless @store[i] == other[i] }
    true
  end

  alias_method :<<, :push
  [:length, :size].each { |method| alias_method method, :count }

  private
  def resize!
    c, @count = @count, 0
    old_store, @store = @store, StaticArray.new(capacity * 2)
    c.times do |i|
      push(old_store[i])
    end
  end
end
