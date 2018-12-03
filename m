From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v4 4/7] cgroup: cgroup v2 freezer
Date: Mon, 3 Dec 2018 15:47:18 +0100
Message-ID: <20181203144717.GD31795@redhat.com>
References: <20181130234745.6756-1-guro@fb.com>
 <20181130234745.6756-5-guro@fb.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181130234745.6756-5-guro@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guroan@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Dan Carpenter <dan.carpenter@oracle.com>, Mike Rapoport <rppt@linux.vnet.ibm.com>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Roman Gushchin <guro@fb.com>

To be honest, I fail to understand this patch. At least after a quick glance,
I will try to read it again tomorrow but so far I do not even understand the
desired semantics wrt signals/ptrace.

On 11/30, Roman Gushchin wrote:
>
> @@ -368,6 +369,8 @@ static inline int signal_pending_state(long state, struct task_struct *p)
>  		return 0;
>  	if (!signal_pending(p))
>  		return 0;
> +	if (unlikely(cgroup_task_frozen(p)))
> +		return __fatal_signal_pending(p);

Oh, this is not nice. And doesn't look right.

> +/*
> + * Entry path into frozen state.
> + * If the task was not frozen before, counters are updated and the cgroup state
> + * is revisited. Otherwise, the task is put into the TASK_KILLABLE sleep.
> + */
> +void cgroup_enter_frozen(void)
> +{
> +	if (!current->frozen) {
> +		struct cgroup *cgrp;
> +
> +		spin_lock_irq(&css_set_lock);
> +		current->frozen = true;
> +		cgrp = task_dfl_cgroup(current);
> +		cgrp->freezer.nr_frozen_tasks++;
> +		WARN_ON_ONCE(cgrp->freezer.nr_frozen_tasks >
> +			     cgrp->freezer.nr_tasks_to_freeze);
> +		cgroup_update_frozen(cgrp, true);
> +		spin_unlock_irq(&css_set_lock);
> +	}
> +
> +	__set_current_state(TASK_INTERRUPTIBLE);
> +	schedule();

The comment above says TASK_KILLABLE, very confusing.

Probably this pairs with the change in signal_pending_state() above. So this
schedule() should actually "work" in that it won't return if signal_pending().

But this can't protect from another signal_wake_up(). Yes, iiuc in this case
cgroup_enter_frozen() will be called again "soon" but this all looks strange.

> --- a/kernel/ptrace.c
> +++ b/kernel/ptrace.c
> @@ -410,6 +410,13 @@ static int ptrace_attach(struct task_struct *task, long request,
>
>  	spin_lock(&task->sighand->siglock);
>
> +	/*
> +	 * If the process is frozen, let's wake it up to give it a chance
> +	 * to enter the ptrace trap.
> +	 */
> +	if (cgroup_task_frozen(task))
> +		wake_up_process(task);

And why this can't race with cgroup_enter_frozen() ?

Or think of PTRACE_INTERRUPT. It can race with cgroup_enter_frozen() too, the
tracee can miss this request because of that change in signal_pending_state().


>  static void do_jobctl_trap(void)
>  {
> +	struct sighand_struct *sighand = current->sighand;
>  	struct signal_struct *signal = current->signal;
>  	int signr = current->jobctl & JOBCTL_STOP_SIGMASK;
>  
> -	if (current->ptrace & PT_SEIZED) {
> -		if (!signal->group_stop_count &&
> -		    !(signal->flags & SIGNAL_STOP_STOPPED))
> -			signr = SIGTRAP;
> -		WARN_ON_ONCE(!signr);
> -		ptrace_do_notify(signr, signr | (PTRACE_EVENT_STOP << 8),
> -				 CLD_STOPPED);
> -	} else {
> -		WARN_ON_ONCE(!signr);
> -		ptrace_stop(signr, CLD_STOPPED, 0, NULL);
> -		current->exit_code = 0;
> +	if (current->jobctl & (JOBCTL_TRAP_STOP | JOBCTL_TRAP_NOTIFY)) {
> +		if (current->ptrace & PT_SEIZED) {
> +			if (!signal->group_stop_count &&
> +			    !(signal->flags & SIGNAL_STOP_STOPPED))
> +				signr = SIGTRAP;
> +			WARN_ON_ONCE(!signr);
> +			ptrace_do_notify(signr,
> +					 signr | (PTRACE_EVENT_STOP << 8),
> +					 CLD_STOPPED);
> +		} else {
> +			WARN_ON_ONCE(!signr);
> +			ptrace_stop(signr, CLD_STOPPED, 0, NULL);
> +			current->exit_code = 0;
> +		}
> +	} else if (current->jobctl & JOBCTL_TRAP_FREEZE) {
> +		/*
> +		 * Enter the frozen state, unless the task is about to exit.
> +		 */
> +		if (fatal_signal_pending(current)) {
> +			current->jobctl &= ~JOBCTL_TRAP_FREEZE;
> +		} else {
> +			spin_unlock_irq(&sighand->siglock);
> +			cgroup_enter_frozen();
> +			spin_lock_irq(&sighand->siglock);
> +		}
>  	}
>  }
>  
> @@ -2401,12 +2420,23 @@ bool get_signal(struct ksignal *ksig)
>  		    do_signal_stop(0))
>  			goto relock;
>  
> -		if (unlikely(current->jobctl & JOBCTL_TRAP_MASK)) {
> +		if (unlikely(current->jobctl &
> +			     (JOBCTL_TRAP_MASK | JOBCTL_TRAP_FREEZE))) {
>  			do_jobctl_trap();

Cosmetic nit, but can't you add another helper? To me something like

		if (JOBCTL_TRAP_MASK)
			do_jobctl_trap();
		else if (JOBCTL_TRAP_FREEZE)
			do_jobctl_freeze();

will look more clean, but I won't insist.


> +		/*
> +		 * If the task is leaving the frozen state, let's update
> +		 * cgroup counters and reset the frozen bit.
> +		 */
> +		if (unlikely(cgroup_task_frozen(current))) {
> +			spin_unlock_irq(&sighand->siglock);
> +			cgroup_leave_frozen();
> +			spin_lock_irq(&sighand->siglock);

looks like this needs another "goto relock", no?

And perhaps this another reason for the new do_jobctl_freeze() helper which
could absorb this leave_frozen() ?

Oleg.

