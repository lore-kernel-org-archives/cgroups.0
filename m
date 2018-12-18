From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH v5 4/7] cgroup: cgroup v2 freezer
Date: Tue, 18 Dec 2018 01:28:04 +0000
Message-ID: <20181218012800.GA29563@tower.DHCP.thefacebook.com>
References: <20181207201531.1665-1-guro@fb.com>
 <20181207201531.1665-5-guro@fb.com> <20181211162632.GB8504@redhat.com>
 <20181211184033.GA8971@tower.DHCP.thefacebook.com>
 <20181212174902.GA30309@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=i6kq1toTi6Y41x7q39A4sqXlgAtPkMKJQMjTBCP+N6Q=;
 b=hepYaHzORr2FDww3zU+VucCd/U1Fyfv2YJp3aPasZh0EBnz+IMZbs2WuDo69jZJBzetq
 QfZT7hUzbr74aPaPWiiGYaGbj5c6tFf4HGa4STRIorWRVeRuPMW39cl3KnJNav+pyHnf
 HHGQbu0KKClc09M0QpE/vNvdP9nhN+PXTcc= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i6kq1toTi6Y41x7q39A4sqXlgAtPkMKJQMjTBCP+N6Q=;
 b=JsVQnX+/mbdy1LJqzsRZlb9jInufmrZb8Mk1V3q/ABQEOHyqRZbDISNBeuyl0bsi+zv/3h+oO6GaJW/h5g6Cm5uN5hSE8+L9Y5AAMIUXVarXrT2Z+5GeKx8nDlOLyxdUT8cgPgiYY1dWYGfRtH9wFneLYbOaIG/oMc7M06BlgXg=
In-Reply-To: <20181212174902.GA30309@redhat.com>
Content-Language: en-US
Content-ID: <6CF8A95676590942A875E1FEB3ABDA1C@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Roman Gushchin <guroan@gmail.com>, Tejun Heo <tj@kernel.org>, Dan Carpenter <dan.carpenter@oracle.com>, Mike Rapoport <rppt@linux.vnet.ibm.com>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>

