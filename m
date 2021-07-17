From: Yutian Yang <nglaive-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] memcg: charge fs_context and legacy_fs_context
Date: Sat, 17 Jul 2021 06:20:01 -0400
Message-ID: <1626517201-24086-1-git-send-email-nglaive@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=+StolKAcDufVlmzojkSC3TjMvCFftVBsdtQJ52EleJY=;
        b=Jns2zr2mXKa/1SI1vWueB4vMVJ2ot3Vw405+C5xjcQU4KrIEF5mq7ltcWCbKzf5UdS
         aXFUOSLIdbtzDS41F64DGUbAl2t8cXIfxRUTGCsALub42QITeLC1d9mYPli6gMakRYC2
         ynKij2pzLRF+9ckXst5vlg9aasuqT1f9dhvTKSSTS9ssKvZ34W3g3vdgJWO9OjZe8tFG
         MW5TAEOY+O1eHxeB0d1HXSWe1jYoIs/3fqkWYabv4lriA9HWEGKxh6KHfhj+TwppX0zi
         MSaarbS23cUIAjyYtxrK4RLHfHNX9AJ8k+wda1fEJQjXIUpXVN4QYFqAVhyoylaMjc1W
         472Q==
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, shenwenbo-Y5EWUtBUdg4nDS1+zs4M5A@public.gmane.org, Yutian Yang <nglaive-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

This patch adds accounting flags to fs_context and legacy_fs_context 
allocation sites so that kernel could correctly charge these objects.

We have written a PoC to demonstrate the effect of the missing-charging
bugs. The PoC takes around 1,200MB unaccounted memory, while it is charged
for only 362MB memory usage. We evaluate the PoC on QEMU x86_64 v5.2.90
+ Linux kernel v5.10.19 + Debian buster. All the limitations including
ulimits and sysctl variables are set as default. Specifically, the hard 
NOFILE limit and nr_open in sysctl are both 1,048,576.

/*------------------------- POC code ----------------------------*/

#define _GNU_SOURCE
#include <sys/types.h>
#include <sys/file.h>
#include <time.h>
#include <sys/wait.h>
#include <stdint.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>
#include <signal.h>
#include <sched.h>
#include <fcntl.h>
#include <linux/mount.h>

#define errExit(msg)    do { perror(msg); exit(EXIT_FAILURE); \
                        } while (0)

#define STACK_SIZE (8 * 1024)
#ifndef __NR_fsopen
#define __NR_fsopen 430
#endif
static inline int fsopen(const char *fs_name, unsigned int flags)
{
        return syscall(__NR_fsopen, fs_name, flags);
}

static char thread_stack[512][STACK_SIZE];

int thread_fn(void* arg)
{
  for (int i = 0; i< 800000; ++i) {
    int fsfd = fsopen("nfs", FSOPEN_CLOEXEC);
    if (fsfd == -1) {
      errExit("fsopen");
    }
  }
  while(1);
  return 0;
}

int main(int argc, char *argv[]) {
  int thread_pid;
  for (int i = 0; i < 1; ++i) {
    thread_pid = clone(thread_fn, thread_stack[i] + STACK_SIZE, \
      SIGCHLD, NULL);
  }
  while(1);
  return 0;
}

/*-------------------------- end --------------------------------*/


Thanks!
Yutian Yang,
Zhejiang University


Signed-off-by: Yutian Yang <nglaive-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/fs_context.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/fs_context.c b/fs/fs_context.c
index 2834d1afa..4858645ca 100644
--- a/fs/fs_context.c
+++ b/fs/fs_context.c
@@ -231,7 +231,7 @@ static struct fs_context *alloc_fs_context(struct file_system_type *fs_type,
 	struct fs_context *fc;
 	int ret = -ENOMEM;
 
-	fc = kzalloc(sizeof(struct fs_context), GFP_KERNEL);
+	fc = kzalloc(sizeof(struct fs_context), GFP_KERNEL_ACCOUNT);
 	if (!fc)
 		return ERR_PTR(-ENOMEM);
 
@@ -631,7 +631,7 @@ const struct fs_context_operations legacy_fs_context_ops = {
  */
 static int legacy_init_fs_context(struct fs_context *fc)
 {
-	fc->fs_private = kzalloc(sizeof(struct legacy_fs_context), GFP_KERNEL);
+	fc->fs_private = kzalloc(sizeof(struct legacy_fs_context), GFP_KERNEL_ACCOUNT);
 	if (!fc->fs_private)
 		return -ENOMEM;
 	fc->ops = &legacy_fs_context_ops;
-- 
2.25.1

