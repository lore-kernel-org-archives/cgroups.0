From: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH] page_alloc: skip cpuset enforcement for lower zone
 allocations
Date: Fri, 23 May 2014 13:51:12 -0700 (PDT)
Message-ID: <alpine.DEB.2.02.1405231334460.13205@chino.kir.corp.google.com>
References: <20140523193706.GA22854@amt.cnet>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        bh=iFXvXhrH+5LFOUS3ZjB8sFFrbdlJvJIeJAyxtef4Tqc=;
        b=kPCGbSlnp6slIQeBoGd5Pzhu3YTEaCMTOvJXtpLOVoVmUCakpOXzdcs96uSghVur60
         GshOSgezaiUXwdkEYATc/XIPLgIGbWAhI7UrCR4/7A6c7M1ItWIeB2/snO9oIbWIS9hT
         RRUXjgDwkL9dcfMFWakgzilG2jdroL8pbB4XEsDRZO+vBtmZvOd6E73QRj2OQX2PStlE
         jRhIDvmPf/yF51Fr91Hi2xQR6C21DmuxUI82HfIkPWv1zMDvLeb0+rLi8NJ4UYs0cUUC
         uhO7rJpRkXTYqLEzeTg/DWsUcgY7y0o2aduUetz7GIQaAMz2mxvrm+2GvIO5jxMU88Zw
         MIDA==
In-Reply-To: <20140523193706.GA22854@amt.cnet>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, Lai Jiangshan <laijs@cn.fujitsu.com>, Mel Gorman <mgorman@suse.de>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>, Li Zefan <lizefan@huawei.com>, Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org

On Fri, 23 May 2014, Marcelo Tosatti wrote:

> Zone specific allocations, such as GFP_DMA32, should not be restricted
> to cpusets allowed node list: the zones which such allocations demand
> might be contained in particular nodes outside the cpuset node list.
> 
> The alternative would be to not perform such allocations from
> applications which are cpuset restricted, which is unrealistic.
> 

Or ensure applications that allocate from lowmem are allowed to do so, but 
I understand that might be hard to make sure always happens.

> Fixes KVM's alloc_page(gfp_mask=GFP_DMA32) with cpuset as explained.
> 
> Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 5dba293..f228039 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -2698,6 +2698,7 @@ __alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order,
>  	unsigned int cpuset_mems_cookie;
>  	int alloc_flags = ALLOC_WMARK_LOW|ALLOC_CPUSET|ALLOC_FAIR;
>  	struct mem_cgroup *memcg = NULL;
> +	nodemask_t *cpuset_mems_allowed = &cpuset_current_mems_allowed;
>  
>  	gfp_mask &= gfp_allowed_mask;
>  
> @@ -2726,9 +2727,14 @@ __alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order,
>  retry_cpuset:
>  	cpuset_mems_cookie = read_mems_allowed_begin();
>  
> +#ifdef CONFIG_NUMA
> +	if (gfp_zone(gfp_mask) < policy_zone)
> +		cpuset_mems_allowed = NULL;
> +#endif
> +
>  	/* The preferred zone is used for statistics later */
>  	first_zones_zonelist(zonelist, high_zoneidx,
> -				nodemask ? : &cpuset_current_mems_allowed,
> +				nodemask ? : cpuset_mems_allowed,
>  				&preferred_zone);
>  	if (!preferred_zone)
>  		goto out;
> 

I think this is incomplete.  Correct me if I'm wrong on how this is 
working: preferred_zone, today, is NULL because first_zones_zonelist() is 
restricted to a cpuset.mems that does not include lowmem and your patch 
fixes that.  But if the fastpath allocation with mandatory ALLOC_CPUSET 
fails and we go to the slowpath, which may or may not have showed up in 
your testing, there's still issues, particularly if __GFP_WAIT and lots of 
allocators do GFP_KERNEL | __GFP_DMA32.  This requires ALLOC_CPUSET on all 
allocations and you haven't updated __cpuset_node_allowed_softwall() with 
this exception nor zlc_setup().

After that's done, I think all of this is really convoluted and deserves a 
comment to describe the ALLOC_CPUSET and __GFP_DMA32 behavior.

Adding Li, the cpusets maintainer, to this as well.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
