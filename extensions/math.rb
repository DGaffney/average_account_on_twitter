module Math
  def self.rand_n(n, max)
    randoms = Set.new
    i = 1
    loop do
    	randoms << rand(max)
    	break if randoms.size >= n
    	i += 1
    end
    return randoms.to_a
  end
end
