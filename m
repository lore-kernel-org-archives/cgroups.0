From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v6 4/7] cgroup: cgroup v2 freezer
Date: Fri, 25 Jan 2019 13:27:13 +0100
Message-ID: <20190125122713.GA18218@redhat.com>
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

Sorry, this version raced with my vacation, I missed it.

I'll try to read this code carefully but after a quick glance I have some
concerns,

On 12/21, Roman Gushchin wrote:
>
> +static void cgroup_update_frozen(struct cgroup *cgrp)
> +{
> +	bool frozen;
> +
> +	lockdep_assert_held(&css_set_lock);
> +
> +	/*
> +	 * If the cgroup has to be frozen (CGRP_FREEZE bit set),
> +	 * and all tasks are frozen or stopped, let's consider
> +	 * the cgroup frozen. Otherwise it's not frozen.
> +	 */
> +	frozen = test_bit(CGRP_FREEZE, &cgrp->flags) &&
> +		cgrp->freezer.nr_frozen_tasks +
> +		cgrp->freezer.nr_stopped_tasks ==
> +		cgrp->freezer.nr_tasks_to_freeze;

OK. Suppose that cgroup is frozen, CGRP_FROZEN is set, stopped == 0,
to_freeze = frozen.

One of the task is killed, it calls leave_frozen(). If I read this code path
correctly, only ->nr_frozen_tasks will be decremented, so "frozen" will be
"false" when cgroup_update_frozen() is called.

Doesn't this mean that this cgroup will no longer be CGRP_FROZEN even after
the killed task goes away completely?


Or. Suppose that another process picks a task from the CGRP_FROZEN cgroup and
does PTRACE_ATTACH + PTRACE_INTERRUPT. IIUC, the tracee will only increment
->nr_stopped_tasks, it won't touch other counters. Again, cgroup won't be FROZEN
until PTRACE_CONT'ed tracee does cgroup_leave_stopped() ? This looks strange at
least.



SIGSTOP. IIUC, a frozen task sleeping in do_freezer_trap() won't stop. However if
another thread has already called do_signal_stop(), the woken frozen task will
react to JOBCTL_STOP_PENDING and stop. And do_signal_stop()->cgroup_enter_stopped()
will "destroy" CGRP_FROZEN too, or I am totally confused.

OTOH, if you freeze a TASK_STOPPED task's cgroup, this task can react to SIGCONT,
notify its parent, then freeze again. This is fine, but iiuc this cgroup won't be
FROZEN in between, cgroup_file_notify() will be called twice...

Oleg.

