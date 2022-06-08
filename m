From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v6 3/3] blk-cgroup: Optimize blkcg_rstat_flush()
Date: Wed, 8 Jun 2022 14:16:45 -0400
Message-ID: <506eaa3d-be84-c51e-3252-2979847054fe@redhat.com>
References: <20220602192020.166940-1-longman@redhat.com>
 <20220602192020.166940-4-longman@redhat.com>
 <20220608165732.GB19399@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654712210;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=puhUcvLRx9zat7PF7KwdoaGeUx8bqAUgfHHvV+ON4tg=;
        b=frsC9osYGpWdpHxJoJ5yuwAHyOSL1r/4wq+GgW5t3STu+2R5jQ9RYs3q5FpVhCq3W+Rr4Z
        POgiK9t7KzttCoA1zMELCYWJqLG5nXE+mhhZ7BFcReAhMssRXAHhRdGLU/qs/GVUE5zhm8
        bTqYdkUxTcJNJvuFJTF3zMEtwTs+kfE=
Content-Language: en-US
In-Reply-To: <20220608165732.GB19399@blackbody.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>
Cc: Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, Ming Lei <ming.lei@redhat.com>

On 6/8/22 12:57, Michal Koutný wrote:
> Hello.
>
> On Thu, Jun 02, 2022 at 03:20:20PM -0400, Waiman Long <longman@redhat.com> wrote:
>> As it is likely that not all the percpu blkg_iostat_set's has been
>> updated since the last flush, those stale blkg_iostat_set's don't need
>> to be flushed in this case.
> Yes, there's no point to flush stats for idle devices if there can be
> many of them. Good idea.
>
>> +static struct llist_node *fetch_delete_blkcg_llist(struct llist_head *lhead)
>> +{
>> +	return xchg(&lhead->first, &llist_last);
>> +}
>> +
>> +static struct llist_node *fetch_delete_lnode_next(struct llist_node *lnode)
>> +{
>> +	struct llist_node *next = READ_ONCE(lnode->next);
>> +	struct blkcg_gq *blkg = llist_entry(lnode, struct blkg_iostat_set,
>> +					    lnode)->blkg;
>> +
>> +	WRITE_ONCE(lnode->next, NULL);
>> +	percpu_ref_put(&blkg->refcnt);
>> +	return next;
>> +}
> Idea/just asking: would it make sense to generalize this into llist.c
> (this is basically llist_del_first() + llist_del_all() with a sentinel)?
> For the sake of reusability.

I have thought about that. It can be done as a follow-up patch to add a 
sentinel version into llist and use that instead. Of course, I can also 
update this patchset to include that.


>
>> +#define blkcg_llist_for_each_entry_safe(pos, node, nxt)			\
>> +	for (; (node != &llist_last) &&					\
>> +	       (pos = llist_entry(node, struct blkg_iostat_set, lnode),	\
>> +		nxt = fetch_delete_lnode_next(node), true);		\
>> +		node = nxt)
>> +
> It's good hygiene to parenthesize the args.
I am aware of that. I will certainly add that if it is a generic macro 
that can have many users.

>
>> @@ -2011,9 +2092,16 @@ void blk_cgroup_bio_start(struct bio *bio)
>>   	}
>>   	bis->cur.ios[rwd]++;
>>   
>> +	if (!READ_ONCE(bis->lnode.next)) {
>> +		struct llist_head *lhead = per_cpu_ptr(blkcg->lhead, cpu);
>> +
>> +		llist_add(&bis->lnode, lhead);
>> +		percpu_ref_get(&bis->blkg->refcnt);
>> +	}
>> +
> When a blkg's cgroup is rmdir'd, what happens with the lhead list?
> We have cgroup_rstat_exit() in css_free_rwork_fn() that ultimately flushes rstats.
> init_and_link_css however adds reference form blkcg->css to cgroup->css.
> The blkcg->css would be (transitively) pinned by the lhead list and
> hence would prevent the final flush (when refs drop to zero). Seems like
> a cyclic dependency.
>
> Luckily, there's also per-subsys flushing in css_release which could be
> moved after rmdir (offlining) but before last ref is gone:
>
> diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
> index adb820e98f24..d830e6a8fb3b 100644
> --- a/kernel/cgroup/cgroup.c
> +++ b/kernel/cgroup/cgroup.c
> @@ -5165,11 +5165,6 @@ static void css_release_work_fn(struct work_struct *work)
>
>          if (ss) {
>                  /* css release path */
> -               if (!list_empty(&css->rstat_css_node)) {
> -                       cgroup_rstat_flush(cgrp);
> -                       list_del_rcu(&css->rstat_css_node);
> -               }
> -
>                  cgroup_idr_replace(&ss->css_idr, NULL, css->id);
>                  if (ss->css_released)
>                          ss->css_released(css);
> @@ -5279,6 +5274,11 @@ static void offline_css(struct cgroup_subsys_state *css)
>          css->flags &= ~CSS_ONLINE;
>          RCU_INIT_POINTER(css->cgroup->subsys[ss->id], NULL);
>
> +       if (!list_empty(&css->rstat_css_node)) {
> +               cgroup_rstat_flush(css->cgrp);
> +               list_del_rcu(&css->rstat_css_node);
> +       }
> +
>          wake_up_all(&css->cgroup->offline_waitq);
>   }
>
> (not tested)

Good point.

Your change may not be enough since there could be update after the 
flush which will pin the blkg and hence blkcg.  I guess one possible 
solution may be to abandon the llist and revert back to list iteration 
when offline. I need to think a bit more about that.

>
>
>>   	u64_stats_update_end_irqrestore(&bis->sync, flags);
>>   	if (cgroup_subsys_on_dfl(io_cgrp_subsys))
>> -		cgroup_rstat_updated(bio->bi_blkg->blkcg->css.cgroup, cpu);
>> +		cgroup_rstat_updated(blkcg->css.cgroup, cpu);
> Maybe bundle the lhead list maintenace with cgroup_rstat_updated() under
> cgroup_subsys_on_dfl()? The stats can be read on v1 anyway.

I don't quite understand here. The change is not specific to v1 or v2. 
What do you mean by the stat is readable on v1?

Cheers,
Longman

