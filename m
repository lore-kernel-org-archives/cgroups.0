From: Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v2 9/9] memcg: do not modify rstat tree for zero updates
Date: Thu, 30 Mar 2023 09:43:42 +0200
Message-ID: <ZCU9rsLmPGQiZx13@dhcp22.suse.cz>
References: <20230328221644.803272-1-yosryahmed@google.com>
 <20230328221644.803272-10-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1680162223; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pcR6uGA8qbqfio6LsBj8cNALnv9xWak5dIIrh+CRcYc=;
        b=MVEtG58MeLA15yiqwOQsyU7lQWKy3SM6ILJww5NxO11VDo5w2GI08CrM66fX87jUm+ZTrn
        WGtLRJH21MUpLoK6nzD4jfvLVEN2izyrVTfW4vT2qm3ipGVANV5+V6S+CWgIy3tcl7vMO0
        JYW0mU18y8N5KC2JpW6dUF5XhrBC/cg=
Content-Disposition: inline
In-Reply-To: <20230328221644.803272-10-yosryahmed@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed@google.com>
Cc: Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Jens Axboe <axboe@kernel.dk>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>, Vasily Averin <vasily.averin@linux.dev>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org

On Tue 28-03-23 22:16:44, Yosry Ahmed wrote:
> In some situations, we may end up calling memcg_rstat_updated() with a
> value of 0, which means the stat was not actually updated. An example is
> if we fail to reclaim any pages in shrink_folio_list().
> 
> Do not add the cgroup to the rstat updated tree in this case, to avoid
> unnecessarily flushing it.
> 
> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> Acked-by: Shakeel Butt <shakeelb@google.com>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Michal Hocko <mhocko@suse.com>

> ---
>  mm/memcontrol.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 361c0bbf7283..a63ee2efa780 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -618,6 +618,9 @@ static inline void memcg_rstat_updated(struct mem_cgroup *memcg, int val)
>  {
>  	unsigned int x;
>  
> +	if (!val)
> +		return;
> +
>  	cgroup_rstat_updated(memcg->css.cgroup, smp_processor_id());
>  
>  	x = __this_cpu_add_return(stats_updates, abs(val));
> -- 
> 2.40.0.348.gf938b09366-goog

-- 
Michal Hocko
SUSE Labs
