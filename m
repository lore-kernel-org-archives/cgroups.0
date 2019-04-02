From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH v9 4/9] cgroup: cgroup v2 freezer
Date: Tue, 2 Apr 2019 22:08:42 +0000
Message-ID: <20190402220836.GA16417@tower.DHCP.thefacebook.com>
References: <20190316175812.6787-1-guro@fb.com>
 <20190316175812.6787-5-guro@fb.com> <20190402160241.GA10425@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=SwsKDjjj7SRUR25hjJd7eLdumKNnAozD6h0qL1PCTxU=;
 b=FgHm9rtvZ7xKbY+J9DIloiRRh2Ps2y0kpK0lwuhVEcp6H7etCSneQC2MWdgdkAo4RjB0
 54v0h3FzYwku0zpA08sVnSsYtIeQXE2WIh/sS7t+v06A01tfU6KePq8uLa1W0YSTUakW
 1CPj6wgJnb2G5yPOVThG+q4x6sVT+V/R09U= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SwsKDjjj7SRUR25hjJd7eLdumKNnAozD6h0qL1PCTxU=;
 b=DD2G0TBXw3/TEhkcUhWGkhMT5K274ncosRlbkbWSvpMjMGIrsAkMpO/vj/RVPdSD+ixpd4kNRaDnbtWyji5duUsy0qCaI0Vz/6cZ2pBn6l2fUUxC/ZKZwAg/XdSYc78ZL4uC4mT51wk/ymc9omsnCsDYZppItlCt5BTKu4C5luE=
In-Reply-To: <20190402160241.GA10425@redhat.com>
Content-Language: en-US
Content-ID: <EE7121A77379BE499B23894A109E1688@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Roman Gushchin <guroan@gmail.com>, Tejun Heo <tj@kernel.org>, Kernel Team <Kernel-team@fb.com>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

Hi Oleg,


Thank you very much for your time! Really appreciate it.

I'll rebase the patchset, address your comments and send v10 soon-ish.

Please, find some notes below.

