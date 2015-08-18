From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 3/3] sched: Implement interface for cgroup unified
 hierarchy
Date: Wed, 19 Aug 2015 08:39:43 +0900
Message-ID: <55D3C23F.702@jp.fujitsu.com>
References: <1438641689-14655-1-git-send-email-tj@kernel.org>
 <1438641689-14655-4-git-send-email-tj@kernel.org>
 <20150804090711.GL25159@twins.programming.kicks-ass.net>
 <20150804151017.GD17598@mtj.duckdns.org>
 <20150805091036.GT25159@twins.programming.kicks-ass.net>
 <20150805143132.GK17598@mtj.duckdns.org>
 <CAPM31RJTf0v=2v90kN6-HM9xUGab_k++upO0Ym=irmfO9+BbFw@mail.gmail.com>
 <CAPM31R+5=4bGQo++PrYoFuS86_7JqhhQ0OtPvCYooAzJsvhb=w@mail.gmail.com>
 <20150818203117.GC15739@mtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150818203117.GC15739@mtj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj@kernel.org>, Paul Turner <pjt@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, lizefan@huawei.com, cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-team <kernel-team@fb.com>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>

On 2015/08/19 5:31, Tejun Heo wrote:
> Hello, Paul.
>
> On Mon, Aug 17, 2015 at 09:03:30PM -0700, Paul Turner wrote:
>>> 2) Control within an address-space.  For subsystems with fungible resources,
>>> e.g. CPU, it can be useful for an address space to partition its own
>>> threads.  Losing the capability to do this against the CPU controller would
>>> be a large set-back for instance.  Occasionally, it is useful to share these
>>> groupings between address spaces when processes are cooperative, but this is
>>> less of a requirement.
>>>
>>> This is important to us.
>
> Sure, let's build a proper interface for that.  Do you actually need
> sub-hierarchy inside a process?  Can you describe your use case in
> detail and why having hierarchical CPU cycle distribution is essential
> for your use case?

An actual per-thread use case in our customers is qemu-kvm + cpuset.
customers pin each vcpus and qemu-kvm's worker threads to cpus.
For example, pinning 4 vcpus to cpu 2-6 and pinning qemu main thread and
others(vhost) to cpu 0-1.

This is an actual kvm tuning on our customers for performance guarantee.

In another case, cpu cgroup's throttling feature is used per vcpu for vm cpu sizing.

Thanks,
-Kame
