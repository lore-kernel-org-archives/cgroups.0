From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] blkcg: fix memory leak in blk_iolatency_init
Date: Wed, 15 Sep 2021 07:43:18 -1000
Message-ID: <YUIwtsaJeisezVBI@slm.duckdns.org>
References: <20210915072426.4022924-1-yanfei.xu@windriver.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=txWtxQmy07MGdoAs+OedOZn1lzXrGQuZ/mk3Eu7b5aE=;
        b=XT7A2WHPULRNXUNb/JMXgeVo8IlX8TrZbm5PZPkwTjgr81LV9uQEXKdQ0n/osyUULc
         cC7Ha3t/6YDIOi5ukEtv0Jr/c7kwuq3nv8RoPyC0WjPjap7MdLzjDe16ChgeYXpFbtMg
         NfiLpio76Zn/sJvUETMKKk4LlWuAWz9aQNbA1xG9FY0vAafQXisAXSNUp55oVyAY2eYp
         krWT3nWHJ7ADp5KNQTtZmMBK6F6+nQa7loQIIySYfo7lthI47DxMGGsRMFbCIlPr6McN
         XIvOxf7L1zjQLcdbZxLI2sRYYAhkbf61nonH0Ax5CgAAqok+l5EeaCV0GlZpum+TAvLv
         9QBg==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20210915072426.4022924-1-yanfei.xu@windriver.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yanfei Xu <yanfei.xu@windriver.com>
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

On Wed, Sep 15, 2021 at 03:24:26PM +0800, Yanfei Xu wrote:
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
> 
> Reported-by: syzbot+01321b15cc98e6bf96d6@syzkaller.appspotmail.com
> Fixes: 19688d7f9592 (block/blk-cgroup: Swap the blk_throtl_init() and blk_iolatency_init() calls)
> Signed-off-by: Yanfei Xu <yanfei.xu@windriver.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
