From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [patch 01/11] mm: memcg: fix compaction/migration failing due to
 memcg limits
Date: Mon, 9 Jul 2012 16:15:54 +0200
Message-ID: <20120709141554.GD4627@tiehlicka.suse.cz>
References: <1341449103-1986-1-git-send-email-hannes@cmpxchg.org>
 <1341449103-1986-2-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1341449103-1986-2-git-send-email-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

[CCing Ingo for the memcg-devel vs tip/sched/numa inter tree dependency
 - see bellow]

On Thu 05-07-12 02:44:53, Johannes Weiner wrote:
> Compaction (and page migration in general) can currently be hindered
> through pages being owned by memory cgroups that are at their limits
> and unreclaimable.
> 
> The reason is that the replacement page is being charged against the
> limit while the page being replaced is also still charged.  But this
> seems unnecessary, given that only one of the two pages will still be
> in use after migration finishes.
> 
> This patch changes the memcg migration sequence so that the
> replacement page is not charged.  Whatever page is still in use after
> successful or failed migration gets to keep the charge of the page
> that was going to be replaced.

Could you mention the side effect on the stat vs charges discrepancy,
please?

> Reported-by: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Acked-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

[...]
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 8137aea..aa06bf4 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
[...]
> @@ -1519,10 +1512,9 @@ migrate_misplaced_page(struct page *page, struct mm_struct *mm, int node)
>  {
>  	struct page *oldpage = page, *newpage;
>  	struct address_space *mapping = page_mapping(page);
> -	struct mem_cgroup *mcg;
> +	struct mem_cgroup *memcg;
>  	unsigned int gfp;
>  	int rc = 0;
> -	int charge = -ENOMEM;
>  
>  	VM_BUG_ON(!PageLocked(page));
>  	VM_BUG_ON(page_mapcount(page));
> @@ -1556,12 +1548,7 @@ migrate_misplaced_page(struct page *page, struct mm_struct *mm, int node)
>  	if (!trylock_page(newpage))
>  		BUG();		/* new page should be unlocked!!! */
>  
> -	// XXX hnaz, is this right?
> -	charge = mem_cgroup_prepare_migration(page, newpage, &mcg, gfp);
> -	if (charge == -ENOMEM) {
> -		rc = charge;
> -		goto out;
> -	}
> +	mem_cgroup_prepare_migration(page, newpage, &memcg);
>  
>  	newpage->index = page->index;
>  	newpage->mapping = page->mapping;
> @@ -1581,11 +1568,9 @@ migrate_misplaced_page(struct page *page, struct mm_struct *mm, int node)
>  		page = newpage;
>  	}
>  
> +	mem_cgroup_end_migration(memcg, oldpage, newpage, !rc);
>  out:
> -	if (!charge)
> -		mem_cgroup_end_migration(mcg, oldpage, newpage, !rc);
> -
> -       if (oldpage != page)
> +	if (oldpage != page)
>                 put_page(oldpage);
>  
>  	if (rc) {

Hmm, this depends on 4783af47 (mm: Migrate misplaced page) from
tip/sched/numa which adds an inter tree dependency which is quite
unfortunate from memcg-devel (aka mmotm git tree) tree POV. 
I can cherry-pick this patch into memcg-devel but I am not sure what
is the merging status of the patch (XXX sounds like it is going to be
updated later). Ingo?

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
