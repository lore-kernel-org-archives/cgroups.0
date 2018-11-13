From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v2 3/6] cgroup: cgroup v2 freezer
Date: Tue, 13 Nov 2018 17:00:04 +0100
Message-ID: <20181113160003.GD30990@redhat.com>
References: <20181112230422.5911-1-guro@fb.com>
 <20181112230422.5911-5-guro@fb.com>
 <20181113153700.GB30990@redhat.com>
 <20181113154349.GF2509588@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181113154349.GF2509588@devbig004.ftw2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Roman Gushchin <guroan@gmail.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Roman Gushchin <guro@fb.com>

Hi Tejun,

On 11/13, Tejun Heo wrote:
>
> > OK, please forget for now, but perhaps it would be more clean to add
> > JOBCTL_TRAP_FREEZE to the JOBCTL_PENDING_MASK check in recalc_sigpending()
> > and change get_signal to check JOBCTL_TRAP_MASK | JOBCTL_TRAP_FREEZE; and
> > I am not even sure cgroup_freezer_enter() should live in do_jobctl_trap().
>
> I'm sure you're aware of the context but just to refresh - one thing
> which was really broken about cgroup1 freezer was that it piggybacked
> on hibernation freezer and put frozen tasks in a state which is
> undefined when seen from userspace - they're just stuck in D sleep
> somewhere in the kernel.  That's fine when the whole system is not
> gonna be running, but not when only a subportion is being frozen.

Thanks, I see.

> So, the primary goal of cgroup2 freezer is putting the tasks in an
> equivalent state as jobctl stop.  It's a jobctl stop but controlled by
> cgroup frozen state, meaning that they can be killed, PTRACE_SEIZE'd
> and INTERRUPT'ed (PTRACE_ATTACH doesn't work as signal delivery should
> be blocked but that's fine) and so on.

And I agree, JOBCTL_TRAP_FREEZE looks fine.

Just somehow I _feel_ that we can improve this logic a bit, but let me
repeat that of course I can be easily wrong and I didn't even read the
patch yet.

Oleg.

