#include <stdio.h>
main()
{


	int a, b, c, aux;


	scanf("%d\n%d\n%d",&a,&b,&c);


	if(a>b)
	{
		aux=a;
		a=b;
		b=aux;
	}

	if(a>c)
	{
		aux=a;
		a=c;
		c=aux;
	}

	if(b>c)
	{
		aux=b;
		b=c;
		c=aux;
	}

	printf("%d\n%d\n%d", a, b, c);



}
