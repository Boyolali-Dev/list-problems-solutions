# @param {Integer[]} nums
# @return {Boolean}
def contains_duplicate(nums)
  seen = {}
  nums.each do |num|
    return true if seen[num]
    seen[num] = true
  end
  false
end
