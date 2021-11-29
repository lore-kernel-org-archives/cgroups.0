From: Mathias Krause <minipli@grsecurity.net>
Subject: Re: [RFC PATCH] sched/fair: Filter by css_is_dying() in the last
 tg_unthrottle_up()
Date: Mon, 29 Nov 2021 12:33:35 +0100
Message-ID: <8691397e-eb57-764d-5b22-919f08519286@grsecurity.net>
References: <20211126130619.30730-1-mkoutny@suse.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+dwPC6u/G98GUEAXj4oJVU2LLr7Ev42qrE5A9zY1Zv4=;
        b=eGz1qCqBjb5ixAlh7ETS7XwWCXbQjyXBEgWzfQUCT3izFUYjHM+oIGdDGcS8BXjhCG
         Xq2QYUEawnQsfPgsTGn61cDjU/xPE/+YUhLyKvBEJPWxqb3Crr4OpP196Fp5WEGgJdBl
         PZ0mSkIAmi70NNvSF+AfZskdUnKnRJRZnVNoaWqzzi0KXEqlTJSyiN6WzPkX0Q1QVZPn
         Y7pJYnxwXOywHlgNRklcSFBPAeiMHpePQdYobfOVUn/hc9uyyNjwLuYN/xDpPSpF2uib
         088LtPBY0yoUd58DVjcBoEuNRqSH4O+LLgBJrv4Sw1Nv/DCqedxtW26HvWL/T4HiFb+C
         s2Uw==
In-Reply-To: <20211126130619.30730-1-mkoutny@suse.com>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Cc: Valentin.Schneider@arm.com, bristot@redhat.com, bsegall@google.com, dietmar.eggemann@arm.com, juri.lelli@redhat.com, kevin.tanguy@corp.ovh.com, mgorman@suse.de, mingo@redhat.com, odin@uged.al, peterz@infradead.org, rostedt@goodmis.org, spender@grsecurity.net, vincent.guittot@linaro.org, tj@kernel.org

Am 26.11.21 um 14:06 schrieb Michal Koutný:
> The commit b027789e5e50 ("sched/fair: Prevent dead task groups from
> regaining cfs_rq's") tackled the issue of use-after-free of cfs_rqs
> surviving on the leaf list after cgroup removal. Two key changes of the
> fix are:
> - move destroy_cfs_bandwidth() before the list_del_leaf_cfs_rq() so that
>   tg_unthrottle_up(cfs_rq) will not re-add the cfs_rq into the list,
> - insert RCU GP between task_group tree unlinking and leaf list removal
>   (ancestors walk the tree and could call tg_unthrottle_up() (re-add)
>   too).
> 
> This is correct but it makes the task_group removal path in cpu
> controller unnecessarily complex. This patch simplifies the code by
> removing the GP but ensuring that cfs_rq won't be re-added when it is
> going away. The css_is_dying() check and list_add_leaf_cfs_rq() cannot
> race against sched_released_group() because they are both in one RCU
> read section and cpu_cgroup_css_released() is called after an RCU GP
> (more precisely the sequence is: rmdir, css_is_dying()=1, GP,
> .css_offline(), .css_released()).
> 
> Autogroups are not cgroups so they are not affected by bandwidth timer
> (GP before free is kept).
> 
> Cc: Tejun Heo <tj@kernel.org>
> Signed-off-by: Michal Koutný <mkoutny@suse.com>
> ---
>  kernel/sched/autogroup.c | 10 ++++++--
>  kernel/sched/core.c      | 55 ++++++++--------------------------------
>  kernel/sched/fair.c      |  6 +++++
>  kernel/sched/sched.h     |  4 +--
>  4 files changed, 27 insertions(+), 48 deletions(-)
> 
> As explained in the message, this relies on the RCU GP between css_is_dying()
> returning false and the potential .css_offline() call. 
> This is stated in the css_is_dying() documentation:
> 
>> the actual offline operations are RCU delayed and this test returns %true
>> also when @css is scheduled to be offlined.
> 
> On the other hand the documentation of the underlying
> percpu_ref_kill_and_confirm() says (to discourage relying on GP):
> 
>> There are no implied RCU grace periods between kill and release.
> 
> This seems to discord with each other at first thought. (That's why I marked
> this RFC.)
> 
> However, if one takes into account that percpu_refs as used by css are never
> switched to atomic besides the actual killing (and they start in per-cpu mode),
> the GP (inserted in __percpu_ref_switch_to_atomic()) is warranted.

This feels fragile and is very implicit. It, at least, needs a
corresponding mention in the comment above the call to
percpu_ref_kill_and_confirm(). But even then, the RCU GP is an
implementation detail of percpu_refs and us relying on it is kind of
ignoring the API guarantees. Doesn't feel right. :/

> 
> 
> diff --git a/kernel/sched/autogroup.c b/kernel/sched/autogroup.c
> index 8629b37d118e..e53d1ea9afc0 100644
> --- a/kernel/sched/autogroup.c
> +++ b/kernel/sched/autogroup.c
> @@ -22,6 +22,11 @@ void autogroup_free(struct task_group *tg)
>  	kfree(tg->autogroup);
>  }
>  
> +static void sched_free_group_rcu(struct rcu_head *rcu)
> +{
> +	sched_free_group(container_of(rcu, struct task_group, rcu));
> +}
> +
>  static inline void autogroup_destroy(struct kref *kref)
>  {
>  	struct autogroup *ag = container_of(kref, struct autogroup, kref);
> @@ -31,8 +36,9 @@ static inline void autogroup_destroy(struct kref *kref)
>  	ag->tg->rt_se = NULL;
>  	ag->tg->rt_rq = NULL;
>  #endif
> -	sched_release_group(ag->tg);
> -	sched_destroy_group(ag->tg);
> +	sched_released_group(ag->tg);
> +	/* Wait for possible concurrent references to cfs_rqs complete: */
> +	call_rcu(&ag->tg->rcu, sched_free_group_rcu);
>  }

