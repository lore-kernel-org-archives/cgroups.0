From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] Add a file named cgroup.procs_stat in cgroup
Date: Fri, 4 May 2018 17:43:50 +0200
Message-ID: <20180504154350.GN12217@hirez.programming.kicks-ass.net>
References: <1525444100-4858-1-git-send-email-qiangzh.hust@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=YQl9k7/Aza8bPTd+U1kC7KzEisZyuIRnNTJMd45LJ6E=; b=rHo/jjcJmGu+H+zMaG0SwEObQ
        6BGflJjodDubkAlyASoGmQkmD5MYTW9PoespIIc2o8b1YNvGz1Rynqbr4NXEltv2MukycOQRdi1Fi
        1mrmdMja+hhh/nqtGfpf8FBPlyKsY+LO1Mn1lE7E0bJOJ7CGVFi8My60uTTBelVzMOYfdLrXq3bU2
        GlTVV7IiL2T1iMV+cIqdScgqtleWC79sKpWFZVpqX7QfyafGyUiDYdTphL172yxtoEvahTl+oLEWg
        XV30N8forZAeLDcIezWQ6GqUEiPxn+9Sgoqh9YliD+ttinsjvqFJN1BN6tFSLnP0I3tBdMd0F0038
    
Content-Disposition: inline
In-Reply-To: <1525444100-4858-1-git-send-email-qiangzh.hust@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: zhangq95 <qiangzh.hust@gmail.com>
Cc: linux-kernel@vger.kernel.org, tj@kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, mingo@redhat.com, cgroups@vger.kernel.org, riel@redhat.com, gs051095@gmail.com, akpm@linux-foundation.org, oleg@redhat.com, tglx@linutronix.de, keescook@chromium.org, gregkh@linuxfoundation.org, longman@redhat.com, prsood@codeaurora.org, guro@fb.com, davem@davemloft.net, mhocko@suse.com, kirill.shutemov@linux.intel.com, marcos.souza.org@gmail.com, hoeun.ryu@gmail.com, rostedt@goodmis.org, bigeasy@linutronix.de, alexander.levin@verizon.com, paulmck@linux.vnet.ibm.com, fweisbec@gmail.com

On Fri, May 04, 2018 at 10:28:20PM +0800, zhangq95 wrote:
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 5e10aae..ba969af 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -3404,11 +3404,19 @@ static void __sched notrace __schedule(bool preempt)
>  	struct rq_flags rf;
>  	struct rq *rq;
>  	int cpu;
> +	struct task_struct *prev_root = NULL, *next_root = NULL;
>  
>  	cpu = smp_processor_id();
>  	rq = cpu_rq(cpu);
>  	prev = rq->curr;
>  
> +	if (task_active_pid_ns(prev)) {
> +		prev_root = task_active_pid_ns(prev)->child_reaper;
> +		if (prev_root != init_pid_ns.child_reaper)
> +			update_cpuacct_procs_stat(prev, prev->cpu,
> +				CPUACCT_PROCS_SWITCHES, 1, 0);
> +	}
> +
>  	schedule_debug(prev);
>  
>  	if (sched_feat(HRTICK))
> @@ -3462,6 +3470,12 @@ static void __sched notrace __schedule(bool preempt)
>  	}
>  
>  	next = pick_next_task(rq, prev, &rf);
> +	if (task_active_pid_ns(next)) {
> +		next_root = task_active_pid_ns(next)->child_reaper;
> +		if (prev_root && prev_root != next_root)
> +			update_cpuacct_procs_stat(next, next->cpu,
> +				CPUACCT_PROCS_SWITCHES, 1, 0);
> +	}
>  	clear_tsk_need_resched(prev);
>  	clear_preempt_need_resched();
>  

> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 54dc31e..46adf63 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -4757,6 +4774,7 @@ static void throttle_cfs_rq(struct cfs_rq *cfs_rq)
>  		if (dequeue)
>  			dequeue_entity(qcfs_rq, se, DEQUEUE_SLEEP);
>  		qcfs_rq->h_nr_running -= task_delta;
> +		update_cpuacct_running_from_cfs(qcfs_rq, -task_delta);
>  
>  		if (qcfs_rq->load.weight)
>  			dequeue = 0;
> @@ -4820,6 +4838,7 @@ void unthrottle_cfs_rq(struct cfs_rq *cfs_rq)
>  		if (enqueue)
>  			enqueue_entity(cfs_rq, se, ENQUEUE_WAKEUP);
>  		cfs_rq->h_nr_running += task_delta;
> +		update_cpuacct_running_from_cfs(cfs_rq, task_delta);
>  
>  		if (cfs_rq_throttled(cfs_rq))
>  			break;
> @@ -5379,6 +5398,7 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
>  		if (cfs_rq_throttled(cfs_rq))
>  			break;
>  		cfs_rq->h_nr_running++;
> +		update_cpuacct_running_from_cfs(cfs_rq, 1);
>  
>  		flags = ENQUEUE_WAKEUP;
>  	}
> @@ -5386,6 +5406,7 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
>  	for_each_sched_entity(se) {
>  		cfs_rq = cfs_rq_of(se);
>  		cfs_rq->h_nr_running++;
> +		update_cpuacct_running_from_cfs(cfs_rq, 1);
>  
>  		if (cfs_rq_throttled(cfs_rq))
>  			break;
> @@ -5427,6 +5448,7 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
>  		if (cfs_rq_throttled(cfs_rq))
>  			break;
>  		cfs_rq->h_nr_running--;
> +		update_cpuacct_running_from_cfs(cfs_rq, -1);
>  
>  		/* Don't dequeue parent if it has other entities besides us */
>  		if (cfs_rq->load.weight) {
> @@ -5446,6 +5468,7 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
>  	for_each_sched_entity(se) {
>  		cfs_rq = cfs_rq_of(se);
>  		cfs_rq->h_nr_running--;
> +		update_cpuacct_running_from_cfs(cfs_rq, -1);
>  
>  		if (cfs_rq_throttled(cfs_rq))
>  			break;
> diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
> index 7aef6b4..766ec16 100644
> --- a/kernel/sched/rt.c
> +++ b/kernel/sched/rt.c
> @@ -1327,6 +1327,7 @@ enqueue_task_rt(struct rq *rq, struct task_struct *p, int flags)
>  		rt_se->timeout = 0;
>  
>  	enqueue_rt_entity(rt_se, flags);
> +	update_cpuacct_procs_stat(p, cpu_of(rq), CPUACCT_PROCS_RUNNING, 1, 0);
>  
>  	if (!task_current(rq, p) && p->nr_cpus_allowed > 1)
>  		enqueue_pushable_task(rq, p);
> @@ -1338,6 +1339,7 @@ static void dequeue_task_rt(struct rq *rq, struct task_struct *p, int flags)
>  
>  	update_curr_rt(rq);
>  	dequeue_rt_entity(rt_se, flags);
> +	update_cpuacct_procs_stat(p, cpu_of(rq), CPUACCT_PROCS_RUNNING, -1, 0);
>  
>  	dequeue_pushable_task(rq, p);
>  }


Yeah, I think not... death by accounting.
