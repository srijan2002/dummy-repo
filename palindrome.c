/*
U.ANANDHAKUMAR
EC21B1087
PALINDROME
*/
#include<stdio.h>
#include<ctype.h>
int main()
{
          int n,i,j,flag=0;
          printf("enter the string size:");
          scanf("%d",&n);
	if(n>0 && n<=50)
	{
		char a[n];
		 printf("enter the string:");
		 scanf("%s",a);// getting the input
		 for(i=0 ; i<n ; i++)
		 {
			 if (a[i]==0 || a[i]==1 || a[i]==2 || a[i]==3 || a[i]==4 || a[i]==5 || a[i]==6 || a[i]==7 || a[i]==8 || a[i]==9)
			    {
			  	flag=3;
			  	break;
			   }
			 else
			   {
			    if (a[i]!=a[n-i-1])// Comparing the 1st and 1st last term, 2nd and 2nd last term and so on are not equal giving flag value as 1
			  	 {
			  	   flag=1;
			  	 }
			    }
		 }
		 if(flag==0)// printing palindrome
		 {
		 	printf("%s  string is palindrome",a);
		 }
		 else if(flag==3)// printing palindrome
		 {
		 	printf("%s  string is invalid input",a);
		 	
		 }
		 else// printing not palindrome
		 {
		 	printf("%s string is not palindrome",a);
		 }
	}
	else
	{
		  printf("Invalid input");
	}	 
}

