#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <sys/wait.h>

#ifndef TARGET
#define TARGET "/etc/hosts"
#endif

void child(int);

int fd[2];
int pid[2];

char *command[] = {"ls", "head"};

int main(int argc, char *argv[]) {
    int i, cp;
    int status;

    // パイプ(新しい入出力の組)を作成
    if(pipe(fd) < 0) {
        perror("pipe creation failed");
        exit(1);
    }

    // 2回fork
    for (cp = 0; cp < 2; cp++) {
        if((pid[cp] = fork()) < 0) {
            fprintf(stderr, "fork failed (cp = %d)\n", cp);
            exit(1);
        }
        // 子プロセスの処理
        if(pid[cp] == 0) {
            child(cp);
        }
    }

    // 親プロセスではpipeは不要なのでclose
    for (i = 0; i < 2; i++) close(fd[i]);

    // 子プロセス終了待ち
    for (cp = 0; cp < 2; cp++) {
        waitpid(pid[cp], &status, 0);
        printf("%s (cp = %d, pid = %d): done\n", command[cp], cp, pid[cp]);
    }

    return 0;
}

void child(int cp) {
    fprintf(stderr, "I am going to be '%s'. pid = %d, cp = %d\n", command[cp], getpid(), cp);

    // 1. 前のプロセスのpipe-in(fd[0])をclose
    // 2. 後ろのプロセスのpipe-out(fd[1])をclose
    close(fd[cp]);

    // 3. 前のプロセスのstdout(1)をclose
    // 4. 後ろのプロセスのstdin(0)をclose
    close(cp^1);

    // 5. 前のプロセスのpipe-outをstdoutにつなぐ
    // 6. 後ろのプロセスのpipe-inをstdinにつなぐ
    // => 前のプロセスのoutが後ろのプロセスのinに繋がった!
    dup2(fd[cp^1], cp^1);

    // 7./8. 残ったpipe-out/inをclose
    close(fd[cp^1]);

    // コマンドを実行
    execlp(command[cp], command[cp], NULL);
    fprintf(stderr, "NEVER REACH HERE... child %d: done\n", cp);
}
