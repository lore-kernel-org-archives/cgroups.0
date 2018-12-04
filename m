From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH v4 4/7] cgroup: cgroup v2 freezer
Date: Tue, 4 Dec 2018 00:11:13 +0000
Message-ID: <20181204001105.GA14586@castle.DHCP.thefacebook.com>
References: <20181130234745.6756-1-guro@fb.com>
 <20181130234745.6756-5-guro@fb.com> <20181203144717.GD31795@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=U3JjbP/W/sU665MEzYUwF/I0/Jtnm8EbcXnYYbGHVWE=;
 b=VoT7Y/J+TEZoF1P/Ep3X/ceknIYm+xRV2k8d5htltf8v8z2/7+oqTcwTcOF5NO1WEdgU
 JpSFr5PjkG/bMgfHn100OHe7OBJWwSFM7KTzowvm5MGK2Qg61E+YzqG8nXg4GHj5MgyY
 Eoz54+8Pp8nL4jDbaXfiDtPoRh1o0w2QHq0= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U3JjbP/W/sU665MEzYUwF/I0/Jtnm8EbcXnYYbGHVWE=;
 b=hqy3wa11mMwe0Mv2HkXxZ0jtequq0TF4VXKe3BWGEoiOGHcL4z9JbdcGIWiSpekfX7WCyZTa+HpUPCYpMu8pSFyGzZmiidY1A2ncNOI7LECz7l9rtKPcKs35uYljsA8nbGbU/xZwzQzxFYVi+S97QXVUUzNDgrRc8wxLaEjgulA=
In-Reply-To: <20181203144717.GD31795@redhat.com>
Content-Language: en-US
Content-ID: <87C0C50BC289E147B62B1AF5F48DDDBE@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Roman Gushchin <guroan@gmail.com>, Tejun Heo <tj@kernel.org>, Dan Carpenter <dan.carpenter@oracle.com>, Mike Rapoport <rppt@linux.vnet.ibm.com>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>

