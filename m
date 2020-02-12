From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH 2/3] mm: vmscan: detect file thrashing at the reclaim root
Date: Wed, 12 Feb 2020 13:18:34 -0500
Message-ID: <20200212181834.GD180867@cmpxchg.org>
References: <20191107205334.158354-1-hannes@cmpxchg.org>
 <20191107205334.158354-3-hannes@cmpxchg.org>
 <20200212102817.GA18107@js1304-desktop>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OWGcBq+RmtovTTracPqR5yMhReLnPEQNRqBqlsGYoqQ=;
        b=y2gv+7sTsHniWkrRXHbMycwPBOZkSVEUBxS0FbQa9VB6OPJaYJ1Ny9M6xr/G2DVX+A
         2y3zu+4t8K+YEOEZiGZ16SmwaFBkHE7wfdPJ73oAGMEcRLyA7SdYtUq2rlqAIOJ7AlQ+
         UybJYIDz3qsZGxZfUM1AtJQB0pELtShzFC9k3aLs7g4W9U5IbFUlcjQfKEHGvhzfclm+
         JveHX0RcnHpMZXSqGvlbSX7VBuxQcKiVaV6YvUnzx7SOAGPdgFUsRDnB4h3byEIPdOR4
         Deg6SO3d+i3NoTjYxf140EY5fK1CDhyhjBV3mFZrOFF2taWoChENIoAjBrb9azCLuXXz
         mScA==
Content-Disposition: inline
In-Reply-To: <20200212102817.GA18107@js1304-desktop>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joonsoo Kim <js1304-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Rik van Riel <riel-ebMLmSuQjDVBDgjK7y7TUQ@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Wed, Feb 12, 2020 at 07:28:19PM +0900, Joonsoo Kim wrote:
> Hello, Johannes.
> 
> When I tested my patchset on v5.5, I found that my patchset doesn't
> work as intended. I tracked down the issue and this patch would be the
> reason of unintended work. I don't fully understand the patchset so I
> could be wrong. Please let me ask some questions.
> 
> On Thu, Nov 07, 2019 at 12:53:33PM -0800, Johannes Weiner wrote:
> ...snip...
> > -static void snapshot_refaults(struct mem_cgroup *root_memcg, pg_data_t *pgdat)
> > +static void snapshot_refaults(struct mem_cgroup *target_memcg, pg_data_t *pgdat)
> >  {
> > -	struct mem_cgroup *memcg;
> > -
> > -	memcg = mem_cgroup_iter(root_memcg, NULL, NULL);
> > -	do {
> > -		unsigned long refaults;
> > -		struct lruvec *lruvec;
> > +	struct lruvec *target_lruvec;
> > +	unsigned long refaults;
> >  
> > -		lruvec = mem_cgroup_lruvec(memcg, pgdat);
> > -		refaults = lruvec_page_state_local(lruvec, WORKINGSET_ACTIVATE);
> > -		lruvec->refaults = refaults;
> > -	} while ((memcg = mem_cgroup_iter(root_memcg, memcg, NULL)));
> > +	target_lruvec = mem_cgroup_lruvec(target_memcg, pgdat);
> > +	refaults = lruvec_page_state(target_lruvec, WORKINGSET_ACTIVATE);
> > +	target_lruvec->refaults = refaults;
> 
> Is it correct to just snapshot the refault for the target memcg? I
> think that we need to snapshot the refault for all the child memcgs
> since we have traversed all the child memcgs with the refault count
> that is aggregration of all the child memcgs. If next reclaim happens
> from the child memcg, workingset transition that is already considered
> could be considered again.

Good catch, you're right! We have to update all cgroups in the tree,
like we used to. However, we need to use lruvec_page_state() instead
of _local, because we do recursive comparisons in shrink_node()! So
it's not a clean revert of that hunk.

Does this patch here fix the problem you are seeing?

diff --git a/mm/vmscan.c b/mm/vmscan.c
index c82e9831003f..e7431518db13 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2993,12 +2993,17 @@ static void shrink_zones(struct zonelist *zonelist, struct scan_control *sc)
 
 static void snapshot_refaults(struct mem_cgroup *target_memcg, pg_data_t *pgdat)
 {
-	struct lruvec *target_lruvec;
-	unsigned long refaults;
+	struct mem_cgroup *memcg;
 
-	target_lruvec = mem_cgroup_lruvec(target_memcg, pgdat);
-	refaults = lruvec_page_state(target_lruvec, WORKINGSET_ACTIVATE);
-	target_lruvec->refaults = refaults;
+	memcg = mem_cgroup_iter(target_memcg, NULL, NULL);
+	do {
+		unsigned long refaults;
+		struct lruvec *lruvec;
+
+		lruvec = mem_cgroup_lruvec(memcg, pgdat);
+		refaults = lruvec_page_state(lruvec, WORKINGSET_ACTIVATE);
+		lruvec->refaults = refaults;
+	} while ((memcg = mem_cgroup_iter(target_memcg, memcg, NULL)));
 }
 
 /*

> > @@ -277,12 +305,12 @@ void workingset_refault(struct page *page, void *shadow)
> >  	 * would be better if the root_mem_cgroup existed in all
> >  	 * configurations instead.
> >  	 */
> > -	memcg = mem_cgroup_from_id(memcgid);
> > -	if (!mem_cgroup_disabled() && !memcg)
> > +	eviction_memcg = mem_cgroup_from_id(memcgid);
> > +	if (!mem_cgroup_disabled() && !eviction_memcg)
> >  		goto out;
> > -	lruvec = mem_cgroup_lruvec(memcg, pgdat);
> > -	refault = atomic_long_read(&lruvec->inactive_age);
> > -	active_file = lruvec_lru_size(lruvec, LRU_ACTIVE_FILE, MAX_NR_ZONES);
> > +	eviction_lruvec = mem_cgroup_lruvec(eviction_memcg, pgdat);
> > +	refault = atomic_long_read(&eviction_lruvec->inactive_age);
> > +	active_file = lruvec_page_state(eviction_lruvec, NR_ACTIVE_FILE);
> 
> Do we need to use the aggregation LRU count of all the child memcgs?
> AFAIU, refault here is the aggregation counter of all the related
> memcgs. Without using the aggregation count for LRU, active_file could
> be so small than the refault distance and refault cannot happen
> correctly.

lruvec_page_state() *is* aggregated for all child memcgs (as opposed
to lruvec_page_state_local()), so that comparison looks correct to me.
