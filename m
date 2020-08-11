From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [Resend PATCH 2/6] mm/memcg: remove useless check on
 page->mem_cgroup
Date: Tue, 11 Aug 2020 15:56:26 +0200
Message-ID: <20200811135626.GL4793@dhcp22.suse.cz>
References: <1597144232-11370-1-git-send-email-alex.shi@linux.alibaba.com>
 <1597144232-11370-2-git-send-email-alex.shi@linux.alibaba.com>
 <20200811113008.GK4793@dhcp22.suse.cz>
 <776b0e6f-4129-9fb9-0f66-47757cf320d5@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <776b0e6f-4129-9fb9-0f66-47757cf320d5-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue 11-08-20 20:54:18, Alex Shi wrote:
> >From beeac61119ab39b1869c520c0f272fb8bab93765 Mon Sep 17 00:00:00 2001
> From: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
> Date: Wed, 5 Aug 2020 21:02:30 +0800
> Subject: [PATCH 2/6] memcg: bail out early from swap accounting when memcg is
>  disabled
> 
> If we disabled memcg by cgroup_disable=memory, the swap charges are
> still called. Let's return from the funcs earlier.

They are not, are they? page->memcg will be NULL and so the charge is
skipped and that will trigger a warning with your current ordering.

Let me repeat again. Either you put it first in the series and argue
that we can bail out early or keep the ordering then this makes sure the
warning doesn't trigger.

> Signed-off-by: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
> Reviewed-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
> Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
> Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> ---
>  mm/memcontrol.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 299382fc55a9..419cf565f40b 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -7098,6 +7098,9 @@ void mem_cgroup_swapout(struct page *page, swp_entry_t entry)
>  	VM_BUG_ON_PAGE(PageLRU(page), page);
>  	VM_BUG_ON_PAGE(page_count(page), page);
>  
> +	if (mem_cgroup_disabled())
> +		return;
> +
>  	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
>  		return;
>  
> @@ -7163,6 +7166,9 @@ int mem_cgroup_try_charge_swap(struct page *page, swp_entry_t entry)
>  	struct mem_cgroup *memcg;
>  	unsigned short oldid;
>  
> +	if (mem_cgroup_disabled())
> +		return 0;
> +
>  	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
>  		return 0;
>  
> -- 
> 1.8.3.1

-- 
Michal Hocko
SUSE Labs
