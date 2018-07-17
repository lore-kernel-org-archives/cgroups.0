From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 09/10] psi: cgroup support
Date: Tue, 17 Jul 2018 17:40:59 +0200
Message-ID: <20180717154059.GB2476@hirez.programming.kicks-ass.net>
References: <20180712172942.10094-1-hannes@cmpxchg.org>
 <20180712172942.10094-10-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=iNAjETrR5c7BDYGuWnQBomWlbWRoOKw/fyTQZw45yV4=; b=XfyWS/wwW77zx27Q51FmI+vEU
        Nsd/PRWzhvrGhM2k3YLj3aAymglQQsROWjP82T/jyCRBZQAoaq7gpUovFd2eB8iFNjt2WCNY10lqx
        a4OCKUVGy6aQtCIWC0zeYjL1/EXizXkd9yBND21terBlI7EyU+ZPMXp7jw3LbEWggavNYYteZEAcM
        XGNoDxl+rnG51vmh5tUwfPZQtKsCe7Pp9nyfk36pAct9/1INHJlBDhGT27AqPDRjRMsq1nx71qQH1
        ji73rZVzqC9cI1DS+VoX7ibQnU7IyrWeyJVZknPGjZeX514c/40/sAxlip1SBXHaCqHDVggST5kU6
      
Content-Disposition: inline
In-Reply-To: <20180712172942.10094-10-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Vinayak Menon <vinmenon@codeaurora.org>, Christopher Lameter <cl@linux.com>, Mike Galbraith <efault@gmx.de>, Shakeel Butt <shakeelb@google.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Thu, Jul 12, 2018 at 01:29:41PM -0400, Johannes Weiner wrote:
> +/**
> + * cgroup_move_task - move task to a different cgroup
> + * @task: the task
> + * @to: the target css_set
> + *
> + * Move task to a new cgroup and safely migrate its associated stall
> + * state between the different groups.
> + *
> + * This function acquires the task's rq lock to lock out concurrent
> + * changes to the task's scheduling state and - in case the task is
> + * running - concurrent changes to its stall state.
> + */
> +void cgroup_move_task(struct task_struct *task, struct css_set *to)
> +{
> +	unsigned int task_flags = 0;
> +	struct rq_flags rf;
> +	struct rq *rq;
> +	u64 now;
> +
> +	rq = task_rq_lock(task, &rf);
> +
> +	if (task_on_rq_queued(task)) {
> +		task_flags = TSK_RUNNING;
> +	} else if (task->in_iowait) {
> +		task_flags = TSK_IOWAIT;
> +	}
> +	if (task->flags & PF_MEMSTALL)
> +		task_flags |= TSK_MEMSTALL;
> +
> +	if (task_flags) {
> +		update_rq_clock(rq);
> +		now = rq_clock(rq);
> +		psi_task_change(task, now, task_flags, 0);
> +	}
> +
> +	/*
> +	 * Lame to do this here, but the scheduler cannot be locked
> +	 * from the outside, so we move cgroups from inside sched/.
> +	 */
> +	rcu_assign_pointer(task->cgroups, to);
> +
> +	if (task_flags)
> +		psi_task_change(task, now, 0, task_flags);
> +
> +	task_rq_unlock(rq, task, &rf);
> +}

Why is that not part of cpu_cgroup_attach() / sched_move_task() ?
