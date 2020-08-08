#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <string.h>

void bad(int *p, int a, int b)
{

	if(a + b == 10 && a * b > 20)
		free(p);
	if(p != NULL)
		free(p);
}

int main (int argc,char *argv[])
{
	int a,b;
	char buffer[20] = {0};
	int fd = open(*(argv+1),O_RDONLY,0);
	read(fd, buffer, 8);

	memcpy(&a,buffer,4);
	memcpy(&b,buffer+4,4);
	printf("a: %d\n", a);
	printf("b: %d\n", b);

	int *p = malloc(sizeof(int));
	*p = 100;

	bad(p, a, b);
}