On Wed, Dec 12, 2018 at 06:49:02PM +0100, Oleg Nesterov wrote:
> On 12/11, Roman Gushchin wrote:
> >
> > On Tue, Dec 11, 2018 at 05:26:32PM +0100, Oleg Nesterov wrote:
> > > On 12/07, Roman Gushchin wrote:
> > > >
> > > > Cgroup v2 freezer tries to put tasks into a state similar to jobctl
> > > > stop. This means that tasks can be killed, ptraced (using
> > > > PTRACE_SEIZE*), and interrupted. It is possible to attach to
> > > > a frozen task, get some information (e.g. read registers) and detac=
h.
> > >
> > > I fail to understand how this all supposed to work.
> > >
> > > > @@ -368,6 +369,8 @@ static inline int signal_pending_state(long sta=
te, struct task_struct *p)
> > > >  		return 0;
> > > >  	if (!signal_pending(p))
> > > >  		return 0;
> > > > +	if (unlikely(cgroup_task_frozen(p) && p->jobctl =3D=3D JOBCTL_TRA=
P_FREEZE))
> > > > +		return __fatal_signal_pending(p);
> > >
> > > I think I will never agree with this change ;) and I don't think it a=
ctually helps.
> >
> > See below.
> >
> > >
> > > > +void cgroup_enter_frozen(void)
> > > > +{
> > > > +	if (!current->frozen) {
> > > > +		spin_lock_irq(&css_set_lock);
> > > > +		current->frozen =3D true;
> > > > +		cgroup_inc_frozen_cnt(task_dfl_cgroup(current), false, true);
> > > > +		spin_unlock_irq(&css_set_lock);
> > > > +	}
> > > > +
> > > > +	__set_current_state(TASK_INTERRUPTIBLE);
> > > > +	schedule();
> > >
> > > So once again, suppose it races with PTRACE_INTERRUPT, or SIGSTOP, or=
 something
> > > else which should be handled by get_signal() before do_freezer_trap()=
.
> > >
> > > If (say) PTRACE_INTERRUPT comes before schedule it will be lost. Othe=
rwise
> > > the frozen task will react. This can't be right. Or I am totally conf=
used.
> >
> > Why?
> > PTRACE_INTERRUPT will set JOBCTL_TRAP_STOP, so signal_pending_state()
> > will return true, schedule() will return immediately, and we'll handle =
the trap.
>=20
> OK, I misread the JOBCTL_TRAP_FREEZE check as "jobctl & JOBCTL_TRAP_FREEZ=
E".
>=20
> But p->jobctl =3D=3D JOBCTL_TRAP_FREEZE doesn't look right too. For examp=
le,
> JOBCTL_STOP_DEQUEUED can be set. You probably need something like
>=20
> 	jobctl & (JOBCTL_PENDING_MASK | JOBCTL_TRAP_FREEZE) =3D=3D JOBCTL_TRAP_F=
REEZE
>=20
> And you need a barrier in between, iow you need set_current_state(TASK_IN=
TERRUPTIBLE).
>=20
> But this doesn't really matter. I don't think you need to modify signal_p=
ending_state()
> and penalize schedule(). You can do something like
>=20
> 	spin_lock_irq(sigllock);
> 	if (jobctl & (JOBCTL_PENDING_MASK | JOBCTL_TRAP_FREEZE) =3D=3D JOBCTL_TR=
AP_FREEZE &&
> 	    !__fatal_signal_pending())
> 	{
> 		__set_current_state(TASK_INTERRUPTIBLE);
> 		clear_thread_flag(TIF_SIGPENDING);
> 	}
> 	spin_unlock_irq(siglock);
>=20
> 	schedule();
> 	// recalc_sigpending() is not needed
>=20
> in cgroup_enter_frozen() with the same effect. Which looks equally ugly a=
nd
> suboptimal, but at least this doesn't touch the sched code.

Gotcha. Will follow this approach in v6.

>=20
> > > and btw.... what about suspend? try_to_freeze_tasks() will obviously =
fail
> > > if there is a ->frozen thread?
> >
> > I have to think a bit more here, but something like this will probably =
work:
> >
> > diff --git a/kernel/freezer.c b/kernel/freezer.c
> > index b162b74611e4..590ac4d10b02 100644
> > --- a/kernel/freezer.c
> > +++ b/kernel/freezer.c
> > @@ -134,7 +134,7 @@ bool freeze_task(struct task_struct *p)
> >                 return false;
> >
> >         spin_lock_irqsave(&freezer_lock, flags);
> > -       if (!freezing(p) || frozen(p)) {
> > +       if (!freezing(p) || frozen(p) || cgroup_task_frozen()) {
> >                 spin_unlock_irqrestore(&freezer_lock, flags);
> >                 return false;
> >         }
> >
> > --
> >
> > If the task is already frozen by the cgroup freezer, we don't have to d=
o
> > anything additionally.
>=20
> I don't think so. A cgroup_task_frozen() task can be killed after
> try_to_freeze_tasks() succeeds, and the exiting task can close files,
> do IO, etc. Or it can be thawed by cgroup_freeze_task(false).
>=20
> In short, if try_to_freeze_tasks() succeeds, the caller has all rights
> to assume that nobody can escape from __refrigerator().

But this is what we do with stopped and ptraced tasks, isn't it?
We do use freezable_schedule() and the system freezer just ignores such tas=
ks.
I believe that cgroup v2 freezer should follow the same path.

>=20
> And what about TASK_STOPPED/TASK_TRACED tasks? They can not be frozen
> or thawed, right? This doesn't look good, and this differs from the
> current freezer controller...

Good question!

It looks like cgroup v1 freezer just ignores them treating as already froze=
n,
which doesn't look nice.

I'd say s/signal_wake_up(task, 0)/signal_wake_up(task, 1) in
cgroup_freeze_task() will do the job of moving them into the frozen state.
The question is how to get them back into the stopped state, if cgroup is
unfrozen. At this point there are no more signs, that the task has been
previously frozen. I've no better idea, than to introduce another
per-task bit/flag. If you have any better ideas, please, share.

Thank you for the review!