However, I do like the above cleanup, as it adds an explicit RCU only to
autogroup, which needs it, instead to adding it too all other users.

>  
>  static inline void autogroup_kref_put(struct autogroup *ag)
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 3c9b0fda64ac..2c5b22f54ab8 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -9711,7 +9711,7 @@ static inline void alloc_uclamp_sched_group(struct task_group *tg,
>  #endif
>  }
>  
> -static void sched_free_group(struct task_group *tg)
> +void sched_free_group(struct task_group *tg)
>  {
>  	free_fair_sched_group(tg);
>  	free_rt_sched_group(tg);
> @@ -9719,22 +9719,6 @@ static void sched_free_group(struct task_group *tg)
>  	kmem_cache_free(task_group_cache, tg);
>  }
>  
> -static void sched_free_group_rcu(struct rcu_head *rcu)
> -{
> -	sched_free_group(container_of(rcu, struct task_group, rcu));
> -}
> -
> -static void sched_unregister_group(struct task_group *tg)
> -{
> -	unregister_fair_sched_group(tg);
> -	unregister_rt_sched_group(tg);
> -	/*
> -	 * We have to wait for yet another RCU grace period to expire, as
> -	 * print_cfs_stats() might run concurrently.
> -	 */
> -	call_rcu(&tg->rcu, sched_free_group_rcu);
> -}
> -
>  /* allocate runqueue etc for a new task group */
>  struct task_group *sched_create_group(struct task_group *parent)
>  {
> @@ -9777,40 +9761,23 @@ void sched_online_group(struct task_group *tg, struct task_group *parent)
>  	online_fair_sched_group(tg);
>  }
>  
> -/* rcu callback to free various structures associated with a task group */
> -static void sched_unregister_group_rcu(struct rcu_head *rhp)
> -{
> -	/* Now it should be safe to free those cfs_rqs: */
> -	sched_unregister_group(container_of(rhp, struct task_group, rcu));
> -}
> -
> -void sched_destroy_group(struct task_group *tg)
> -{
> -	/* Wait for possible concurrent references to cfs_rqs complete: */
> -	call_rcu(&tg->rcu, sched_unregister_group_rcu);
> -}
> -
> -void sched_release_group(struct task_group *tg)
> +void sched_released_group(struct task_group *tg)
>  {
>  	unsigned long flags;
>  
>  	/*
> -	 * Unlink first, to avoid walk_tg_tree_from() from finding us (via
> -	 * sched_cfs_period_timer()).
> -	 *
> -	 * For this to be effective, we have to wait for all pending users of
> -	 * this task group to leave their RCU critical section to ensure no new
> -	 * user will see our dying task group any more. Specifically ensure
> -	 * that tg_unthrottle_up() won't add decayed cfs_rq's to it.
> -	 *
> -	 * We therefore defer calling unregister_fair_sched_group() to
> -	 * sched_unregister_group() which is guarantied to get called only after the
> -	 * current RCU grace period has expired.
> +	 * We get here only after all CPUs see tg as dying and an RCU grace
> +	 * period. Despite that there may still be concurrent RCU readers
> +	 * (walk_tg_tree_from() or task_group list) in their RCU sections.
> +	 * Their references to tg stay valid only inside the RCU read section.
>  	 */
>  	spin_lock_irqsave(&task_group_lock, flags);
>  	list_del_rcu(&tg->list);
>  	list_del_rcu(&tg->siblings);
>  	spin_unlock_irqrestore(&task_group_lock, flags);
> +
> +	unregister_fair_sched_group(tg);
> +	unregister_rt_sched_group(tg);
>  }
>  
>  static void sched_change_group(struct task_struct *tsk, int type)
> @@ -9925,7 +9892,7 @@ static void cpu_cgroup_css_released(struct cgroup_subsys_state *css)
>  {
>  	struct task_group *tg = css_tg(css);
>  
> -	sched_release_group(tg);
> +	sched_released_group(tg);
>  }
>  
>  static void cpu_cgroup_css_free(struct cgroup_subsys_state *css)
> @@ -9935,7 +9902,7 @@ static void cpu_cgroup_css_free(struct cgroup_subsys_state *css)
>  	/*
>  	 * Relies on the RCU grace period between css_released() and this.
>  	 */
> -	sched_unregister_group(tg);
> +	sched_free_group(tg);
>  }
>  
>  /*
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 6e476f6d9435..b3081ece2e16 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -4762,6 +4762,12 @@ static int tg_unthrottle_up(struct task_group *tg, void *data)
>  		cfs_rq->throttled_clock_task_time += rq_clock_task(rq) -
>  					     cfs_rq->throttled_clock_task;
>  
> +		/*
> +		 * Last tg_unthrottle_up() may happen in a task_group being removed,
> +		 * it is only RCU protected so don't store it into leaf list.
> +		 */
> +		if (css_is_dying(&tg->css))
> +			return 0;

This, however, looks like band aid. I'd rather not call
tg_unthrottle_up() on a dying css.

>  		/* Add cfs_rq with load or one or more already running entities to the list */
>  		if (!cfs_rq_is_decayed(cfs_rq) || cfs_rq->nr_running)
>  			list_add_leaf_cfs_rq(cfs_rq);
> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
> index 0e66749486e7..560151258d92 100644
> --- a/kernel/sched/sched.h
> +++ b/kernel/sched/sched.h
> @@ -503,8 +503,8 @@ extern int sched_rt_can_attach(struct task_group *tg, struct task_struct *tsk);
>  extern struct task_group *sched_create_group(struct task_group *parent);
>  extern void sched_online_group(struct task_group *tg,
>  			       struct task_group *parent);
> -extern void sched_destroy_group(struct task_group *tg);
> -extern void sched_release_group(struct task_group *tg);
> +extern void sched_released_group(struct task_group *tg);
> +extern void sched_free_group(struct task_group *tg);
>  
>  extern void sched_move_task(struct task_struct *tsk);
>  
> 

Thanks,
Mathias
