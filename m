From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH v10 4/9] cgroup: cgroup v2 freezer
Date: Fri, 19 Apr 2019 16:11:23 +0000
Message-ID: <20190419161118.GA23357@tower.DHCP.thefacebook.com>
References: <20190405174708.1010-1-guro@fb.com>
 <20190405174708.1010-5-guro@fb.com> <20190419151912.GA12152@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=5YQBS8B9MDPxpYoO7RSF7J4DXEBiM8f9IyCWcDXCCd8=;
 b=e7CFt7HTnE/UKSLolWTsuDB+wIH0W4CudiAgr0RxeR5oXPF8a56vmntSXe/7Nw/fr1rS
 bgjxj44Ns5uZbw/FyWHcMFhyJDKRL9S3221w9bNzv+h6x9ODuR/S6cJk3i+Hrcdeg6p4
 x8DviBSDgqIIbBOCdj5PTQZyCWHytx5iAcU= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5YQBS8B9MDPxpYoO7RSF7J4DXEBiM8f9IyCWcDXCCd8=;
 b=HPpM7tBSMi4mmBxfGp7DPeNP1NAQ/XU228y/lFI7k+q93ZjojCY6xW/9VzK/i/hBWWD4gY4V4A9rSzVS7aJhdFdbSmiXWBfNUCYoSUBMjOCgOq91N3yF5+sA1I1MfhwQnFZipqLj9Hp6Ruq1oJFX3r9n6VcBJO9AhxyIh9MCiFY=
In-Reply-To: <20190419151912.GA12152@redhat.com>
Content-Language: en-US
Content-ID: <DB4FE982D79AB247B8AC1B1E520F88C1@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Roman Gushchin <guroan@gmail.com>, Tejun Heo <tj@kernel.org>, Kernel Team <Kernel-team@fb.com>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

Hi Oleg!

On Fri, Apr 19, 2019 at 05:19:12PM +0200, Oleg Nesterov wrote:
> On 04/05, Roman Gushchin wrote:
> >
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
> > +	}
> > +	spin_unlock_irq(&css_set_lock);
> > +
> > +	if (unlikely(current->frozen)) {
> > +		/*
> > +		 * If the task remained in the frozen state,
> > +		 * make sure it won't reach userspace without
> > +		 * entering the signal handling loop.
> > +		 */
> > +		spin_lock_irq(&current->sighand->siglock);
> > +		recalc_sigpending();
> > +		spin_unlock_irq(&current->sighand->siglock);
>=20
> I still can't understand this logic.
>=20
> Once again, suppose we race with CGRP_FREEZE. If JOBCTL_TRAP_FREEZE is al=
ready
> set then signal_pending() must be already T and we do not need recalc_sig=
pending?
> If JOBCTL_TRAP_FREEZE is not set yet, how can recalc_sigpending() help?

This is paired with cgroup_task_frozen() check in recalc_sigpending_tsk().
If the task is waking from waiting in vfork(), and it races with
unfreezing of the cgroup, we should guarantee that the task won't
return to userspace with task->frozen flag set, otherwise it would break
accounting of frozen tasks.
We can't rely solely on JOBCTL_TRAP_FREEZE bit, as it can be cleared
in parallel at any moment. So we backup it with the task->frozen check.

>=20
> > +static void cgroup_freeze_task(struct task_struct *task, bool freeze)
> > +{
> > +	unsigned long flags;
> > +
> > +	/* If the task is about to die, don't bother with freezing it. */
> > +	if (!lock_task_sighand(task, &flags))
> > +		return;
> > +
> > +	if (freeze) {
> > +		task->jobctl |=3D JOBCTL_TRAP_FREEZE;
> > +		signal_wake_up(task, false);
> > +	} else {
> > +		task->jobctl &=3D ~JOBCTL_TRAP_FREEZE;
> > +		wake_up_process(task);
>=20
> wake_up_interruptible() ?

Wait_up_interruptible() is supposed to work with a workqueue,
but here there is nothing like this. Probably, I didn't understand your ide=
a.
Can you, please, elaborate a bit more?

>=20
> >  static int ptrace_signal(int signr, kernel_siginfo_t *info)
> >  {
> >  	/*
> > @@ -2442,6 +2483,10 @@ bool get_signal(struct ksignal *ksig)
> >  		ksig->info.si_signo =3D signr =3D SIGKILL;
> >  		sigdelset(&current->pending.signal, SIGKILL);
> >  		recalc_sigpending();
> > +		current->jobctl &=3D ~JOBCTL_TRAP_FREEZE;
> > +		spin_unlock_irq(&sighand->siglock);
> > +		if (unlikely(cgroup_task_frozen(current)))
> > +			cgroup_leave_frozen(true);
>=20
> Oh, and another leave_frozen below...

Yeah, because of this new "goto fatal" shortcut.

>=20
> I feel this must be simplified somehow, but nothing comes to my mind righ=
t now.
>=20
> > +		/*
> > +		 * If the task is leaving the frozen state, let's update
> > +		 * cgroup counters and reset the frozen bit.
> > +		 */
> > +		if (unlikely(cgroup_task_frozen(current))) {
> >  			spin_unlock_irq(&sighand->siglock);
> > +			cgroup_leave_frozen(true);
> >  			goto relock;
> >  		}
>=20
> afaics cgroup_leave_frozen(false) makes more sense here.

Why? I don't see any reasons why the task should remain in the frozen
state after this point. Can you, please, provide an example?

Thank you for looking into it!

Roman
