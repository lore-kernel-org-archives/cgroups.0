From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH] mm/memcontrol: fix NULL pointer dereference when
 use_hierarchy is 0
Date: Tue, 17 Feb 2015 07:28:31 -0500
Message-ID: <20150217122830.GB12721@phnom.home.cmpxchg.org>
References: <1424150699-5395-1-git-send-email-iamjoonsoo.kim@lge.com>
 <20150217083327.GA32017@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150217083327.GA32017-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Joonsoo Kim <js1304-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>

On Tue, Feb 17, 2015 at 09:33:27AM +0100, Michal Hocko wrote:
> On Tue 17-02-15 14:24:59, Joonsoo Kim wrote:
> > It can be possible to return NULL in parent_mem_cgroup()
> > if use_hierarchy is 0.
> 
> This alone is not sufficient because the low limit is present only in
> the unified hierarchy API and there is no use_hierarchy there. The
> primary issue here is that the memcg has 0 usage so the previous
> check for usage will not stop us. And that is bug IMO.

Yes, empty groups shouldn't be considered low.

> From f5d74671d30e44c50b45b4464c92f536f1dbdff6 Mon Sep 17 00:00:00 2001
> From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
> Date: Tue, 17 Feb 2015 08:02:12 +0100
> Subject: [PATCH] memcg: fix low limit calculation
> 
> A memcg is considered low limited even when the current usage is equal
> to the low limit. This leads to interesting side effects e.g.
> groups/hierarchies with no memory accounted are considered protected and
> so the reclaim will emit MEMCG_LOW event when encountering them.
> 
> Another and much bigger issue was reported by Joonsoo Kim. He has hit a
> NULL ptr dereference with the legacy cgroup API which even doesn't have
> low limit exposed. The limit is 0 by default but the initial check fails
> for memcg with 0 consumption and parent_mem_cgroup() would return NULL
> if use_hierarchy is 0 and so page_counter_read would try to dereference
> NULL.
> 
> I suppose that the current implementation is just an overlook because
> the documentation in Documentation/cgroups/unified-hierarchy.txt says:
> "
> The memory.low boundary on the other hand is a top-down allocated
> reserve.  A cgroup enjoys reclaim protection when it and all its
> ancestors are below their low boundaries
> "
> 
> Fix the usage and the low limit comparision in mem_cgroup_low accordingly.
> 
> Fixes: 241994ed8649 (mm: memcontrol: default hierarchy interface for memory)
> Reported-by: Joonsoo Kim <js1304-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
