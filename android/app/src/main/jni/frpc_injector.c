#include <stdio.h>

int main(int argc, char *argv[]) {
    FILE *fp;
    char buffer[1024];
    char command[2048];

    if (argc < 4) {
        printf("Usage: %s frpcPath token proxyId\n", argv[0]);
        return 1;
    }

    // 构建命令
    snprintf(command, sizeof(command), "%s -u %s -p %s", argv[1], argv[2], argv[3]);

    // 执行命令并打开进程
    fp = popen(command, "r");
    if (fp == NULL) {
        printf("Error opening pipe!\n");
        return 1;
    }

    // 读取进程输出并打印
    while (fgets(buffer, sizeof(buffer), fp) != NULL) {
        printf("%s", buffer);
    }
    pclose(fp);

    return 0;
}

