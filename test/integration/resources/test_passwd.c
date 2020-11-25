#include <stdlib.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netdb.h>
#include <string.h>
#include <dirent.h>
#include <arpa/inet.h>
#include <netinet/in.h>
#include <sys/mman.h>
#include <sys/wait.h>
#include <unistd.h>

int test_file_system_access()
{
    char line[255];

    FILE *passwd = fopen("/etc/passwd", "rt");
    int read = passwd!=NULL;
    if (read)
    {
        while(fgets(line, 80, passwd) != NULL)
        {
            puts(line);
        }
        fclose(passwd);
    }
    return (read);

}

int main()
{
	if (test_file_system_access()){
	    return -1;
	}else{
	    char nome[255];
	    fgets(nome,254,stdin);
	    printf("Seja muito bem-vindo %s\n",nome);
	}
	return 0;
}
