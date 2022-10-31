#include <bits/stdc++.h>
using namespace std;

// Structure to define a triplet.
struct triplet
{
	int first, second, third;
};

// Function to find unique triplets that
// sum up to a given value.
int findTriplets(int nums[], int n, int sum)
{
	int i, j, k;

	// Vector to store all unique triplets.
	vector<triplet> triplets;

	// Set to store already found triplets
	// to avoid duplication.
	unordered_set<string> uniqTriplets;

	// Variable used to hold triplet
	// converted to string form.
	string temp;

	// Variable used to store current
	// triplet which is stored in vector
	// if it is unique.
	triplet newTriplet;

	// Sort the input array.
	sort(nums, nums + n);

	// Iterate over the array from the
	// start and consider it as the
	// first element.
	for (i = 0; i < n - 2; i++)
	{
		// index of the first element in
		// the remaining elements.
		j = i + 1;

		// index of the last element.
		k = n - 1;

		while (j < k) {

			// If sum of triplet is equal to
			// given value, then check if
			// this triplet is unique or not.
			// To check uniqueness, convert
			// triplet to string form and
			// then check if this string is
			// present in set or not. If
			// triplet is unique, then store
			// it in vector.
			if (nums[i] + nums[j] + nums[k] == sum)
			{
				temp = to_string(nums[i]) + " : "
					+ to_string(nums[j]) + " : "
					+ to_string(nums[k]);
				if (uniqTriplets.find(temp)
					== uniqTriplets.end()) {
					uniqTriplets.insert(temp);
					newTriplet.first = nums[i];
					newTriplet.second = nums[j];
					newTriplet.third = nums[k];
					triplets.push_back(newTriplet);
				}

				// Increment the first index
				// and decrement the last
				// index of remaining elements.
				j++;
				k--;
			}

			// If sum is greater than given
			// value then to reduce sum
			// decrement the last index.
			else if (nums[i] + nums[j] + nums[k] > sum)
				k--;

			// If sum is less than given value
			// then to increase sum increment
			// the first index of remaining
			// elements.
			else
				j++;
		}
	}

	// If no unique triplet is found, then
	// return 0.
	if (triplets.size() == 0)
		return 0;

	// Print all unique triplets stored in
	// vector.
	for (i = 0; i < triplets.size(); i++) {
		cout << "[" << triplets[i].first << ", "
			<< triplets[i].second << ", "
			<< triplets[i].third << "], ";
	}
}

// Driver Code
int main()
{
	int nums[] = { 12, 3, 6, 1, 6, 9 };
	int n = sizeof(nums) / sizeof(nums[0]);
	int sum = 24;

	// Function call
	if (!findTriplets(nums, n, sum))
		cout << "No triplets can be formed.";

	return 0;
}