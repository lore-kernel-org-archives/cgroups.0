From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH 3/3] mm/memcg: move generation assignment and comparison
 together
Date: Wed, 30 Mar 2022 11:57:07 -0400
Message-ID: <YkR902CHgavwleet@cmpxchg.org>
References: <20220225003437.12620-1-richard.weiyang@gmail.com>
 <20220225003437.12620-4-richard.weiyang@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2DqrTDJij/+jnL6IguPlfSJVz0YoCK5Qn6m+J92VWzI=;
        b=orgO24LkHCF4EOuz/ab4HIS8kjgemcfoGLDYGu7EWuXlTISEDMSKr4h2nrxRs2PzEc
         EjAshco2pN7gXzRJhW+0+mjZnkG0Xxm5vCR41OHjwj7BNKSAbpspP9aKawjBtJt4ZKKk
         Iat4FhW+5tFjMxnCnwdh8Bfl7HaK837UV+gjMj9/2UCWjyP+V8to1NZzXlrfzbZHkzeX
         WwPTYlpbpMAm35NaEV1dkfMAfyfgI3ZCHwuPlupG2iXlGyuDmKzIaZ/YYwDXbMdDNC9p
         km4O1WETMIikl7k5dpkF/phamL+DERfeGpjhuTN3hR+/OfQDxFYdrJ2a9p8r5UE1gffJ
         TTpA==
Content-Disposition: inline
In-Reply-To: <20220225003437.12620-4-richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Fri, Feb 25, 2022 at 12:34:37AM +0000, Wei Yang wrote:
> For each round-trip, we assign generation on first invocation and
> compare it on subsequent invocations.
> 
> Let's move them together to make it more self-explaining. Also this
> reduce a check on prev.
> 
> Signed-off-by: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

This makes sense. The function is structured into 1) load state, 2)
advance, 3) save state. The load state is a better fit for
initializing reclaim->generation.

> @@ -996,7 +996,14 @@ struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
>  		mz = root->nodeinfo[reclaim->pgdat->node_id];
>  		iter = &mz->iter;
>  
> -		if (prev && reclaim->generation != iter->generation)
> +		/*
> +		 * On first invocation, assign iter->generation to
> +		 * reclaim->generation.
> +		 * On subsequent invocations, make sure no one else jump in.
> +		 */
> +		if (!prev)
> +			reclaim->generation = iter->generation;
> +		else if (reclaim->generation != iter->generation)
>  			goto out_unlock;

The comment duplicates the code, it doesn't explain why we're doing
this. How about:

		/*
		 * On start, join the current reclaim iteration cycle.
		 * Exit when a concurrent walker completes it.
		 */

With that, please feel free to add:

Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
