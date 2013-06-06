From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v10 11/35] list_lru: per-node list infrastructure
Date: Wed, 5 Jun 2013 20:51:23 -0700
Message-ID: <20130605205123.7be6a0fe.akpm@linux-foundation.org>
References: <1370287804-3481-1-git-send-email-glommer@openvz.org>
	<1370287804-3481-12-git-send-email-glommer@openvz.org>
	<20130605160804.be25fb655f075efe70ec57c0@linux-foundation.org>
	<20130606032107.GQ29338@dastard>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20130606032107.GQ29338@dastard>
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Dave Chinner <david@fromorbit.com>
Cc: Glauber Costa <glommer@openvz.org>, linux-fsdevel@vger.kernel.org, Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org, cgroups@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, hughd@google.com, Greg Thelen <gthelen@google.com>, Dave Chinner <dchinner@redhat.com>

On Thu, 6 Jun 2013 13:21:07 +1000 Dave Chinner <david@fromorbit.com> wrote:

> > > +struct list_lru {
> > > +	/*
> > > +	 * Because we use a fixed-size array, this struct can be very big if
> > > +	 * MAX_NUMNODES is big. If this becomes a problem this is fixable by
> > > +	 * turning this into a pointer and dynamically allocating this to
> > > +	 * nr_node_ids. This quantity is firwmare-provided, and still would
> > > +	 * provide room for all nodes at the cost of a pointer lookup and an
> > > +	 * extra allocation. Because that allocation will most likely come from
> > > +	 * a different slab cache than the main structure holding this
> > > +	 * structure, we may very well fail.
> > > +	 */
> > > +	struct list_lru_node	node[MAX_NUMNODES];
> > > +	nodemask_t		active_nodes;
> > 
> > Some documentation of the data structure would be helpful.  It appears
> > that active_nodes tracks (ie: duplicates) node[x].nr_items!=0.
> > 
> > It's unclear that active_nodes is really needed - we could just iterate
> > across all items in list_lru.node[].  Are we sure that the correct
> > tradeoff decision was made here?
> 
> Yup. Think of all the cache line misses that checking
> node[x].nr_items != 0 entails. If MAX_NUMNODES = 1024, there's 1024
> cacheline misses right there. The nodemask is a much more cache
> friendly method of storing active node state.

Well, it depends on the relative frequency of list-wide walking.  If
that's "very low" then the cost of maintaining active_nodes could
dominate.

Plus all the callsites which traverse active_nodes will touch
list_lru.node[n] anyway, so the cache-miss impact will be unaltered.

> not to mention that for small machines with a large MAX_NUMNODES,
> we'd be checking nodes that never have items stored on them...

Yes, there is that.
