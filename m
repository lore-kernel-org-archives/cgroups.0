From: Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH v5 08/31] list: add a new LRU list type
Date: Fri, 10 May 2013 11:01:21 +0100
Message-ID: <20130510100121.GN11497@suse.de>
References: <1368079608-5611-1-git-send-email-glommer@openvz.org>
 <1368079608-5611-9-git-send-email-glommer@openvz.org>
 <20130509133742.GW11497@suse.de>
 <518C0ECF.8010302@parallels.com>
 <20130510092105.GK11497@suse.de>
 <518CC44D.1020409@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <518CC44D.1020409-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Fri, May 10, 2013 at 01:56:29PM +0400, Glauber Costa wrote:
> On 05/10/2013 01:21 PM, Mel Gorman wrote:
> > On Fri, May 10, 2013 at 01:02:07AM +0400, Glauber Costa wrote:
> >> On 05/09/2013 05:37 PM, Mel Gorman wrote:
> >>> On Thu, May 09, 2013 at 10:06:25AM +0400, Glauber Costa wrote:
> >>>> From: Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >>>>
> >>>> Several subsystems use the same construct for LRU lists - a list
> >>>> head, a spin lock and and item count. They also use exactly the same
> >>>> code for adding and removing items from the LRU. Create a generic
> >>>> type for these LRU lists.
> >>>>
> >>>> This is the beginning of generic, node aware LRUs for shrinkers to
> >>>> work with.
> >>>>
> >>>> [ glommer: enum defined constants for lru. Suggested by gthelen,
> >>>>   don't relock over retry ]
> >>>> Signed-off-by: Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >>>> Signed-off-by: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
> >>>> Reviewed-by: Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> >>>>>
> >>>>> <SNIP>
> >>>>>
> >>>> +
> >>>> +unsigned long
> >>>> +list_lru_walk(
> >>>> +	struct list_lru *lru,
> >>>> +	list_lru_walk_cb isolate,
> >>>> +	void		*cb_arg,
> >>>> +	long		nr_to_walk)
> >>>> +{
> >>>> +	struct list_head *item, *n;
> >>>> +	unsigned long removed = 0;
> >>>> +
> >>>> +	spin_lock(&lru->lock);
> >>>> +restart:
> >>>> +	list_for_each_safe(item, n, &lru->list) {
> >>>> +		enum lru_status ret;
> >>>> +
> >>>> +		if (nr_to_walk-- < 0)
> >>>> +			break;
> >>>> +
> >>>> +		ret = isolate(item, &lru->lock, cb_arg);
> >>>> +		switch (ret) {
> >>>> +		case LRU_REMOVED:
> >>>> +			lru->nr_items--;
> >>>> +			removed++;
> >>>> +			break;
> >>>> +		case LRU_ROTATE:
> >>>> +			list_move_tail(item, &lru->list);
> >>>> +			break;
> >>>> +		case LRU_SKIP:
> >>>> +			break;
> >>>> +		case LRU_RETRY:
> >>>> +			goto restart;
> >>>> +		default:
> >>>> +			BUG();
> >>>> +		}
> >>>> +	}
> >>>
> >>> What happened your suggestion to only retry once for each object to
> >>> avoid any possibility of infinite looping or stalling for prolonged
> >>> periods of time waiting on XFS to do something?
> >>>
> >>
> >> Sorry. It wasn't clear for me if you were just trying to make sure we
> >> had a way out in case it proves to be a problem, or actually wanted a
> >> change.
> >>
> > 
> > Either. If you are sure there is a way out for XFS using LRU_RETRY without
> > prolonged stalls then it's fine. If it is not certain then I would be much
> > more comfortable with a retry-once and then moving onto the next LRU node.
> > 
> >> In any case, I cannot claim to be as knowledgeable as Dave in the
> >> subtleties of such things in the final behavior of the shrinker. Dave,
> >> can you give us your input here?
> >>
> >> I also have another recent observation on this:
> >>
> >> The main difference between LRU_SKIP and LRU_RETRY is that LRU_RETRY
> >> will go back to the beginning of the list, and start scanning it again.
> >>
> > 
> > Only sortof true. Lets say we had a list of 8 LRU nodes. Nodes 1-3 get
> > isolated. Node 4 returns LRU_RETRY so we goto restart. The first item on
> > the list is now potentially LRU_RETRY which it must handle before
> > reaching Nodes 5-8
> > 
> > LRU_SKIP is different. If Node 4 returned LRU_SKIP then Node 5-8 are
> > ignored entirely. Actually..... why is that? LRU_SKIP is documented to
> > "item cannot be locked, skip" but what it actually does it "item cannot
> > be locked, abort the walk". It's documented behaviour LRU_SKIP implies
> > continue, not break.
> > 
> > 	case LRU_SKIP:
> > 		continue;
> > 
> 
> but we are only breaking the switch statement, so this is a de facto
> continue.
> 

Bah, I'm a tool.

-- 
Mel Gorman
SUSE Labs
