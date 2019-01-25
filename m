From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v6 4/7] cgroup: cgroup v2 freezer
Date: Fri, 25 Jan 2019 14:43:36 +0100
Message-ID: <20190125134336.GA18991@redhat.com>
References: <20181222000307.28231-1-guro@fb.com>
 <20181222000307.28231-5-guro@fb.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181222000307.28231-5-guro@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guroan@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Roman Gushchin <guro@fb.com>

On 12/21, Roman Gushchin wrote:
>
> +static void cgroup_do_freeze(struct cgroup *cgrp, bool freeze)
> +{
> +	struct css_task_iter it;
> +	struct task_struct *task;
> +
> +	lockdep_assert_held(&cgroup_mutex);
> +
> +	spin_lock_irq(&css_set_lock);
> +	if (freeze) {
> +		cgrp->freezer.nr_tasks_to_freeze = __cgroup_task_count(cgrp);
> +		set_bit(CGRP_FREEZE, &cgrp->flags);
> +	} else {
> +		clear_bit(CGRP_FREEZE, &cgrp->flags);
> +	}
> +	spin_unlock_irq(&css_set_lock);
> +
> +	css_task_iter_start(&cgrp->self, 0, &it);
> +	while ((task = css_task_iter_next(&it))) {
> +		/*
> +		 * Ignore kernel threads here. Freezing cgroups containing
> +		 * kthreads isn't supported.
> +		 */
> +		if (task->flags & PF_KTHREAD)
> +			continue;
> +		cgroup_freeze_task(task, freeze);
> +	}
> +	css_task_iter_end(&it);

I don't understand why this can race with exiting task. Or with SIGKILL which
kills a task before it sets current->frozen.

How can we trust nr_tasks_to_freeze at all?

Yes you added cgroup_dec_tasks_to_freeze() into cgroup_exit(). But it won't be
called if CGRP_FROZEN was not set yet, or because of "spurious" transitions
caused by cgroup_inc/dec_frozen_cnt() called by this or other tasks.

it seems that cgroup_exit() should check CGRP_FREEZE instead...

Oleg.

