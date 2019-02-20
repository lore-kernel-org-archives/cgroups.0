From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH v8 0/7] freezer for cgroup v2
Date: Wed, 20 Feb 2019 22:00:27 +0000
Message-ID: <20190220220020.GA16335@castle.DHCP.thefacebook.com>
References: <20190219220252.4906-1-guro@fb.com>
 <20190220143748.GA9477@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=vhEPKFB/oj8EfoFHOMrNae0jBKCk68arb5bwwFSNXDo=;
 b=ReG69GkXug5aAoN8VT77IziQoOQ8Y9MAe5rGUtl9GvyGweYZmSOvNigc9X+BNPxVJipi
 2+TnYi2yjEHg5NWCKe2boTopJibkrk4urveEOGQIFDMe1Tr5fMJY7JupcudhEk+2lk3x
 oUfqjbcf7nlH91titLMzRk0ZPqh570kDUNo= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vhEPKFB/oj8EfoFHOMrNae0jBKCk68arb5bwwFSNXDo=;
 b=Xt8e5bksH3fd/GPGtb71pEsRTnVO6TQXG60DMkcMFq3CMPLyTLRNaTT1TrrbbyAd94K0kTwadg8Ok9rLmNnduwtt4DiWMaqaJS66zpqaXlVnznCsW4klV0KRl0WhJPGWDfCM6/ubc+sdNJsKDG5GkCfXJBg1+0VEbc8S5msrDbA=
In-Reply-To: <20190220143748.GA9477@redhat.com>
Content-Language: en-US
Content-ID: <9EA294F400D2BD4998284D50FB893001@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Roman Gushchin <guroan@gmail.com>, Tejun Heo <tj@kernel.org>, Kernel Team <Kernel-team@fb.com>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Wed, Feb 20, 2019 at 03:37:48PM +0100, Oleg Nesterov wrote:
> On 02/19, Roman Gushchin wrote:
> >
> > It provides similar functionality as v1 freezer, but the interface
> > conforms to the cgroup v2 interface design principles, and it
> > provides a better user experience: tasks can be killed, ptrace works,
>=20
> I tried to not argue with intent, but to be honest I am more and more
> sceptical... Lets forget about ptrace for the moment.
>=20
> Once again, why do we want a killable freezer?
>=20
> If a user wants to kill a frozen task from CGRP_FROZEN cgroup he can simp=
ly
>=20
> 	1. send SIGKILL to that task
>=20
> 	2. migrate it to the root cgroup.
>=20
> why this doesn't / can't work?

It does work, but it doesn't look as a nice interface to take into
the cgroup v2 world.

It just not clear, why killing a frozen task requires some cgroup-level
operations? It doesn't add anything except some additional complexity
to the userspace. Generally speaking, any process hanging in D-state
for a long time isn't the nicest object from the userspace's point of view.

Exactly as a SIGSTOPped process can be killed without sending SIGCONT,
why a frozen task would require some additional operations?

And I'm not talking about the case, when the process which is sending
SIGKILL has no write access to cgroupfs.


> Why I am starting to argue... The ability to kill a frozen task complicat=
es
> the code, and since cgroup_enter_stopped() (in this version at least) doe=
sn't
> properly interacts with freezable_schedule() leads to other problems.
>=20
> From 7/7:
>=20
> 	+  cgroup.freeze
> 	+	A read-write single value file which exists on non-root cgroups.
> 	+	Allowed values are "0" and "1". The default is "0".
> 	+
> 	+	Writing "1" to the file causes freezing of the cgroup and all
> 	+	descendant cgroups. This means that all belonging processes will
> 	+	be stopped and will not run until the cgroup will be explicitly
> 	+	unfrozen. Freezing of the cgroup may take some time;
>                                                  ^^^^^^^^^^^^^^^^^^
> it may take infinite time.
>=20
> Just suppose that a task does vfork() and this races with cgroup_do_freez=
e(true).
> If the new child notices JOBCTL_TRAP_FREEZE before exit/exec the cgroup w=
ill be
> never frozen.

Hm, why? cgroup_update_frozen() called from cgroup_post_fork() should bring
the cgroup into the frozen state. If it's not true (I'm missing some race h=
ere),
it's a bug, but I don't see why it's not possible in general.

>=20
> If I read the current kernel/cgroup/freezer.c correctly, CGROUP_FREEZING =
should
> "always" work (unless a task hangs in D state) and to me this looks more =
important
> than kill/ptrace support...

Again, I don't see a case, when cgroup v1 freezer will work and the propose=
d
v2 freezer won't work in general.

>=20
> > there is no separate controller, which has to be enabled, etc.
>=20
> agreed, this is nice.

Thanks!
