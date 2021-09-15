From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] blkcg: fix memory leak in blk_iolatency_init
Date: Wed, 15 Sep 2021 11:58:09 -0600
Message-ID: <db4a41c9-9ba6-ea8e-8ebe-cf292d796308@kernel.dk>
References: <20210915072426.4022924-1-yanfei.xu@windriver.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VOwjbYzeXD/cfrrWWmcbH4Jm4bi4xHQwCqaQ6FZ72ds=;
        b=ksUgv0z/jK1fFxqRkilF0js7nEYkh82ulyizoIIjjlMADlDRxN98LP8vqWZXqOfpUK
         rebMq7gdURQp/KGTbbtu3cj1dg/jPWmMq3LH+IXBQWeI5sbTSNCSMQbadXmNQ4IevXJZ
         4qiXITXxiQDdecLKSYyRoEuQFeBZZCYHTltDeLZ2LhPhcjmWNmHuWBYrO7wuoOAJjk8C
         WI6+DvREQZoXFARaGGcO+aGjvN5QK4bpqHsKiNX9mNgjfkz3+PHsTBLPP6wmDJjvvqxx
         DyTURT5ZDZJyRXsp8VsxQylRyTN+12LCG83wNy3h9wOX08uKegm2RfsPDzkV5vXYOe8B
         vS0w==
In-Reply-To: <20210915072426.4022924-1-yanfei.xu@windriver.com>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Yanfei Xu <yanfei.xu@windriver.com>, tj@kernel.org
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

On 9/15/21 1:24 AM, Yanfei Xu wrote:
> BUG: memory leak
> unreferenced object 0xffff888129acdb80 (size 96):
>   comm "syz-executor.1", pid 12661, jiffies 4294962682 (age 15.220s)
>   hex dump (first 32 bytes):
>     20 47 c9 85 ff ff ff ff 20 d4 8e 29 81 88 ff ff   G...... ..)....
>     01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   backtrace:
>     [<ffffffff82264ec8>] kmalloc include/linux/slab.h:591 [inline]
>     [<ffffffff82264ec8>] kzalloc include/linux/slab.h:721 [inline]
>     [<ffffffff82264ec8>] blk_iolatency_init+0x28/0x190 block/blk-iolatency.c:724
>     [<ffffffff8225b8c4>] blkcg_init_queue+0xb4/0x1c0 block/blk-cgroup.c:1185
>     [<ffffffff822253da>] blk_alloc_queue+0x22a/0x2e0 block/blk-core.c:566
>     [<ffffffff8223b175>] blk_mq_init_queue_data block/blk-mq.c:3100 [inline]
>     [<ffffffff8223b175>] __blk_mq_alloc_disk+0x25/0xd0 block/blk-mq.c:3124
>     [<ffffffff826a9303>] loop_add+0x1c3/0x360 drivers/block/loop.c:2344
>     [<ffffffff826a966e>] loop_control_get_free drivers/block/loop.c:2501 [inline]
>     [<ffffffff826a966e>] loop_control_ioctl+0x17e/0x2e0 drivers/block/loop.c:2516
>     [<ffffffff81597eec>] vfs_ioctl fs/ioctl.c:51 [inline]
>     [<ffffffff81597eec>] __do_sys_ioctl fs/ioctl.c:874 [inline]
>     [<ffffffff81597eec>] __se_sys_ioctl fs/ioctl.c:860 [inline]
>     [<ffffffff81597eec>] __x64_sys_ioctl+0xfc/0x140 fs/ioctl.c:860
>     [<ffffffff843fa745>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>     [<ffffffff843fa745>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>     [<ffffffff84600068>] entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> Once blk_throtl_init() queue init failed, blkcg_iolatency_exit() will
> not be invoked for cleanup. That leads a memory leak. Swap the
> blk_throtl_init() and blk_iolatency_init() calls can solve this.

Applied, thanks.

-- 
Jens Axboe

