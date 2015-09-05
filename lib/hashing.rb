class Array
  def hash1 #byebug uses Array#hash, that's why this is called #hash1
    hash = ""
    self.each_with_index do |ele, idx|
      if ele.is_a?(Array)
        hash += (ele.hash.to_s + idx.to_s)
      else
        hash += (ele.ord + idx).to_s
      end
    end
    hash.to_i
  end
end

class String
  def hash
    self.split("").map(&:ord).hash1
  end
end

class Hash
  SECRET_HASH_KEYS = [873757473,1973234324]

  def hash
    xor_hash = 0

    each do |k, v|
      key_hash = (k.class.to_s.hash ^ k.to_s.hash) ^ SECRET_HASH_KEYS[0]
      val_hash = (v.class.to_s.hash ^ v.to_s.hash) ^ SECRET_HASH_KEYS[1]

      xor_hash ^= key_hash ^ val_hash
    end

    xor_hash
  end
end
