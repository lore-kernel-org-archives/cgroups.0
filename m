From: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH] signal: don't always leave task frozen after
 ptrace_stop()
Date: Tue, 14 May 2019 18:01:59 +0200
Message-ID: <20190514160158.GB32459@redhat.com>
References: <20190513195517.2289671-1-guro@fb.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190513195517.2289671-1-guro@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Tejun Heo <tj@kernel.org>, Alex Xu <alex_y_xu@yahoo.ca>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Roman,

Sorry, I can't agree with this patch. And even the changelog doesn't
look right.

On 05/13, Roman Gushchin wrote:
>
> The ptrace_stop() function contains the cgroup_enter_frozen() call,
> but no cgroup_leave_frozen(). When ptrace_stop() is called from the
> do_jobctl_trap() path, it's correct, because corresponding
> cgroup_leave_frozen() calls in get_signal() will guarantee that
> the task won't leave the signal handler loop frozen.
>
> However, if ptrace_stop() is called from ptrace_signal() or
> ptrace_notify(), there is no such guarantee, and the task may leave
> with the frozen bit set.

ptrace_signal() looks fine in that the task can't return to user-mode,
get_signal() will be called again exactly because ->frozen == 1 means
TIF_SIGPENDING. So I an not surre I understand why ptrace_signal() does
ptrace_stop(false) with your patch. But this is minor.

> It leads to the regression, reported by Alex Xu. Write system call
> gets mistakenly interrupted by fake TIF_SIGPENDING, which is set
> by recalc_sigpending_tsk() because of the set frozen bit.

IMHO, the real problem is not that syscall was interrupted. The problem
is that a frozen task must never start the syscall.


---------------------------------------------------------------------------

Can't we add the unconditional leave_frozen() into ptrace_stop() for now ?

Sure, this is not what we want. Debugger can disturb CGRP_FROZEN.

But. The "may_remain_frozen" argument uglifies this code too much (imo) and
at the same time it doesn't solve the problem above: CGRP_FROZEN can be cleared
"for no reason".

Say, why ptrace_event_pid() should do leave_frozen(true) ? And if there is any
reason, then why wait_for_vfork_done() can do leave_frozen(false) ?

Or syscall-exit path. It can't miss get_signal(), it doesn't need leave_frozen().


In short, I believe that compared to the unconditional leave_frozen() in ptrace_stop()
this patch buys almost nothing, but makes the code and the whole logic much uglier.

Oleg.

