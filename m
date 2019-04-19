From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v10 4/9] cgroup: cgroup v2 freezer
Date: Fri, 19 Apr 2019 18:26:00 +0200
Message-ID: <20190419162600.GC12228@redhat.com>
References: <20190405174708.1010-1-guro@fb.com>
 <20190405174708.1010-5-guro@fb.com>
 <20190419151912.GA12152@redhat.com>
 <20190419161118.GA23357@tower.DHCP.thefacebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190419161118.GA23357@tower.DHCP.thefacebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Roman Gushchin <guroan@gmail.com>, Tejun Heo <tj@kernel.org>, Kernel Team <Kernel-team@fb.com>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On 04/19, Roman Gushchin wrote:
>
> > Once again, suppose we race with CGRP_FREEZE. If JOBCTL_TRAP_FREEZE is already
> > set then signal_pending() must be already T and we do not need recalc_sigpending?
> > If JOBCTL_TRAP_FREEZE is not set yet, how can recalc_sigpending() help?
>
> This is paired with cgroup_task_frozen() check in recalc_sigpending_tsk().

Ooh, I didn't notice this version added cgroup_task_frozen() into
recalc_sigpending_tsk() ...

Honestly, I don't like this. But see another email I sent, we can cleanup
this code later.

> > > +static void cgroup_freeze_task(struct task_struct *task, bool freeze)
> > > +{
> > > +	unsigned long flags;
> > > +
> > > +	/* If the task is about to die, don't bother with freezing it. */
> > > +	if (!lock_task_sighand(task, &flags))
> > > +		return;
> > > +
> > > +	if (freeze) {
> > > +		task->jobctl |= JOBCTL_TRAP_FREEZE;
> > > +		signal_wake_up(task, false);
> > > +	} else {
> > > +		task->jobctl &= ~JOBCTL_TRAP_FREEZE;
> > > +		wake_up_process(task);
> >
> > wake_up_interruptible() ?
>
> Wait_up_interruptible() is supposed to work with a workqueue,
> but here there is nothing like this. Probably, I didn't understand your idea.
> Can you, please, elaborate a bit more?

Not sure I understand... We need to wake up the task if it sleeps in
do_freezer_trap(), right? do_freezer_trap() uses TASK_INTERRUPTIBLE, so
why can't wake_up_interruptible() == __wake_up(TASK_INTERRUPTIBLE) work?

> > >  static int ptrace_signal(int signr, kernel_siginfo_t *info)
> > >  {
> > >  	/*
> > > @@ -2442,6 +2483,10 @@ bool get_signal(struct ksignal *ksig)
> > >  		ksig->info.si_signo = signr = SIGKILL;
> > >  		sigdelset(&current->pending.signal, SIGKILL);
> > >  		recalc_sigpending();
> > > +		current->jobctl &= ~JOBCTL_TRAP_FREEZE;
> > > +		spin_unlock_irq(&sighand->siglock);
> > > +		if (unlikely(cgroup_task_frozen(current)))
> > > +			cgroup_leave_frozen(true);
> >
> > Oh, and another leave_frozen below...
>
> Yeah, because of this new "goto fatal" shortcut.

I understand, but the code doesn't look nice... but again, I can't suggest
anything better at least right now, so please forget.

> > > +		if (unlikely(cgroup_task_frozen(current))) {
> > >  			spin_unlock_irq(&sighand->siglock);
> > > +			cgroup_leave_frozen(true);
> > >  			goto relock;
> > >  		}
> >
> > afaics cgroup_leave_frozen(false) makes more sense here.
>
> Why? I don't see any reasons why the task should remain in the frozen
> state after this point.

But cgroup_leave_frozen(false) will equally clear ->frozen if !CGRP_FREEZE ?
OTOH, if CGRP_FREEZE is set again, why do we need to clear ->frozen?

Oleg.

