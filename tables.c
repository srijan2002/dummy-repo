#include <stdio.h>

int main()
{
int i,n=1;
printf("i");
scanf("%d",&i);
/*while(n<=12)
{
    printf("%d  X %d = %d\n",n,i,n*i);
    n++;
}*/
/*do{
   printf("%d  X %d = %d\n",n,i,n*i);
   n++; 
}while(n<=12);
*/

for (n;n<=12;n++)
{
    printf("%d  X",n);
    printf(" %d = %d\n",i,n*i);
} 

}
