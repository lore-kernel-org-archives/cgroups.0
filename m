From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v8 0/7] freezer for cgroup v2
Date: Wed, 20 Feb 2019 15:37:48 +0100
Message-ID: <20190220143748.GA9477@redhat.com>
References: <20190219220252.4906-1-guro@fb.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190219220252.4906-1-guro@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guroan@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Roman Gushchin <guro@fb.com>

On 02/19, Roman Gushchin wrote:
>
> It provides similar functionality as v1 freezer, but the interface
> conforms to the cgroup v2 interface design principles, and it
> provides a better user experience: tasks can be killed, ptrace works,

I tried to not argue with intent, but to be honest I am more and more
sceptical... Lets forget about ptrace for the moment.

Once again, why do we want a killable freezer?

If a user wants to kill a frozen task from CGRP_FROZEN cgroup he can simply

	1. send SIGKILL to that task

	2. migrate it to the root cgroup.

why this doesn't / can't work?



Why I am starting to argue... The ability to kill a frozen task complicates
the code, and since cgroup_enter_stopped() (in this version at least) doesn't
properly interacts with freezable_schedule() leads to other problems.

From 7/7:

	+  cgroup.freeze
	+	A read-write single value file which exists on non-root cgroups.
	+	Allowed values are "0" and "1". The default is "0".
	+
	+	Writing "1" to the file causes freezing of the cgroup and all
	+	descendant cgroups. This means that all belonging processes will
	+	be stopped and will not run until the cgroup will be explicitly
	+	unfrozen. Freezing of the cgroup may take some time;
                                                 ^^^^^^^^^^^^^^^^^^
it may take infinite time.

Just suppose that a task does vfork() and this races with cgroup_do_freeze(true).
If the new child notices JOBCTL_TRAP_FREEZE before exit/exec the cgroup will be
never frozen.

If I read the current kernel/cgroup/freezer.c correctly, CGROUP_FREEZING should
"always" work (unless a task hangs in D state) and to me this looks more important
than kill/ptrace support...

> there is no separate controller, which has to be enabled, etc.

agreed, this is nice.

Oleg.

