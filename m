From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: asynchronous reclaim for memory.high
Date: Thu, 20 Feb 2020 10:46:39 +0100
Message-ID: <20200220094639.GD20509@dhcp22.suse.cz>
References: <20200219181219.54356-1-hannes@cmpxchg.org>
 <20200219183731.GC11847@dhcp22.suse.cz>
 <20200219191618.GB54486@cmpxchg.org>
 <20200219195332.GE11847@dhcp22.suse.cz>
 <20200219211735.GD54486@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200219211735.GD54486-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Wed 19-02-20 16:17:35, Johannes Weiner wrote:
> On Wed, Feb 19, 2020 at 08:53:32PM +0100, Michal Hocko wrote:
> > On Wed 19-02-20 14:16:18, Johannes Weiner wrote:
[...]
> > > [ This is generally work in process: for example, if you isolate
> > >   workloads with memory.low, kswapd cpu time isn't accounted to the
> > >   cgroup that causes it. Swap IO issued by kswapd isn't accounted to
> > >   the group that is getting swapped.
> > 
> > Well, kswapd is a system activity and as such it is acceptable that it
> > is accounted to the system. But in this case we are talking about a
> > memcg configuration which influences all other workloads by stealing CPU
> > cycles from them 
> 
> From a user perspective this isn't a meaningful distinction.
> 
> If I partition my memory among containers and one cgroup is acting
> out, I would want the culprit to be charged for the cpu cycles the
> reclaim is causing. Whether I divide my machine up using memory.low or
> using memory.max doesn't really matter: I'm choosing between the two
> based on a *memory policy* I want to implement - work-conserving vs
> non-conserving. I shouldn't have to worry about the kernel tracking
> CPU cycles properly in the respective implementations of these knobs.
> 
> So kswapd is very much a cgroup-attributable activity, *especially* if
> I'm using memory.low to delineate different memory domains.

While I understand what you are saying I do not think this is easily
achievable with the current implementation. The biggest problem I can
see is that you do not have a clear information who to charge for
the memory shortage on a particular NUMA node with a pure low limit
based balancing because the limit is not NUMA aware. Besides that the
origin of the memory pressure might be outside of any memcg.  You can
punish/account all memcgs in excess in some manner, e.g. proportionally
to their size/excess but I am not really sure how fair that will
be. Sounds like an interesting project but also sounds like tangent to
this patch.

High/Max limits are quite different because they are dealing with
the internal memory pressure and you can attribute it to the
cgroup/hierarchy which is in excess. There is a clear domain to reclaim
from. This is an easier model to reason about IMHO.

> > without much throttling on the consumer side - especially when the
> > memory is reclaimable without a lot of sleeping or contention on
> > locks etc.
> 
> The limiting factor on the consumer side is IO. Reading a page is way
> more costly than reclaiming it, which is why we built our isolation
> stack starting with memory and IO control and are only now getting to
> working on proper CPU isolation.
> 
> > I am absolutely aware that we will never achieve a perfect isolation due
> > to all sorts of shared data structures, lock contention and what not but
> > this patch alone just allows spill over to unaccounted work way too
> > easily IMHO.
> 
> I understand your concern about CPU cycles escaping, and I share
> it. My point is that this patch isn't adding a problem that isn't
> already there, nor is it that much of a practical concern at the time
> of this writing given the state of CPU isolation in general.

I beg to differ here. Ppu controller should be able to isolate user
contexts performing high limit reclaim now. Your patch is changing that
functionality to become unaccounted for a large part and that might be
seen as a regression for those workloads which partition the system by
using high limit and also rely on cpu controller because workloads are
CPU sensitive.

Without the CPU controller support this patch is not complete and I do
not see an absolute must to marge it ASAP because it is not a regression
fix or something we cannot live without.
-- 
Michal Hocko
SUSE Labs
