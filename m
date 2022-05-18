From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH] blk-cgroup: Remove unnecessary rcu_read_lock/unlock()
Date: Wed, 18 May 2022 21:28:50 +0200
Message-ID: <46253c48-81cb-0787-20ad-9133afdd9e21@samsung.com>
References: <20220516173930.159535-1-bh1scw@gmail.com>
        <CGME20220518192850eucas1p1458c00d4917c5ed39f2c37c9eb30cd46@eucas1p1.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20220518192853euoutp0223bde464ff07826b1becdcbc46de5729~wSbuzrlsc1850018500euoutp02b
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1652902133;
        bh=rU7RXbbuzPE5V8CNvE+sIgl9BA3+n1vzQusFXegX7JE=;
        h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
        b=lQ4rv4GqBuOGUpx7R0uiGuRSUbw5/PHhkCQfdv2rkxG0HlDscthUY8MiWV28MwpEH
         sH7bVBBhsTAaspzk02Hqm6BORH03WKNeSWec61jyXspV34RveaxpVY9v3e9OT/3GKH
         MsKo6ySanhnPiME+PWSw+J8BLQIN7nc2HfLtkBiE=
Content-Language: en-US
In-Reply-To: <20220516173930.159535-1-bh1scw@gmail.com>
List-ID: <cgroups.vger.kernel.org>
To: bh1scw@gmail.com, tj@kernel.org, axboe@kernel.dk
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, songmuchun@bytedance.com

On 16.05.2022 19:39, bh1scw@gmail.com wrote:
> From: Fanjun Kong <bh1scw@gmail.com>
>
> spin_lock_irq/spin_unlock_irq contains preempt_disable/enable().
> Which can serve as RCU read-side critical region, so remove
> rcu_read_lock/unlock().
>
> Signed-off-by: Fanjun Kong <bh1scw@gmail.com>

This patch landed in today's linux next-20220518 as commit 77c570a1ea85 
("blk-cgroup: Remove unnecessary rcu_read_lock/unlock()").

Unfortunately it triggers the following warning on ARM64 based Raspberry 
Pi 4B board:

------------[ cut here ]------------
WARNING: CPU: 0 PID: 1 at block/blk-cgroup.c:301 blkg_create+0x398/0x4e0
Modules linked in:
CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.18.0-rc3+ #5080
Hardware name: Raspberry Pi 4 Model B (DT)
pstate: 600000c5 (nZCv daIF -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : blkg_create+0x398/0x4e0
...
Call trace:
  blkg_create+0x398/0x4e0
  blkcg_init_queue+0x74/0x204
  __alloc_disk_node+0xf8/0x1f0
  __blk_alloc_disk+0x38/0x140
  brd_alloc.part.0+0xf8/0x220
  brd_init+0xe8/0x164
  do_one_initcall+0x74/0x400
  kernel_init_freeable+0x2f4/0x37c
  kernel_init+0x28/0x130
  ret_from_fork+0x10/0x20
irq event stamp: 218372
hardirqs last  enabled at (218371): [<ffff80000914b99c>] 
_raw_spin_unlock_irqrestore+0x98/0x9c
hardirqs last disabled at (218372): [<ffff80000914bcbc>] 
_raw_spin_lock_irq+0xac/0xb0
softirqs last  enabled at (216732): [<ffff800008010470>] _stext+0x470/0x5e8
softirqs last disabled at (216723): [<ffff8000080a0ec4>] 
__irq_exit_rcu+0x180/0x1ac
---[ end trace 0000000000000000 ]---

If this is a false positive, then the check in the code needs to be 
adjusted.

> ---
>   block/blk-cgroup.c | 4 +---
>   1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
> index a91f8ae18b49..7bdc16a36560 100644
> --- a/block/blk-cgroup.c
> +++ b/block/blk-cgroup.c
> @@ -1283,14 +1283,13 @@ int blkcg_init_queue(struct request_queue *q)
>   	preloaded = !radix_tree_preload(GFP_KERNEL);
>   
>   	/* Make sure the root blkg exists. */
> -	rcu_read_lock();
> +	/* spin_lock_irq can serve as RCU read-side critical section. */
>   	spin_lock_irq(&q->queue_lock);
>   	blkg = blkg_create(&blkcg_root, q, new_blkg);
>   	if (IS_ERR(blkg))
>   		goto err_unlock;
>   	q->root_blkg = blkg;
>   	spin_unlock_irq(&q->queue_lock);
> -	rcu_read_unlock();
>   
>   	if (preloaded)
>   		radix_tree_preload_end();
> @@ -1316,7 +1315,6 @@ int blkcg_init_queue(struct request_queue *q)
>   	return ret;
>   err_unlock:
>   	spin_unlock_irq(&q->queue_lock);
> -	rcu_read_unlock();
>   	if (preloaded)
>   		radix_tree_preload_end();
>   	return PTR_ERR(blkg);

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

