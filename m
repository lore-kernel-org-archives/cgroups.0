From: Mel Gorman <mgorman@techsingularity.net>
Subject: Re: [PATCH 02/27] mm, vmscan: Check if cpusets are enabled during
 direct reclaim
Date: Wed, 9 Mar 2016 11:59:38 +0000
Message-ID: <20160309115909.GA31585@techsingularity.net>
References: <1456239890-20737-1-git-send-email-mgorman@techsingularity.net>
 <1456239890-20737-3-git-send-email-mgorman@techsingularity.net>
 <56D8209C.5020103@suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <56D8209C.5020103@suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Linux-MM <linux-mm@kvack.org>, Rik van Riel <riel@surriel.com>, Johannes Weiner <hannes@cmpxchg.org>, LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, Li Zefan <lizefan@huawei.com>, cgroups@vger.kernel.org

On Thu, Mar 03, 2016 at 12:31:40PM +0100, Vlastimil Babka wrote:
> On 02/23/2016 04:04 PM, Mel Gorman wrote:
> > Direct reclaim obeys cpusets but misses the cpusets_enabled() check.
> > The overhead is unlikely to be measurable in the direct reclaim
> > path which is expensive but there is no harm is doing it.
> > 
> > Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
> > ---
> >  mm/vmscan.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 86eb21491867..de8d6226e026 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -2566,7 +2566,7 @@ static void shrink_zones(struct zonelist *zonelist, struct scan_control *sc)
> >  		 * to global LRU.
> >  		 */
> >  		if (global_reclaim(sc)) {
> > -			if (!cpuset_zone_allowed(zone,
> > +			if (cpusets_enabled() && !cpuset_zone_allowed(zone,
> >  						 GFP_KERNEL | __GFP_HARDWALL))
> >  				continue;
> 
> Hmm, wouldn't it be nicer if cpuset_zone_allowed() itself did the right
> thing, and not each caller?
> 
> How about the patch below? (+CC)
> 

The patch appears to be layer upon the entire series but that in itself
is ok. This part is a problem

> An important function for cpusets is cpuset_node_allowed(), which acknowledges
> that if there's a single root CPU set, it must be trivially allowed. But the
> check "nr_cpusets() <= 1" doesn't use the cpusets_enabled_key static key in a
> proper way where static keys can reduce the overhead.


There is one check for the static key and a second for the count to see
if it's likely a valid cpuset that matters has been configured. The
point of that check was that it was lighter than __cpuset_zone_allowed
in the case where no cpuset is configured.

The patches are not equivalent.

-- 
Mel Gorman
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
