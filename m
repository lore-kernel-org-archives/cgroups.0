From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [patch 5/8] mm: memcg: remove unneeded checks from
 newpage_charge()
Date: Thu, 24 Nov 2011 09:04:43 +0900
Message-ID: <20111124090443.d3f720c5.kamezawa.hiroyu@jp.fujitsu.com>
References: <1322062951-1756-1-git-send-email-hannes@cmpxchg.org>
	<1322062951-1756-6-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1322062951-1756-6-git-send-email-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, 23 Nov 2011 16:42:28 +0100
Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:

> From: Johannes Weiner <jweiner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> 
> All callsites pass in freshly allocated pages and a valid mm.  As a
> result, all checks pertaining the page's mapcount, page->mapping or
> the fallback to init_mm are unneeded.
> 
> Signed-off-by: Johannes Weiner <jweiner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Hmm, it's true now. But for making clear our assumption to all readers of code,

could you add
VM_BUG_ON(!mm || page_mapped(page) || (page->mapping && !PageAnon(page)) ?

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>

> ---
>  mm/memcontrol.c |   13 +------------
>  1 files changed, 1 insertions(+), 12 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index d4d139a..0d10be4 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2679,19 +2679,8 @@ int mem_cgroup_newpage_charge(struct page *page,
>  {
>  	if (mem_cgroup_disabled())
>  		return 0;
> -	/*
> -	 * If already mapped, we don't have to account.
> -	 * If page cache, page->mapping has address_space.
> -	 * But page->mapping may have out-of-use anon_vma pointer,
> -	 * detecit it by PageAnon() check. newly-mapped-anon's page->mapping
> -	 * is NULL.
> -  	 */
> -	if (page_mapped(page) || (page->mapping && !PageAnon(page)))
> -		return 0;
> -	if (unlikely(!mm))
> -		mm = &init_mm;
>  	return mem_cgroup_charge_common(page, mm, gfp_mask,
> -				MEM_CGROUP_CHARGE_TYPE_MAPPED);
> +					MEM_CGROUP_CHARGE_TYPE_MAPPED);
>  }
>  
>  static void
> -- 
> 1.7.6.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

--
To unsubscribe from this list: send the line "unsubscribe cgroups" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
