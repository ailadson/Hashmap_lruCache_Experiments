class Link
  attr_accessor :key, :val, :next, :prev, :tail

  def initialize(key = nil, val = nil, nxt = nil, prev = nil)
    @key, @val, @next, @prev = key, val, nxt, prev
  end

  def to_s
    "#{@key}, #{@val}"
  end
end

class LinkedList
  include Enumerable

  attr_reader :head

  def initialize
    @head = Link.new
    @tail = nil
  end

  def [](i)
    each_with_index { |link, j| return link if i == j }
    nil
  end

  def first
    @head.next
  end

  def last
    last_link = @head.next
    last_link = last_link.next while last_link.next
    last_link
  end

  def empty?
    @head.next.nil?
  end

  def get(key)
    found_link = @head
    until found_link.nil? || found_link.key == key
      found_link = found_link.next
    end

    found_link.val if found_link
  end

  # Remove guard statement
  def include?(key)
    found_link = @head
    found_link = found_link.next until found_link.nil? || found_link.key == key
    !!found_link
  end

  # Remove guard statement
  def insert(key, val)
    last_link = @head
    last_link = last_link.next until last_link.next.nil?
    last_link.next = Link.new(key, val, nil, last_link)
  end

  # Remove guard statement
  def remove(key)
    parent_link = @head
    parent_link = parent_link.next until parent_link.nil? || parent_link.next.key == key
    return nil unless parent_link
    new_child = parent_link.next.next
    parent_link.next = new_child
    new_child.prev = parent_link
  end

  def each
    current_link = @head.next

    while current_link
      yield(current_link)
      current_link = current_link.next
    end
  end

  # uncomment when you have `each` working and `Enumerable` included
  def to_s
    inject([]) { |acc, link| acc << "[#{link.key}, #{link.val}]" }.join(", ")
  end
end
