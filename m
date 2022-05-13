From: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: Re: [PATCH 0/4] memcg: accounting for objects allocated by mkdir
 cgroup
Date: Fri, 13 May 2022 10:49:35 -0700
Message-ID: <Yn6aL3cO7VdrmHHp@carbon>
References: <Ynv7+VG+T2y9rpdk@carbon>
 <1c14dce9-1981-2690-0e35-58e2d9fbc0da@openvz.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1652464181;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=B0+ajyKCVT2rz3AxxcmXTaNoUIUvS+gueEimpFPDfFg=;
        b=I85v06/ZEvJcNeiDuoilbejPX0TNHUuErn8RttBrVH5JjU+zsoh88HKy0szjsX39Yi1RsZ
        In7uhy6gUa1Ho85cugaXKEqwDU+8pfzqbBwhpoRhZrG1XMndLyDa1pMav2wpAm/OLxZQgc
        4JdsAOF2NqBN+3cgllWzaU+NIwsQX+o=
Content-Disposition: inline
In-Reply-To: <1c14dce9-1981-2690-0e35-58e2d9fbc0da-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, May 13, 2022 at 06:51:30PM +0300, Vasily Averin wrote:
> Below is tracing results of mkdir /sys/fs/cgroup/vvs.test on 
> 4cpu VM with Fedora and self-complied upstream kernel. The calculations
> are not precise, it depends on kernel config options, number of cpus,
> enabled controllers, ignores possible page allocations etc.
> However this is enough to clarify the general situation:
> - Total sum of accounted memory is ~60Kb.
> - Accounted only 2 huge percpu allocation marked '=', ~18Kb.
>   (and can be 0 without memory controller)
> - kernfs nodes and iattrs are among the main memory consumers.
>    they are marked '+' to be accounted.
> - cgroup_mkdir always allocates 4Kb,
>    so I think it should be accounted first too.
> - mem_cgroup_css_alloc allocations consumes 10K,
>    it's enough to be accounted, especially for VMs with 1-2 CPUs
> - Almost all other allocations are quite small and can be ignored.
>   Exceptions are percpu allocations in alloc_fair_sched_group(),
>    this can consume a significant amount of memory on nodes
>    with multiple processors.
> - kernfs nodes consumes ~6Kb memory inside simple_xattr_set() 
>    and simple_xattr_alloc(). This is quite high numbers,
>    but is not critical, and I think we can ignore it at the moment.
> - If all proposed memory will be accounted it gives us ~47Kb, 
>    or ~75% of all allocated memory.
> 
> number	bytes	$1*$2	sum	note	call_site
> of	alloc
> allocs
> ------------------------------------------------------------
> 1       14448   14448   14448   =       percpu_alloc_percpu:
> 1       8192    8192    22640   +       (mem_cgroup_css_alloc+0x54)
> 49      128     6272    28912   +       (__kernfs_new_node+0x4e)
> 49      96      4704    33616   ?       (simple_xattr_alloc+0x2c)
> 49      88      4312    37928   +       (__kernfs_iattrs+0x56)
> 1       4096    4096    42024   +       (cgroup_mkdir+0xc7)
> 1       3840    3840    45864   =       percpu_alloc_percpu:
> 4       512     2048    47912   +       (alloc_fair_sched_group+0x166)
> 4       512     2048    49960   +       (alloc_fair_sched_group+0x139)
> 1       2048    2048    52008   +       (mem_cgroup_css_alloc+0x109)
> 49      32      1568    53576   ?       (simple_xattr_set+0x5b)
> 2       584     1168    54744		(radix_tree_node_alloc.constprop.0+0x8d)
> 1       1024    1024    55768           (cpuset_css_alloc+0x30)
> 1       1024    1024    56792           (alloc_shrinker_info+0x79)
> 1       768     768     57560           percpu_alloc_percpu:
> 1       640     640     58200           (sched_create_group+0x1c)
> 33      16      528     58728           (__kernfs_new_node+0x31)
> 1       512     512     59240           (pids_css_alloc+0x1b)
> 1       512     512     59752           (blkcg_css_alloc+0x39)
> 9       48      432     60184           percpu_alloc_percpu:
> 13      32      416     60600           (__kernfs_new_node+0x31)
> 1       384     384     60984           percpu_alloc_percpu:
> 1       256     256     61240           (perf_cgroup_css_alloc+0x1c)
> 1       192     192     61432           percpu_alloc_percpu:
> 1       64      64      61496           (mem_cgroup_css_alloc+0x363)
> 1       32      32      61528           (ioprio_alloc_cpd+0x39)
> 1       32      32      61560           (ioc_cpd_alloc+0x39)
> 1       32      32      61592           (blkcg_css_alloc+0x6b)
> 1       32      32      61624           (alloc_fair_sched_group+0x52)
> 1       32      32      61656           (alloc_fair_sched_group+0x2e)
> 3       8       24      61680           (__kernfs_new_node+0x31)
> 3       8       24      61704           (alloc_cpumask_var_node+0x1b)
> 1       24      24      61728           percpu_alloc_percpu:
> 
> This patch-set enables accounting for required resources.
> I would like to discuss the patches with cgroup developers and maintainers,
> then I'm going re-send approved patches to subsystem maintainers.

Hi Vasily!

Thank you for the analysis and for the series. It looks really good to me.

Please, feel free to add
Reviewed-by: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
for the whole series.

Thanks!
