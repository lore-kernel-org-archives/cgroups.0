From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 3/4] mm: memcontrol: bail out early when id is zero
Date: Mon, 15 Feb 2021 10:39:30 +0100
Message-ID: <YCpBUm2N4Bqm5PM5@dhcp22.suse.cz>
References: <20210212170159.32153-1-songmuchun@bytedance.com>
 <20210212170159.32153-3-songmuchun@bytedance.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1613381971; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AfxkVXqAHAm17EFwPtPwrVPHnFGJsC0+h+W+8Wzcudk=;
        b=QpHe7YRtB8RNMZWfhyKrDekJEH7y6gOUpQo21orpdf1GlGcYRJBY+zW+QzA+lirhVWw++K
        yOBrSPMoA3XkI+nhEojgostgEWblMww2qAUgFjp7I/jp588fiPOdtY07CLFsUCYeMLvlfa
        ggFU0zuPhY/fGiRMc63SIu0fWrZAOKs=
Content-Disposition: inline
In-Reply-To: <20210212170159.32153-3-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat 13-02-21 01:01:58, Muchun Song wrote:
> The memcg ID cannot be zero, but we can pass zero to mem_cgroup_from_id,
> so idr_find() is pointless and wastes CPU cycles.

Is this possible at all to happen? If not why should we add a test for
_all_ invocations?

> 
> Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> ---
>  mm/memcontrol.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index a3f26522765a..68ed4b297c13 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5173,6 +5173,9 @@ static inline void mem_cgroup_id_put(struct mem_cgroup *memcg)
>  struct mem_cgroup *mem_cgroup_from_id(unsigned short id)
>  {
>  	WARN_ON_ONCE(!rcu_read_lock_held());
> +	/* The memcg ID cannot be zero. */
> +	if (id == 0)
> +		return NULL;
>  	return idr_find(&mem_cgroup_idr, id);
>  }
>  
> -- 
> 2.11.0

-- 
Michal Hocko
SUSE Labs