On Mon, Dec 03, 2018 at 03:47:18PM +0100, Oleg Nesterov wrote:
> To be honest, I fail to understand this patch. At least after a quick gla=
nce,
> I will try to read it again tomorrow but so far I do not even understand =
the
> desired semantics wrt signals/ptrace.
>=20
> On 11/30, Roman Gushchin wrote:
> >
> > @@ -368,6 +369,8 @@ static inline int signal_pending_state(long state, =
struct task_struct *p)
> >  		return 0;
> >  	if (!signal_pending(p))
> >  		return 0;
> > +	if (unlikely(cgroup_task_frozen(p)))
> > +		return __fatal_signal_pending(p);
>=20
> Oh, this is not nice. And doesn't look right.
>=20
> > +/*
> > + * Entry path into frozen state.
> > + * If the task was not frozen before, counters are updated and the cgr=
oup state
> > + * is revisited. Otherwise, the task is put into the TASK_KILLABLE sle=
ep.
> > + */
> > +void cgroup_enter_frozen(void)
> > +{
> > +	if (!current->frozen) {
> > +		struct cgroup *cgrp;
> > +
> > +		spin_lock_irq(&css_set_lock);
> > +		current->frozen =3D true;
> > +		cgrp =3D task_dfl_cgroup(current);
> > +		cgrp->freezer.nr_frozen_tasks++;
> > +		WARN_ON_ONCE(cgrp->freezer.nr_frozen_tasks >
> > +			     cgrp->freezer.nr_tasks_to_freeze);
> > +		cgroup_update_frozen(cgrp, true);
> > +		spin_unlock_irq(&css_set_lock);
> > +	}
> > +
> > +	__set_current_state(TASK_INTERRUPTIBLE);
> > +	schedule();
>=20
> The comment above says TASK_KILLABLE, very confusing.

Sorry, it's a leftover from one of the previous versions. Fixed.

>=20
> Probably this pairs with the change in signal_pending_state() above. So t=
his
> schedule() should actually "work" in that it won't return if signal_pendi=
ng().
>=20
> But this can't protect from another signal_wake_up(). Yes, iiuc in this c=
ase
> cgroup_enter_frozen() will be called again "soon" but this all looks stra=
nge.

So, the idea here is to make ptrace traps and fatal signals working, but
non-fatal shouldn't be delivered.

As soon as the frozen task is looping in the signal delivery loop, it's fin=
e,
it's not going anywhere.

Without the change above the task is getting out of schedule() immediately,
if any signal is pending (including non-fatals). So it becomes a busy-loop.

>=20
> > --- a/kernel/ptrace.c
> > +++ b/kernel/ptrace.c
> > @@ -410,6 +410,13 @@ static int ptrace_attach(struct task_struct *task,=
 long request,
> >
> >  	spin_lock(&task->sighand->siglock);
> >
> > +	/*
> > +	 * If the process is frozen, let's wake it up to give it a chance
> > +	 * to enter the ptrace trap.
> > +	 */
> > +	if (cgroup_task_frozen(task))
> > +		wake_up_process(task);
>=20
> And why this can't race with cgroup_enter_frozen() ?
>=20
> Or think of PTRACE_INTERRUPT. It can race with cgroup_enter_frozen() too,=
 the
> tracee can miss this request because of that change in signal_pending_sta=
te().

It's a good point. So I need an additional synchronization around
checking/setting the JOBCTL_TRAP_FREEZE?

>=20
>=20
> >  static void do_jobctl_trap(void)
> >  {
> > +	struct sighand_struct *sighand =3D current->sighand;
> >  	struct signal_struct *signal =3D current->signal;
> >  	int signr =3D current->jobctl & JOBCTL_STOP_SIGMASK;
> > =20
> > -	if (current->ptrace & PT_SEIZED) {
> > -		if (!signal->group_stop_count &&
> > -		    !(signal->flags & SIGNAL_STOP_STOPPED))
> > -			signr =3D SIGTRAP;
> > -		WARN_ON_ONCE(!signr);
> > -		ptrace_do_notify(signr, signr | (PTRACE_EVENT_STOP << 8),
> > -				 CLD_STOPPED);
> > -	} else {
> > -		WARN_ON_ONCE(!signr);
> > -		ptrace_stop(signr, CLD_STOPPED, 0, NULL);
> > -		current->exit_code =3D 0;
> > +	if (current->jobctl & (JOBCTL_TRAP_STOP | JOBCTL_TRAP_NOTIFY)) {
> > +		if (current->ptrace & PT_SEIZED) {
> > +			if (!signal->group_stop_count &&
> > +			    !(signal->flags & SIGNAL_STOP_STOPPED))
> > +				signr =3D SIGTRAP;
> > +			WARN_ON_ONCE(!signr);
> > +			ptrace_do_notify(signr,
> > +					 signr | (PTRACE_EVENT_STOP << 8),
> > +					 CLD_STOPPED);
> > +		} else {
> > +			WARN_ON_ONCE(!signr);
> > +			ptrace_stop(signr, CLD_STOPPED, 0, NULL);
> > +			current->exit_code =3D 0;
> > +		}
> > +	} else if (current->jobctl & JOBCTL_TRAP_FREEZE) {
> > +		/*
> > +		 * Enter the frozen state, unless the task is about to exit.
> > +		 */
> > +		if (fatal_signal_pending(current)) {
> > +			current->jobctl &=3D ~JOBCTL_TRAP_FREEZE;
> > +		} else {
> > +			spin_unlock_irq(&sighand->siglock);
> > +			cgroup_enter_frozen();
> > +			spin_lock_irq(&sighand->siglock);
> > +		}
> >  	}
> >  }
> > =20
> > @@ -2401,12 +2420,23 @@ bool get_signal(struct ksignal *ksig)
> >  		    do_signal_stop(0))
> >  			goto relock;
> > =20
> > -		if (unlikely(current->jobctl & JOBCTL_TRAP_MASK)) {
> > +		if (unlikely(current->jobctl &
> > +			     (JOBCTL_TRAP_MASK | JOBCTL_TRAP_FREEZE))) {
> >  			do_jobctl_trap();
>=20
> Cosmetic nit, but can't you add another helper? To me something like
>=20
> 		if (JOBCTL_TRAP_MASK)
> 			do_jobctl_trap();
> 		else if (JOBCTL_TRAP_FREEZE)
> 			do_jobctl_freeze();
>=20
> will look more clean, but I won't insist.

Sure.

>=20
>=20
> > +		/*
> > +		 * If the task is leaving the frozen state, let's update
> > +		 * cgroup counters and reset the frozen bit.
> > +		 */
> > +		if (unlikely(cgroup_task_frozen(current))) {
> > +			spin_unlock_irq(&sighand->siglock);
> > +			cgroup_leave_frozen();
> > +			spin_lock_irq(&sighand->siglock);
>=20
> looks like this needs another "goto relock", no?
>=20
> And perhaps this another reason for the new do_jobctl_freeze() helper whi=
ch
> could absorb this leave_frozen() ?

Makes sense. Will follow this path in v5.

Thank you!
