From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v2 3/6] cgroup: cgroup v2 freezer
Date: Tue, 13 Nov 2018 16:37:01 +0100
Message-ID: <20181113153700.GB30990@redhat.com>
References: <20181112230422.5911-1-guro@fb.com>
 <20181112230422.5911-5-guro@fb.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181112230422.5911-5-guro@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guroan@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Roman Gushchin <guro@fb.com>

On 11/12, Roman Gushchin wrote:
>
> This patch implements freezer for cgroup v2. However the functionality
> is similar, the interface is different to cgroup v1: it follows
> cgroup v2 interface principles.

Oh, it seems that I actually need to apply this patch to (try to) understand
the details ;) Will try tomorrow.

> --- a/include/linux/sched/jobctl.h
> +++ b/include/linux/sched/jobctl.h
> @@ -18,6 +18,7 @@ struct task_struct;
>  #define JOBCTL_TRAP_NOTIFY_BIT	20	/* trap for NOTIFY */
>  #define JOBCTL_TRAPPING_BIT	21	/* switching to TRACED */
>  #define JOBCTL_LISTENING_BIT	22	/* ptracer is listening for events */
> +#define JOBCTL_TRAP_FREEZE_BIT	23	/* trap for cgroup freezer */
>
>  #define JOBCTL_STOP_DEQUEUED	(1UL << JOBCTL_STOP_DEQUEUED_BIT)
>  #define JOBCTL_STOP_PENDING	(1UL << JOBCTL_STOP_PENDING_BIT)
> @@ -26,8 +27,10 @@ struct task_struct;
>  #define JOBCTL_TRAP_NOTIFY	(1UL << JOBCTL_TRAP_NOTIFY_BIT)
>  #define JOBCTL_TRAPPING		(1UL << JOBCTL_TRAPPING_BIT)
>  #define JOBCTL_LISTENING	(1UL << JOBCTL_LISTENING_BIT)
> +#define JOBCTL_TRAP_FREEZE	(1UL << JOBCTL_TRAP_FREEZE_BIT)
>
> -#define JOBCTL_TRAP_MASK	(JOBCTL_TRAP_STOP | JOBCTL_TRAP_NOTIFY)
> +#define JOBCTL_TRAP_MASK	(JOBCTL_TRAP_STOP | JOBCTL_TRAP_NOTIFY | \
> +				 JOBCTL_TRAP_FREEZE)

Again, I didn't actually read the patch yet, but my gut feeling tells me
we shouldn't change JOBCTL_TRAP_MASK... and the fact you had to change
task_clear_jobctl_pending() to filter out JOBCTL_TRAP_FREEZE bit may be
proves this.

This

	if (current->jobctl & (JOBCTL_TRAP_STOP | JOBCTL_TRAP_NOTIFY))
	...
	else if (current->jobctl & JOBCTL_TRAP_FREEZE)

code in do_jobctl_trap() doesn't look nice too.

OK, please forget for now, but perhaps it would be more clean to add
JOBCTL_TRAP_FREEZE to the JOBCTL_PENDING_MASK check in recalc_sigpending()
and change get_signal to check JOBCTL_TRAP_MASK | JOBCTL_TRAP_FREEZE; and
I am not even sure cgroup_freezer_enter() should live in do_jobctl_trap().

> @@ -5642,6 +5700,23 @@ void cgroup_post_fork(struct task_struct *child)
>  			cset->nr_tasks++;
>  			css_set_move_task(child, NULL, cset, false);
>  		}
> +
> +		if (unlikely(cgroup_frozen(child) &&
> +			     (child->flags & ~PF_KTHREAD))) {
> +			struct cgroup *cgrp;
> +			unsigned long flags;
> +
> +			if (lock_task_sighand(child, &flags)) {

You can just do spin_lock_irq(siglock). The new child can't go away
until wake_up_new_task(), otherwise any usage of "child" including
lock_task_sighand() was not safe.

> +				cgrp = cset->dfl_cgrp;
> +				cgrp->freezer.nr_tasks_to_freeze++;
> +				WARN_ON_ONCE(cgrp->freezer.nr_tasks_to_freeze <
> +					     cgrp->freezer.nr_frozen_tasks);
> +				child->jobctl |= JOBCTL_TRAP_FREEZE;
> +				signal_wake_up(child, false);

signal_wake_up() is pointless.

wake_up_process() has no effect, set_tsk_thread_flag(TIF_SIGPENDING) is
not needed because schedule_tail() does calculate_sigpending() which should
notice JOBCTL_TRAP_FREEZE.

> +	} else if (current->jobctl & JOBCTL_TRAP_FREEZE) {
> +		/*
> +		 * Enter the freezer, unless the task is about to exit.
> +		 */
> +		if (fatal_signal_pending(current)) {
> +			current->jobctl &= ~JOBCTL_TRAP_FREEZE;

And again, please note that we need this because task_clear_jobctl_pending()
drops JOBCTL_TRAP_FREEZE. It shouldn't, I think...

Oleg.

