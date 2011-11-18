From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH] fix mem_cgroup_split_huge_fixup to work efficiently.
Date: Fri, 18 Nov 2011 17:35:21 +0100
Message-ID: <20111118163521.GD23223@tiehlicka.suse.cz>
References: <20111117103308.063f78df.kamezawa.hiroyu@jp.fujitsu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20111117103308.063f78df.kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org" <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Thu 17-11-11 10:33:08, KAMEZAWA Hiroyuki wrote:
> 
> I'll send this again when mm is shipped.
> I sometimes see mem_cgroup_split_huge_fixup() in perf report and noticed
> it's very slow. This fixes it. Any comments are welcome.
> 
> ==
> Subject: [PATCH] fix mem_cgroup_split_huge_fixup to work efficiently.
> 
> at split_huge_page(), mem_cgroup_split_huge_fixup() is called to
> handle page_cgroup modifcations. It takes move_lock_page_cgroup()
> and modify page_cgroup and LRU accounting jobs and called
> HPAGE_PMD_SIZE - 1 times.
> 
> But thinking again,
>   - compound_lock() is held at move_accout...then, it's not necessary
>     to take move_lock_page_cgroup().
>   - LRU is locked and all tail pages will go into the same LRU as
>     head is now on.
>   - page_cgroup is contiguous in huge page range.
> 
> This patch fixes mem_cgroup_split_huge_fixup() as to be called once per
> hugepage and reduce costs for spliting.
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>

Yes, looks good. Andrew already took the patch, but just in case
Reviewed-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

Just one really minor comment bellow
[...]
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 6aff93c..99101f1 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2523,38 +2523,38 @@ static void __mem_cgroup_commit_charge(struct mem_cgroup *memcg,
>  /*
>   * Because tail pages are not marked as "used", set it. We're under
>   * zone->lru_lock, 'splitting on pmd' and compund_lock.

typo that could be fixed to make grep happier

> + * charge/uncharge will be never happen and move_account() is done under
> + * compound_lock(), so we don't have to take care of races.
>   */
> -void mem_cgroup_split_huge_fixup(struct page *head, struct page *tail)
> +void mem_cgroup_split_huge_fixup(struct page *head)

Thanks!
-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
--
To unsubscribe from this list: send the line "unsubscribe cgroups" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
