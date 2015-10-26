From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 3/3] sched: Implement interface for cgroup unified
 hierarchy
Date: Mon, 26 Oct 2015 15:10:27 +0100
Message-ID: <20151026141027.GW2508@worktop.programming.kicks-ass.net>
References: <CAPM31RKx0vT-9VFN=XASYM4iv4U5ZGZW93XRtJd_7mOHwu76NA@mail.gmail.com>
 <20151023222110.GA4390@mtj.duckdns.org>
 <1445661367.3218.62.camel@gmail.com>
 <20151025021829.GA15471@mtj.duckdns.org>
 <CA+55aFzMdG5VPA0ZvoFANj-H-7LHeu=JUvvqPykF_w5Nd0pnSA@mail.gmail.com>
 <20151025093331.GA4834@gmail.com>
 <20151025104145.GE27558@thunk.org>
 <562CB328.3090906@redhat.com>
 <20151025115842.GA13940@thunk.org>
 <562CD663.5010506@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <562CD663.5010506@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Florian Weimer <fweimer@redhat.com>
Cc: Theodore Ts'o <tytso@mit.edu>, Ingo Molnar <mingo@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Mike Galbraith <umgwanakikbuti@gmail.com>, Paul Turner <pjt@google.com>, Ingo Molnar <mingo@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, Li Zefan <lizefan@huawei.com>, cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-team <kernel-team@fb.com>, Andrew Morton <akpm@linux-foundation.org>

On Sun, Oct 25, 2015 at 02:17:23PM +0100, Florian Weimer wrote:
> On 10/25/2015 12:58 PM, Theodore Ts'o wrote:
> 
> > Well, I was thinking we could just teach them to use
> > "syscall(SYS_gettid)".
> 
> Right, and that's easier if TIDs are officially part of the GNU API.
> 
> I think the worry is that some future system might have TIDs which do
> not share the PID space, or are real descriptors (that they need
> explicit open and close operations).

For the scheduler the sharing of pid/tid space is not an issue.

Semantically all [1] scheduler syscalls take a tid. There isn't a single
syscall that iterates the thread group.

Even sys_setpriority() interprets its @who argument as a tid when
@which == PRIO_PROCESS (PRIO_PGRP looks to be the actual process).

[1] as seen from: git grep SYSCALL kernel/sched/

