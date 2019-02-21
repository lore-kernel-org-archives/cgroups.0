From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v8 0/7] freezer for cgroup v2
Date: Thu, 21 Feb 2019 17:29:24 +0100
Message-ID: <20190221162923.GA26064@redhat.com>
References: <20190219220252.4906-1-guro@fb.com>
 <20190220143748.GA9477@redhat.com>
 <20190220220020.GA16335@castle.DHCP.thefacebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190220220020.GA16335@castle.DHCP.thefacebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Roman Gushchin <guroan@gmail.com>, Tejun Heo <tj@kernel.org>, Kernel Team <Kernel-team@fb.com>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On 02/20, Roman Gushchin wrote:
>
> On Wed, Feb 20, 2019 at 03:37:48PM +0100, Oleg Nesterov wrote:
> >
> > I tried to not argue with intent, but to be honest I am more and more
> > sceptical... Lets forget about ptrace for the moment.
> >
> > Once again, why do we want a killable freezer?
> >
> > If a user wants to kill a frozen task from CGRP_FROZEN cgroup he can simply
> >
> > 	1. send SIGKILL to that task
> >
> > 	2. migrate it to the root cgroup.
> >
> > why this doesn't / can't work?
>
> It does work, but it doesn't look as a nice interface to take into
> the cgroup v2 world.
>
> It just not clear, why killing a frozen task requires some cgroup-level
> operations? It doesn't add anything except some additional complexity
> to the userspace.

Yes.

But to me this is a reasonable trade-off because this way we do not add
additional complexity to the kernel.

Actually, "killable" is not that difficult afaics. "ptraceable" looks more
problematic to me. Again, user-space can do

	1. PTRACE_SEIZE
	2. move the tracee to the root cgroup
	3. do anything with the tracee
	4. move it back

> Generally speaking, any process hanging in D-state
> for a long time isn't the nicest object from the userspace's point of view.

Roman, this is unfair comparison ;)

> Exactly as a SIGSTOPped process can be killed without sending SIGCONT,
> why a frozen task would require some additional operations?

this too,

> And I'm not talking about the case, when the process which is sending
> SIGKILL has no write access to cgroupfs.

True.

But there is another case. If admin wants to freeze a cgroup then it is not
clear why a user which can send SIGKILL to a frozen process should wake it up.

------------------------------------------------------------------------------
Again, it is not that I hate the idea of killable/ptraceable freezer. Just I
personally think it's not worth the trouble. Perhaps I am wrong, but so far
I do not see a good implementation...

And, apart from reading/writing the registers, what can ptrace do with a frozen
tracee? This doesn't look like a "must have" feature to me.

At least, may I ask you again to make (if possible) a separate patch which adds
the ability to kill/ptrace?
------------------------------------------------------------------------------

> > Why I am starting to argue... The ability to kill a frozen task complicates
> > the code, and since cgroup_enter_stopped() (in this version at least) doesn't
> > properly interacts with freezable_schedule() leads to other problems.
> >
> > From 7/7:
> >
> > 	+  cgroup.freeze
> > 	+	A read-write single value file which exists on non-root cgroups.
> > 	+	Allowed values are "0" and "1". The default is "0".
> > 	+
> > 	+	Writing "1" to the file causes freezing of the cgroup and all
> > 	+	descendant cgroups. This means that all belonging processes will
> > 	+	be stopped and will not run until the cgroup will be explicitly
> > 	+	unfrozen. Freezing of the cgroup may take some time;
> >                                                  ^^^^^^^^^^^^^^^^^^
> > it may take infinite time.
> >
> > Just suppose that a task does vfork() and this races with cgroup_do_freeze(true).
> > If the new child notices JOBCTL_TRAP_FREEZE before exit/exec the cgroup will be
> > never frozen.
>
> Hm, why? cgroup_update_frozen() called from cgroup_post_fork() should bring
> the cgroup into the frozen state. If it's not true (I'm missing some race here),
> it's a bug, but I don't see why it's not possible in general.

A task P calls vfork() and creates the new child C. Now, how can the parent P
(which sleeps in TASK_KILLABLE) call cgroup_enter_stopped() ? It can't until C
exits or execs. C can't exit or exec because it is frozen.

> > If I read the current kernel/cgroup/freezer.c correctly, CGROUP_FREEZING should
> > "always" work (unless a task hangs in D state) and to me this looks more important
> > than kill/ptrace support...
>
> Again, I don't see a case, when cgroup v1 freezer will work and the proposed
> v2 freezer won't work in general.

See above.

Oleg.

