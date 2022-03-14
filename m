From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [Patch v2 3/3] mm/memcg: add next_mz back to soft limit tree if
 not reclaimed yet
Date: Mon, 14 Mar 2022 10:41:13 +0100
Message-ID: <Yi8NudEX/sZsO2nO@dhcp22.suse.cz>
References: <20220312071623.19050-1-richard.weiyang@gmail.com>
 <20220312071623.19050-3-richard.weiyang@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1647250873; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vjCAmfOeIAmJsBLZGTQdftIhcJ0qr7uynuuuQ3TesCo=;
        b=NzzajjqEfhDUN2nmysnf+Itb4aFQe8SNtcbcddDI3ZQKOLMqLXLomuKFhQbSjmDeW6Lekw
        7b5Hl1XvWv8QXxMRHPR6mBKZIsXYiF69jyNsz+nsuhsZ2iZB/auOvRvq5e22Q+WIs2Hc3R
        DfgIu7LRtH+3wSJn0pEhnJzOMIKDtUE=
Content-Disposition: inline
In-Reply-To: <20220312071623.19050-3-richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Sat 12-03-22 07:16:23, Wei Yang wrote:
> When memory reclaim failed for a maximum number of attempts and we bail
> out of the reclaim loop, we forgot to put the target mem_cgroup chosen
> for next reclaim back to the soft limit tree. This prevented pages in
> the mem_cgroup from being reclaimed in the future even though the
> mem_cgroup exceeded its soft limit.
> 
> Let's say there are two mem_cgroup and both of them exceed the soft
> limit, while the first one is more active then the second. Since we add
> a mem_cgroup to soft limit tree every 1024 event, the second one just
> get a rare chance to be put on soft limit tree even it exceeds the
> limit.

yes, 1024 could be just 4MB of memory or 2GB if all the charged pages
are THPs. So the excess can build up considerably.

> As time goes on, the first mem_cgroup was kept close to its soft limit
> due to reclaim activities, while the memory usage of the second
> mem_cgroup keeps growing over the soft limit for a long time due to its
> relatively rare occurrence.
> 
> This patch adds next_mz back to prevent this sceanrio.
> 
> Signed-off-by: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Even though your changelog is different the change itself is identical to
https://lore.kernel.org/linux-mm/8d35206601ccf0e1fe021d24405b2a0c2f4e052f.1613584277.git.tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org/
In those cases I would preserve the the original authorship by
From: Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
and add his s-o-b before yours.

Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

Thanks!

> ---
>  mm/memcontrol.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 344a7e891bc5..e803ff02aae2 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3493,8 +3493,13 @@ unsigned long mem_cgroup_soft_limit_reclaim(pg_data_t *pgdat, int order,
>  			loop > MEM_CGROUP_MAX_SOFT_LIMIT_RECLAIM_LOOPS))
>  			break;
>  	} while (!nr_reclaimed);
> -	if (next_mz)
> +	if (next_mz) {
> +		spin_lock_irq(&mctz->lock);
> +		excess = soft_limit_excess(next_mz->memcg);
> +		__mem_cgroup_insert_exceeded(next_mz, mctz, excess);
> +		spin_unlock_irq(&mctz->lock);
>  		css_put(&next_mz->memcg->css);
> +	}
>  	return nr_reclaimed;
>  }
>  
> -- 
> 2.33.1

-- 
Michal Hocko
SUSE Labs
