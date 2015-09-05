require_relative 'hashing'
require_relative 'linked_list'

class HashMap
  include Enumerable

  attr_reader :count, :store

  def initialize(num_buckets = 8)
    @store = Array.new(num_buckets) { LinkedList.new }
    @count = 0
  end

  def include?(key)
    @store[key.hash % num_buckets].include?(key)
  end

  def set(key, val)
    # p @store
    # p @store[key.hash % num_buckets]
    if count >= num_buckets
      resize!
    end

    @count += 1
    @store[key.hash % num_buckets].insert(key, val)
    # p @store[key.hash % num_buckets]
  end

  def get(key)
    @store[key.hash % num_buckets].get(key)
  end

  def delete(key)
    @count -= 1
    @store[key.hash % num_buckets].remove(key)
  end

  def each
    @store.each do |link_list|
      link_list.each { |link| yield(link.key, link.val) }
    end
  end

  # uncomment when you have Enumerable included
  def to_s
    pairs = inject([]) do |strs, (k, v)|
      strs << "#{k.to_s} => #{v.to_s}"
    end
    "{\n" + pairs.join(",\n") + "\n}"
  end

  alias_method :[], :get
  alias_method :[]=, :set

  # def inspect
  #   @store.each do |link_list|
  #     link_list.each do |link|
  #
  #     end
  #   end
  # end

  private

  def num_buckets
    @store.length
  end

  def resize!
    old_store = @store
    @store = Array.new(num_buckets * 2) { LinkedList.new }
    @count = 0

    old_store.each do |link_list|
      # p link_list
      link_list.each do |link|
        set(link.key, link.val)
      end
    end
  end

  def bucket(key)
    # optional but useful; return the bucket corresponding to `key`
  end
end
