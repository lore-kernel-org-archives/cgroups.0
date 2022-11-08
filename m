From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: [PATCH] block, bfq: fix null pointer dereference in bfq_bio_bfqg()
Date: Tue, 08 Nov 2022 07:13:48 -0700
Message-ID: <166791682840.41277.4130538125529354302.b4-ty@kernel.dk>
References: <20221108103434.2853269-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZcQMPR+vY4HDnxFrn6DWfgOLsByM9wrckBFX6ElxCNo=;
        b=Bizwli3rHid237sI4fMedw4c8a0QLD9BkHZak1F3/W2+Ttp4sBANl46L65mjSkjyYq
         ug1PKOs0KVPJW6TP0t45QeiEMzgpMAL45uaLZDGsfzoCjFQdVqDMMaw/P40TebA8xqfC
         umhQpYXilzAXzrE8okAaowBOjzKlr9ENR/2WOMXbDhhEHDFsIyrl7gzd70QgkJpV7/hu
         ENG9jAn3nVRCZlRJKKK822sj5g/tY3xd099LfQgDv9nLZKIkMrlJCxGm4S4S58CxfP1M
         Hmudfr1TOBKCEGK5pDesRmBsyUyypKca+S6KiVZbAiBZvPXIjQkqnxL32/QIYYiAYor0
         94oA==
In-Reply-To: <20221108103434.2853269-1-yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, 8 Nov 2022 18:34:34 +0800, Yu Kuai wrote:
> From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> 
> Out test found a following problem in kernel 5.10, and the same problem
> should exist in mainline:
> 
> BUG: kernel NULL pointer dereference, address: 0000000000000094
> PGD 0 P4D 0
> Oops: 0000 [#1] SMP
> CPU: 7 PID: 155 Comm: kworker/7:1 Not tainted 5.10.0-01932-g19e0ace2ca1d-dirty 4
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ?-20190727_073836-b4
> Workqueue: kthrotld blk_throtl_dispatch_work_fn
> RIP: 0010:bfq_bio_bfqg+0x52/0xc0
> Code: 94 00 00 00 00 75 2e 48 8b 40 30 48 83 05 35 06 c8 0b 01 48 85 c0 74 3d 4b
> RSP: 0018:ffffc90001a1fba0 EFLAGS: 00010002
> RAX: ffff888100d60400 RBX: ffff8881132e7000 RCX: 0000000000000000
> RDX: 0000000000000017 RSI: ffff888103580a18 RDI: ffff888103580a18
> RBP: ffff8881132e7000 R08: 0000000000000000 R09: ffffc90001a1fe10
> R10: 0000000000000a20 R11: 0000000000034320 R12: 0000000000000000
> R13: ffff888103580a18 R14: ffff888114447000 R15: 0000000000000000
> FS:  0000000000000000(0000) GS:ffff88881fdc0000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000094 CR3: 0000000100cdb000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  bfq_bic_update_cgroup+0x3c/0x350
>  ? ioc_create_icq+0x42/0x270
>  bfq_init_rq+0xfd/0x1060
>  bfq_insert_requests+0x20f/0x1cc0
>  ? ioc_create_icq+0x122/0x270
>  blk_mq_sched_insert_requests+0x86/0x1d0
>  blk_mq_flush_plug_list+0x193/0x2a0
>  blk_flush_plug_list+0x127/0x170
>  blk_finish_plug+0x31/0x50
>  blk_throtl_dispatch_work_fn+0x151/0x190
>  process_one_work+0x27c/0x5f0
>  worker_thread+0x28b/0x6b0
>  ? rescuer_thread+0x590/0x590
>  kthread+0x153/0x1b0
>  ? kthread_flush_work+0x170/0x170
>  ret_from_fork+0x1f/0x30
> Modules linked in:
> CR2: 0000000000000094
> ---[ end trace e2e59ac014314547 ]---
> RIP: 0010:bfq_bio_bfqg+0x52/0xc0
> Code: 94 00 00 00 00 75 2e 48 8b 40 30 48 83 05 35 06 c8 0b 01 48 85 c0 74 3d 4b
> RSP: 0018:ffffc90001a1fba0 EFLAGS: 00010002
> RAX: ffff888100d60400 RBX: ffff8881132e7000 RCX: 0000000000000000
> RDX: 0000000000000017 RSI: ffff888103580a18 RDI: ffff888103580a18
> RBP: ffff8881132e7000 R08: 0000000000000000 R09: ffffc90001a1fe10
> R10: 0000000000000a20 R11: 0000000000034320 R12: 0000000000000000
> R13: ffff888103580a18 R14: ffff888114447000 R15: 0000000000000000
> FS:  0000000000000000(0000) GS:ffff88881fdc0000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000094 CR3: 0000000100cdb000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> 
> [...]

Applied, thanks!

[1/1] block, bfq: fix null pointer dereference in bfq_bio_bfqg()
      commit: f02be9002c480cd3ec0fcf184ad27cf531bd6ece

Best regards,
-- 
Jens Axboe


