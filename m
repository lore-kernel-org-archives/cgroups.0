From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] memcg: charge io_uring related objects
Date: Sat, 17 Jul 2021 10:03:07 -0700
Message-ID: <CALvZod59c1TmiGA5afoy=eM6PH15hEpxsfo2+GJ48yExLz7odQ@mail.gmail.com>
References: <1626519462-24400-1-git-send-email-nglaive@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=myDw34gcnPsdsn8zYUpTrkQVthzGeg+NVYxl0HK7vuI=;
        b=EjZTwhbV5BExwSBP15v3Kwp4LYRVdsFt4wc0eT9ydBGcilt/Zrd548iRfADKEQMy/e
         As/akEavxuemljUYRoGonfW8N2MbGPjRopH9Wra+C5WHW4V2161SBwqwjxG8XRPYsmZ1
         wWo22PeXgEP9gRBkIUgXu/+30zcHnqMzrUxZhGUiABixMt7DGg9VwbNFbmfmnKm0TRY5
         B3Ap4YbkVA+21xn63iAjUpb1WnkRGdxNY5yGGlh+EoOWUho19zxyAUKhX5MN/XUoqJNn
         IES1fVxlIYtyGVv2Dr8JmtUguCluPMbMZA9cti+nfyI7q4RjVGBw6dyCwGwaQ7cUHQ2G
         B0rw==
In-Reply-To: <1626519462-24400-1-git-send-email-nglaive-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yutian Yang <nglaive-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, shenwenbo-Y5EWUtBUdg4nDS1+zs4M5A@public.gmane.org

+ Jens and Andrew

