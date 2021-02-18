From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v2 3/3] mm: Fix missing mem cgroup soft limit tree updates
Date: Thu, 18 Feb 2021 00:56:02 -0500
Message-ID: <YC4BcsNFEmW7XeqB@cmpxchg.org>
References: <cover.1613584277.git.tim.c.chen@linux.intel.com>
 <e269f5df3af1157232b01a9b0dae3edf4880d786.1613584277.git.tim.c.chen@linux.intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=97xepu+H893Qn2oD7QzEQlF0nqYf2pV6us14XKtvHxU=;
        b=mgbz52W0JN7xwQftwEtM6NGsY/g84xRLA4xkhTjEINN5my44bcXRu6XD/L38sC1qfB
         fFk0r+RCj1e1clOhXV7+g4RwblTqhm4rMAYlgBga522+NSBTxYmvRQBy1Wby31qUxspS
         2o1DQPJXVPiyJh6aiJRdpzWtHvBAg8XR4lxxIg1tkZhIUN+CxS34HLATPmSjYMbryzYh
         L3gZ0Bmtz2aLr/fB2xjsFlEgfigT7X0md89CHZzGaIwcsqT+wP+5w7Yh09lA+jl/U8NS
         5ZI43x8+XjOGS5AddwtIoX1G0f0hze4USrUbCr7PTJ7ElbZRW957RBC1kocJFd96cIPp
         w/sw==
Content-Disposition: inline
In-Reply-To: <e269f5df3af1157232b01a9b0dae3edf4880d786.1613584277.git.tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ying Huang <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Feb 17, 2021 at 12:41:36PM -0800, Tim Chen wrote:
> On a per node basis, the mem cgroup soft limit tree on each node tracks
> how much a cgroup has exceeded its soft limit memory limit and sorts
> the cgroup by its excess usage.  On page release, the trees are not
> updated right away, until we have gathered a batch of pages belonging to
> the same cgroup. This reduces the frequency of updating the soft limit tree
> and locking of the tree and associated cgroup.
> 
> However, the batch of pages could contain pages from multiple nodes but
> only the soft limit tree from one node would get updated.  Change the
> logic so that we update the tree in batch of pages, with each batch of
> pages all in the same mem cgroup and memory node.  An update is issued for
> the batch of pages of a node collected till now whenever we encounter
> a page belonging to a different node.  Note that this batching for
> the same node logic is only relevant for v1 cgroup that has a memory
> soft limit.
> 
> Reviewed-by: Ying Huang <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> ---
>  mm/memcontrol.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index d72449eeb85a..8bddee75f5cb 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -6804,6 +6804,7 @@ struct uncharge_gather {
>  	unsigned long pgpgout;
>  	unsigned long nr_kmem;
>  	struct page *dummy_page;
> +	int nid;
>  };
>  
>  static inline void uncharge_gather_clear(struct uncharge_gather *ug)
> @@ -6849,7 +6850,13 @@ static void uncharge_page(struct page *page, struct uncharge_gather *ug)
>  	 * exclusive access to the page.
>  	 */
>  
> -	if (ug->memcg != page_memcg(page)) {
> +	if (ug->memcg != page_memcg(page) ||
> +	    /*
> +	     * Update soft limit tree used in v1 cgroup in page batch for
> +	     * the same node. Relevant only to v1 cgroup with a soft limit.
> +	     */
> +	    (ug->dummy_page && ug->nid != page_to_nid(page) &&
> +	     ug->memcg->soft_limit != PAGE_COUNTER_MAX)) {

Sorry, I used weird phrasing in my last email.

Can you please preface the checks you're adding with a
!cgroup_subsys_on_dfl(memory_cgrp_subsys) to static branch for
cgroup1? The uncharge path is pretty hot, and this would avoid the
runtime overhead on cgroup2 at least, which doesn't have the SL.

Also, do we need the ug->dummy_page check? It's only NULL on the first
loop - where ug->memcg is NULL as well and the branch is taken anyway.

The soft limit check is also slightly cheaper than the nid check, as
page_to_nid() might be out-of-line, so we should do it first. This?

	/*
	 * Batch-uncharge all pages of the same memcg.
	 *
	 * Unless we're looking at a cgroup1 with a softlimit
	 * set: the soft limit trees are maintained per-node
	 * and updated on uncharge (via dummy_page), so keep
	 * batches confined to a single node as well.
	 */
	if (ug->memcg != page_memcg(page) ||
	    (!cgroup_subsys_on_dfl(memory_cgrp_subsys) &&
	     ug->memcg->soft_limit != PAGE_COUNTER_MAX &&
	     ug->nid != page_to_nid(page)))
