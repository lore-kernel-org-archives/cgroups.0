From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: eliminate redundant check in
 __mem_cgroup_insert_exceeded()
Date: Fri, 9 Oct 2020 17:12:27 +0200
Message-ID: <20201009151227.GP4967@dhcp22.suse.cz>
References: <20201009135104.39048-1-linmiaohe@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1602256352;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BSD1kYo1TCGseCG0CMo0C9XsPcUqaOsDq8A7C+bHfAc=;
        b=H9vZZHdqeJILfnwmhQEIFVlV29sQ5i/dofyz5kArPDdfu1Dl+uoOE0Y+YJku6zahrYl3R8
        R/CyAR+M+8h6Z/GdvxRvvFvdlvT3x/HxRWyaaesz1u2dqzvfRhAsNXJcGvmv0RJzWUK37C
        N8LATr1C4lgtsO/P/i/6e2kwNWMVDNU=
Content-Disposition: inline
In-Reply-To: <20201009135104.39048-1-linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri 09-10-20 09:51:04, Miaohe Lin wrote:
> The mz->usage_in_excess >= mz_node->usage_in_excess check is exactly the
> else case of mz->usage_in_excess < mz_node->usage_in_excess. So we could
> replace else if (mz->usage_in_excess >= mz_node->usage_in_excess) with else
> equally.
> 
> Signed-off-by: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

I believe this is a result of a very unreadable code. Resp. the comment
makes it hard to follow. It would be slightly better to simply drop the
comment which doesn't really explain much IMHO.

> ---
>  mm/memcontrol.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 2636f8bad908..f607afd0fcbf 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -629,7 +629,7 @@ static void __mem_cgroup_insert_exceeded(struct mem_cgroup_per_node *mz,
>  		 * We can't avoid mem cgroups that are over their soft
>  		 * limit by the same amount
>  		 */
> -		else if (mz->usage_in_excess >= mz_node->usage_in_excess)
> +		else
>  			p = &(*p)->rb_right;
>  	}
>  
> -- 
> 2.19.1

-- 
Michal Hocko
SUSE Labs
