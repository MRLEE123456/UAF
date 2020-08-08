#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <string.h>

int DIFFIC_LEVEL = 7; //0 < DIFFIC_LEVEL < 8

void bad(int *p, char* buffer, int count)
{
	int flag = 1;
	int i = 0;
	for(i=0; i<count-1; i++)
	{
		flag = flag && (buffer[i+1] == (buffer[i] * 2));
		//printf("flag%d: %d\n",i,flag);
	}
	if(flag)
		free(p);
	if(p != NULL)
		free(p);
}

int main (int argc,char *argv[])
{
	char buffer[20] = {0};
	int count = DIFFIC_LEVEL;

	int fd = open(*(argv+1),O_RDONLY,0);
	read(fd, buffer, count);

	int *p = malloc(sizeof(int)*1024);

	bad(p, buffer, count);
}
