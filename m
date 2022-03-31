From: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: Re: [Patch v2 2/3] mm/memcg: set pos explicitly for reclaim and
 !reclaim
Date: Wed, 30 Mar 2022 17:21:29 -0700
Message-ID: <YkT0CXIey0a6pPX6@carbon.dhcp.thefacebook.com>
References: <20220330234719.18340-1-richard.weiyang@gmail.com>
 <20220330234719.18340-3-richard.weiyang@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1648686095;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aWF887DtqFZawSDRTplBMzE6vHE/PS285KJ5U8ZNHwA=;
        b=KrFNO/YnPGeftymOJt04Ki+/yT0lpAC29OMuRJMM2jNsur/jxiBMNdzjv7iuN1pnC6LllH
        /BoKRUYj0SF2GnQmz2mH+G0oM5AKaua0UTXmj4MBQN55I8Q3eTLZfaAQbQGJO+Lop5r3q+
        zFSYyHGuCgzP+mYixT89TQqAwvXZe98=
Content-Disposition: inline
In-Reply-To: <20220330234719.18340-3-richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Wed, Mar 30, 2022 at 11:47:18PM +0000, Wei Yang wrote:
> During mem_cgroup_iter, there are two ways to get iteration position:
> reclaim vs non-reclaim mode.
> 
> Let's do it explicitly for reclaim vs non-reclaim mode.
> 
> Signed-off-by: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Reviewed-by: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>

Thanks!

> 
> ---
> v2: split into two explicit part as suggested by Johannes
> ---
>  mm/memcontrol.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index eed9916cdce5..5d433b79ba47 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1005,9 +1005,6 @@ struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
>  	if (!root)
>  		root = root_mem_cgroup;
>  
> -	if (prev && !reclaim)
> -		pos = prev;
> -
>  	rcu_read_lock();
>  
>  	if (reclaim) {
> @@ -1033,6 +1030,8 @@ struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
>  			 */
>  			(void)cmpxchg(&iter->position, pos, NULL);
>  		}
> +	} else if (prev) {
> +		pos = prev;
>  	}
>  
>  	if (pos)
> -- 
> 2.33.1
> 
> 