On Tue, Apr 02, 2019 at 06:02:41PM +0200, Oleg Nesterov wrote:
> Hi Roman,
>=20
> let me apologize again for the huge delay.
>=20
> I see nothing really wrong in this version, so no objections from me.
>=20
> However, 4/9 doesn't apply, so it seems you will need to make v10 anyway
> to adapt these changes to the recent changes in kernel/signal.c ;)
>=20
> Just a couple of minor nits below...
>=20
> On 03/16, Roman Gushchin wrote:
> >
> > + * If always_leave is not set, and the cgroup is freezing,
> > + * we're racing with the cgroup freezing. In this case, we don't
> > + * drop the frozen counter to avoid a transient switch to
> > + * the unfrozen state. To make sure that the task won't go
> > + * to the userspace before reaching the signal handler loop,
> > + * let's set TIF_SIGPENDING flag.
> > + */
> > +void cgroup_leave_frozen(bool always_leave)
> > +{
> > +	struct cgroup *cgrp;
> > +
> > +	spin_lock_irq(&css_set_lock);
> > +	cgrp =3D task_dfl_cgroup(current);
> > +	if (always_leave || !test_bit(CGRP_FREEZE, &cgrp->flags)) {
> > +		cgroup_dec_frozen_cnt(cgrp);
> > +		cgroup_update_frozen(cgrp);
> > +		WARN_ON_ONCE(!current->frozen);
> > +		current->frozen =3D false;
> > +	} else {
> > +		set_tsk_thread_flag(current, TIF_SIGPENDING);
>=20
> The setting of TIF_SIGPENDING looks unnecessary and even not correct; bec=
ause
> this flag must not be updated without ->siglock held (even if "set" is mo=
re
> or less safe).
>=20
> If JOBCTL_TRAP_FREEZE is already set, then TIF_SIGPENDING must be set too=
.
>=20
> Otherwise set_tsk_thread_flag(TIF_SIGPENDING) can't help because the task=
 can
> do recalc_sigpending() at any moment.
>=20
> In particular, get_signal() does dequeue_signal()->recalc_sigpending() ri=
ght
> after cgroup_leave_frozen(), so I fail to understand why do we need to se=
t
> TIF_SIGPENDING.

So this "else" part is only for vfork path. What I'm trying to do, is to
avoid flipping the cgroup state from frozen to unfrozen and back to frozen.

You're right, TIF_SIGPENDING isn't enough, we need proper cgroup_freeze_tas=
k()
with some additional synchronization.

>=20
>=20
> > @@ -912,6 +912,10 @@ static struct task_struct *dup_task_struct(struct =
task_struct *orig, int node)
> >  	tsk->fail_nth =3D 0;
> >  #endif
> >
> > +#ifdef CONFIG_CGROUPS
> > +	tsk->frozen =3D 0;
> > +#endif
>=20
> Hmm, do we really need this? How can a cgroup_task_frozen() task call
> copy_process() ?

We shouldn't, but let me double check it.

>=20
> > +static void do_freezer_trap(void)
> > +	__releases(&current->sighand->siglock)
> > +{
> > +	/*
> > +	 * If a fatal signal is pending, there is no way back for the process=
,
> > +	 * so let it escape from the freezer trap and exit.
> > +	 * If the task has been frozen, cgroup_leave_frozen() will be invoked
> > +	 * to update the cgroup state, if necessary.
> > +	 */
> > +	if (fatal_signal_pending(current)) {
> > +		current->jobctl &=3D ~JOBCTL_TRAP_FREEZE;
> > +		spin_unlock_irq(&current->sighand->siglock);
> > +		return;
> > +	}
> > +
> > +	/*
> > +	 * If there are other trap bits pending except JOBCTL_TRAP_FREEZE,
> > +	 * let's make another loop to give it a chance to be handled.
> > +	 * In any case, we'll return back.
> > +	 */
> > +	if (((current->jobctl & (JOBCTL_PENDING_MASK | JOBCTL_TRAP_FREEZE)) !=
=3D
> > +	     JOBCTL_TRAP_FREEZE) || fatal_signal_pending(current)) {
>                                     ^^^^^^^^^^^^^^^^^^^^
>=20
> We have already checked fatal_signal_pending() at the start?

Yeah, I'll remove the second call. Thanks!

>=20
> And in fact, you can probably remove fatal_signal_pending() altogether...
> Note that with recent changes get_signal() does
>=20
> 	if (signal_group_exit(signal)) {
> 		ksig->info.si_signo =3D signr =3D SIGKILL;
> 		sigdelset(&current->pending.signal, SIGKILL);
> 		recalc_sigpending();
> 		goto fatal;
> 	}
>=20
> before the main loop, so afaics fatal_signal_pending() =3D=3D T in do_fre=
ezer_trap()
> is simply impossible. This means that you can't clear JOBCTL_TRAP_FREEZE,=
 but
> this is probably fine... if not, you can add jobctl &=3D ~JOBCTL_TRAP_FRE=
EZE into
> the "if (signal_group_exit(signal))" above.

I'll try.

>=20
> > @@ -2401,12 +2453,27 @@ bool get_signal(struct ksignal *ksig)
> >  		    do_signal_stop(0))
> >  			goto relock;
> > =20
> > -		if (unlikely(current->jobctl & JOBCTL_TRAP_MASK)) {
> > -			do_jobctl_trap();
> > -			spin_unlock_irq(&sighand->siglock);
> > +		if (unlikely(current->jobctl &
> > +			     (JOBCTL_TRAP_MASK | JOBCTL_TRAP_FREEZE))) {
> > +			if (current->jobctl & JOBCTL_TRAP_MASK) {
> > +				do_jobctl_trap();
> > +				spin_unlock_irq(&sighand->siglock);
> > +			} else if (current->jobctl & JOBCTL_TRAP_FREEZE)
> > +				do_freezer_trap();
> > +
> >  			goto relock;
> >  		}
> > =20
> > +		/*
> > +		 * If the task is leaving the frozen state, let's update
> > +		 * cgroup counters and reset the frozen bit.
> > +		 */
> > +		if (unlikely(cgroup_task_frozen(current))) {
> > +			spin_unlock_irq(&sighand->siglock);
> > +			cgroup_leave_frozen(true);
> > +			spin_lock_irq(&sighand->siglock);
>=20
> I'd suggest to do "goto relock" rather than spin_lock_irq(&sighand->siglo=
ck).
> To ensure we can't miss SIGKILL which can come right after we drop sigloc=
k,
> note again the new signal_group_exit() check above.

Sure, will switch to "goto relock".

Thank you!

Roman
