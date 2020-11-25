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

int can_write()
{
    char line[255];
    int could_write = 0;

    FILE *file = fopen("/file_to_write", "wt");
    if (file)
    {
        fprintf(file,"consegui escrever na raiz\n");
        if ( !ferror (file))
        {
            could_write = 1;
        }
        fclose(file);
    }
    if (could_write) return 1;

    // tenta criar um arquivo no diretorio atual
    file = fopen("file_to_write", "wt");
    if (file)
    {
        fprintf(file,"consegui escrever na pasta\n");
        if ( !ferror (file))
        {
            could_write = 1;
        }
        fclose(file);
    }
    if (could_write) return 1;

    file = fopen("/home/huxley/data/submissions/file_to_write", "wt");
    if (file)
    {
        fprintf(file,"consegui escrever na pasta\n");
        if ( !ferror (file))
        {
            could_write = 1;
        }
        fclose(file);
    }


    return (could_write);

}

int main()
{
	if (can_write()){
	    printf("DEU ERRADO, CONSEGUI ESCREVER\n");
	}else{
	    char nome[255];
	    fgets(nome,254,stdin);
	    printf("Seja muito bem-vindo %s\n",nome);
	}
	return 0;
}
