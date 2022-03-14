From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [Patch v2 2/3] mm/memcg: __mem_cgroup_remove_exceeded could
 handle a !on-tree mz properly
Date: Mon, 14 Mar 2022 10:54:03 +0100
Message-ID: <Yi8Qu/1V4H1M9qZV@dhcp22.suse.cz>
References: <20220312071623.19050-1-richard.weiyang@gmail.com>
 <20220312071623.19050-2-richard.weiyang@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1647251643; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6VPBVQrxRZ4Cx7+iuRgH+2wDidcAf0gmeaDeqXu8ow8=;
        b=uoiY0spO/Ap8AdtaUTbRUJl58srkazDganaxbtxD0SvT4OF+KtD/ux6hk3ueqxX3EGYSu8
        3c7E3zpadTc2qGeE9wDEVL6l9ZxN/hlQAFwh+2UJy2pFUjgaa0NOxcMOR6iuKz6UyqfBHr
        k6RF+rr6F+tvDC5mnQrI0i5fti0aj78=
Content-Disposition: inline
In-Reply-To: <20220312071623.19050-2-richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Sat 12-03-22 07:16:22, Wei Yang wrote:
> There is no tree operation if mz is not on-tree.

This doesn't explain problem you are trying to solve nor does it make
much sense to me TBH.

> Let's remove the extra check.

What would happen if the mz was already in the excess tree and the
excess has grown?

> Signed-off-by: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  mm/memcontrol.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index d70bf5cf04eb..344a7e891bc5 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -545,9 +545,11 @@ static void mem_cgroup_update_tree(struct mem_cgroup *memcg, int nid)
>  			unsigned long flags;
>  
>  			spin_lock_irqsave(&mctz->lock, flags);
> -			/* if on-tree, remove it */
> -			if (mz->on_tree)
> -				__mem_cgroup_remove_exceeded(mz, mctz);
> +			/*
> +			 * remove it first
> +			 * If not on-tree, no tree ops.
> +			 */
> +			__mem_cgroup_remove_exceeded(mz, mctz);
>  			/*
>  			 * Insert again. mz->usage_in_excess will be updated.
>  			 * If excess is 0, no tree ops.
> -- 
> 2.33.1

-- 
Michal Hocko
SUSE Labs
