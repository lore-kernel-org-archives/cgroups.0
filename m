From: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: Re: [PATCH mm v2 6/9] memcg: enable accounting for percpu allocation
 of struct cgroup_rstat_cpu
Date: Tue, 24 May 2022 18:31:10 -0700
Message-ID: <Yo2G3mVlu6+/zXtP@carbon>
References: <Yn6aL3cO7VdrmHHp@carbon>
 <c0d01d6e-530c-9be3-1c9b-67a7f8ea09be@openvz.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1653442275;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OVjueIe9mhvrA27ww7AR0v74gWv/I98eGtND8IZl3vg=;
        b=VyeEk+zQVrAX1dIxFiZr77PDfHCvUjewxtS5IhtduYYDn5AqfvWy60/KZVUPwogYGH2TRW
        kTsnAIrSGT+1YJBn+jOgwjZRcYRaOargixCYaEvGQsgsk8LkNNJeTEwc4YfWesQ/W18lCL
        +/5ggn+QKpfcJrCA07Vjk4tVSQq3s68=
Content-Disposition: inline
In-Reply-To: <c0d01d6e-530c-9be3-1c9b-67a7f8ea09be-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, May 21, 2022 at 07:38:31PM +0300, Vasily Averin wrote:
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

Acked-by: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>

