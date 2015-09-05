require_relative 'hash_map'
require_relative 'linked_list'

class LRUCache
  attr_reader :count
  def initialize(max, prc)
    @map = HashMap.new
    @store = LinkedList.new
    @max = max
    @prc = prc
  end

  def count
    @map.count
  end

  def get(key)
    if @map.include?(key)
      link = @map[key]
      update_link!(link)
      link.val
    else
      calc!(key)
    end
  end

  def to_s
    "Map: " + @map.to_s + "\n" + "Store: " + @store.to_s
  end

  private
  def calc!(key)
      val = @prc.call(key)
      link = @store.insert(key, val)
      @map[key] = link
      val
  end

  def update_link!(link)
    next_link, prev_link = link.next, link.prev
    prev_link.next = next_link if prev_link
    next_link.prev = prev_link if next_link
    link.prev = @store.last
    @store.last.next = link
    link.next = nil
  end

  def eject!
    @store.first
  end
end
