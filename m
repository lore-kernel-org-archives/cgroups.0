From: Baolin Wang <baolin.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: [PATCH v2] blk-cgroup: Use cond_resched() when destroy blkgs
Date: Thu, 28 Jan 2021 11:49:29 +0800
Message-ID: <f58ce890-d54c-e4a7-d379-ad4ad4ae20de@linux.alibaba.com>
References: <8e8a0c4644d5eb01b7f79ec9b67c2b240f4a6434.1611798287.git.baolin.wang@linux.alibaba.com>
 <3f3c12de-b5fb-a9ad-9324-55f5bf9d7453@kernel.dk>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3f3c12de-b5fb-a9ad-9324-55f5bf9d7453-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: joseph.qi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



在 2021/1/28 11:41, Jens Axboe 写道:
> On 1/27/21 8:22 PM, Baolin Wang wrote:
>> On !PREEMPT kernel, we can get below softlockup when doing stress
>> testing with creating and destroying block cgroup repeatly. The
>> reason is it may take a long time to acquire the queue's lock in
>> the loop of blkcg_destroy_blkgs(), or the system can accumulate a
>> huge number of blkgs in pathological cases. We can add a need_resched()
>> check on each loop and release locks and do cond_resched() if true
>> to avoid this issue, since the blkcg_destroy_blkgs() is not called
>> from atomic contexts.
>>
>> [ 4757.010308] watchdog: BUG: soft lockup - CPU#11 stuck for 94s!
>> [ 4757.010698] Call trace:
>> [ 4757.010700]  blkcg_destroy_blkgs+0x68/0x150
>> [ 4757.010701]  cgwb_release_workfn+0x104/0x158
>> [ 4757.010702]  process_one_work+0x1bc/0x3f0
>> [ 4757.010704]  worker_thread+0x164/0x468
>> [ 4757.010705]  kthread+0x108/0x138
> 
> Kind of ugly with the two clauses for dropping the blkcg lock, one
> being a cpu_relax() and the other a resched. How about something
> like this:
> 
> 
> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
> index 031114d454a6..4221a1539391 100644
> --- a/block/blk-cgroup.c
> +++ b/block/blk-cgroup.c
> @@ -1016,6 +1016,8 @@ static void blkcg_css_offline(struct cgroup_subsys_state *css)
>    */
>   void blkcg_destroy_blkgs(struct blkcg *blkcg)
>   {
> +	might_sleep();
> +
>   	spin_lock_irq(&blkcg->lock);
>   
>   	while (!hlist_empty(&blkcg->blkg_list)) {
> @@ -1023,14 +1025,20 @@ void blkcg_destroy_blkgs(struct blkcg *blkcg)
>   						struct blkcg_gq, blkcg_node);
>   		struct request_queue *q = blkg->q;
>   
> -		if (spin_trylock(&q->queue_lock)) {
> -			blkg_destroy(blkg);
> -			spin_unlock(&q->queue_lock);
> -		} else {
> +		if (need_resched() || !spin_trylock(&q->queue_lock)) {
> +			/*
> +			 * Given that the system can accumulate a huge number
> +			 * of blkgs in pathological cases, check to see if we
> +			 * need to rescheduling to avoid softlockup.
> +			 */
>   			spin_unlock_irq(&blkcg->lock);
> -			cpu_relax();
> +			cond_resched();
>   			spin_lock_irq(&blkcg->lock);
> +			continue;
>   		}
> +
> +		blkg_destroy(blkg);
> +		spin_unlock(&q->queue_lock);
>   	}
>   
>   	spin_unlock_irq(&blkcg->lock);
> 

Looks better to me. Do I need resend with your suggestion? Thanks.
