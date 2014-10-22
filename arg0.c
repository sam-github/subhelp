#include <stdio.h>

void prn(const char* name, const char** v)
{
    int i;
    for(i = 0; v[i]; i++) {
        printf("%s[%d]='%s'\n", name, i, v[i]);
    }
}

int main(int argc, const char* argv[], const char* env[])
{
    prn("arg", argv);
    prn("env", env);
    return 0;
}
