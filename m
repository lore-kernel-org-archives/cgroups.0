From: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: Re: [PATCH] mm/memcg: non-hierarchical mode is deprecated
Date: Mon, 4 Apr 2022 12:11:05 -0700
Message-ID: <YktCyf4sJ11aC8xn@carbon.dhcp.thefacebook.com>
References: <20220403020833.26164-1-richard.weiyang@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1649099469;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IQhgBimXjsff3C4o+7n/5Q3wYW2UqkiKGEeJ94ihq2Y=;
        b=mvCuJqdY/cG41YOkKNjL26KNm9A/3wMmhWMTazOGnFypRIqmqp7Za3sv/lZRIEk+DNNR9Z
        RYaKlu1imlw/XYW7u7VkTHv6GBZ42hhkfKzXjobhMz88QCmYsDX32KJGwK5zbxTpjlZ5Ia
        EQqU6oPNG5ZMiBRaqVDQe41jtCgiySk=
Content-Disposition: inline
In-Reply-To: <20220403020833.26164-1-richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

On Sun, Apr 03, 2022 at 02:08:33AM +0000, Wei Yang wrote:
> After commit bef8620cd8e0 ("mm: memcg: deprecate the non-hierarchical
> mode"), we won't have a NULL parent except root_mem_cgroup. And this
> case is handled when (memcg == root).
> 
> Signed-off-by: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> CC: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
> CC: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Reviewed-by: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>

Thanks!

> ---
>  mm/memcontrol.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 2cd8bfdec379..3ceb9b8592b1 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -6587,9 +6587,6 @@ void mem_cgroup_calculate_protection(struct mem_cgroup *root,
>  		return;
>  
>  	parent = parent_mem_cgroup(memcg);
> -	/* No parent means a non-hierarchical mode on v1 memcg */
> -	if (!parent)
> -		return;
>  
>  	if (parent == root) {
>  		memcg->memory.emin = READ_ONCE(memcg->memory.min);
> -- 
> 2.33.1
> 
