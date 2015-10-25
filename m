From: Florian Weimer <fweimer@redhat.com>
Subject: Re: [PATCH 3/3] sched: Implement interface for cgroup unified
 hierarchy
Date: Sun, 25 Oct 2015 14:17:23 +0100
Message-ID: <562CD663.5010506@redhat.com>
References: <CAPM31RLAtuaDbE9+nvMvgMB8zaOpxVcriCyE9qqszNM3XXTo5Q@mail.gmail.com>
 <20151001184629.GB26498@mtj.duckdns.org>
 <CAPM31RKx0vT-9VFN=XASYM4iv4U5ZGZW93XRtJd_7mOHwu76NA@mail.gmail.com>
 <20151023222110.GA4390@mtj.duckdns.org> <1445661367.3218.62.camel@gmail.com>
 <20151025021829.GA15471@mtj.duckdns.org>
 <CA+55aFzMdG5VPA0ZvoFANj-H-7LHeu=JUvvqPykF_w5Nd0pnSA@mail.gmail.com>
 <20151025093331.GA4834@gmail.com> <20151025104145.GE27558@thunk.org>
 <562CB328.3090906@redhat.com> <20151025115842.GA13940@thunk.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151025115842.GA13940@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Theodore Ts'o <tytso@mit.edu>, Ingo Molnar <mingo@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Mike Galbraith <umgwanakikbuti@gmail.com>, Paul Turner <pjt@google.com>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, Li Zefan <lizefan@huawei.com>, cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-team <kernel-team@fb.com>, Andrew Morton <akpm@linux-foundation.org>

On 10/25/2015 12:58 PM, Theodore Ts'o wrote:

> Well, I was thinking we could just teach them to use
> "syscall(SYS_gettid)".

Right, and that's easier if TIDs are officially part of the GNU API.

I think the worry is that some future system might have TIDs which do
not share the PID space, or are real descriptors (that they need
explicit open and close operations).

> On a different subject, I'm going to start telling people to use
> "syscall(SYS_getrandom)", since I think that's going to be easier than
> having asking people to change their Makefiles to link against some
> Linux-specific library, but that's a different debate, and I recognize
> the glibc folks aren't willing to bend on that one.

I think we can reach consensus for an implementation which makes this code

  unsigned char session_key[32];
  getrandom (session_key, sizeof (session_key), 0);
  install_session_key (session_key);

correct.  That is, no error handling code for ENOMEM, ENOSYS, EINTR,
ENOMEM or short reads is necessary.  It seems that several getrandom
wrappers currently built into applications do not get this completely right.

Florian
