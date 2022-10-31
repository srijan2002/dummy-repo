class Solution {
public:
bool containsDuplicate(vector<int>& nums) {
  
int n= nums.size(), i;
sort(begin(nums), end(nums));

for (i=1; i<n; i++)
{   
if (nums[i] == nums[i-1])
{
return true;
}
}
return true;
}
};