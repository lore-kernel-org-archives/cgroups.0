From: Joseph Qi <joseph.qi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: [PATCH v2] blk-throttle: fix race between blkcg_bio_issue_check
 and cgroup_rmdir
Date: Thu, 8 Feb 2018 10:29:43 +0800
Message-ID: <b590caed-1423-4776-966d-cd9e346a8ea1@linux.alibaba.com>
References: <6f136c90-faa9-4bc0-b02f-3a112b4d8360@linux.alibaba.com>
 <20180207213811.GF695913@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180207213811.GF695913-4dN5La/x3IkLX0oZNxdnEQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, xuejiufei <jiufei.xue-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Caspar Zhang <caspar-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, linux-block <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Tejun,
Thanks very much for reviewing this patch.

On 18/2/8 05:38, Tejun Heo wrote:
> Hello, Joseph.
> 
> On Wed, Feb 07, 2018 at 04:40:02PM +0800, Joseph Qi wrote:
>> writeback kworker
>>   blkcg_bio_issue_check
>>     rcu_read_lock
>>     blkg_lookup
>>     <<< *race window*
>>     blk_throtl_bio
>>       spin_lock_irq(q->queue_lock)
>>       spin_unlock_irq(q->queue_lock)
>>     rcu_read_unlock
>>
>> cgroup_rmdir
>>   cgroup_destroy_locked
>>     kill_css
>>       css_killed_ref_fn
>>         css_killed_work_fn
>>           offline_css
>>             blkcg_css_offline
>>               spin_trylock(q->queue_lock)
>>               blkg_destroy
>>               spin_unlock(q->queue_lock)
> 
> Ah, right.  Thanks for spotting the bug.
> 
>> Since rcu can only prevent blkg from releasing when it is being used,
>> the blkg->refcnt can be decreased to 0 during blkg_destroy and schedule
>> blkg release.
>> Then trying to blkg_get in blk_throtl_bio will complains the WARNING.
>> And then the corresponding blkg_put will schedule blkg release again,
>> which result in double free.
>> This race is introduced by commit ae1188963611 ("blkcg: consolidate blkg
>> creation in blkcg_bio_issue_check()"). Before this commit, it will lookup
>> first and then try to lookup/create again with queue_lock. So revive
>> this logic to fix the race.
> 
> The change seems a bit drastic to me.  Can't we do something like the
> following instead?
> 
> blk_throtl_bio()
> {
> 	... non throttled cases ...
> 
> 	/* out-of-limit, queue to @tg */
> 
> 	/*
> 	 * We can look up and retry but the race window is tiny here.
> 	 * Just letting it through should be good enough.
> 	 */
> 	if (!css_tryget(blkcg->css))
> 		goto out;
> 
> 	... actual queueing ...
> 	css_put(blkcg->css);
> 	...
> }
So you mean checking css->refcnt to prevent the further use of
blkg_get? I think it makes sense.
IMO, we should use css_tryget_online instead, and rightly after taking
queue_lock. Because there may be more use of blkg_get in blk_throtl_bio
in the futher. Actually it already has two now. One is in
blk_throtl_assoc_bio, and the other is in throtl_qnode_add_bio.
What do you think of this?

Thanks,
Joseph
