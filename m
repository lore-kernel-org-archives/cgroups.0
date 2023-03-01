From: shrikanth hegde <sshegde-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v12 8/8] sched/fair: Add latency list
Date: Thu, 2 Mar 2023 01:01:47 +0530
Message-ID: <be67535c-8b5f-4549-f24c-e41066654204@linux.vnet.ibm.com>
References: <20230224093454.956298-1-vincent.guittot@linaro.org>
 <20230224093454.956298-9-vincent.guittot@linaro.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=SWTxDgtU7Ij8HjMbL5Mgty6/kkR9J3iEHhXS27eyMM4=;
 b=KFIte8BKkQBsWcJ1vAJoGdJBuP+jOnIg0b+PWvh+o++944CROhFxJ1I8gSuSKwi4tQIL
 G69dqssJXRdYLIy5sdEm8Ja/uFf26auVTnYe9XQ0xc701KGU41Y55qrph9TdADtL6GGY
 ZNd5yRnACWGA/Pv5uJmrC9zZO4spEbD15+RbYK8mish6aH/N9l0aevxopWBp2oG8dwzO
 mTSMxvEoD1ga+plKTS2oNXt/D3qr2ZRsKPPALneX1Pec71URjL0e4AEa1jgayh6RcZIA
 k1BKuXbANy/pcIady9LsVyFqUoYJaU77YEunVM7PD7c7TVEuSpyzV1un248ecp4edgOf PQ== 
Content-Language: en-US
In-Reply-To: <20230224093454.956298-9-vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: qyousef-wp2msK0BRk8tq7phqP6ubQ@public.gmane.org, chris.hyser-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, patrick.bellasi-X6neQFFVdzGsTnJN9+BGXg@public.gmane.org, David.Laight-JxhZ9S5GRejQT0dZR+AlfA@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, pavel-+ZI9xUNit7I@public.gmane.org, qperret-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, joshdon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, timj-mXXj517/zsQ@public.gmane.org, kprateek.nayak-5C7GfCeVMHo@public.gmane.org, yu.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, youssefesmat-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dietmar.eggemann-5wv7dgnIgG8@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, parth-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



