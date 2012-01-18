From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [patch 2/2] mm: memcg: hierarchical soft limit reclaim
Date: Wed, 18 Jan 2012 14:26:38 +0900
Message-ID: <20120118142638.11667d2c.kamezawa.hiroyu@jp.fujitsu.com>
References: <1326207772-16762-1-git-send-email-hannes@cmpxchg.org>
	<1326207772-16762-3-git-send-email-hannes@cmpxchg.org>
	<20120112105427.4b80437b.kamezawa.hiroyu@jp.fujitsu.com>
	<20120113121645.GA1653@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120113121645.GA1653-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, 13 Jan 2012 13:16:56 +0100
Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:

> On Thu, Jan 12, 2012 at 10:54:27AM +0900, KAMEZAWA Hiroyuki wrote:

> > Thank you for your work and the result seems atractive and code is much
> > simpler. My small concerns are..
> > 
> > 1. This approach may increase latency of direct-reclaim because of priority=0.
> 
> I think strictly speaking yes, but note that with kswapd being less
> likely to get stuck in hammering on one group, the need for allocators
> to enter direct reclaim itself is reduced.
> 
> However, if this really becomes a problem in real world loads, the fix
> is pretty easy: just ignore the soft limit for direct reclaim.  We can
> still consider it from hard limit reclaim and kswapd.
> 
> > 2. In a case numa-spread/interleave application run in its own container, 
> >    pages on a node may paged-out again and again becasue of priority=0
> >    if some other application runs in the node.
> >    It seems difficult to use soft-limit with numa-aware applications.
> >    Do you have suggestions ?
> 
> This is a question about soft limits in general rather than about this
> particular patch, right?
> 

Partially, yes. My concern is related to "1".

Assume an application is binded to some cpu/node and try to allocate memory.
If its memcg's usage is over softlimit, this application will play bad because
newly allocated memory will be reclaim target soon, again....


> And if I understand correctly, the problem you are referring to is
> this: an application and parts of a soft-limited container share a
> node, the soft limit setting means that the container's pages on that
> node are reclaimed harder.  At that point, the container's share on
> that node becomes tiny, but since the soft limit is oblivious to
> nodes, the expansion of the other application pushes the soft-limited
> container off that node completely as long as the container stays
> above its soft limit with the usage on other nodes.
> 
> What would you think about having node-local soft limits that take the
> node size into account?
> 
> 	local_soft_limit = soft_limit * node_size / memcg_size
> 
> The soft limit can be exceeded globally, but the container is no
> longer pushed off a node on which it's only occupying a small share of
> memory.
> 
Yes, I think this kind of care is required.
What is the 'node_size' here ? size of pgdat ?
size of per-node usage in the memcg ?


> Putting it into proportion of the memcg size, not overall memory size
> has the following advantages:
> 
>   1. if the container is sitting on only one of several available
>   nodes without exceeding the limit globally, the memcg will not be
>   reclaimed harder just because it has a relatively large share of the
>   node.
> 
>   2. if the soft limit excess is ridiculously high, the local soft
>   limits will be pushed down, so the tolerance for smaller shares on
>   nodes goes down in proportion to the global soft limit excess.
> 
> Example:
> 
> 	4G soft limit * 2G node / 4G container = 2G node-local limit
> 
> The container is globally within its soft limit, so the local limit is
> at least the size of the node.  It's never reclaimed harder compared
> to other applications on the node.
> 
> 	4G soft limit * 2G node / 5G container = ~1.6G node-local limit
> 



> Here, it will experience more pressure initially, but it will level
> off when the shrinking usage and the thereby increasing node-local
> soft limit meet.  From that point on, the container and the competing
> application will be treated equally during reclaim.
> 
> Finally, if the container is 16G in size, i.e. 300% in excess, the
> per-node tolerance is at 512M node-local soft limit, which IMO strikes
> a good balance between zero tolerance and still applying some stress
> to the hugely oversized container when other applications (with
> virtually unlimited soft limits) want to run on the same node.
> 
> What do you think?

I like the idea. Another idea is changing 'priority' based on per-node stats
if not too complicated...

Thanks,
-Kame



