From: Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH 2/4] mm/memcg: mem_cgroup_per_node is already set to 0 on
 allocation
Date: Tue, 11 Jan 2022 09:41:32 +0100
Message-ID: <Yd1CvBVpCj5y0qZU@dhcp22.suse.cz>
References: <20220111010302.8864-1-richard.weiyang@gmail.com>
 <20220111010302.8864-2-richard.weiyang@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1641890492; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Qrf8PNeNEVsS9AToHTl2fRoEbnuL360momcCs7MV/Sg=;
        b=ecugM7jQuj/2S3JHjsuidBQqPtwwEX4TGWpLLZt+mGtoKTsyv7KiL/V8T3ykq5QhPyepzb
        avM3gfZF8eubZ8zI8PtyljwP4pGNP2V5BBtD/C/V2DMnKk0HmkHhlMqJ0pODA7hATwq7RX
        +ZE+8TsvtCdZWhxr/eNU6TbpGutY1UQ=
Content-Disposition: inline
In-Reply-To: <20220111010302.8864-2-richard.weiyang@gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wei Yang <richard.weiyang@gmail.com>
Cc: hannes@cmpxchg.org, vdavydov.dev@gmail.com, akpm@linux-foundation.org, shakeelb@google.com, guro@fb.com, vbabka@suse.cz, willy@infradead.org, songmuchun@bytedance.com, shy828301@gmail.com, surenb@google.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org

On Tue 11-01-22 01:03:00, Wei Yang wrote:
> kzalloc_node() would set data to 0, so it's not necessary to set it
> again.
> 
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>

Acked-by: Michal Hocko <mhocko@suse.com>

> ---
>  mm/memcontrol.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 11715f7323c0..a504616f904a 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5067,8 +5067,6 @@ static int alloc_mem_cgroup_per_node_info(struct mem_cgroup *memcg, int node)
>  	}
>  
>  	lruvec_init(&pn->lruvec);
> -	pn->usage_in_excess = 0;
> -	pn->on_tree = false;
>  	pn->memcg = memcg;
>  
>  	memcg->nodeinfo[node] = pn;
> -- 
> 2.33.1

-- 
Michal Hocko
SUSE Labs
