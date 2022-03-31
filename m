From: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: Re: [Patch v2 1/3] mm/memcg: set memcg after css verified and got
 reference
Date: Wed, 30 Mar 2022 17:20:22 -0700
Message-ID: <YkTzxgB85BhNRXjl@carbon.dhcp.thefacebook.com>
References: <20220330234719.18340-1-richard.weiyang@gmail.com>
 <20220330234719.18340-2-richard.weiyang@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1648686027;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kMINQAWO37CD+sVTlC/+ZMx9SRomlyJk24EcdjGWpeg=;
        b=wjiU1M6n3t656w0pWJcX+6aZPo7iWKh4pkJ21tOjlUEuOgNEycFbGfaLRm62qc3jXJ07iB
        dzUoeAh0RFkYRBb+iHMxH/+EuvR6VSeac50J4ncNDTQV3gFlcUfaguwKpQjNF2j7xtxJM2
        9/0/DJH3LBq0RFHj0pVnZZRYglSeoJY=
Content-Disposition: inline
In-Reply-To: <20220330234719.18340-2-richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Wed, Mar 30, 2022 at 11:47:17PM +0000, Wei Yang wrote:
> Instead of reset memcg when css is either not verified or not got
> reference, we can set it after these process.
> 
> No functional change, just simplified the code a little.
> 
> Signed-off-by: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Reviewed-by: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>

Nice cleanup!

> ---
>  mm/memcontrol.c | 11 +++--------
>  1 file changed, 3 insertions(+), 8 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index dc193e83794d..eed9916cdce5 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1057,15 +1057,10 @@ struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
>  		 * is provided by the caller, so we know it's alive
>  		 * and kicking, and don't take an extra reference.
>  		 */
> -		memcg = mem_cgroup_from_css(css);
> -
> -		if (css == &root->css)
> -			break;
> -
> -		if (css_tryget(css))
> +		if (css == &root->css || css_tryget(css)) {
> +			memcg = mem_cgroup_from_css(css);
>  			break;
> -
> -		memcg = NULL;
> +		}
>  	}
>  
>  	if (reclaim) {
> -- 
> 2.33.1
> 
> 
