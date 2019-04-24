From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH v10 4/9] cgroup: cgroup v2 freezer
Date: Wed, 24 Apr 2019 22:06:41 +0000
Message-ID: <20190424220634.GA22896@tower.DHCP.thefacebook.com>
References: <20190405174708.1010-1-guro@fb.com>
 <20190405174708.1010-5-guro@fb.com> <20190419151912.GA12152@redhat.com>
 <20190419161118.GA23357@tower.DHCP.thefacebook.com>
 <20190419162600.GC12228@redhat.com>
 <20190419165600.GC23357@tower.DHCP.thefacebook.com>
 <20190420105838.GA17468@redhat.com>
 <20190422221116.GA10341@tower.DHCP.thefacebook.com>
 <20190424154619.GG16167@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=OO0dT22zQMUOLHjqGwpb/WzX0H3cVmTSMhoD/vmHPmw=;
 b=Erq1WUQBh+vNUNTsq/PfkmWo/GtfO4zSNhQNGMuaKeTwJweEE2mHcB6AjP+3bhvDvF/r
 4I7F8viY3ji/E0u1tldqo+KjEv3y5uJnyOnTUc77jc81IEByxyEE0D35wxkaDETJtgwp
 6s0cGs2MlJ20CuZxS0ZAdobfw7CC8L3v5Cc= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OO0dT22zQMUOLHjqGwpb/WzX0H3cVmTSMhoD/vmHPmw=;
 b=RRCpGFX33OyAXPsQCvKYTK/dbrTiBThKBzb4NOH9H2F6adOzrx8XQsZTKqRFXb3gWJoxZStvewxRoUrLqiTP3tVDlqzR61ncIXw4YFXPTGAhC99GLqIMcZuAAnpTeOzt8iGISPjlcRH4Fzakxq3sDaiJjkL3EPZrCrfYCVYXiq8=
In-Reply-To: <20190424154619.GG16167@redhat.com>
Content-Language: en-US
Content-ID: <5F0127BE4FF174499F524C4EA730B549@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Roman Gushchin <guroan@gmail.com>, Tejun Heo <tj@kernel.org>, Kernel Team <Kernel-team@fb.com>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Wed, Apr 24, 2019 at 05:46:19PM +0200, Oleg Nesterov wrote:
> On 04/22, Roman Gushchin wrote:
> >
> > > > Hm, it might work too, but I'm not sure I like it more. IMO, the be=
st option
> > > > is to have a single cgroup_leave_frozen(true) in signal.c, it's jus=
t simpler.
> > > > If a user changed the desired state of cgroup twice, there is no ne=
ed to avoid
> > > > state transitions. Or maybe I don't see it yet.
> > >
> > > Then why do we need cgroup_leave_frozen(false) in wait_for_vfork_done=
() ? How
> > > does it differ from get_signal() ?
> >
> > We need it because sleeping in vfork is a special state which we want t=
o
> > account as frozen. And if the parent process wakes up while the cgroup =
is frozen
> > (because of the child death, for example), we want to push it into the =
"proper"
> > frozen state without changing the state of the cgroup.
>=20
> Again, I do not see how vfork() differs from get_signal() in this respect=
.
>=20
> Let me provide another example. A TASK_STOPPED task reacts to SIGCONT and
> returns to get_signal(), current->frozen is true.
>=20
> If this races with CGRP_FREEZE, the task should not return to user-space,
> just like vfork(). I see no difference.
>=20
> They differ in that wait_for_vfork_done() should guarentee TIF_SIGPENDING
> in this case, but this is another story...

Right, I agree.

>=20
> >
> > > If nothing else. Suppose that wait_for_vfork_done() calls leave(false=
) and this
> > > races with freezer, CGRP_FREEZE is already set but JOBCTL_TRAP_FREEZE=
 is not.
> > >
> > > This sets TIF_SIGPENDING to ensure the task won't return to user mode=
, thus it
> > > calls get_signal().
> > >
> > > get_signal() doesn't see JOBCTL_TRAP_FREEZE, it notices ->frozen =3D=
=3D T and does
> > > cgroup_leave_frozen(true) which clears ->frozen.
> > >
> > > Then the task calls dequeue_signal(), clears TIF_SIGPENDING and retur=
ns to user
> > > mode?
> >
> > Got it, a good catch! So if the freezer races with vfork() completion, =
we might
> > have a spurious frozen->unfrozen->frozen transition of the cgroup state=
.
> >
> > Switching to cgroup_leave_frozen(false) seems to solve it, but I'm slig=
htly
> > concerned that we're basically putting the task in a busy loop between
> > the setting CGRP_FREEZE and setting TRAP_FREEZE.
>=20
> Yes, yes. Didn't I say I dislike the new ->frozen check in recalc() ? ;)
>=20
> OK, how about the ABSOLUTELY UNTESTED patch below? For the start.

It looks good to me (and all freezer selftests pass).

Just to be sure, is it a solution to avoid the busy loop in the signal hand=
ling
loop, right? Because it doesn't allow to drop the ->frozen check from recal=
c().

The JOBCTL_TRAP_FREEZE check without siglock initially looked dangerous to =
me,
but after some thoughts I didn't find any case when it's wrong.

Do you prefer me to master a patch or to do it by yourself?

Thank you!

Roman
