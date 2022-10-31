class MedianFinder {
public:
    priority_queue<int> smaller;
    priority_queue<int,vector<int>,greater<int>> bigger;
    
    MedianFinder() {    
    }
    
    void addNum(int num) {
        if(bigger.size()!=0)
        {
            if(bigger.top()<=num)
                bigger.push(num);
            else
                smaller.push(num);
            
            if(bigger.size()>smaller.size()+1)
            {
                int buff=bigger.top();
                bigger.pop();
                smaller.push(buff);
            }
            if(smaller.size()>bigger.size()+1)
            {
                int buff=smaller.top();
                smaller.pop();
                bigger.push(buff);
            }
        }
        else
        {
            bigger.push(num);
        }
    }
    
    
    double findMedian() {
        if(bigger.size()==0&&smaller.size()==0)
        {
            return 0;
        }
        
        if(bigger.size()==smaller.size())
        {
            double l=bigger.top()+smaller.top();
            l=l/2;
            return l;
        }
        
        if(bigger.size()>smaller.size())
            return bigger.top();
        else
            return smaller.top();
        
    }
};

/**
 * Your MedianFinder object will be instantiated and called as such:
 * MedianFinder* obj = new MedianFinder();
 * obj->addNum(num);
 * double param_2 = obj->findMedian();
 */
