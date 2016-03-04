From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] mm: memcontrol: drop unnecessary lru locking from
 mem_cgroup_migrate()
Date: Fri, 4 Mar 2016 19:04:11 +0100
Message-ID: <20160304180411.GE24204@dhcp22.suse.cz>
References: <1454616467-8994-1-git-send-email-hannes@cmpxchg.org>
 <1454616467-8994-2-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1454616467-8994-2-git-send-email-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Mateusz Guzik <mguzik-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sergey Senozhatsky <sergey.senozhatsky.work-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Thu 04-02-16 15:07:47, Johannes Weiner wrote:
> Migration accounting in the memory controller used to have to handle
> both oldpage and newpage being on the LRU already; fuse's page cache
> replacement used to pass a recycled newpage that had been uncharged
> but not freed and removed from the LRU, and the memcg migration code
> used to uncharge oldpage to "pass on" the existing charge to newpage.
> 
> Nowadays, pages are no longer uncharged when truncated from the page
> cache, but rather only at free time, so if a LRU page is recycled in
> page cache replacement it'll also still be charged. And we bail out of
> the charge transfer altogether in that case. Tell commit_charge() that
> we know newpage is not on the LRU, to avoid taking the zone->lru_lock
> unnecessarily from the migration path.
> 
> But also, oldpage is no longer uncharged inside migration. We only use
> oldpage for its page->mem_cgroup and page size, so we don't care about
> its LRU state anymore either. Remove any mention from the kernel doc.
> 
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Suggested-by: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

> ---
>  mm/memcontrol.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 3e4199830456..42882c1e7fce 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5489,7 +5489,6 @@ void mem_cgroup_uncharge_list(struct list_head *page_list)
>   * be uncharged upon free.
>   *
>   * Both pages must be locked, @newpage->mapping must be set up.
> - * Either or both pages might be on the LRU already.
>   */
>  void mem_cgroup_migrate(struct page *oldpage, struct page *newpage)
>  {
> @@ -5524,7 +5523,7 @@ void mem_cgroup_migrate(struct page *oldpage, struct page *newpage)
>  		page_counter_charge(&memcg->memsw, nr_pages);
>  	css_get_many(&memcg->css, nr_pages);
>  
> -	commit_charge(newpage, memcg, true);
> +	commit_charge(newpage, memcg, false);
>  
>  	local_irq_disable();
>  	mem_cgroup_charge_statistics(memcg, newpage, compound, nr_pages);
> -- 
> 2.7.0

-- 
Michal Hocko
SUSE Labs
