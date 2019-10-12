module NumberUtils

  def self.numeric?(value)
    return true if value =~ /\A\d+\Z/
    true if Float(value) rescue false
  end

end