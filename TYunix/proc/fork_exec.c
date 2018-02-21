#include <unistd.h>
#include <sys/wait.h>
#include <stdlib.h>
#include <stdio.h>

void child(char **);
void parent(int);

int main(int argc, char const *argv[], char const *envp[]) {
    int pid;
    char **e;

    // 環境変数を表示
    for (e = envp; *e != NULL; e++) {
        printf("%s\n", *e);
    }

    // fork
    if ((pid = fork()) < 0) {
        perror("at fork!");
        exit(1);
    }

    // forkの返り値は、子プロセスなら0, 親プロセスなら今生成した子プロセスのpid
    if (pid > 0)
        parent(pid);
    else
        child(envp);

    return 0;
}

// 子プロセスでの処理
void child(char *envp[]) {
    char *argv[3];

    printf("I am a child process. pid = %d\n", getpid());

    // "/bin/ls ."を実行
    argv[0] = "/bin/ls";
    argv[1] = ".";
    argv[2] = NULL;

    puts("execv");
    execv(argv[0], argv);

    // execvが成功した場合、ここに来ることはない
    printf("exec failed\n");
}

// 親プロセスでの処理
void parent(int pid) {
    int status;

    printf("I am a parent process. The child's pid = %d\n", pid);

    // 子プロセスの終了を待つ
    if (wait(&status) < 0) {
        perror("at wait!");
        exit(2);
    }

    printf("child process: done.\n");
}
