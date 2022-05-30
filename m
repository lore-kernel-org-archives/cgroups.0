From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH mm v3 0/9] memcg: accounting for objects allocated by
 mkdir cgroup
Date: Mon, 30 May 2022 13:55:42 +0200
Message-ID: <YpSwvii5etfnOYC9@dhcp22.suse.cz>
References: <06505918-3b8a-0ad5-5951-89ecb510138e@openvz.org>
 <3e1d6eab-57c7-ba3d-67e1-c45aa0dfa2ab@openvz.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1653911743; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=K5eN5/cePnHED6LIz60pf/vSdydS33X2AATbO9NoXNo=;
        b=EcpslcQfWh6nAGTYnwJ3a24s1aWzIfX8p6opHBvq34+UJVRbdsJ4azT+ozFRxQ0cW9KcZG
        YX1NbUCM5sG8Z00Y2NhK4zhIybN+kYYJVh3fBzoeUIkmJ0Rr1CCkET+Ovj/PeBYyDjBpcI
        2zpZpWLlE2hsSiciEG+XJ53o4kSBQyU=
Content-Disposition: inline
In-Reply-To: <3e1d6eab-57c7-ba3d-67e1-c45aa0dfa2ab-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon 30-05-22 14:25:45, Vasily Averin wrote:
> Below is tracing results of mkdir /sys/fs/cgroup/vvs.test on 
> 4cpu VM with Fedora and self-complied upstream kernel. The calculations
> are not precise, it depends on kernel config options, number of cpus,
> enabled controllers, ignores possible page allocations etc.
> However this is enough to clarify the general situation.
> All allocations are splited into:
> - common part, always called for each cgroup type
> - per-cgroup allocations
> 
> In each group we consider 2 corner cases:
> - usual allocations, important for 1-2 CPU nodes/Vms
> - percpu allocations, important for 'big irons'
> 
> common part: 	~11Kb	+  318 bytes percpu
> memcg: 		~17Kb	+ 4692 bytes percpu
> cpu:		~2.5Kb	+ 1036 bytes percpu
> cpuset:		~3Kb	+   12 bytes percpu
> blkcg:		~3Kb	+   12 bytes percpu
> pid:		~1.5Kb	+   12 bytes percpu		
> perf:		 ~320b	+   60 bytes percpu
> -------------------------------------------
> total:		~38Kb	+ 6142 bytes percpu
> currently accounted:	  4668 bytes percpu
> 
> - it's important to account usual allocations called
> in common part, because almost all of cgroup-specific allocations
> are small. One exception here is memory cgroup, it allocates a few
> huge objects that should be accounted.
> - Percpu allocation called in common part, in memcg and cpu cgroups
> should be accounted, rest ones are small an can be ignored.
> - KERNFS objects are allocated both in common part and in most of
> cgroups 
> 
> Details can be found here:
> https://lore.kernel.org/all/d28233ee-bccb-7bc3-c2ec-461fd7f95e6a-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org/
> 
> I checked other cgroups types was found that they all can be ignored.
> Additionally I found allocation of struct rt_rq called in cpu cgroup 
> if CONFIG_RT_GROUP_SCHED was enabled, it allocates huge (~1700 bytes)
> percpu structure and should be accounted too.

One thing that the changelog is missing is an explanation why do we need
to account those objects. Users are usually not empowered to create
cgroups arbitrarily. Or at least they shouldn't because we can expect
more problems to happen.

Could you clarify this please?
-- 
Michal Hocko
SUSE Labs
