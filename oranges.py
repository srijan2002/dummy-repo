class Solution(object):
    def orangesRotting(self, grid):
        """
        :type grid: List[List[int]]
        :rtype: int
        """
        minutes = -1
        queue = []
        
        all_empty = True
        for i in range(len(grid)):
            for j in range(len(grid[0])):
                if grid[i][j] == 2:
                    queue.append((i, j))
                    all_empty = False
                elif grid[i][j] == 1:
                    all_empty = False
                    
                    
        if all_empty:
            return 0
        
        while queue:            
            minutes += 1
            
            size = len(queue)           
            for _ in range(size):
                rotten = queue.pop(0)
                
                i = rotten[0]
                j = rotten[1]
                
                grid[i][j] = 2
                
                if i - 1 >= 0:
                    left = (i - 1, j)                    
                    if grid[left[0]][left[1]] == 1 and left not in queue:
                        queue.append(left)
                    
                if i + 1 <= len(grid) - 1:
                    right = (i + 1, j)
                    if grid[right[0]][right[1]] == 1 and right not in queue:
                        queue.append(right)
                        
                if j - 1 >= 0:
                    up = (i, j - 1)
                    if grid[up[0]][up[1]] == 1 and up not in queue:
                        queue.append(up)
                
                if j + 1 <= len(grid[0]) - 1:
                    down = (i, j + 1)
                    if grid[down[0]][down[1]] == 1 and down not in queue:
                        queue.append(down)                
        


        for i in range(len(grid)):
            for j in range(len(grid[0])):
                if grid[i][j] == 1:
                    print (i, j)
                    
                    return -1
                                    
        
        return minutes
        