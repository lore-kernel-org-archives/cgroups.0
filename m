From: Florian Weimer <fweimer@redhat.com>
Subject: Re: [PATCH 3/3] sched: Implement interface for cgroup unified
 hierarchy
Date: Sun, 25 Oct 2015 11:47:04 +0100
Message-ID: <562CB328.3090906@redhat.com>
References: <CAPM31RJvrPL7S37=yhxMA5OGUFNUfPurTZ21nfH6eFRb15ZGtw@mail.gmail.com>
 <20150912144007.GA8942@htj.duckdns.org>
 <CAPM31RLAtuaDbE9+nvMvgMB8zaOpxVcriCyE9qqszNM3XXTo5Q@mail.gmail.com>
 <20151001184629.GB26498@mtj.duckdns.org>
 <CAPM31RKx0vT-9VFN=XASYM4iv4U5ZGZW93XRtJd_7mOHwu76NA@mail.gmail.com>
 <20151023222110.GA4390@mtj.duckdns.org> <1445661367.3218.62.camel@gmail.com>
 <20151025021829.GA15471@mtj.duckdns.org>
 <CA+55aFzMdG5VPA0ZvoFANj-H-7LHeu=JUvvqPykF_w5Nd0pnSA@mail.gmail.com>
 <20151025093331.GA4834@gmail.com> <20151025104145.GE27558@thunk.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151025104145.GE27558@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Theodore Ts'o <tytso@mit.edu>, Ingo Molnar <mingo@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Mike Galbraith <umgwanakikbuti@gmail.com>, Paul Turner <pjt@google.com>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, Li Zefan <lizefan@huawei.com>, cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-team <kernel-team@fb.com>, Andrew Morton <akpm@linux-foundation.org>

On 10/25/2015 11:41 AM, Theodore Ts'o wrote:
> On Sun, Oct 25, 2015 at 10:33:32AM +0100, Ingo Molnar wrote:
>>
>> Hm, that's weird - all our sched_*() system call APIs that set task scheduling 
>> priorities are fundamentally per thread, not per process. Same goes for the old 
>> sys_nice() interface. The scheduler has no real notion of 'process', and certainly 
>> not at the system call level.
>>
> 
> I suspect the main issue is that the games programmers were trying to
> access it via libc / pthreads, which hides a lot of the power
> available at the raw syscall level.  This is probably more of a
> "tutorial needed for userspace programmers" issue, at a guess.

If this refers to the lack of exposure of thread IDs in glibc, we are
willing to change that on glibc side.  The discussion has progressed to
the point where it is now about the question whether it should be part
of the GNU API (like sched_setaffinity), or live in glibc as a
Linux-specific extension (like sched_getcpu).  More input is certainly
welcome.

Old concerns about support for n:m threading implementations in glibc
are no longer relevant because too much code using well-documented
interfaces would break.

Florian
