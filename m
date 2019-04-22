From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH v10 4/9] cgroup: cgroup v2 freezer
Date: Mon, 22 Apr 2019 22:11:22 +0000
Message-ID: <20190422221116.GA10341@tower.DHCP.thefacebook.com>
References: <20190405174708.1010-1-guro@fb.com>
 <20190405174708.1010-5-guro@fb.com> <20190419151912.GA12152@redhat.com>
 <20190419161118.GA23357@tower.DHCP.thefacebook.com>
 <20190419162600.GC12228@redhat.com>
 <20190419165600.GC23357@tower.DHCP.thefacebook.com>
 <20190420105838.GA17468@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=OYV/QkCLKRJvFA326Z6+sTKwufHsZL75V0CTOKVRIV8=;
 b=hMylz/i7ddF3Idn4qvCvoWlhZecQho0UkzO/9BAX0tPH9SA7XBIL+Mxk3tyapDrk7l8G
 4eH84ToYjb+Qhi9k8ecMzVcwqBgSZubjEB98pb2vbCAZP8HBn998kbIZuMa2DYvLBYdf
 8KSLkV8Toy06AdHSsWjKGKMAqQOXW6sEMmk= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OYV/QkCLKRJvFA326Z6+sTKwufHsZL75V0CTOKVRIV8=;
 b=hfEBlBPSiv394G3gx4d3mvw8FKrE3NKqY84G2Wx2AIV6p7pwk36yMhgiE978Obl6eCOmrMmVoGwz+TAPYLrQTjnSoVFDHQFfhhQZnk33pLqcDzLvhdDS9U6fOdnS/WnXCfej6825QkBBdss5hxyeDk26NE2WmqLrCdbUU2BaXqQ=
In-Reply-To: <20190420105838.GA17468@redhat.com>
Content-Language: en-US
Content-ID: <B91AB6C224AD854BBF2B3FE7BC05ED8D@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Roman Gushchin <guroan@gmail.com>, Tejun Heo <tj@kernel.org>, Kernel Team <Kernel-team@fb.com>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Sat, Apr 20, 2019 at 12:58:38PM +0200, Oleg Nesterov wrote:
> On 04/19, Roman Gushchin wrote:
> >
> > > > >
> > > > > wake_up_interruptible() ?
> > > >
> > > > Wait_up_interruptible() is supposed to work with a workqueue,
> > > > but here there is nothing like this. Probably, I didn't understand =
your idea.
> > > > Can you, please, elaborate a bit more?
> > >
> > > Not sure I understand... We need to wake up the task if it sleeps in
> > > do_freezer_trap(), right? do_freezer_trap() uses TASK_INTERRUPTIBLE, =
so
> > > why can't wake_up_interruptible() =3D=3D __wake_up(TASK_INTERRUPTIBLE=
) work?
> >
> > Right, but __wake_up is supposed to wake threads blocked on a waitqueue=
:
>=20
> Ugh sorry ;) of course I meant wake_up_state(task, TASK_INTERRUPTIBLE).

Agh, then it makes total sense to me. I'll master a follow-up patch.

>=20
> > > > > > +		if (unlikely(cgroup_task_frozen(current))) {
> > > > > >  			spin_unlock_irq(&sighand->siglock);
> > > > > > +			cgroup_leave_frozen(true);
> > > > > >  			goto relock;
> > > > > >  		}
> > > > >
> > > > > afaics cgroup_leave_frozen(false) makes more sense here.
> > > >
> > > > Why? I don't see any reasons why the task should remain in the froz=
en
> > > > state after this point.
> > >
> > > But cgroup_leave_frozen(false) will equally clear ->frozen if !CGRP_F=
REEZE ?
> > > OTOH, if CGRP_FREEZE is set again, why do we need to clear ->frozen?
> >
> > Hm, it might work too, but I'm not sure I like it more. IMO, the best o=
ption
> > is to have a single cgroup_leave_frozen(true) in signal.c, it's just si=
mpler.
> > If a user changed the desired state of cgroup twice, there is no need t=
o avoid
> > state transitions. Or maybe I don't see it yet.
>=20
> Then why do we need cgroup_leave_frozen(false) in wait_for_vfork_done() ?=
 How
> does it differ from get_signal() ?

We need it because sleeping in vfork is a special state which we want to
account as frozen. And if the parent process wakes up while the cgroup is f=
rozen
(because of the child death, for example), we want to push it into the "pro=
per"
frozen state without changing the state of the cgroup.

>=20
> If nothing else. Suppose that wait_for_vfork_done() calls leave(false) an=
d this
> races with freezer, CGRP_FREEZE is already set but JOBCTL_TRAP_FREEZE is =
not.
>=20
> This sets TIF_SIGPENDING to ensure the task won't return to user mode, th=
us it
> calls get_signal().
>=20
> get_signal() doesn't see JOBCTL_TRAP_FREEZE, it notices ->frozen =3D=3D T=
 and does
> cgroup_leave_frozen(true) which clears ->frozen.
>=20
> Then the task calls dequeue_signal(), clears TIF_SIGPENDING and returns t=
o user
> mode?

Got it, a good catch! So if the freezer races with vfork() completion, we m=
ight
have a spurious frozen->unfrozen->frozen transition of the cgroup state.

Switching to cgroup_leave_frozen(false) seems to solve it, but I'm slightly
concerned that we're basically putting the task in a busy loop between
the setting CGRP_FREEZE and setting TRAP_FREEZE. Do you think it's ok?
I wonder if there are better solutions.

Thank you!
