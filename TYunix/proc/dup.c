#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>

#ifndef TARGET
#define TARGET "/etc/hosts"
#endif

void child();
void parent(int);

int main(int argc, char *argv[]) {
    int fd;

    // ファイルを開きファイル記述子(fd)を得る
    fd = open(TARGET, O_RDONLY);
    if (fd < 0) {
        perror("open failed!");
        close(fd);
        exit(2);
    }

    // リダイレクト処理
    // stdin(0)を閉じる
    close(0);
    // stdin(0)に開いたファイルのfdをつなぐ
    dup2(fd, 0);
    // fdを閉じる
    close(fd);

    // head: 入力の最初10行を表示
    // 入力は開いたファイルにリダイレクトされているので、開いたファイルの最初10行が表示される
    execlp("head", "head", NULL);
    return 0;
}
