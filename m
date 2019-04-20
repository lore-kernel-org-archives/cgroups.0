From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v10 4/9] cgroup: cgroup v2 freezer
Date: Sat, 20 Apr 2019 12:58:38 +0200
Message-ID: <20190420105838.GA17468@redhat.com>
References: <20190405174708.1010-1-guro@fb.com>
 <20190405174708.1010-5-guro@fb.com>
 <20190419151912.GA12152@redhat.com>
 <20190419161118.GA23357@tower.DHCP.thefacebook.com>
 <20190419162600.GC12228@redhat.com>
 <20190419165600.GC23357@tower.DHCP.thefacebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190419165600.GC23357@tower.DHCP.thefacebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Roman Gushchin <guroan@gmail.com>, Tejun Heo <tj@kernel.org>, Kernel Team <Kernel-team@fb.com>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On 04/19, Roman Gushchin wrote:
>
> > > >
> > > > wake_up_interruptible() ?
> > >
> > > Wait_up_interruptible() is supposed to work with a workqueue,
> > > but here there is nothing like this. Probably, I didn't understand your idea.
> > > Can you, please, elaborate a bit more?
> >
> > Not sure I understand... We need to wake up the task if it sleeps in
> > do_freezer_trap(), right? do_freezer_trap() uses TASK_INTERRUPTIBLE, so
> > why can't wake_up_interruptible() == __wake_up(TASK_INTERRUPTIBLE) work?
>
> Right, but __wake_up is supposed to wake threads blocked on a waitqueue:

Ugh sorry ;) of course I meant wake_up_state(task, TASK_INTERRUPTIBLE).

> > > > > +		if (unlikely(cgroup_task_frozen(current))) {
> > > > >  			spin_unlock_irq(&sighand->siglock);
> > > > > +			cgroup_leave_frozen(true);
> > > > >  			goto relock;
> > > > >  		}
> > > >
> > > > afaics cgroup_leave_frozen(false) makes more sense here.
> > >
> > > Why? I don't see any reasons why the task should remain in the frozen
> > > state after this point.
> >
> > But cgroup_leave_frozen(false) will equally clear ->frozen if !CGRP_FREEZE ?
> > OTOH, if CGRP_FREEZE is set again, why do we need to clear ->frozen?
>
> Hm, it might work too, but I'm not sure I like it more. IMO, the best option
> is to have a single cgroup_leave_frozen(true) in signal.c, it's just simpler.
> If a user changed the desired state of cgroup twice, there is no need to avoid
> state transitions. Or maybe I don't see it yet.

Then why do we need cgroup_leave_frozen(false) in wait_for_vfork_done() ? How
does it differ from get_signal() ?

If nothing else. Suppose that wait_for_vfork_done() calls leave(false) and this
races with freezer, CGRP_FREEZE is already set but JOBCTL_TRAP_FREEZE is not.

This sets TIF_SIGPENDING to ensure the task won't return to user mode, thus it
calls get_signal().

get_signal() doesn't see JOBCTL_TRAP_FREEZE, it notices ->frozen == T and does
cgroup_leave_frozen(true) which clears ->frozen.

Then the task calls dequeue_signal(), clears TIF_SIGPENDING and returns to user
mode?

Oleg.

