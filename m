From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v9 4/9] cgroup: cgroup v2 freezer
Date: Tue, 2 Apr 2019 18:02:41 +0200
Message-ID: <20190402160241.GA10425@redhat.com>
References: <20190316175812.6787-1-guro@fb.com>
 <20190316175812.6787-5-guro@fb.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190316175812.6787-5-guro@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guroan@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Roman Gushchin <guro@fb.com>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Hi Roman,

let me apologize again for the huge delay.

I see nothing really wrong in this version, so no objections from me.

However, 4/9 doesn't apply, so it seems you will need to make v10 anyway
to adapt these changes to the recent changes in kernel/signal.c ;)

Just a couple of minor nits below...

On 03/16, Roman Gushchin wrote:
>
> + * If always_leave is not set, and the cgroup is freezing,
> + * we're racing with the cgroup freezing. In this case, we don't
> + * drop the frozen counter to avoid a transient switch to
> + * the unfrozen state. To make sure that the task won't go
> + * to the userspace before reaching the signal handler loop,
> + * let's set TIF_SIGPENDING flag.
> + */
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
> +	} else {
> +		set_tsk_thread_flag(current, TIF_SIGPENDING);

The setting of TIF_SIGPENDING looks unnecessary and even not correct; because
this flag must not be updated without ->siglock held (even if "set" is more
or less safe).

If JOBCTL_TRAP_FREEZE is already set, then TIF_SIGPENDING must be set too.

Otherwise set_tsk_thread_flag(TIF_SIGPENDING) can't help because the task can
do recalc_sigpending() at any moment.

In particular, get_signal() does dequeue_signal()->recalc_sigpending() right
after cgroup_leave_frozen(), so I fail to understand why do we need to set
TIF_SIGPENDING.


> @@ -912,6 +912,10 @@ static struct task_struct *dup_task_struct(struct task_struct *orig, int node)
>  	tsk->fail_nth = 0;
>  #endif
>
> +#ifdef CONFIG_CGROUPS
> +	tsk->frozen = 0;
> +#endif

Hmm, do we really need this? How can a cgroup_task_frozen() task call
copy_process() ?

> +static void do_freezer_trap(void)
> +	__releases(&current->sighand->siglock)
> +{
> +	/*
> +	 * If a fatal signal is pending, there is no way back for the process,
> +	 * so let it escape from the freezer trap and exit.
> +	 * If the task has been frozen, cgroup_leave_frozen() will be invoked
> +	 * to update the cgroup state, if necessary.
> +	 */
> +	if (fatal_signal_pending(current)) {
> +		current->jobctl &= ~JOBCTL_TRAP_FREEZE;
> +		spin_unlock_irq(&current->sighand->siglock);
> +		return;
> +	}
> +
> +	/*
> +	 * If there are other trap bits pending except JOBCTL_TRAP_FREEZE,
> +	 * let's make another loop to give it a chance to be handled.
> +	 * In any case, we'll return back.
> +	 */
> +	if (((current->jobctl & (JOBCTL_PENDING_MASK | JOBCTL_TRAP_FREEZE)) !=
> +	     JOBCTL_TRAP_FREEZE) || fatal_signal_pending(current)) {
                                    ^^^^^^^^^^^^^^^^^^^^

We have already checked fatal_signal_pending() at the start?

And in fact, you can probably remove fatal_signal_pending() altogether...
Note that with recent changes get_signal() does

	if (signal_group_exit(signal)) {
		ksig->info.si_signo = signr = SIGKILL;
		sigdelset(&current->pending.signal, SIGKILL);
		recalc_sigpending();
		goto fatal;
	}

before the main loop, so afaics fatal_signal_pending() == T in do_freezer_trap()
is simply impossible. This means that you can't clear JOBCTL_TRAP_FREEZE, but
this is probably fine... if not, you can add jobctl &= ~JOBCTL_TRAP_FREEZE into
the "if (signal_group_exit(signal))" above.

> @@ -2401,12 +2453,27 @@ bool get_signal(struct ksignal *ksig)
>  		    do_signal_stop(0))
>  			goto relock;
>  
> -		if (unlikely(current->jobctl & JOBCTL_TRAP_MASK)) {
> -			do_jobctl_trap();
> -			spin_unlock_irq(&sighand->siglock);
> +		if (unlikely(current->jobctl &
> +			     (JOBCTL_TRAP_MASK | JOBCTL_TRAP_FREEZE))) {
> +			if (current->jobctl & JOBCTL_TRAP_MASK) {
> +				do_jobctl_trap();
> +				spin_unlock_irq(&sighand->siglock);
> +			} else if (current->jobctl & JOBCTL_TRAP_FREEZE)
> +				do_freezer_trap();
> +
>  			goto relock;
>  		}
>  
> +		/*
> +		 * If the task is leaving the frozen state, let's update
> +		 * cgroup counters and reset the frozen bit.
> +		 */
> +		if (unlikely(cgroup_task_frozen(current))) {
> +			spin_unlock_irq(&sighand->siglock);
> +			cgroup_leave_frozen(true);
> +			spin_lock_irq(&sighand->siglock);

I'd suggest to do "goto relock" rather than spin_lock_irq(&sighand->siglock).
To ensure we can't miss SIGKILL which can come right after we drop siglock,
note again the new signal_group_exit() check above.

Oleg.

