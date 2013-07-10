From: Konstantin Khlebnikov <khlebnikov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH RFC] fsio: filesystem io accounting cgroup
Date: Wed, 10 Jul 2013 10:03:27 +0400
Message-ID: <51DCF92F.6090409@openvz.org>
References: <20130708095928.14058.26736.stgit@zurg> <CAFj3OHVtVGDnWHqNBRZH+LNtzDrbk8PO0fKLwFscZAWCJRW9oA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        bh=SnJ+viIN0dMb50Ro946OAsiqTLRQc8fNBK5NK6fzN/M=;
        b=ssZIZu734bOu21yZ7pHKyyvzpc713Ycuj1O8nQitjZi8NAoanMcf3fNqaEt/ywG1Dl
         UYNCQvqIEOETFMoXyJW50PkL4lpE4v+K2k5j7SVQ7Xr110HSHp0hcXERBF6Sn4D/yUm9
         WhuWrgkpTZUHjaMqeph1W0vwX+nbV8GDE8L1RAYXoxc1THZsH0rmUolQmlbbRynqllmb
         wItXVyrv8JVc0lRw//9oezyI60YffEoJlX4tz+ibbg3KD4PrSQjrD5ZjB3L6Qaa5VPoo
         lW3cZVBbZcuc6730xpDBaxqfNNxY2oz8Td0EZBvQ2E9eM77XYNI1zOUY/nA++bctlL+S
         a6oQ==
In-Reply-To: <CAFj3OHVtVGDnWHqNBRZH+LNtzDrbk8PO0fKLwFscZAWCJRW9oA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, "devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org" <devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

Sha Zhengju wrote:
> Hi,
>
> On Mon, Jul 8, 2013 at 5:59 PM, Konstantin Khlebnikov
> <khlebnikov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>  wrote:
>> >  This is proof of concept, just basic functionality for IO controller.
>> >  This cgroup will control filesystem usage on vfs layer, it's main goal is
>> >  bandwidth control. It's supposed to be much more lightweight than memcg/blkio.
>> >
>> >  This patch shows easy way for accounting pages in dirty/writeback state in
>> >  per-inode manner. This is easier that doing this in memcg in per-page manner.
>> >  Main idea is in keeping on each inode pointer (->i_fsio) to cgroup which owns
>> >  dirty data in that inode. It's settled by fsio_account_page_dirtied() when
>> >  first dirty tag appears in the inode. Relying to mapping tags gives us locking
>> >  for free, this patch doesn't add any new locks to hot paths.
> While referring to dirty/writeback numbers, what I care about is 'how
> many dirties in how many memory' and later may use the proportion to
> decide throttling or something else. So if you are talking about nr of
> dirty pages without memcg's amount of memory, I don't see the meaning
> of a single number.

I'm planning to add some thresholds or limits to fsio cgroup -- how many dirty pages
this cgroup may have. memcg is completely different thing: memcg controls data storage
while fsio controls data flows. Memcg already handles too much, I just don't want add
yet another unrelated stuff into it. Otherwise we will end with one single controller
which would handle all possible resources, because they all related in some cases.

>
> What's more, counting dirty/writeback stats in per-node manner can
> bring inaccuracy in some situations: considering two tasks from
> different fsio cgroups are dirtying one file concurrently but may only
> be counting in one fsio stats, or a task is moved to another fsio
> cgroup after dirtrying one file. As talking about task moving, it is
> the root cause of adding memcg locks in page stat routines, since
> there's a race window between 'modify cgroup owner' and 'update stats
> using cgroup pointer'. But if you are going to handle task move or
> take care of ->i_fsio for better accuracy in future, I'm afraid you
> will also need some synchronization mechanism in hot paths. Maybe also
> a new lock or mapping->tree_lock(which is already hot enough) IMHO.

Yes, per-inode accounting is less accurate. But this approach works really
well in the real life. I don't want add new locks and loose performance just
to fix accuracy for some artificial cases.

to Tejun:
BTW I don't like that volatility of task's cgroup ponters. I'd like to forbid
moving tasks between cgroups except for 'current', existing behavior can be
kept with help of task_work: instead external change of task->cgroups we can
schedule task_work into it in and change that pointer in the 'current' context.
That will save us a lot of rcu_lock/unlock and atomic operations in grabbing
temporary pointers to current cgroup because current->cgroups will be stable.
I don't think that external cross-cgroup task migration is really performance
critical. Currently I don't know what to do with kernel threads and workqueues,
but any way this problem doesn't look unsolvable.
