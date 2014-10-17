From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [patch 4/5] mm: memcontrol: continue cache reclaim from offlined
 groups
Date: Fri, 17 Oct 2014 16:00:22 +0200
Message-ID: <20141017140022.GF8076@dhcp22.suse.cz>
References: <1413303637-23862-1-git-send-email-hannes@cmpxchg.org>
 <1413303637-23862-5-git-send-email-hannes@cmpxchg.org>
 <20141017084011.GC5641@esperanza>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20141017084011.GC5641@esperanza>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri 17-10-14 10:40:11, Vladimir Davydov wrote:
> On Tue, Oct 14, 2014 at 12:20:36PM -0400, Johannes Weiner wrote:
> > On cgroup deletion, outstanding page cache charges are moved to the
> > parent group so that they're not lost and can be reclaimed during
> > pressure on/inside said parent.  But this reparenting is fairly tricky
> > and its synchroneous nature has led to several lock-ups in the past.
> > 
> > Since css iterators now also include offlined css, memcg iterators can
> > be changed to include offlined children during reclaim of a group, and
> > leftover cache can just stay put.
> > 
> > There is a slight change of behavior in that charges of deleted groups
> > no longer show up as local charges in the parent.  But they are still
> > included in the parent's hierarchical statistics.
> > 
> > Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> > ---
> >  mm/memcontrol.c | 218 +-------------------------------------------------------
> >  1 file changed, 1 insertion(+), 217 deletions(-)
> 
> I do like the stats :-) However, as I've already mentioned, on big
> machines we can end up with hundred of thousands of dead css's.

css->id is bound to the css life so this is bound to the maximum number
of allowed cgroups AFAIR. It is true that dead memcgs might block
creation of new. This is a good point. It would be a problem either when
there is no reclaim (global or memcg) or when groups are very short
lived. One possible way out would be counting dead memcgs and kick
background mem_cgroup_force_empty loop over those that are dead once we
hit a threshold. This should be pretty trivial to implement.

> Iterating over all of them during reclaim may result in noticeable lags.
> One day we'll have to do something about that I guess.
>
> Another issue is that AFAICT currently we can't have more than 64K
> cgroups due to the MEM_CGROUP_ID_MAX limit.The limit exists, because we
> use css ids for tagging swap entries and we don't want to spend too much
> memory on this. May be, we should simply use the mem_cgroup pointer
> instead of the css id?

We are using the id to reduce the memory footprint. We cannot effort 8B
per each swappage (we can have GBs of swap space in the system).
 
> OTOH, the reparenting code looks really ugly. And we can't easily
> reparent swap and kmem. So I think it's a reasonable change.

At least swap shouldn't be a big deal. Hugh already had a patch for
that. You would simply have to go over all swap entries and change the
id. kmem should be doable as well as you have already shown in your
patches. The main question is. Do we really need it? I think we are good
now and should make the code more complicated once this starts being a
practical problem.

> Acked-by: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo-Bw31MaZKKs0EbZ0PF+XxCw@public.gmane.org  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org"> email-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org </a>

-- 
Michal Hocko
SUSE Labs
