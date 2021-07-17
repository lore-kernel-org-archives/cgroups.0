From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] memcg: charge fs_context and legacy_fs_context
Date: Sat, 17 Jul 2021 09:52:25 -0700
Message-ID: <CALvZod5cX_J0O-dr8rtudqNzOg-N+z7c5uR4zSoP5J5=-dqTqA@mail.gmail.com>
References: <1626517201-24086-1-git-send-email-nglaive@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EtEG9h57/w2CMZDQ/fsZ1KRb5SK57GhIIkopkVoDlbc=;
        b=XUHU2gNDJcqocEEkrB3+yDpFf9dowkAfmkfyxZaPTu+QszPAXTXXRjnG8ep3deLymd
         ucMq+pR92OmT0PPAlb0xw5c4xHYO/rT1Ik8saw3SZyfo07VZPMiXHc0ESsqvTZVo/sqZ
         5EOTeqO384bYUJHBIVov2RIlCYxhF3ERBXISt/O29DR2bkSoLBeeL7exWBDQ6VgsDgIX
         LGpw6g/b8j+Xrz4TZwPw9yeJSltMWo/lJG+nB0JMrn4KafjmOgODPthC7r5wU1v69hS8
         z8mg2VrtpCLALg6+mDy2BLhQYGkro6gZe09MpmWOAKjPf7wKsC72O8TZkSgqEVswBxI/
         stGQ==
In-Reply-To: <1626517201-24086-1-git-send-email-nglaive-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yutian Yang <nglaive-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, shenwenbo-Y5EWUtBUdg4nDS1+zs4M5A@public.gmane.org

+Andrew Morton

On Sat, Jul 17, 2021 at 3:23 AM Yutian Yang <nglaive-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
> This patch adds accounting flags to fs_context and legacy_fs_context
> allocation sites so that kernel could correctly charge these objects.
>
> We have written a PoC to demonstrate the effect of the missing-charging
> bugs. The PoC takes around 1,200MB unaccounted memory, while it is charged
> for only 362MB memory usage. We evaluate the PoC on QEMU x86_64 v5.2.90
> + Linux kernel v5.10.19 + Debian buster. All the limitations including
> ulimits and sysctl variables are set as default. Specifically, the hard
> NOFILE limit and nr_open in sysctl are both 1,048,576.
>
> /*------------------------- POC code ----------------------------*/
>
> #define _GNU_SOURCE
> #include <sys/types.h>
> #include <sys/file.h>
> #include <time.h>
> #include <sys/wait.h>
> #include <stdint.h>
> #include <stdlib.h>
> #include <unistd.h>
> #include <stdio.h>
> #include <signal.h>
> #include <sched.h>
> #include <fcntl.h>
> #include <linux/mount.h>
>
> #define errExit(msg)    do { perror(msg); exit(EXIT_FAILURE); \
>                         } while (0)
>
> #define STACK_SIZE (8 * 1024)
> #ifndef __NR_fsopen
> #define __NR_fsopen 430
> #endif
> static inline int fsopen(const char *fs_name, unsigned int flags)
> {
>         return syscall(__NR_fsopen, fs_name, flags);
> }
>
> static char thread_stack[512][STACK_SIZE];
>
> int thread_fn(void* arg)
> {
>   for (int i = 0; i< 800000; ++i) {
>     int fsfd = fsopen("nfs", FSOPEN_CLOEXEC);
>     if (fsfd == -1) {
>       errExit("fsopen");
>     }
>   }
>   while(1);
>   return 0;
> }
>
> int main(int argc, char *argv[]) {
>   int thread_pid;
>   for (int i = 0; i < 1; ++i) {
>     thread_pid = clone(thread_fn, thread_stack[i] + STACK_SIZE, \
>       SIGCHLD, NULL);
>   }
>   while(1);
>   return 0;
> }
>
> /*-------------------------- end --------------------------------*/
>
>
> Thanks!
> Yutian Yang,
> Zhejiang University
>
>
> Signed-off-by: Yutian Yang <nglaive-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

I think this can go through the mm tree.

> ---
>  fs/fs_context.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/fs_context.c b/fs/fs_context.c
> index 2834d1afa..4858645ca 100644
> --- a/fs/fs_context.c
> +++ b/fs/fs_context.c
> @@ -231,7 +231,7 @@ static struct fs_context *alloc_fs_context(struct file_system_type *fs_type,
>         struct fs_context *fc;
>         int ret = -ENOMEM;
>
> -       fc = kzalloc(sizeof(struct fs_context), GFP_KERNEL);
> +       fc = kzalloc(sizeof(struct fs_context), GFP_KERNEL_ACCOUNT);
>         if (!fc)
>                 return ERR_PTR(-ENOMEM);
>
> @@ -631,7 +631,7 @@ const struct fs_context_operations legacy_fs_context_ops = {
>   */
>  static int legacy_init_fs_context(struct fs_context *fc)
>  {
> -       fc->fs_private = kzalloc(sizeof(struct legacy_fs_context), GFP_KERNEL);
> +       fc->fs_private = kzalloc(sizeof(struct legacy_fs_context), GFP_KERNEL_ACCOUNT);
>         if (!fc->fs_private)
>                 return -ENOMEM;
>         fc->ops = &legacy_fs_context_ops;
> --
> 2.25.1
>
