From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v3 04/13] kmem accounting basic infrastructure
Date: Fri, 21 Sep 2012 09:34:04 -0700
Message-ID: <20120921163404.GC7264@google.com>
References: <1347977050-29476-1-git-send-email-glommer@parallels.com>
 <1347977050-29476-5-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=4MvPeTW01sXCOZVlSiUGMaghsM/2X3u+elRhDZaedww=;
        b=iXVk8iFbIAPaMA3gaezg4ZnCRWCs5ibWlHULasOSxCe0Q1jKSD2EmdZJS9FSdWRsYO
         HLdhArv5vQT5ux0W+gEr/eGhEJ3FD3MRJeTvCE7ra9eCJ9n7dqxsDNh911eU1PwN9YtI
         w+baowIMVEAx8jcek7DCBuH8rqhDbSliBW9C8xzFzP0p3cb8MMwY5SL5bF6C9oYmKi9u
         BVjd8T2wUACktpC49c1uh61Yq71wDD4Lygg4uFD9I0kS9tnY2HRoRqssiNith7ReNazn
         xn/CAMYaoioZ8GEk0zkr0F5P1NEErQbrnkpxJqebGYLn5c5XMxxWeusrr74fd307Ha3X
         RGCw==
Content-Disposition: inline
In-Reply-To: <1347977050-29476-5-git-send-email-glommer@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com, devel@openvz.org, linux-mm@kvack.org, Suleiman Souhlal <suleiman@google.com>, Frederic Weisbecker <fweisbec@gmail.com>, Mel Gorman <mgorman@suse.de>, David Rientjes <rientjes@google.com>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>

On Tue, Sep 18, 2012 at 06:04:01PM +0400, Glauber Costa wrote:
>  #ifdef CONFIG_MEMCG_KMEM
> +static struct cftype kmem_cgroup_files[] = {
> +	{
> +		.name = "kmem.limit_in_bytes",
> +		.private = MEMFILE_PRIVATE(_KMEM, RES_LIMIT),
> +		.write_string = mem_cgroup_write,
> +		.read = mem_cgroup_read,
> +	},
> +	{
> +		.name = "kmem.usage_in_bytes",
> +		.private = MEMFILE_PRIVATE(_KMEM, RES_USAGE),
> +		.read = mem_cgroup_read,
> +	},
> +	{
> +		.name = "kmem.failcnt",
> +		.private = MEMFILE_PRIVATE(_KMEM, RES_FAILCNT),
> +		.trigger = mem_cgroup_reset,
> +		.read = mem_cgroup_read,
> +	},
> +	{
> +		.name = "kmem.max_usage_in_bytes",
> +		.private = MEMFILE_PRIVATE(_KMEM, RES_MAX_USAGE),
> +		.trigger = mem_cgroup_reset,
> +		.read = mem_cgroup_read,
> +	},
> +	{},
> +};
> +
>  static int memcg_init_kmem(struct mem_cgroup *memcg, struct cgroup_subsys *ss)
>  {
>  	return mem_cgroup_sockets_init(memcg, ss);
> @@ -4961,6 +5015,12 @@ mem_cgroup_create(struct cgroup *cont)
>  		int cpu;
>  		enable_swap_cgroup();
>  		parent = NULL;
> +
> +#ifdef CONFIG_MEMCG_KMEM
> +		WARN_ON(cgroup_add_cftypes(&mem_cgroup_subsys,
> +					   kmem_cgroup_files));
> +#endif
> +

Why not just make it part of mem_cgroup_files[]?

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
