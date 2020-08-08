#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <string.h>

int DIFFIC_LEVEL = 20; // 3 < diffic_level < 20

void bad(int *p, int* sequence, int count)
{
	int flag = 1;
	int i = 0;
	for(i=0; i < count-2; i++)
		flag = (sequence[i] + sequence[i+1] == sequence[i+2]) && flag;
	if(flag && sequence[0] == 1 && sequence[1] == 1)
		free(p);
	if(p != NULL)
		free(p);
}

int main (int argc,char *argv[])
{
	int count = DIFFIC_LEVEL;
	int sequence[20] = {0};
	char buffer[100] = {0};
	int fd = open(*(argv+1),O_RDONLY,0);

	read(fd, buffer, count*4);

	int i=0;
	for(i=0; i< count; i++)
	{
		memcpy(&sequence[i],buffer+i*4,4);
		printf("num%d: %d\n",i,sequence[i]);
	}

	int *p = malloc(sizeof(int));
	*p = 100;

	bad(p, sequence, count);
}
