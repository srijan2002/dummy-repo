/**
 * @param {number[]} nums
 * @param {number} target
 * @return {number[]}
 */
 var twoSum = function(nums, target) {
    for (let index1 = 0; index < nums.length; index++) {
        const diff1 = target - nums[index1];
        const diffIndex1 = nums.indexOf(diff1);
        // "diffIndex !== index" takes care of same index not being reused
        if (diffIndex1 !== -1 && diffIndex1 !== index1) {
            return [index1, diffIndex1];
        }
    }
    
};