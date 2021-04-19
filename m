From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v4 1/5] mm/memcg: Move mod_objcg_state() to memcontrol.c
Date: Mon, 19 Apr 2021 11:14:23 -0400
Message-ID: <YH2eT+JCII48hX80@cmpxchg.org>
References: <20210419000032.5432-1-longman@redhat.com>
 <20210419000032.5432-2-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=55uomXciVSZ6J6HOTB32O4AbktADuhgCDGYMDuRmQxE=;
        b=RQhB8OjlxbRDagS7zeb7sF3QHZwiZdGpXuuxJSsZOxySpSixsl4FqbgevMPiEdfs5V
         SRiDYvj2aok3lt+Kb0CaDE3nO0nzdifSCwV5jMfBFJKlVGGw/SPYIp+lJPWdQxVl560T
         KwQRD7NBYrflCIbsLoFGLGlPICDLLjfLaQ0HYUmIZjCRldM6OI4HbuVdhXzoKRxCpaUo
         u5u7RbH0I2icI19RuUvEqPq/Xhey6DWAxZzyBlCCemoLeo2zwVbfv8HkjRR7iyIZ652x
         +zYC+YI6muSdaB8L13xdzgdASaPEkae7oXWHP5rleWZLqiD8bRo2JZNvQKm2o4u1CmOa
         FsgA==
Content-Disposition: inline
In-Reply-To: <20210419000032.5432-2-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Masayoshi Mizuma <msys.mizuma-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Xing Zhengjun <zhengjun.xing-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Matthew Wilcox <>

On Sun, Apr 18, 2021 at 08:00:28PM -0400, Waiman Long wrote:
> The mod_objcg_state() function is moved from mm/slab.h to mm/memcontrol.c
> so that further optimization can be done to it in later patches without
> exposing unnecessary details to other mm components.
> 
> Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  mm/memcontrol.c | 13 +++++++++++++
>  mm/slab.h       | 16 ++--------------
>  2 files changed, 15 insertions(+), 14 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index e064ac0d850a..dc9032f28f2e 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3150,6 +3150,19 @@ void __memcg_kmem_uncharge_page(struct page *page, int order)
>  	css_put(&memcg->css);
>  }
>  
> +void mod_objcg_state(struct obj_cgroup *objcg, struct pglist_data *pgdat,
> +		     enum node_stat_item idx, int nr)
> +{
> +	struct mem_cgroup *memcg;
> +	struct lruvec *lruvec = NULL;
> +
> +	rcu_read_lock();
> +	memcg = obj_cgroup_memcg(objcg);
> +	lruvec = mem_cgroup_lruvec(memcg, pgdat);
> +	mod_memcg_lruvec_state(lruvec, idx, nr);
> +	rcu_read_unlock();
> +}

It would be more naturally placed next to the others, e.g. below
__mod_lruvec_kmem_state().

But no deal breaker if there isn't another revision.

Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
