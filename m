From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v14 5/6] sched/core: uclamp: Update CPU's refcount on
 TG's clamp changes
Date: Fri, 30 Aug 2019 11:48:34 +0200
Message-ID: <20190830094834.GB2369@hirez.programming.kicks-ass.net>
References: <20190822132811.31294-1-patrick.bellasi@arm.com>
 <20190822132811.31294-6-patrick.bellasi@arm.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=PKLkBBrwktzoIAL7/V9IuDoU+f4BVjGqlqVhW17S6o4=; b=As1pAFviZ2UU9B0+0SzNSBCYv
        9+oue+ii5LBUF5/NUqfkAyYITd/SJz/5wQ2PYc5kOQtywSz1Q0SrjuAlUC0TlY60GmLqJWrXVoSY/
        LRYhMgyEKpN2IP8uadwOqPYt6p0KIG6BNS2+DnjF0a0Y60VchqV0DXrWYMvpWyibEpAXcG5QrzM3g
        EA9J74XOel0mtM2fyTPtoOMwMoNrc/TfPnjMy+tu6ZRwy1wQuth2hdDmd5KYjje0uko0UybFJMgEa
        dCMIPX2o2AVt/F4b4HIwAam68PB09LKYH8l7L13plZRYYpSw2bEP7tKKT712sNnreNmk1/2Sl8lQr
Content-Disposition: inline
In-Reply-To: <20190822132811.31294-6-patrick.bellasi@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Patrick Bellasi <patrick.bellasi@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-api@vger.kernel.org, cgroups@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Vincent Guittot <vincent.guittot@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>, Paul Turner <pjt@google.com>, Michal Koutny <mkoutny@suse.com>, Quentin Perret <quentin.perret@arm.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Morten Rasmussen <morten.rasmussen@arm.com>, Juri Lelli <juri.lelli@redhat.com>, Todd Kjos <tkjos@google.com>, Joel Fernandes <joelaf@google.com>, Steve Muckle <smuckle@google.com>, Suren Baghdasaryan <surenb@google.com>, Alessio Balsini <balsini@android.com>

On Thu, Aug 22, 2019 at 02:28:10PM +0100, Patrick Bellasi wrote:

> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 04fc161e4dbe..fc2dc86a2abe 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -1043,6 +1043,57 @@ static inline void uclamp_rq_dec(struct rq *rq, struct task_struct *p)
>  		uclamp_rq_dec_id(rq, p, clamp_id);
>  }
>  
> +static inline void
> +uclamp_update_active(struct task_struct *p, unsigned int clamp_id)
> +{
> +	struct rq_flags rf;
> +	struct rq *rq;
> +
> +	/*
> +	 * Lock the task and the rq where the task is (or was) queued.
> +	 *
> +	 * We might lock the (previous) rq of a !RUNNABLE task, but that's the
> +	 * price to pay to safely serialize util_{min,max} updates with
> +	 * enqueues, dequeues and migration operations.
> +	 * This is the same locking schema used by __set_cpus_allowed_ptr().
> +	 */
> +	rq = task_rq_lock(p, &rf);

Since modifying cgroup parameters is priv only, this should be OK I
suppose. Priv can already DoS the system anyway.

> +	/*
> +	 * Setting the clamp bucket is serialized by task_rq_lock().
> +	 * If the task is not yet RUNNABLE and its task_struct is not
> +	 * affecting a valid clamp bucket, the next time it's enqueued,
> +	 * it will already see the updated clamp bucket value.
> +	 */
> +	if (!p->uclamp[clamp_id].active)
> +		goto done;
> +
> +	uclamp_rq_dec_id(rq, p, clamp_id);
> +	uclamp_rq_inc_id(rq, p, clamp_id);
> +
> +done:

I'm thinking that:

	if (p->uclamp[clamp_id].active) {
		uclamp_rq_dec_id(rq, p, clamp_id);
		uclamp_rq_inc_id(rq, p, clamp_id);
	}

was too obvious? ;-)

> +
> +	task_rq_unlock(rq, p, &rf);
> +}
