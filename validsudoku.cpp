class Solution
{
public:
    vector<vector<int>> insert(vector<vector<int>> &intervals, vector<int> &newInterval)
    {
        intervals.push_back(newInterval);
        sort(intervals.begin(), intervals.end());
        vector<vector<int>> ans;
        vector<int> temp = intervals[0];

        for (auto it : intervals)
        {
            if (it[0] <= temp[1])
            {
                temp[1] = max(temp[1], it[1]);
            }
            else
            {
                ans.push_back(temp);
                temp = it;
            }
        }

        ans.push_back(temp);

        return ans;
    }
};
