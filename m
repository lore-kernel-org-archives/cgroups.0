From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: [PATCH v2] blk-cgroup: Use cond_resched() when destroy blkgs
Date: Wed, 27 Jan 2021 20:41:33 -0700
Message-ID: <3f3c12de-b5fb-a9ad-9324-55f5bf9d7453@kernel.dk>
References: <8e8a0c4644d5eb01b7f79ec9b67c2b240f4a6434.1611798287.git.baolin.wang@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8gjX+jjDFMAlZkTk6jMUJPns6AHBcmdN1XMHS3UqN/A=;
        b=V0DylTMjpL5WcI72wITMJnqhWjt5RB80k11HTTxQk1QuSPO+8GNRuLhwD+E+X5DwEl
         91T6ytbzRiO1cTXCiQxwPzoAeMKChzegBnfIE6Wj2jQC3issmbg5n5yVGaFWQi72cy52
         Jk0c5rANenq/FOgB6higjUbR8B9AlpjL887l8LN3q6VCKaEQjOCjUlBZJe+Xx4aIJ23h
         lvWRHD7I6k83axGbw2IVQivf2b1cK0Te/7q+aSmVd6FE7S6X+pyFPCUy42v0fmR24HYq
         yWbJKjRa0x5wvUPu/zEu9cP445i6u/fwxyy9BkA5w8X4loZYIIsmzKQl0rTQaAp2eBw3
         ab6Q==
In-Reply-To: <8e8a0c4644d5eb01b7f79ec9b67c2b240f4a6434.1611798287.git.baolin.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Baolin Wang <baolin.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: joseph.qi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 1/27/21 8:22 PM, Baolin Wang wrote:
> On !PREEMPT kernel, we can get below softlockup when doing stress
> testing with creating and destroying block cgroup repeatly. The
> reason is it may take a long time to acquire the queue's lock in
> the loop of blkcg_destroy_blkgs(), or the system can accumulate a
> huge number of blkgs in pathological cases. We can add a need_resched()
> check on each loop and release locks and do cond_resched() if true
> to avoid this issue, since the blkcg_destroy_blkgs() is not called
> from atomic contexts.
> 
> [ 4757.010308] watchdog: BUG: soft lockup - CPU#11 stuck for 94s!
> [ 4757.010698] Call trace:
> [ 4757.010700]  blkcg_destroy_blkgs+0x68/0x150
> [ 4757.010701]  cgwb_release_workfn+0x104/0x158
> [ 4757.010702]  process_one_work+0x1bc/0x3f0
> [ 4757.010704]  worker_thread+0x164/0x468
> [ 4757.010705]  kthread+0x108/0x138

Kind of ugly with the two clauses for dropping the blkcg lock, one
being a cpu_relax() and the other a resched. How about something
like this:


diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 031114d454a6..4221a1539391 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1016,6 +1016,8 @@ static void blkcg_css_offline(struct cgroup_subsys_state *css)
  */
 void blkcg_destroy_blkgs(struct blkcg *blkcg)
 {
+	might_sleep();
+
 	spin_lock_irq(&blkcg->lock);
 
 	while (!hlist_empty(&blkcg->blkg_list)) {
@@ -1023,14 +1025,20 @@ void blkcg_destroy_blkgs(struct blkcg *blkcg)
 						struct blkcg_gq, blkcg_node);
 		struct request_queue *q = blkg->q;
 
-		if (spin_trylock(&q->queue_lock)) {
-			blkg_destroy(blkg);
-			spin_unlock(&q->queue_lock);
-		} else {
+		if (need_resched() || !spin_trylock(&q->queue_lock)) {
+			/*
+			 * Given that the system can accumulate a huge number
+			 * of blkgs in pathological cases, check to see if we
+			 * need to rescheduling to avoid softlockup.
+			 */
 			spin_unlock_irq(&blkcg->lock);
-			cpu_relax();
+			cond_resched();
 			spin_lock_irq(&blkcg->lock);
+			continue;
 		}
+
+		blkg_destroy(blkg);
+		spin_unlock(&q->queue_lock);
 	}
 
 	spin_unlock_irq(&blkcg->lock);

-- 
Jens Axboe

