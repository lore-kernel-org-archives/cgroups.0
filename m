From: Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH] mm: vmscan: fix IO/refault regression in cache
 workingset transition
Date: Thu, 06 Apr 2017 12:51:16 -0400
Message-ID: <1491497476.8850.156.camel@redhat.com>
References: <20170404220052.27593-1-hannes@cmpxchg.org>
	 <1491430264.16856.43.camel@redhat.com> <20170406144922.GA32364@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <owner-linux-mm@kvack.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.redhat.com 56DA413D13
In-Reply-To: <20170406144922.GA32364@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.com>, Vladimir Davydov <vdavydov.dev@gmail.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Thu, 2017-04-06 at 10:49 -0400, Johannes Weiner wrote:
> On Wed, Apr 05, 2017 at 06:11:04PM -0400, Rik van Riel wrote:
> > On Tue, 2017-04-04 at 18:00 -0400, Johannes Weiner wrote:
> > 
> > > +
> > > +	/*
> > > +	 * When refaults are being observed, it means a new
> > > workingset
> > > +	 * is being established. Disable active list protection
> > > to
> > > get
> > > +	 * rid of the stale workingset quickly.
> > > +	 */
> > 
> > This looks a little aggressive. What is this
> > expected to do when you have multiple workloads
> > sharing the same LRU, and one of the workloads
> > is doing refaults, while the other workload is
> > continuing to use the same working set as before?
> 
> That win was intriguing, but it would be bad if it came out of the
> budget of truly shared LRUs (for which I have no quantification).
> 
> Since this is a regression fix, it would be fair to be conservative
> and use the 50/50 split for transitions here; keep the more adaptive
> behavior for a future optimization.
> 
> What do you think?

Lets try your patch, and see what happens.
After all, it only affects the file cache,
and does not lead to anonymous pages being
swapped out and causing major pain.

A fast workload transition seems like it
could be in everybody's best interest.

If this approach leads to trouble, we can
always try to soften it later.

One potential way of softening would be to
look at the number of refaults, vs the
number of working set re-confirmations, and
determine a target based on that.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
