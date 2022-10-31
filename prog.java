import java.io.*;
import java.util.*;

public class GFG {

	// Stores the pair of indices
	static class Pair {

		int index1;
		int index2;

		// Constructor
		Pair(int x, int y)
		{
			index1 = x;
			index2 = y;
		}
	}

	// Function to find the all the
	// unique quadruplets with the
	// elements at different indices
	public static void
	GetQuadruplets(ArrayList<Integer> nums,
				int target)
	{

		// Stores the sum mapped to
		// a List Of Pair<i, j>
		HashMap<Integer, ArrayList<Pair> > map
			= new HashMap<>();

		// Generate all possible pairs
		// for the HashMap
		for (int i = 0;
			i < nums.size() - 1; i++) {

			for (int j = i + 1;
				j < nums.size(); j++) {

				// Find the sum of pairs
				// of elements
				int sum = nums.get(i)
						+ nums.get(j);

				// If the sum doesn't
				// exists then update
				// with the new pairs
				if (!map.containsKey(sum)) {

					ArrayList<Pair> temp
						= new ArrayList<>();
					Pair p = new Pair(i, j);
					temp.add(p);

					// Update the hashmap
					map.put(sum, temp);
				}

				// Otherwise, push the new
				// pair of indices to the
				// current sum
				else {

					ArrayList<Pair> temp
						= map.get(sum);

					Pair p = new Pair(i, j);
					temp.add(p);

					// Update the hashmap
					map.put(sum, temp);
				}
			}
		}

		// Stores all the Quadruplets
		HashSet<ArrayList<Integer> > ans
			= new HashSet<ArrayList<Integer> >();

		for (int i = 0;
			i < nums.size() - 1; i++) {

			for (int j = i + 1;
				j < nums.size(); j++) {

				int lookUp = target
							- (nums.get(i)
								+ nums.get(j));

				// If the sum with value
				// (K - sum) exists
				if (map.containsKey(lookUp)) {

					// Get the pair of
					// indices of sum
					ArrayList<Pair> temp
						= map.get(lookUp);

					for (Pair pair : temp) {

						// Check if i, j, k
						// and l are distinct
						// or not
						if (pair.index1 != i
							&& pair.index1 != j
							&& pair.index2 != i
							&& pair.index2 != j) {

							ArrayList<Integer> values
								= new ArrayList<>();
							values.add(
								nums.get(pair.index1));
							values.add(
								nums.get(pair.index2));
							values.add(nums.get(i));
							values.add(nums.get(j));

							// Sort the list to
							// avoid duplicacy
							Collections.sort(values);

							// Update the hashset
							ans.add(values);
						}
					}
				}
			}
		}