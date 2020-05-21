From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] mm, memcg: reclaim more aggressively before high
 allocator throttling
Date: Thu, 21 May 2020 09:19:29 +0200
Message-ID: <20200521071929.GH6462@dhcp22.suse.cz>
References: <20200520143712.GA749486@chrisdown.name>
 <20200520160756.GE6462@dhcp22.suse.cz>
 <20200520202650.GB558281@chrisdown.name>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200520202650.GB558281-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Wed 20-05-20 21:26:50, Chris Down wrote:
> Michal Hocko writes:
> > Let me try to understand the actual problem. The high memory reclaim has
> > a target which is proportional to the amount of charged memory. For most
> > requests that would be SWAP_CLUSTER_MAX though (resp. N times that where
> > N is the number of memcgs in excess up the hierarchy). I can see to be
> > insufficient if the memcg is already in a large excess but if the
> > reclaim can make a forward progress this should just work fine because
> > each charging context should reclaim at least the contributed amount.
> > 
> > Do you have any insight on why this doesn't work in your situation?
> > Especially with such a large inactive file list I would be really
> > surprised if the reclaim was not able to make a forward progress.
> 
> Reclaim can fail for any number of reasons, which is why we have retries
> sprinkled all over for it already. It doesn't seem hard to believe that it
> might just fail for transient reasons and drive us deeper into the hole as a
> result.

Reclaim can certainly fail. It is however surprising to see it fail with
such a large inactive lru list and reasonably small reclaim target.
Having the full LRU of dirty pages sounds a bit unusual, IO throttling
for v2 and explicit throttling during the reclaim for v1 should prevent
from that. If the reclaim gives up too easily then this should be
addressed at the reclaim level.

> In this case, a.) the application is producing tons of dirty pages, and b.)
> we have really heavy systemwide I/O contention on the affected machines.
> This high load is one of the reasons that direct and kswapd reclaim cannot
> keep up, and thus nr_pages can become a number of orders of magnitude larger
> than SWAP_CLUSTER_MAX. This is trivially reproducible on these machines,
> it's not an edge case.

Please elaborate some more. memcg_nr_pages_over_high shouldn't really
depend on the system wide activity. It should scale with the requested
charges. So yes it can get large for something like a large read/write
which does a lot of allocations in a single syscall before returning to
the userspace.
 
But ok, let's say that the reclaim target is large and then a single
reclaim attempt might fail. Then I am wondering why your patch is not
really targetting to reclaim memcg_nr_pages_over_high pages and instead
push for reclaim down to the high limit.

The main problem I see with that approach is that the loop could easily
lead to reclaim unfairness when a heavy producer which doesn't leave the
kernel (e.g. a large read/write call) can keep a different task doing
all the reclaim work. The loop is effectivelly unbound when there is a
reclaim progress and so the return to the userspace is by no means
proportional to the requested memory/charge.
-- 
Michal Hocko
SUSE Labs