On 2/24/23 3:04 PM, Vincent Guittot wrote:
> Add a rb tree for latency sensitive entities so we can schedule the most
> sensitive one first even when it failed to preempt current at wakeup or
> when it got quickly preempted by another entity of higher priority.
>
> In order to keep fairness, the latency is used once at wakeup to get a
> minimum slice and not during the following scheduling slice to prevent
> long running entity to got more running time than allocated to his nice
> priority.
>
> The rb tree enables to cover the last corner case where latency
> sensitive entity can't got schedule quickly after the wakeup.
>
> Signed-off-by: Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> Tested-by: K Prateek Nayak <kprateek.nayak-5C7GfCeVMHo@public.gmane.org>
> ---
>  include/linux/sched.h |   1 +
>  kernel/sched/core.c   |   1 +
>  kernel/sched/fair.c   | 109 ++++++++++++++++++++++++++++++++++++++++--
>  kernel/sched/sched.h  |   1 +
>  4 files changed, 109 insertions(+), 3 deletions(-)
>
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 38decae3e156..41bb92be5ecc 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -548,6 +548,7 @@ struct sched_entity {
>  	/* For load-balancing: */
>  	struct load_weight		load;
>  	struct rb_node			run_node;
> +	struct rb_node			latency_node;
>  	struct list_head		group_node;
>  	unsigned int			on_rq;
>  
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 093cc1af73dc..752fd364216c 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -4434,6 +4434,7 @@ static void __sched_fork(unsigned long clone_flags, struct task_struct *p)
>  	p->se.nr_migrations		= 0;
>  	p->se.vruntime			= 0;
>  	INIT_LIST_HEAD(&p->se.group_node);
> +	RB_CLEAR_NODE(&p->se.latency_node);
>  
>  #ifdef CONFIG_FAIR_GROUP_SCHED
>  	p->se.cfs_rq			= NULL;
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 125a6ff53378..e2aeb4511686 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -680,7 +680,85 @@ struct sched_entity *__pick_last_entity(struct cfs_rq *cfs_rq)
>  
>  	return __node_2_se(last);
>  }
> +#endif
>  
> +/**************************************************************
> + * Scheduling class tree data structure manipulation methods:
> + * for latency
> + */
> +
> +static inline bool latency_before(struct sched_entity *a,
> +				struct sched_entity *b)
> +{
> +	return (s64)(a->vruntime + a->latency_offset - b->vruntime - b->latency_offset) < 0;
> +}
> +
> +#define __latency_node_2_se(node) \
> +	rb_entry((node), struct sched_entity, latency_node)
> +
> +static inline bool __latency_less(struct rb_node *a, const struct rb_node *b)
> +{
> +	return latency_before(__latency_node_2_se(a), __latency_node_2_se(b));
> +}
> +
> +/*
> + * Enqueue an entity into the latency rb-tree:
> + */
> +static void __enqueue_latency(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
> +{
> +
> +	/* Only latency sensitive entity can be added to the list */
> +	if (se->latency_offset >= 0)
> +		return;
> +
> +	if (!RB_EMPTY_NODE(&se->latency_node))
> +		return;
> +
> +	/*
> +	 * The entity is always added the latency list at wakeup.
> +	 * Then, a not waking up entity that is put back in the list after an
> +	 * execution time less than sysctl_sched_min_granularity, means that
> +	 * the entity has been preempted by a higher sched class or an entity
> +	 * with higher latency constraint. In thi case, the entity is also put
> +	 * back in the latency list so it gets a chance to run 1st during the
> +	 * next slice.
> +	 */
> +	if (!(flags & ENQUEUE_WAKEUP)) {
> +		u64 delta_exec = se->sum_exec_runtime - se->prev_sum_exec_runtime;
> +
> +		if (delta_exec >= sysctl_sched_min_granularity)
> +			return;
> +	}
> +
> +	rb_add_cached(&se->latency_node, &cfs_rq->latency_timeline, __latency_less);
> +}
> +
> +/*
> + * Dequeue an entity from the latency rb-tree and return true if it was really
> + * part of the rb-tree:
> + */
> +static bool __dequeue_latency(struct cfs_rq *cfs_rq, struct sched_entity *se)
> +{
> +	if (!RB_EMPTY_NODE(&se->latency_node)) {
> +		rb_erase_cached(&se->latency_node, &cfs_rq->latency_timeline);
> +		RB_CLEAR_NODE(&se->latency_node);
> +		return true;
> +	}
> +
> +	return false;
> +}
> +
> +static struct sched_entity *__pick_first_latency(struct cfs_rq *cfs_rq)
> +{
> +	struct rb_node *left = rb_first_cached(&cfs_rq->latency_timeline);
> +
> +	if (!left)
> +		return NULL;
> +
> +	return __latency_node_2_se(left);
> +}
> +
> +#ifdef CONFIG_SCHED_DEBUG
>  /**************************************************************
>   * Scheduling class statistics methods:
>   */
> @@ -4758,8 +4836,10 @@ enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
>  	check_schedstat_required();
>  	update_stats_enqueue_fair(cfs_rq, se, flags);
>  	check_spread(cfs_rq, se);
> -	if (!curr)
> +	if (!curr) {
>  		__enqueue_entity(cfs_rq, se);
> +		__enqueue_latency(cfs_rq, se, flags);
> +	}
>  	se->on_rq = 1;
>  
>  	if (cfs_rq->nr_running == 1) {
> @@ -4845,8 +4925,10 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
>  
>  	clear_buddies(cfs_rq, se);
>  
> -	if (se != cfs_rq->curr)
> +	if (se != cfs_rq->curr) {
>  		__dequeue_entity(cfs_rq, se);
> +		__dequeue_latency(cfs_rq, se);
> +	}
>  	se->on_rq = 0;
>  	account_entity_dequeue(cfs_rq, se);
>  
> @@ -4941,6 +5023,7 @@ set_next_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
>  		 */
>  		update_stats_wait_end_fair(cfs_rq, se);
>  		__dequeue_entity(cfs_rq, se);
> +		__dequeue_latency(cfs_rq, se);
>  		update_load_avg(cfs_rq, se, UPDATE_TG);
>  	}
>  
> @@ -4979,7 +5062,7 @@ static struct sched_entity *
>  pick_next_entity(struct cfs_rq *cfs_rq, struct sched_entity *curr)
>  {
>  	struct sched_entity *left = __pick_first_entity(cfs_rq);
> -	struct sched_entity *se;
> +	struct sched_entity *latency, *se;

can this variable be se_latency? 

Sorry, I should have put this in the previous reply itself.

>  
>  	/*
>  	 * If curr is set we have to see if its left of the leftmost entity
> @@ -5021,6 +5104,12 @@ pick_next_entity(struct cfs_rq *cfs_rq, struct sched_entity *curr)
>  		se = cfs_rq->last;
>  	}
>  
> +	/* Check for latency sensitive entity waiting for running */
> +	latency = __pick_first_latency(cfs_rq);
> +	if (latency && (latency != se) &&
> +	    wakeup_preempt_entity(latency, se) < 1)
> +		se = latency;
> +
>  	return se;
>  }
>  
> @@ -5044,6 +5133,7 @@ static void put_prev_entity(struct cfs_rq *cfs_rq, struct sched_entity *prev)
>  		update_stats_wait_start_fair(cfs_rq, prev);
>  		/* Put 'current' back into the tree. */
>  		__enqueue_entity(cfs_rq, prev);
> +		__enqueue_latency(cfs_rq, prev, 0);
>  		/* in !on_rq case, update occurred at dequeue */
>  		update_load_avg(cfs_rq, prev, 0);
>  	}
> @@ -12222,6 +12312,7 @@ static void set_next_task_fair(struct rq *rq, struct task_struct *p, bool first)
>  void init_cfs_rq(struct cfs_rq *cfs_rq)
>  {
>  	cfs_rq->tasks_timeline = RB_ROOT_CACHED;
> +	cfs_rq->latency_timeline = RB_ROOT_CACHED;
>  	u64_u32_store(cfs_rq->min_vruntime, (u64)(-(1LL << 20)));
>  #ifdef CONFIG_SMP
>  	raw_spin_lock_init(&cfs_rq->removed.lock);
> @@ -12378,6 +12469,7 @@ void init_tg_cfs_entry(struct task_group *tg, struct cfs_rq *cfs_rq,
>  	se->my_q = cfs_rq;
>  
>  	se->latency_offset = calc_latency_offset(tg->latency_prio);
> +	RB_CLEAR_NODE(&se->latency_node);
>  
>  	/* guarantee group entities always have weight */
>  	update_load_set(&se->load, NICE_0_LOAD);
> @@ -12529,8 +12621,19 @@ int sched_group_set_latency(struct task_group *tg, int prio)
>  
>  	for_each_possible_cpu(i) {
>  		struct sched_entity *se = tg->se[i];
> +		struct rq *rq = cpu_rq(i);
> +		struct rq_flags rf;
> +		bool queued;
> +
> +		rq_lock_irqsave(rq, &rf);
>  
> +		queued = __dequeue_latency(se->cfs_rq, se);
>  		WRITE_ONCE(se->latency_offset, latency_offset);
> +		if (queued)
> +			__enqueue_latency(se->cfs_rq, se, ENQUEUE_WAKEUP);
> +
> +
> +		rq_unlock_irqrestore(rq, &rf);
>  	}
>  
>  	mutex_unlock(&shares_mutex);
> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
> index 9a2e71231083..21dd309e98a9 100644
> --- a/kernel/sched/sched.h
> +++ b/kernel/sched/sched.h
> @@ -570,6 +570,7 @@ struct cfs_rq {
>  #endif
>  
>  	struct rb_root_cached	tasks_timeline;
> +	struct rb_root_cached	latency_timeline;
>  
>  	/*
>  	 * 'curr' points to currently running entity on this cfs_rq.

