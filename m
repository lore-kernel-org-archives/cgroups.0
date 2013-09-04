From: Anatol Pomozov <anatol.pomozov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Race condition between "read CFQ stats" and "block device shutdown"
Date: Wed, 4 Sep 2013 09:15:22 -0700
Message-ID: <CAOMFOmVmH7G1Tu7RAri6pmLkorh7BUHa1+WdGOcHhRKCXa1M4Q@mail.gmail.com>
References: <CAOMFOmXJ5ZTYdOvdUt-oxsouhPGRmMshCRhn6AFgmFAGZw5WZA@mail.gmail.com>
	<5226D661.7070301@suse.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=BZ4V55vB+/bsGLkWye7Cyqf6Pej1kdDQMsT62l1HP/Q=;
        b=pv5Ehl1iYySsqe9SaFQxbByriNRQ1HuvDy2pzpyXKiDwoah1jeko9vufKe+w8ILk8M
         dhsa+anI6GV5lGjr9SDSfAg48q8w6cemVaQJfw+Exg6wcsQgfOgfCDv7Hltu7d4B4A5O
         F7kWeeeAAM4nVJMn33n/YCjUc28YTpGBqM5NJYpITcmpBFHndi0jKnQDAzF0zSgGJI9c
         5yT9lJPvJpOtWwczTEQDgrWghotKPLoj6d4hwPYceToW0ttTz5pMr2nVUi6T5YJol19l
         oD5dNh4b/0/bcw8Wlo8ma/hkx+f1Q/sKLfJJPqQdB9WQVA1NtXrVufEgPDC+VA35FvkW
         VLCw==
In-Reply-To: <5226D661.7070301-l3A5Bk7waGM@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>
Cc: Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>

Hi

On Tue, Sep 3, 2013 at 11:42 PM, Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org> wrote:
> On 09/03/2013 10:14 PM, Anatol Pomozov wrote:
>> Hi,
>>
>> I am running a program that checkes "read CFQ stat files" for race
>> conditions with other evens (e.g. device shutdown).
>>
>> And I discovered an interesting bug. Here is the "double_unlock" crash for it
>>
>>
>> print_unlock_imbalance_bug.isra.23+0x4/0x10
>> [ 261.453775] [<ffffffff810f7c65>] lock_release_non_nested.isra.39+0x2f5/0x300
>> [ 261.460900] [<ffffffff810f7cfe>] lock_release+0x8e/0x1f0
>> [ 261.466293] [<ffffffff81339030>] ? cfqg_prfill_service_level+0x60/0x60
>> [ 261.472894] [<ffffffff81005be3>] _raw_spin_unlock_irq+0x23/0x50
>> [ 261.478894] [<ffffffff8133559f>] blkcg_print_blkgs+0x8f/0x140
>> [ 261.484724] [<ffffffff81335515>] ? blkcg_print_blkgs+0x5/0x140
>> [ 261.490631] [<ffffffff81338a7f>] cfqg_print_weighted_queue_time+0x2f/0x40
>> [ 261.497489] [<ffffffff8110b793>] cgroup_seqfile_show+0x53/0x60
>> [ 261.503398] [<ffffffff811f1fe4>] seq_read+0x124/0x3a0
>> [ 261.508529] [<ffffffff811ce39d>] vfs_read+0xad/0x180
>> [ 261.513576] [<ffffffff811ce625>] SyS_read+0x55/0xa0
>> [ 261.518538] [<ffffffff81609f66>] cstar_dispatch+0x7/0x1f
>>
>> blkcg_print_blkgs fails with double unlock? Hmm, I checked
>> cfqg_prfill_service_level and I did not find any places where unlock
>> can happen.
>>
>> After some debugging I found that in blkcg_print_blkgs() spinlock
>> passed to spin_lock_irq() function differs from the object passed to
>> spin_unlock_irq just a few lines below. It means
>> request_queue->queue_lock spinlock has changed under the function feet
>> while it was executing!!!
>>
>> To make sure I added
>>
>> --- a/block/blk-cgroup.c
>> +++ b/block/blk-cgroup.c
>> @@ -465,10 +465,16 @@ void blkcg_print_blkgs(struct seq_file *sf,
>> struct blkcg *blkcg,
>>
>>         rcu_read_lock();
>>         hlist_for_each_entry_rcu(blkg, n, &blkcg->blkg_list, blkcg_node) {
>> -               spin_lock_irq(blkg->q->queue_lock);
>> +               spinlock_t *lock = blkg->q->queue_lock;
>> +               spinlock_t *new_lock;
>> +               spin_lock_irq(lock);
>>                 if (blkcg_policy_enabled(blkg->q, pol))
>>                         total += prfill(sf, blkg->pd[pol->plid], data);
>> -               spin_unlock_irq(blkg->q->queue_lock);
>> +               new_lock = blkg->q->queue_lock;
>> +               if (lock != new_lock) {
>> +                       pr_err("old lock %p %s  new lock %p %s\n",
>> lock, lock->dep_map.name, new_lock, new_lock->dep_map.name);
>> +               }
>> +               spin_unlock_irq(lock);
>>         }
>>         rcu_read_unlock();
>>
>>
>>
>> And indeed it shows locks are different.
>>
>>
>> It comes from this change 777eb1bf1 "block: Free queue resources at
>> blk_release_queue()" that changes lock when devices is shutting down.
>>
>> What would be the best fix for the issue?
>>
> The correct fix would be to add checks for 'blkq->q'; the mentioned
> lock reassignment can only happen during queue shutdown.
> So whenever the queue is dead or stopping we whould refuse to print
> anything here.
>
> Try this:
>
> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
> index 290792a..3e17841 100644
> --- a/block/blk-cgroup.c
> +++ b/block/blk-cgroup.c
> @@ -504,6 +504,8 @@ void blkcg_print_blkgs(struct seq_file *sf,
> struct blkcg *bl
> kcg,
>
>         rcu_read_lock();
>         hlist_for_each_entry_rcu(blkg, &blkcg->blkg_list, blkcg_node) {
> +               if (unlikely(blk_queue_dying(blkg->q)))
> +                       continue;
>                 spin_lock_irq(blkg->q->queue_lock);
>                 if (blkcg_policy_enabled(blkg->q, pol))
>                         total += prfill(sf, blkg->pd[pol->plid], data);

I ran my tests with this patch and unfortunately I still see the same
crash. Although test runs much longer now - it needed ~1000 device
shutdowns before the oops. Previously it was just a dozen iterations.
