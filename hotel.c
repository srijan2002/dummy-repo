/*
U.ANANDHAKUMAR
EC21B1087
HOTEL BILL
*/
#include<stdio.h>
#include<string.h>

struct menu
{
    int nos;
    char item[20];
    float price;
};
struct bill
{
 char item[20];
 float price;
 int qty;
};
set_item( struct menu menu[n] )
{
      int y=0;
      printf("enter the item_name: ");
      scanf("%s",s);
      for(int j=0 ; j<i ; j++)
          {
              if (strcmp(menu[j].item,s)==0)
              {
		printf("item already exist.Enter a new item\n\n");
		y=1;
		set_item( &menu[n] );
              }
          }
      if (y==0)
	{
		strcpy(menu[j].item,s);
	}
      return menu	
}
Bill(menu[n])
{
	int qty;
	int n;
	printf("enter the number of unique items excluding quantity: ");
	scanf("%d",&n);
	while(n>0)
	{
		printf("enter the item name: ");
		
		n=n-1;
	}
}
int main()
{
	 int n,ch=-1;
	 printf("Welcome To Our Hotel");
	 printf("1. Set Item and Price\n2. Reset Price\n3. Bill\n4. Display Items and Price\n5. Exit\n");
	 while(ch<0)
		{
			printf("Enter your choice: ");
			if(ch==1)
				{
					printf("enter the number of items: ");
					while(n<0)
					{
						scanf("%d",&n);
						if(n>0)
						{
							struct menu menu[n];
							set_item(&menu[n]);
						}
					}
				}
			else if(ch==2)
				{
					Reset_price();
				}
			else if(ch==3)
				{
					Bill();
				}
			else if(ch==4)
				{
					Display_Items&Price();
				}
			else if(ch==5)
				{
					break;
				}
		} 
}
