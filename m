From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v3] mm/page_alloc: detect allocation forbidden by cpuset
 and bail out early
Date: Tue, 14 Sep 2021 10:17:52 +0200
Message-ID: <YUBasMWLAjzcgtt9@dhcp22.suse.cz>
References: <1631590828-25565-1-git-send-email-feng.tang@intel.com>
 <24d89efa-502f-e31a-5d45-536352485bbb@suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1631607473; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FmdG8PcnuIQuqHtdoYXiNJLHdhDIQt4J2A8/AC35I5c=;
        b=IEJQ2TEznajvCNl1nH6A7iIwCu5Yz2J4O6kJpMm04Zzijue7NO/Y3POHnHOX/b/kVKP4jV
        J+NBflkpoVjrX5prgNDVxIDkMc5fP1DKHCuipbUuWPRYs87/FbhXcV/LjmatEWuDCKSPaZ
        sC94sWIZJ7yhH2Qaf8zqyF2fSfFK1d4=
Content-Disposition: inline
In-Reply-To: <24d89efa-502f-e31a-5d45-536352485bbb-AlSwsSmVLrQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Cc: Feng Tang <feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue 14-09-21 10:01:26, Vlastimil Babka wrote:
> On 9/14/21 05:40, Feng Tang wrote:
[...]
> > +/* Whether the 'nodes' are all movable nodes */
> > +static inline bool movable_only_nodes(nodemask_t *nodes)
> > +{
> > +	struct zonelist *zonelist;
> > +	struct zoneref *z;
> > +
> > +	if (nodes_empty(*nodes))
> > +		return false;
> > +
> > +	zonelist =
> > +	    &NODE_DATA(first_node(*nodes))->node_zonelists[ZONELIST_FALLBACK];
> > +	z = first_zones_zonelist(zonelist, ZONE_NORMAL,	nodes);
> > +	return (!z->zone) ? true : false;
> > +}
> 
> Hmm, could all that become just this?
> 
> !nodes_intersects(&node_states[N_NORMAL_MEMORY], nodes)

Maybe yes but I find the zonelist approach much easier to follow even
though the code looks more complex at first sight. It talks about an
empty zone list for ZONE_NORMAL request which is quite clear from the
scribble. I always have to re-learn how the N*MEMORY works TBH. Maybe
this is just me though.
-- 
Michal Hocko
SUSE Labs
