From: Michal Hocko <mhocko@suse.cz>
Subject: Re: [patch 1/4] mm: memcontrol: reduce reclaim invocations for
 higher order requests
Date: Fri, 8 Aug 2014 14:32:58 +0200
Message-ID: <20140808123258.GK4004@dhcp22.suse.cz>
References: <1407186897-21048-1-git-send-email-hannes@cmpxchg.org>
 <1407186897-21048-2-git-send-email-hannes@cmpxchg.org>
 <20140807130822.GB12730@dhcp22.suse.cz>
 <20140807153141.GD14734@cmpxchg.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20140807153141.GD14734@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu 07-08-14 11:31:41, Johannes Weiner wrote:
> On Thu, Aug 07, 2014 at 03:08:22PM +0200, Michal Hocko wrote:
> > On Mon 04-08-14 17:14:54, Johannes Weiner wrote:
> > > Instead of passing the request size to direct reclaim, memcg just
> > > manually loops around reclaiming SWAP_CLUSTER_MAX pages until the
> > > charge can succeed.  That potentially wastes scan progress when huge
> > > page allocations require multiple invocations, which always have to
> > > restart from the default scan priority.
> > > 
> > > Pass the request size as a reclaim target to direct reclaim and leave
> > > it to that code to reach the goal.
> > 
> > THP charge then will ask for 512 pages to be (direct) reclaimed. That
> > is _a lot_ and I would expect long stalls to achieve this target. I
> > would also expect quick priority drop down and potential over-reclaim
> > for small and moderately sized memcgs (e.g. memcg with 1G worth of pages
> > would need to drop down below DEF_PRIORITY-2 to have a chance to scan
> > that many pages). All that done for a charge which can fallback to a
> > single page charge.
> > 
> > The current code is quite hostile to THP when we are close to the limit
> > but solving this by introducing long stalls instead doesn't sound like a
> > proper approach to me.
> 
> THP latencies are actually the same when comparing high limit nr_pages
> reclaim with the current hard limit SWAP_CLUSTER_MAX reclaim,

Are you sure about this? I fail to see how they can be same as THP
allocations/charges are __GFP_NORETRY so there is only one reclaim
round for the hard limit reclaim followed by the charge failure if
it is not successful.

> although system time is reduced with the high limit.
> High limit reclaim with SWAP_CLUSTER_MAX has better fault latency but
> it doesn't actually contain the workload - with 1G high and a 4G load,
> the consumption at the end of the run is 3.7G.

Wouldn't it help to simply fail the charge and allow the charger to
fallback for THP allocations if the usage is above high limit too
much? The follow up single page charge fallback would be still
throttled.

> So what I'm proposing works and is of equal quality from a THP POV.
> This change is complicated enough when we stick to the facts, let's
> not make up things based on gut feeling.

Agreed and I would expect those _facts_ to be part of the changelog.
-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
