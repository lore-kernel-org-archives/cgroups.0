From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH v6 4/7] cgroup: cgroup v2 freezer
Date: Mon, 11 Feb 2019 21:30:41 +0000
Message-ID: <20190211213036.GA26063@tower.DHCP.thefacebook.com>
References: <20181222000307.28231-1-guro@fb.com>
 <20181222000307.28231-5-guro@fb.com> <20190125122713.GA18218@redhat.com>
 <CALo0P13XnGiFykMXY3ZKu158ZqnBwHru0gyhQUrJSHEprnmiHQ@mail.gmail.com>
 <20190130165200.GA4131@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=dAvtRnouoomH/5+FCdXjdiZJP9FTb43GMpkXaL1gt4k=;
 b=JA5hP/zqgslfX+C9Hj6Z7TV9jOwkrn5sv+K3a9R9CNUk3LaKi3amN1hJ94gNCmBY3Szc
 uYcs8O0Yt24OPvsnROvlk51NpdPZt7r35rchsH04wCw8WEk6LyNS0W1W88F0nI4CNfAn
 1gUFjWuQXP46ir5Fod6SSDvtfqCFXWanR/s= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dAvtRnouoomH/5+FCdXjdiZJP9FTb43GMpkXaL1gt4k=;
 b=ZCRQTY4nH9dEtQHz0h1m92jg2XRNOwe6V2fIJFZF2Se8hGRw34a+1rXuUP8O2ndOpNcGkpXt5VbkkyYdqwikHgyx+jY0tqvVldx7sLRN5+9Pmv+czw/hPmhZ+osUyr3GY63hhNG7YAhRB+vaZyPKkdDg/YZd5X3zNX0TTfbHxaQ=
In-Reply-To: <20190130165200.GA4131@redhat.com>
Content-Language: en-US
Content-ID: <5480ACDE97BA074DAD356E05C5290704@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Roman Gushchin <guroan@gmail.com>, Tejun Heo <tj@kernel.org>, Kernel Team <Kernel-team@fb.com>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Wed, Jan 30, 2019 at 05:52:01PM +0100, Oleg Nesterov wrote:
> Hi Roman,
>=20
> On 01/28, Roman Gushchin wrote:
> >
> > Yes, I think you're right: cgroup_exit() should check CGRP_FREEZE bit,
> > not CGRP_FROZEN. Like cgroup_post_fork() does (a one-liner change below=
).

Hi Oleg!

Sorry for the late reply, I was out of work for some time...
Now I'm fully back.

>=20
> but this won't fix all problems? it seems that you missed my other concer=
ns.
>=20
> Firstly, this doesn't look consistent. Suppose a cgroup contains a single
> process sleeping in ptrace_stop(). Then it becomes CGRP_FROZEN right afte=
r
> "echo 1 > cgroup.freeze".
>=20
> OTOH. if this single task sleeps in do_freezer_trap() and gets PTRACE_INT=
ERRUPT,
> it will equally sleep ptrace_stop() but cgroup won't be CGRP_FROZEN. Neve=
r.
>=20
> Worse, this looks just wrong. In the latter case, cgroup becomes CGRP_FRO=
ZEN
> right after a 2nd task migrates to this cgroup, before this new task call=
s
> do_freezer_trap() or cgroup_enter_stopped().

You're right. So, it looks like the problem is in the equation
nr_tasks_frozen + nr_tasks_stopped =3D=3D nr_tasks_to_freeze ,
because a task can be frozen and stopped simultaneously.

So, basically it has to be
nr_tasks_frozen + nr_tasks_stopped >=3D nr_tasks_to_freeze instead.

I'll cover it with an unit test, and will post v7 soon.

>=20
>=20
>=20
> > About spurious transitions (like frozen->non frozen->frozen on a task
> > being SIGKILLed):
> > in early versions of the patchset I've tried to avoid them, but then
> > following the Tejun's advice
> > switched over to expose them to a user. The logic behind is simple: if
> > the state of the cgroup has been changed (a task is gone, for
> > example), let's notify a user.
>=20
> OK, I won't argue...
>=20
> actually I can't argue because I do not really understand why do we want
> a "killable" freezer, let alone ptraceable ;)

So the problem with the frozen state as in cgroup v1 that it's a very
special and "non-natural" task state, which requires special handling
in many places.

Just for an example, we're using oomd (userspace OOM handling daemon),
which selects and kills one of the workloads in case of too high memory
pressure. It should be able to kill all tasks in the selected cgroup,
but we definitely don't want to let it to fiddle with cgroup controls
to unfreeze the cgroup. Etc.

In other words, the cgroup freezer has a simple task of preventing
processes in the given cgroup to consume CPU resources. Unlike the system-w=
ide
freezer, it shouldn't try to make a "snapshot", it just a non-goal.

Thanks!
