From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH v8 0/7] freezer for cgroup v2
Date: Thu, 21 Feb 2019 22:43:58 +0000
Message-ID: <20190221224352.GA24252@tower.DHCP.thefacebook.com>
References: <20190219220252.4906-1-guro@fb.com>
 <20190220143748.GA9477@redhat.com>
 <20190220220020.GA16335@castle.DHCP.thefacebook.com>
 <20190221162923.GA26064@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=s1MXrnL7uro4t+iPYg88is8usA52Zxw7e4MQw6xasYI=;
 b=kvR70Btw4jDwGqhIxSBGtEY4vY6Al1KzBWqYlfq4/Bh1QXqIq4tFyLGzV2eP9YCQ46Z8
 IeAnPfZb6Xj1ivS0hWIYku+9EaKn2ue1OcnsMYc/c/dKgORYloQoFoHl1bfnCVdmOqVS
 2HKEMyaeP6AsZnlTqt9FpDmumN974MIjgGc= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s1MXrnL7uro4t+iPYg88is8usA52Zxw7e4MQw6xasYI=;
 b=KcDSTjXiyjQt9Bzi85eyqnLxqrNM73i5dE12E+HHY7RI7fmYUJ2WlNVnNP8XfZ2is9XmViGVpFvOp78uIZP0GQQU99JrFdppnwZ+ZtaWLEhVyep19RkHsTvvsR2uP1dIwYGMLLfNidZzK0XBF5gSGDMZ1/16H7pkwkYf0pD5Uwo=
In-Reply-To: <20190221162923.GA26064@redhat.com>
Content-Language: en-US
Content-ID: <5A383B398F6CA64290A21DCCD68EC6D3@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Roman Gushchin <guroan@gmail.com>, Tejun Heo <tj@kernel.org>, Kernel Team <Kernel-team@fb.com>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Thu, Feb 21, 2019 at 05:29:24PM +0100, Oleg Nesterov wrote:
> On 02/20, Roman Gushchin wrote:
> >
> > On Wed, Feb 20, 2019 at 03:37:48PM +0100, Oleg Nesterov wrote:
> > >
> > > I tried to not argue with intent, but to be honest I am more and more
> > > sceptical... Lets forget about ptrace for the moment.
> > >
> > > Once again, why do we want a killable freezer?
> > >
> > > If a user wants to kill a frozen task from CGRP_FROZEN cgroup he can =
simply
> > >
> > > 	1. send SIGKILL to that task
> > >
> > > 	2. migrate it to the root cgroup.
> > >
> > > why this doesn't / can't work?
> >
> > It does work, but it doesn't look as a nice interface to take into
> > the cgroup v2 world.
> >
> > It just not clear, why killing a frozen task requires some cgroup-level
> > operations? It doesn't add anything except some additional complexity
> > to the userspace.
>=20
> Yes.
>=20
> But to me this is a reasonable trade-off because this way we do not add
> additional complexity to the kernel.
>=20
> Actually, "killable" is not that difficult afaics. "ptraceable" looks mor=
e
> problematic to me. Again, user-space can do
>=20
> 	1. PTRACE_SEIZE
> 	2. move the tracee to the root cgroup
> 	3. do anything with the tracee
> 	4. move it back
>=20
> > Generally speaking, any process hanging in D-state
> > for a long time isn't the nicest object from the userspace's point of v=
iew.
>=20
> Roman, this is unfair comparison ;)

Why not? This is exactly the point, with v1 freezer you get a task in D sta=
te,
which isn't manageable by userspace without some actions with sysfs.

>=20
> > Exactly as a SIGSTOPped process can be killed without sending SIGCONT,
> > why a frozen task would require some additional operations?
>=20
> this too,
>=20
> > And I'm not talking about the case, when the process which is sending
> > SIGKILL has no write access to cgroupfs.
>=20
> True.
>=20
> But there is another case. If admin wants to freeze a cgroup then it is n=
ot
> clear why a user which can send SIGKILL to a frozen process should wake i=
t up.

But it will woken up only for a short moment. And the cgroup will remain fr=
ozen
in a sense that belonging processes do not consume CPU.
Actually, a signal can be useful: for example, if it was the last process,
the container management software might want to delete the cgroup.

>=20
> -------------------------------------------------------------------------=
-----
> Again, it is not that I hate the idea of killable/ptraceable freezer. Jus=
t I
> personally think it's not worth the trouble. Perhaps I am wrong, but so f=
ar
> I do not see a good implementation...
>=20
> And, apart from reading/writing the registers, what can ptrace do with a =
frozen
> tracee? This doesn't look like a "must have" feature to me.

I think the minimal requirement is that the tracing application should not =
hang
and wait for tracee to be unfrozen.
So, imagine you're trying to debug an application in production with gdb,
and occasionally gdb just hangs because some cluster management stuff froze
the tracee's cgroup. Not the best user experience.

>=20
> At least, may I ask you again to make (if possible) a separate patch whic=
h adds
> the ability to kill/ptrace?

I'll try, but not sure if it can make the code easier for review.
It looks like this ability defines the implementation.

> -------------------------------------------------------------------------=
-----
>=20
> > > Why I am starting to argue... The ability to kill a frozen task compl=
icates
> > > the code, and since cgroup_enter_stopped() (in this version at least)=
 doesn't
> > > properly interacts with freezable_schedule() leads to other problems.
> > >
> > > From 7/7:
> > >
> > > 	+  cgroup.freeze
> > > 	+	A read-write single value file which exists on non-root cgroups.
> > > 	+	Allowed values are "0" and "1". The default is "0".
> > > 	+
> > > 	+	Writing "1" to the file causes freezing of the cgroup and all
> > > 	+	descendant cgroups. This means that all belonging processes will
> > > 	+	be stopped and will not run until the cgroup will be explicitly
> > > 	+	unfrozen. Freezing of the cgroup may take some time;
> > >                                                  ^^^^^^^^^^^^^^^^^^
> > > it may take infinite time.
> > >
> > > Just suppose that a task does vfork() and this races with cgroup_do_f=
reeze(true).
> > > If the new child notices JOBCTL_TRAP_FREEZE before exit/exec the cgro=
up will be
> > > never frozen.
> >
> > Hm, why? cgroup_update_frozen() called from cgroup_post_fork() should b=
ring
> > the cgroup into the frozen state. If it's not true (I'm missing some ra=
ce here),
> > it's a bug, but I don't see why it's not possible in general.
>=20
> A task P calls vfork() and creates the new child C. Now, how can the pare=
nt P
> (which sleeps in TASK_KILLABLE) call cgroup_enter_stopped() ? It can't un=
til C
> exits or execs. C can't exit or exec because it is frozen.

Got it. I'll address it in the next version.

Thanks!
