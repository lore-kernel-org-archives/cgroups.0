From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v10 4/9] cgroup: cgroup v2 freezer
Date: Fri, 19 Apr 2019 17:19:12 +0200
Message-ID: <20190419151912.GA12152@redhat.com>
References: <20190405174708.1010-1-guro@fb.com>
 <20190405174708.1010-5-guro@fb.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190405174708.1010-5-guro@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guroan@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Roman Gushchin <guro@fb.com>

On 04/05, Roman Gushchin wrote:
>
> +void cgroup_leave_frozen(bool always_leave)
> +{
> +	struct cgroup *cgrp;
> +
> +	spin_lock_irq(&css_set_lock);
> +	cgrp = task_dfl_cgroup(current);
> +	if (always_leave || !test_bit(CGRP_FREEZE, &cgrp->flags)) {
> +		cgroup_dec_frozen_cnt(cgrp);
> +		cgroup_update_frozen(cgrp);
> +		WARN_ON_ONCE(!current->frozen);
> +		current->frozen = false;
> +	}
> +	spin_unlock_irq(&css_set_lock);
> +
> +	if (unlikely(current->frozen)) {
> +		/*
> +		 * If the task remained in the frozen state,
> +		 * make sure it won't reach userspace without
> +		 * entering the signal handling loop.
> +		 */
> +		spin_lock_irq(&current->sighand->siglock);
> +		recalc_sigpending();
> +		spin_unlock_irq(&current->sighand->siglock);

I still can't understand this logic.

Once again, suppose we race with CGRP_FREEZE. If JOBCTL_TRAP_FREEZE is already
set then signal_pending() must be already T and we do not need recalc_sigpending?
If JOBCTL_TRAP_FREEZE is not set yet, how can recalc_sigpending() help?

> +static void cgroup_freeze_task(struct task_struct *task, bool freeze)
> +{
> +	unsigned long flags;
> +
> +	/* If the task is about to die, don't bother with freezing it. */
> +	if (!lock_task_sighand(task, &flags))
> +		return;
> +
> +	if (freeze) {
> +		task->jobctl |= JOBCTL_TRAP_FREEZE;
> +		signal_wake_up(task, false);
> +	} else {
> +		task->jobctl &= ~JOBCTL_TRAP_FREEZE;
> +		wake_up_process(task);

wake_up_interruptible() ?

>  static int ptrace_signal(int signr, kernel_siginfo_t *info)
>  {
>  	/*
> @@ -2442,6 +2483,10 @@ bool get_signal(struct ksignal *ksig)
>  		ksig->info.si_signo = signr = SIGKILL;
>  		sigdelset(&current->pending.signal, SIGKILL);
>  		recalc_sigpending();
> +		current->jobctl &= ~JOBCTL_TRAP_FREEZE;
> +		spin_unlock_irq(&sighand->siglock);
> +		if (unlikely(cgroup_task_frozen(current)))
> +			cgroup_leave_frozen(true);

Oh, and another leave_frozen below...

I feel this must be simplified somehow, but nothing comes to my mind right now.

> +		/*
> +		 * If the task is leaving the frozen state, let's update
> +		 * cgroup counters and reset the frozen bit.
> +		 */
> +		if (unlikely(cgroup_task_frozen(current))) {
>  			spin_unlock_irq(&sighand->siglock);
> +			cgroup_leave_frozen(true);
>  			goto relock;
>  		}

afaics cgroup_leave_frozen(false) makes more sense here.

Oleg.

