From: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH mm v2 6/9] memcg: enable accounting for percpu allocation
 of struct cgroup_rstat_cpu
Date: Sat, 21 May 2022 20:58:35 +0300
Message-ID: <6c980ae0-9731-ba89-d04f-cd55a6badc24@openvz.org>
References: <Yn6aL3cO7VdrmHHp@carbon>
 <c0d01d6e-530c-9be3-1c9b-67a7f8ea09be@openvz.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openvz-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=Q66Lzs3M5kOo/8VJybpmTwF9IYF2g+3dQsdn1hpx9NQ=;
        b=QCTfmXQGadwwlQM7hEIdm50KOXHwYga0OF/NGlbgOk3004UEHV2j12kft+vGwKwWir
         wRilZT8O9unVC1Xau1Q/xJ/oXjKUn097Ca9N477mVVb4T+K+qMPT9zUfhK0U696onLrH
         0os54gYtDt7QmTh2QJVp0zVX+VOwBBN3tTEji9jfwScy0wauB/MKvMR9weEQeZu99gcl
         S6q0/FQT5dVQFSiYwCJOEzJUVh2eXtxNXRkNhlzUj8VPMJ4+JVhxhMspOoclfnBCfr0o
         JdQNunNe+PYOALJWx7fSQNgpOjodEVLFipBmw9+pinSFfPkeFtfzzVFHvhyVXcuEKFmZ
         Cu/w==
Content-Language: en-US
In-Reply-To: <c0d01d6e-530c-9be3-1c9b-67a7f8ea09be-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 5/21/22 19:38, Vasily Averin wrote:
> struct cgroup_rstat_cpu is percpu allocated for each new cgroup and
> can consume a significant portion of all allocated memory on nodes
> with a large number of CPUs.
> 
> Common part of the cgroup creation:
> Allocs  Alloc   $1*$2   Sum	Allocation
> number  size
> --------------------------------------------
> 16  ~   352     5632    5632    KERNFS
> 1   +   4096    4096    9728    (cgroup_mkdir+0xe4)
> 1       584     584     10312   (radix_tree_node_alloc.constprop.0+0x89)
> 1       192     192     10504   (__d_alloc+0x29)
> 2       72      144     10648   (avc_alloc_node+0x27)
> 2       64      128     10776   (percpu_ref_init+0x6a)
> 1       64      64      10840   (memcg_list_lru_alloc+0x21a)
> percpu:
> 1   +   192     192     192     call_site=psi_cgroup_alloc+0x1e
> 1   +   96      96      288     call_site=cgroup_rstat_init+0x5f
> 2       12      24      312     call_site=percpu_ref_init+0x23
> 1       6       6       318     call_site=__percpu_counter_init+0x22
> 
>  '+' -- to be accounted,
>  '~' -- partially accounted
> 
> Signed-off-by: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
> ---
>  kernel/cgroup/rstat.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/cgroup/rstat.c b/kernel/cgroup/rstat.c
> index 24b5c2ab5598..f76cb63ae2e0 100644
> --- a/kernel/cgroup/rstat.c
> +++ b/kernel/cgroup/rstat.c
> @@ -257,7 +257,8 @@ int cgroup_rstat_init(struct cgroup *cgrp)
>  
>  	/* the root cgrp has rstat_cpu preallocated */
>  	if (!cgrp->rstat_cpu) {
> -		cgrp->rstat_cpu = alloc_percpu(struct cgroup_rstat_cpu);
> +		cgrp->rstat_cpu = alloc_percpu_gfp(struct cgroup_rstat_cpu
"," was lost here
> +						   GFP_KERNEL_ACCOUNT);
>  		if (!cgrp->rstat_cpu)
>  			return -ENOMEM;
>  	}

