From: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: Re: [Patch v2 3/3] mm/memcg: move generation assignment and
 comparison together
Date: Wed, 30 Mar 2022 17:28:21 -0700
Message-ID: <YkT1paG1n0ZLe3YN@carbon.dhcp.thefacebook.com>
References: <20220330234719.18340-1-richard.weiyang@gmail.com>
 <20220330234719.18340-4-richard.weiyang@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1648686506;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jJCkR8Jqm62pdxZogzgoWn7utwih/y2wfzxyFGpIn/U=;
        b=NMWkMdAryffAdC9bHXtUzUBevhGQztvRKoIsGq2gk+6d+h+xM7BmQuTWclsyWZtiPFwe01
        raOCfjg/oGNfvLb7bdUkawI09np2FJTF2lpY+sx3fuqtGGal9SzQoGcxT3OMVJIFwGrCOV
        NrqWFGA4MvW8GVoYf/NZS/p+8ioElpc=
Content-Disposition: inline
In-Reply-To: <20220330234719.18340-4-richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Wed, Mar 30, 2022 at 11:47:19PM +0000, Wei Yang wrote:
> For each round-trip, we assign generation on first invocation and
> compare it on subsequent invocations.
> 
> Let's move them together to make it more self-explaining. Also this
> reduce a check on prev.
> 
> [hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org: better comment to explain reclaim model]
> 
> Signed-off-by: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Reviewed-by: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>

> 
> ---
> v2: a better comment from Johannes
> ---
>  mm/memcontrol.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 5d433b79ba47..2cd8bfdec379 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1013,7 +1013,13 @@ struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
>  		mz = root->nodeinfo[reclaim->pgdat->node_id];
>  		iter = &mz->iter;
>  
> -		if (prev && reclaim->generation != iter->generation)
> +		/*
> +		 * On start, join the current reclaim iteration cycle.
> +		 * Exit when a concurrent walker completes it.
> +		 */
> +		if (!prev)
> +			reclaim->generation = iter->generation;
> +		else if (reclaim->generation != iter->generation)
>  			goto out_unlock;
>  
>  		while (1) {
> @@ -1075,8 +1081,6 @@ struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
>  
>  		if (!memcg)
>  			iter->generation++;
> -		else if (!prev)
> -			reclaim->generation = iter->generation;
>  	}
>  
>  out_unlock:
> -- 
> 2.33.1
> 
> 
