From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [patch 1/4] mm: memcontrol: reduce reclaim invocations for
 higher order requests
Date: Thu, 7 Aug 2014 11:31:41 -0400
Message-ID: <20140807153141.GD14734@cmpxchg.org>
References: <1407186897-21048-1-git-send-email-hannes@cmpxchg.org>
 <1407186897-21048-2-git-send-email-hannes@cmpxchg.org>
 <20140807130822.GB12730@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org; s=zene;
	h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date; bh=+KxbnWU8V+soKGw6pYTSRhg2l50J9QA0gbNLs3eYACQ=;
	b=Y50L46FZQbfHsOm702azDnGqOT6xJgwjXk4cBiQG509PAaPmdQ73YwDzn7WSeFb2Dz1Uhs8IW90zNcNdWdNhds2BYyVvk1hykWzeo4YhFBuZlj0aPMOCLpuwkoBK9a3L5KPUpD1gGRLjcc6qFgpQv+BZtlC+GA2guzuws0hR6Os=;
Content-Disposition: inline
In-Reply-To: <20140807130822.GB12730-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Aug 07, 2014 at 03:08:22PM +0200, Michal Hocko wrote:
> On Mon 04-08-14 17:14:54, Johannes Weiner wrote:
> > Instead of passing the request size to direct reclaim, memcg just
> > manually loops around reclaiming SWAP_CLUSTER_MAX pages until the
> > charge can succeed.  That potentially wastes scan progress when huge
> > page allocations require multiple invocations, which always have to
> > restart from the default scan priority.
> > 
> > Pass the request size as a reclaim target to direct reclaim and leave
> > it to that code to reach the goal.
> 
> THP charge then will ask for 512 pages to be (direct) reclaimed. That
> is _a lot_ and I would expect long stalls to achieve this target. I
> would also expect quick priority drop down and potential over-reclaim
> for small and moderately sized memcgs (e.g. memcg with 1G worth of pages
> would need to drop down below DEF_PRIORITY-2 to have a chance to scan
> that many pages). All that done for a charge which can fallback to a
> single page charge.
> 
> The current code is quite hostile to THP when we are close to the limit
> but solving this by introducing long stalls instead doesn't sound like a
> proper approach to me.

THP latencies are actually the same when comparing high limit nr_pages
reclaim with the current hard limit SWAP_CLUSTER_MAX reclaim, although
system time is reduced with the high limit.

High limit reclaim with SWAP_CLUSTER_MAX has better fault latency but
it doesn't actually contain the workload - with 1G high and a 4G load,
the consumption at the end of the run is 3.7G.

So what I'm proposing works and is of equal quality from a THP POV.
This change is complicated enough when we stick to the facts, let's
not make up things based on gut feeling.
