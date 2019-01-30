From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v6 4/7] cgroup: cgroup v2 freezer
Date: Wed, 30 Jan 2019 17:52:01 +0100
Message-ID: <20190130165200.GA4131@redhat.com>
References: <20181222000307.28231-1-guro@fb.com>
 <20181222000307.28231-5-guro@fb.com>
 <20190125122713.GA18218@redhat.com>
 <CALo0P13XnGiFykMXY3ZKu158ZqnBwHru0gyhQUrJSHEprnmiHQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALo0P13XnGiFykMXY3ZKu158ZqnBwHru0gyhQUrJSHEprnmiHQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guroan@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Roman Gushchin <guro@fb.com>

Hi Roman,

On 01/28, Roman Gushchin wrote:
>
> Yes, I think you're right: cgroup_exit() should check CGRP_FREEZE bit,
> not CGRP_FROZEN. Like cgroup_post_fork() does (a one-liner change below).

but this won't fix all problems? it seems that you missed my other concerns.

Firstly, this doesn't look consistent. Suppose a cgroup contains a single
process sleeping in ptrace_stop(). Then it becomes CGRP_FROZEN right after
"echo 1 > cgroup.freeze".

OTOH. if this single task sleeps in do_freezer_trap() and gets PTRACE_INTERRUPT,
it will equally sleep ptrace_stop() but cgroup won't be CGRP_FROZEN. Never.

Worse, this looks just wrong. In the latter case, cgroup becomes CGRP_FROZEN
right after a 2nd task migrates to this cgroup, before this new task calls
do_freezer_trap() or cgroup_enter_stopped().



> About spurious transitions (like frozen->non frozen->frozen on a task
> being SIGKILLed):
> in early versions of the patchset I've tried to avoid them, but then
> following the Tejun's advice
> switched over to expose them to a user. The logic behind is simple: if
> the state of the cgroup has been changed (a task is gone, for
> example), let's notify a user.

OK, I won't argue...

actually I can't argue because I do not really understand why do we want
a "killable" freezer, let alone ptraceable ;)

Oleg.

