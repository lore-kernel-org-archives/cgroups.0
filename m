From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH] mm: Throttle allocators when failing reclaim over
 memory.high
Date: Thu, 28 Feb 2019 10:52:50 +0100
Message-ID: <20190228095250.GA21078@dhcp22.suse.cz>
References: <20190201011352.GA14370@chrisdown.name>
 <20190201071757.GE11599@dhcp22.suse.cz>
 <20190201161233.GA11231@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190201161233.GA11231@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Chris Down <chris@chrisdown.name>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Roman Gushchin <guro@fb.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, kernel-team@fb.com

[Sorry for a late reply]

On Fri 01-02-19 11:12:33, Johannes Weiner wrote:
> On Fri, Feb 01, 2019 at 08:17:57AM +0100, Michal Hocko wrote:
> > On Thu 31-01-19 20:13:52, Chris Down wrote:
> > [...]
> > > The current situation goes against both the expectations of users of
> > > memory.high, and our intentions as cgroup v2 developers. In
> > > cgroup-v2.txt, we claim that we will throttle and only under "extreme
> > > conditions" will memory.high protection be breached. Likewise, cgroup v2
> > > users generally also expect that memory.high should throttle workloads
> > > as they exceed their high threshold. However, as seen above, this isn't
> > > always how it works in practice -- even on banal setups like those with
> > > no swap, or where swap has become exhausted, we can end up with
> > > memory.high being breached and us having no weapons left in our arsenal
> > > to combat runaway growth with, since reclaim is futile.
> > > 
> > > It's also hard for system monitoring software or users to tell how bad
> > > the situation is, as "high" events for the memcg may in some cases be
> > > benign, and in others be catastrophic. The current status quo is that we
> > > fail containment in a way that doesn't provide any advance warning that
> > > things are about to go horribly wrong (for example, we are about to
> > > invoke the kernel OOM killer).
> > > 
> > > This patch introduces explicit throttling when reclaim is failing to
> > > keep memcg size contained at the memory.high setting. It does so by
> > > applying an exponential delay curve derived from the memcg's overage
> > > compared to memory.high.  In the normal case where the memcg is either
> > > below or only marginally over its memory.high setting, no throttling
> > > will be performed.
> > 
> > How does this play wit the actual OOM when the user expects oom to
> > resolve the situation because the reclaim is futile and there is nothing
> > reclaimable except for killing a process?
> 
> Hm, can you elaborate on your question a bit?
> 
> The idea behind memory.high is to throttle allocations long enough for
> the admin or a management daemon to intervene, but not to trigger the
> kernel oom killer. It was designed as a replacement for the cgroup1
> oom_control, but without the deadlock potential, ptrace problems etc.

Yes, this makes sense. The high limit reclaim is also documented as a
best effort resource guarantee. My understanding is that if the workload
cannot be contained within the high limit then the system cannot do much
and eventually gives up. Having the full memory unreclaimable is such an
example. And there is either the global OOM killer or hard limit OOM
killer to trigger to resolve such a situation.

[...]
Thanks for describing the usecase.

> Right now, that throttling mechanism works okay with swap enabled, but
> we cannot enable swap everywhere, or sometimes run out of swap, and
> then it breaks down and we run into system OOMs.
> 
> This patch makes sure memory.high *always* implements the throttling
> semantics described in cgroup-v2.txt, not just most of the time.

I am not really opposed to the throttling in the absence of a
reclaimable memory. We do that for the regular allocation paths already
(should_reclaim_retry). A swapless system with anon memory is very
likely to oom too quickly and this sounds like a real problem. But I do
not think that we should throttle the allocation to freeze it
completely. We should eventually OOM. And that was my question about
essentially. How much we can/should throttle to give a high limit events
consumer enough time to intervene. I am sorry to still not have time to
study the patch more closely but this should be explained in the
changelog. Are we talking about seconds/minutes or simply freeze each
allocator to death?
-- 
Michal Hocko
SUSE Labs
