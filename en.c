#include <stdio.h>
#include <string.h>

int main(int argc, char** argv)
{
    printf("%s\n", strerror(atoi(argv[1])));
    return 0;
}
