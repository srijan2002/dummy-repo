/*
U.ANANDHAKUMAR
EC21B1087
ARMSTRONG NUMBER
*/
#include<stdio.h>
#include<math.h>
int main()
{
	int num,temp,x,c=0,sum=0;
	printf("enter the number : ");
	scanf("%d",&num);
	if(num>0)// valid input
		{
		temp=num;
		while(temp!=0)// counting total number of digits
			{
			temp=temp/10;
			 c+=1;
			}
		temp=num;//reseting the temp value
		while(temp!=0)//removing digits from right to left and raising them to corresponding exponent(totla number of digits)
			{
			 x=temp%10;
			 sum+=pow(x, c);
			 temp=temp/10;
			} 
	          if (sum==num)//if sum of digits raised to exponent is equal to num printing armstrong
			{
			printf("%d is a armstrong number\n",num);
			}
	          else // sum of digits raised to exponent is not equal to num printing not an armstrong number
	                    {
			printf("%d number is not a armstrong number\n",num);
			}
          	}
          else// invalid input
          	{
          	printf("input number should be greater than 0");  
          	} 
}
