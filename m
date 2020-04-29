From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] mm, memcg: Avoid stale protection values when cgroup
 is above protection
Date: Wed, 29 Apr 2020 17:04:14 +0200
Message-ID: <20200429150414.GI28637@dhcp22.suse.cz>
References: <cover.1588092152.git.chris@chrisdown.name>
 <d454fca5d6b38b74d8dc35141e8519b02089a698.1588092152.git.chris@chrisdown.name>
 <20200429101510.GA28637@dhcp22.suse.cz>
 <20200429140330.GA5054@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200429140330.GA5054-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed 29-04-20 10:03:30, Johannes Weiner wrote:
> On Wed, Apr 29, 2020 at 12:15:10PM +0200, Michal Hocko wrote:
> > On Tue 28-04-20 19:26:47, Chris Down wrote:
> > > From: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > > 
> > > A cgroup can have both memory protection and a memory limit to isolate
> > > it from its siblings in both directions - for example, to prevent it
> > > from being shrunk below 2G under high pressure from outside, but also
> > > from growing beyond 4G under low pressure.
> > > 
> > > Commit 9783aa9917f8 ("mm, memcg: proportional memory.{low,min} reclaim")
> > > implemented proportional scan pressure so that multiple siblings in
> > > excess of their protection settings don't get reclaimed equally but
> > > instead in accordance to their unprotected portion.
> > > 
> > > During limit reclaim, this proportionality shouldn't apply of course:
> > > there is no competition, all pressure is from within the cgroup and
> > > should be applied as such. Reclaim should operate at full efficiency.
> > > 
> > > However, mem_cgroup_protected() never expected anybody to look at the
> > > effective protection values when it indicated that the cgroup is above
> > > its protection. As a result, a query during limit reclaim may return
> > > stale protection values that were calculated by a previous reclaim cycle
> > > in which the cgroup did have siblings.
> > > 
> > > When this happens, reclaim is unnecessarily hesitant and potentially
> > > slow to meet the desired limit. In theory this could lead to premature
> > > OOM kills, although it's not obvious this has occurred in practice.
> > 
> > Thanks this describes the underlying problem. I would be also explicit
> > that the issue should be visible only on tail memcgs which have both
> > max/high and protection configured and the effect depends on the
> > difference between the two (the smaller it is the largrger the effect).
> > 
> > There is no mention about the fix. The patch resets effective values for
> > the reclaim root and I've had some concerns about that
> > http://lkml.kernel.org/r/20200424162103.GK11591-2MMpYkNvuYA6bu5BqYkRsg@public.gmane.org
> > Johannes has argued that other races are possible and I didn't get to
> > think about it thoroughly. But this patch is introducing a new
> > possibility of breaking protection. If we want to have a quick and
> > simple fix that would be easier to backport to older kernels then I
> > would feel much better if we simply workedaround the problem as
> > suggested earlier http://lkml.kernel.org/r/20200423061629.24185-1-laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
> > We can rework the effective values calculation to be more robust against
> > races on top of that because this is likely a more tricky thing to do.
> 
> Well, can you please *do* think more thoroughly about what I wrote,
> instead of pushing for an alternative patch on gut feeling alone?
> 
> Especially when you imply that this should be a stable patch.

The patch has a Fixes tag and so it is not unrealistic to assume that it
will hit older trees. I wasn't really implying stable tree backport and
I do not think this is a stable material.

All I was arguing here is that a fix/workaround which doesn't add new
side effects is a safer option.

> Not only does your alternative patch not protect against the race you
> are worried about, the race itself doesn't matter. Racing reclaimers
> will write their competing views of the world into the shared state on
> all other levels anyway.
> 
> And that's okay. If the configuration and memory usage is such that
> there is at least one reclaimer that scans without any protection
> (like a limit reclaimer), it's not a problem when a second reclaimer
> that meant to do protected global reclaim will also do one iteration
> without protection. It's no different than if a second thread had
> entered limit reclaim through another internal allocation.

Yes I do agree here.

> There is no semantical violation with the race in your patch or the
> race in this patch. Any effective protection that becomes visible is
> 1) permitted by the configuration, but 2) also triggered *right now*
> by an acute need to reclaim memory with these parameters.
> 
> The *right now* part is important. That's what's broken before either
> patch, and that's what we're fixing: to see really, really *old* stale
> that might not be representative of the config semantics anymore.

No disagreement here either. But please remember that the example I've
given is a clear violation of the protection. Let me paste it here so
that we have both examples in one email:
: Let's have global and A's reclaim in parallel:
:  |
:  A (low=2G, usage = 3G, max = 3G, children_low_usage = 1.5G)
:  |\
:  | C (low = 1G, usage = 2.5G)
:  B (low = 1G, usage = 0.5G)
: 
: for A reclaim we have
: B.elow = B.low
: C.elow = C.low
: 
: For the global reclaim
: A.elow = A.low
: B.elow = min(B.usage, B.low) because children_low_usage <= A.elow
: C.elow = min(C.usage, C.low)
: 
: With the effective values reseting we have A reclaim
: A.elow = 0
: B.elow = B.low
: C.elow = C.low
: 
: and global reclaim could see the above and then
: B.elow = C.elow = 0 because children_low_usage > A.elow

I hope we both agree that B shouldn't be reclaimed whether the reclaim
comes from A or above A. The race is not possible with with the patch
working around the problem in mem_cgroup_protection().

> Since you haven't linked to my email, here is my counter argument to
> the alternative patch "fixing" this race somehow.
> 
> A reclaim:
> 
>   root
>      `- A (low=2G, max=3G -> elow=0)
>         `- A1 (low=0G -> elow=0)
> 
> Global reclaim:
> 
>   root
>      `- A (low=2G, max=3G -> elow=2G)
>         `- A1 (low=0G -> elow=2G)
> 
> During global reclaim, A1 is supposed to have 2G effective low
> protection. If A limit reclaim races, it can set A1's elow to
> 0. Global reclaim will now query mem_cgroup_protection(root, A1), the
> root == memcg check you insist we add will fail and it'll reclaim A1
> without protection.

You are right that hooking into mem_cgroup_protection wouldn't prevent
the race in this example. But in this example the race really doesn't
matter because the overall protection is not violated. A1 would get
reclaimed by A anyway. But in my example there is a protected memcg
which shouldn't get reclaimed.

-- 
Michal Hocko
SUSE Labs
