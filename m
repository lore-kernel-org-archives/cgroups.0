From: Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCHSET for-4.11] cgroup: implement cgroup v2 thread mode
Date: Tue, 14 Mar 2017 15:45:42 +0100
Message-ID: <1489502742.4111.29.camel@gmx.de>
References: <20170203202048.GD6515@twins.programming.kicks-ass.net>
         <20170203205955.GA9886@mtj.duckdns.org>
         <20170206124943.GJ6515@twins.programming.kicks-ass.net>
         <20170208230819.GD25826@htj.duckdns.org>
         <20170209102909.GC6515@twins.programming.kicks-ass.net>
         <20170210154508.GA16097@mtj.duckdns.org>
         <20170210175145.GJ6515@twins.programming.kicks-ass.net>
         <20170212050544.GJ29323@mtj.duckdns.org> <1486882799.24462.25.camel@gmx.de>
         <1486964707.5912.93.camel@gmx.de> <20170313192621.GD15709@htj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170313192621.GD15709@htj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, lizefan@huawei.com, hannes@cmpxchg.org, mingo@redhat.com, pjt@google.com, luto@amacapital.net, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, lvenanci@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>

On Mon, 2017-03-13 at 15:26 -0400, Tejun Heo wrote:
> Hello, Mike.
> 
> Sorry about the long delay.
> 
> On Mon, Feb 13, 2017 at 06:45:07AM +0100, Mike Galbraith wrote:
> > > > So, as long as the depth stays reasonable (single digit or lower),
> > > > what we try to do is keeping tree traversal operations aggregated or
> > > > located on slow paths.  There still are places that this overhead
> > > > shows up (e.g. the block controllers aren't too optimized) but it
> > > > isn't particularly difficult to make a handful of layers not matter at
> > > > all.
> > > 
> > > A handful of cpu bean counting layers stings considerably.
> 
> Hmm... yeah, I was trying to think about ways to avoid full scheduling
> overhead at each layer (the scheduler does a lot per each layer of
> scheduling) but don't think it's possible to circumvent that without
> introducing a whole lot of scheduling artifacts.

Yup.

> In a lot of workloads, the added overhead from several layers of CPU
> controllers doesn't seem to get in the way too much (most threads do
> something other than scheduling after all).

Sure, don't schedule a lot, it doesn't hurt much, but there are plenty
of loads that routinely do schedule a LOT, and there it matters a LOT..
which is why network benchmarks tend to be severely allergic to
scheduler lard.

>   The only major issue that
> we're seeing in the fleet is the cgroup iteration in idle rebalancing
> code pushing up the scheduling latency too much but that's a different
> issue.

Hm, I would suspect PELT to be the culprit there.  It helps smooth out
load balancing, but will stack "skinny looking" tasks.

	-Mike
