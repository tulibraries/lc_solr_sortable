require "lc_solr_sortable/version"

module LcSolrSortable
  @@alphabet ||= ("a".."z").to_a

  def self.convert(call_number)
    _process(call_number.gsub(/(\d)\.(\d)/, '\1!\2').split("."))
  end

  def self._process(data, result = "", decimal_sort=true)

    if data.is_a? Array
      first = _process(data.shift, "", false)
      return data.map { |segment| _process(segment) }.unshift(first).join("")
    end

    # add interstitial 'Z's and normalize length
    if data && data.downcase.match(/(^[[:alpha:]]+)(.*)/)
      remainder = $2
      alphas = $1.gsub(/([[:alpha:]]{1})/, 'Z\1').ljust(10, "a")
      return _process(remainder, "#{result}#{alphas}", decimal_sort)
    end

    # pad left to normalize fractions, then right to normalize length
    if data && data.match(/^(\d+(!\d+)?)(.*)/)
      num, remainder, zeros = $1, $3, 5
      zeros -= num.include?("!") ? num.length - num.index("!") - 1 : 0
      num.sub!("!", "")
      zeros.times { num.concat("0") }
      raise "call no processing error" unless num.match(/^\d+$/)
      num = num.each_char.to_a.map { |c| @@alphabet[c.to_i] }.join("")
      return _process(remainder, "#{result}#{num.ljust(10, 'a')}", decimal_sort) if decimal_sort
      return _process(remainder, "#{result}#{num.rjust(10, 'a')}", decimal_sort) unless decimal_sort
    end

    return result
  end

end