On Sat, Jul 17, 2021 at 3:58 AM Yutian Yang <nglaive-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
> This patch adds accounting flags to allocations of io_uring related
> objects. Allocations of the objects are all triggerable by
> io_uring_setup() syscall from userspace.
>
> We have written a PoC to show that the missing-charging objects lead to
> breaking memcg limits. The PoC program takes around 835MB unaccounted
> memory, while it is charged for only 23MB memory usage. We evaluate the
> PoC on QEMU x86_64 v5.2.90 + Linux kernel v5.10.19 + Debian buster. All
> the limitations including ulimits and sysctl variables are set as default.
> Specifically, the MEMLOCK in prlimit is set as 65536KB and hard limit of
> NOFILE is set as 1,048,576.
>
> The PoC is written as a testcase under Linux LTP. To compile it, put the
> source to ltp_dir/testcases/kernel/syscalls/io_uring/ and make.
>
> /*------------------------- POC code ----------------------------*/
>
> #include <stdlib.h>
> #include <stdio.h>
> #include <errno.h>
> #include <string.h>
> #include <fcntl.h>
> #include "config.h"
> #include "tst_test.h"
> #include "lapi/io_uring.h"
> #include "lapi/namespaces_constants.h"
>
> #define TEST_FILE "test_file"
>
> #define QUEUE_DEPTH 1
> #define BLOCK_SZ    1024
>
> #define errExit(msg)    do { perror(msg); exit(EXIT_FAILURE);  \
>                         } while (0)
>
> #define STACK_SIZE (16 * 1024)
>
> static char thread_stack[512][STACK_SIZE];
>
> int thread_fn(void* arg)
> {
>   struct io_uring_params p;
>   memset(&p, 0 ,sizeof(p));
>   for (int i = 0; i< 10000 ; ++i) {
>     int ringfd = io_uring_setup(QUEUE_DEPTH, &p);
>     if (ringfd == -1) {
>       errExit("io_uring_setup");
>     }
>   }
>   while(1);
>   return 0;
> }
>
> static void run(unsigned int n) {
>   int thread_pid;
>   for (int i = 0; i < 1; ++i) {
>     thread_pid = ltp_clone(SIGCHLD, thread_fn, NULL, STACK_SIZE, \
>       thread_stack[i]);
>   }
>   while(1);
> }
>
> static struct tst_test test = {
>   .test = run,
>   .tcnt = 1,
>   .timeout = -1,
> };
>
> /*-------------------------- end --------------------------------*/
>
>
> Signed-off-by: Yutian Yang <nglaive-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/io-wq.c    |  6 +++---
>  fs/io_uring.c | 10 +++++-----
>  2 files changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/fs/io-wq.c b/fs/io-wq.c
> index f72d53848..ab31d01cc 100644
> --- a/fs/io-wq.c
> +++ b/fs/io-wq.c
> @@ -1086,11 +1086,11 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
>         if (WARN_ON_ONCE(!data->free_work || !data->do_work))
>                 return ERR_PTR(-EINVAL);
>
> -       wq = kzalloc(sizeof(*wq), GFP_KERNEL);
> +       wq = kzalloc(sizeof(*wq), GFP_KERNEL_ACCOUNT);
>         if (!wq)
>                 return ERR_PTR(-ENOMEM);
>
> -       wq->wqes = kcalloc(nr_node_ids, sizeof(struct io_wqe *), GFP_KERNEL);
> +       wq->wqes = kcalloc(nr_node_ids, sizeof(struct io_wqe *), GFP_KERNEL_ACCOUNT);
>         if (!wq->wqes)
>                 goto err_wq;
>
> @@ -1111,7 +1111,7 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
>
>                 if (!node_online(alloc_node))
>                         alloc_node = NUMA_NO_NODE;
> -               wqe = kzalloc_node(sizeof(struct io_wqe), GFP_KERNEL, alloc_node);
> +               wqe = kzalloc_node(sizeof(struct io_wqe), GFP_KERNEL_ACCOUNT, alloc_node);
>                 if (!wqe)
>                         goto err;
>                 wq->wqes[node] = wqe;
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index d0b7332ca..175fd5b0e 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -1177,7 +1177,7 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
>         struct io_ring_ctx *ctx;
>         int hash_bits;
>
> -       ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
> +       ctx = kzalloc(sizeof(*ctx), GFP_KERNEL_ACCOUNT);
>         if (!ctx)
>                 return NULL;
>
> @@ -1195,7 +1195,7 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
>                 hash_bits = 1;
>         ctx->cancel_hash_bits = hash_bits;
>         ctx->cancel_hash = kmalloc((1U << hash_bits) * sizeof(struct hlist_head),
> -                                       GFP_KERNEL);
> +                                       GFP_KERNEL_ACCOUNT);
>         if (!ctx->cancel_hash)
>                 goto err;
>         __hash_init(ctx->cancel_hash, 1U << hash_bits);
> @@ -7850,7 +7850,7 @@ static int io_uring_alloc_task_context(struct task_struct *task)
>         struct io_uring_task *tctx;
>         int ret;
>
> -       tctx = kmalloc(sizeof(*tctx), GFP_KERNEL);
> +       tctx = kmalloc(sizeof(*tctx), GFP_KERNEL_ACCOUNT);
>         if (unlikely(!tctx))
>                 return -ENOMEM;

What about percpu_counter_init() in this function and io_wq_hash in
io_init_wq_offload()?

>
> @@ -8038,7 +8038,7 @@ static void io_mem_free(void *ptr)
>
>  static void *io_mem_alloc(size_t size)
>  {
> -       gfp_t gfp_flags = GFP_KERNEL | __GFP_ZERO | __GFP_NOWARN | __GFP_COMP |
> +       gfp_t gfp_flags = GFP_KERNEL_ACCOUNT | __GFP_ZERO | __GFP_NOWARN | __GFP_COMP |
>                                 __GFP_NORETRY;
>
>         return (void *) __get_free_pages(gfp_flags, get_order(size));
> @@ -9874,7 +9874,7 @@ static int __init io_uring_init(void)
>
>         BUILD_BUG_ON(ARRAY_SIZE(io_op_defs) != IORING_OP_LAST);
>         BUILD_BUG_ON(__REQ_F_LAST_BIT >= 8 * sizeof(int));
> -       req_cachep = KMEM_CACHE(io_kiocb, SLAB_HWCACHE_ALIGN | SLAB_PANIC);
> +       req_cachep = KMEM_CACHE(io_kiocb, SLAB_HWCACHE_ALIGN | SLAB_PANIC | SLAB_ACCOUNT);
>         return 0;
>  };
>  __initcall(io_uring_init);
> --
> 2.25.1
>
