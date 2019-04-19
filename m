From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH v10 4/9] cgroup: cgroup v2 freezer
Date: Fri, 19 Apr 2019 16:56:04 +0000
Message-ID: <20190419165600.GC23357@tower.DHCP.thefacebook.com>
References: <20190405174708.1010-1-guro@fb.com>
 <20190405174708.1010-5-guro@fb.com> <20190419151912.GA12152@redhat.com>
 <20190419161118.GA23357@tower.DHCP.thefacebook.com>
 <20190419162600.GC12228@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=aUtD2dvdoWlCiuZxW4hirXpeSoo6J+kqWFCSozxGfj0=;
 b=WwlMPuTQxpf0pz5Hm3FbO2Y3seY+SFo3uJo13A54y17kk4dpS+F+pqBqI2mcB2rClLId
 ktWKEOded6Z2QSpVPxAXuQb+BGT04PgdTXSnpVjp+LtU67B9N60HjWwH2824333DjnZy
 /e1f/adpN4X5wvWCBxsqKexyK7aoxmv/ycw= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aUtD2dvdoWlCiuZxW4hirXpeSoo6J+kqWFCSozxGfj0=;
 b=CxrHla/Uf0ZcD8McTBiu3blbQoAE+U3NGxMzwukL7ncDw+mgqgwMdWi7BH66nIfa7I8JHTg2w406J48yUjxTU8lkfA5U8yl0a2eQ5VJ5p36ZxIpoH1fTQ5qv6s1EdbLcXU08fRDugButn0vAZ8rxBBAujLVw1mxGLICEnFztlf4=
In-Reply-To: <20190419162600.GC12228@redhat.com>
Content-Language: en-US
Content-ID: <F937F0E16108E8498B9720C7BDC65529@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Roman Gushchin <guroan@gmail.com>, Tejun Heo <tj@kernel.org>, Kernel Team <Kernel-team@fb.com>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Fri, Apr 19, 2019 at 06:26:00PM +0200, Oleg Nesterov wrote:
> On 04/19, Roman Gushchin wrote:
> >
> > > Once again, suppose we race with CGRP_FREEZE. If JOBCTL_TRAP_FREEZE i=
s already
> > > set then signal_pending() must be already T and we do not need recalc=
_sigpending?
> > > If JOBCTL_TRAP_FREEZE is not set yet, how can recalc_sigpending() hel=
p?
> >
> > This is paired with cgroup_task_frozen() check in recalc_sigpending_tsk=
().
>=20
> Ooh, I didn't notice this version added cgroup_task_frozen() into
> recalc_sigpending_tsk() ...
>=20
> Honestly, I don't like this. But see another email I sent, we can cleanup
> this code later.

Yeah, totally agree: it's not pretty. But honestly I've no better ideas,
so let's fix it later.

>=20
> > > > +static void cgroup_freeze_task(struct task_struct *task, bool free=
ze)
> > > > +{
> > > > +	unsigned long flags;
> > > > +
> > > > +	/* If the task is about to die, don't bother with freezing it. */
> > > > +	if (!lock_task_sighand(task, &flags))
> > > > +		return;
> > > > +
> > > > +	if (freeze) {
> > > > +		task->jobctl |=3D JOBCTL_TRAP_FREEZE;
> > > > +		signal_wake_up(task, false);
> > > > +	} else {
> > > > +		task->jobctl &=3D ~JOBCTL_TRAP_FREEZE;
> > > > +		wake_up_process(task);
> > >
> > > wake_up_interruptible() ?
> >
> > Wait_up_interruptible() is supposed to work with a workqueue,
> > but here there is nothing like this. Probably, I didn't understand your=
 idea.
> > Can you, please, elaborate a bit more?
>=20
> Not sure I understand... We need to wake up the task if it sleeps in
> do_freezer_trap(), right? do_freezer_trap() uses TASK_INTERRUPTIBLE, so
> why can't wake_up_interruptible() =3D=3D __wake_up(TASK_INTERRUPTIBLE) wo=
rk?

Right, but __wake_up is supposed to wake threads blocked on a waitqueue:

    /**
     * __wake_up - wake up threads blocked on a waitqueue.
     * @wq_head: the waitqueue
     * @mode: which threads
     * @nr_exclusive: how many wake-one or wake-many threads to wake up
     * @key: is directly passed to the wakeup function
     *
     * If this function wakes up a task, it executes a full memory barrier =
before
     * accessing the task state.
     */
    void __wake_up(struct wait_queue_head *wq_head, unsigned int mode,
			int nr_exclusive, void *key)

What should I pass as wq_head?

>=20
> > > >  static int ptrace_signal(int signr, kernel_siginfo_t *info)
> > > >  {
> > > >  	/*
> > > > @@ -2442,6 +2483,10 @@ bool get_signal(struct ksignal *ksig)
> > > >  		ksig->info.si_signo =3D signr =3D SIGKILL;
> > > >  		sigdelset(&current->pending.signal, SIGKILL);
> > > >  		recalc_sigpending();
> > > > +		current->jobctl &=3D ~JOBCTL_TRAP_FREEZE;
> > > > +		spin_unlock_irq(&sighand->siglock);
> > > > +		if (unlikely(cgroup_task_frozen(current)))
> > > > +			cgroup_leave_frozen(true);
> > >
> > > Oh, and another leave_frozen below...
> >
> > Yeah, because of this new "goto fatal" shortcut.
>=20
> I understand, but the code doesn't look nice... but again, I can't sugges=
t
> anything better at least right now, so please forget.
>=20
> > > > +		if (unlikely(cgroup_task_frozen(current))) {
> > > >  			spin_unlock_irq(&sighand->siglock);
> > > > +			cgroup_leave_frozen(true);
> > > >  			goto relock;
> > > >  		}
> > >
> > > afaics cgroup_leave_frozen(false) makes more sense here.
> >
> > Why? I don't see any reasons why the task should remain in the frozen
> > state after this point.
>=20
> But cgroup_leave_frozen(false) will equally clear ->frozen if !CGRP_FREEZ=
E ?
> OTOH, if CGRP_FREEZE is set again, why do we need to clear ->frozen?

Hm, it might work too, but I'm not sure I like it more. IMO, the best optio=
n
is to have a single cgroup_leave_frozen(true) in signal.c, it's just simple=
r.
If a user changed the desired state of cgroup twice, there is no need to av=
oid
state transitions. Or maybe I don't see it yet.

Thank you!
