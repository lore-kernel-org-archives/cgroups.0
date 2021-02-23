From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: fix slub memory accounting
Date: Tue, 23 Feb 2021 07:37:54 -0800
Message-ID: <YDUhUtzLBmSV325H@carbon.lan>
References: <20210223092423.42420-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=8Dnke+Xe9pmyGZPvfL7ey84TMNULpiFlkwLnLEfkkZ0=;
 b=Ix9HGaP6s3CXvh+Ec67e/h6DSqmrOE5z0WPR43Gbm11/kwZAlAqe2aPF730G2VWmgd/J
 9josdEMcWqdVJYHkoc5bVIYgFR0511QO213GUndZmDQX76y1cR5yPOBhKqhiZWBb/day
 ENW7t7B1d3RlunVdZJn+rJ+or1s8OTQfpyY= 
Content-Disposition: inline
In-Reply-To: <20210223092423.42420-1-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Feb 23, 2021 at 05:24:23PM +0800, Muchun Song wrote:
> SLUB currently account kmalloc() and kmalloc_node() allocations larger
> than order-1 page per-node. But it forget to update the per-memcg
> vmstats. So it can lead to inaccurate statistics of "slab_unreclaimable"
> which is from memory.stat. Fix it by using mod_lruvec_page_state instead
> of mod_node_page_state.
> 
> Fixes: 6a486c0ad4dc ("mm, sl[ou]b: improve memory accounting")
> Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

Reviewed-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

Thanks!
