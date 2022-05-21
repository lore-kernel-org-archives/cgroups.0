From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH mm v2 6/9] memcg: enable accounting for percpu allocation
 of struct cgroup_rstat_cpu
Date: Sat, 21 May 2022 14:35:51 -0700
Message-ID: <CALvZod6qeh_rNVVpZ5N8RMauhvxjQ=wLJUpK-QBCa9AXDNqi_g@mail.gmail.com>
References: <Yn6aL3cO7VdrmHHp@carbon> <c0d01d6e-530c-9be3-1c9b-67a7f8ea09be@openvz.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ovbs7SznoJE1sVxkoT4HN7MF5cA4tFBx5ooIOKpQ5rI=;
        b=HtMT4pCc5uH63EO6XlkrHpLrHOUT2F/DcCheEuURYYK0r2GEGrJzb/3oD1DgUHGgbS
         DTZvc7agujFsGc8vMopNkC6FjfuUA9MJkZ1FHzoiTFJd0SVGVTNnT9W5ykihOzFgtLAr
         S0EWv4ixlw92AThV7s6hF6xrQQfmjkH1fSqJgR9tQztQtG03xBmGq0UWxi5Sdtkykpri
         hadLh08mZRRFMRw+n0UWus3QJC6eVtN5cCmJjI/1F727JI4G0yv5iVqGWpauiYPRlPlx
         kfbkguPiTMODEoDYwaJS3f5Na9KWMUkMa3aNy8bN+imxqdX4Zat5tfu6XlyOAvSHZtLF
         apBw==
In-Reply-To: <c0d01d6e-530c-9be3-1c9b-67a7f8ea09be-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Sat, May 21, 2022 at 9:38 AM Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org> wrote:
>
> struct cgroup_rstat_cpu is percpu allocated for each new cgroup and
> can consume a significant portion of all allocated memory on nodes
> with a large number of CPUs.
>
> Common part of the cgroup creation:
> Allocs  Alloc   $1*$2   Sum     Allocation
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

Acked-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
