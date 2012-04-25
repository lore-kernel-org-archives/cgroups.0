From: Konstantin Khlebnikov <khlebnikov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: Re: [patch 2/2] mm: memcg: count pte references from every member
 of the reclaimed hierarchy
Date: Wed, 25 Apr 2012 07:52:23 +0400
Message-ID: <4F9774F7.3050702@openvz.org>
References: <1335296144-29381-1-git-send-email-hannes@cmpxchg.org> <1335296144-29381-2-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        bh=MVZf8WaBxevMd3D/3XUqlhKPsKTjVbgSlzgnmzPbFsA=;
        b=wOtJZJAHhFAow7SLxAlgj2wd0ytSpGKDV08u/Vr9CT/kqElAxJgoR+rXGGOXoJi1O5
         953XRsbMvkNWA+0myTLt5MNQAl+YXHOfkvYXqMZdlY1Ywk2vzQQyrle7mq9TubEK9/yj
         10rOQvtClAGo7pTjsEbRQUdzP9C8cQOyhZD4TELXWZmImRC1zTAfRL54edWdPbndn0dd
         t7lZirGy7sqj3MUheMhRpWoforqEkhsh5XhfUJEG3D7I72RHve0qvPE8kkYv4HA1DEDb
         RMvIwfeWmj/J+NpfslVBWIfQPy90N9BhPbnTaIDAYE043PYRN6JVqSicgLYlK6TphL4I
         oXPg==
In-Reply-To: <1335296144-29381-2-git-send-email-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Johannes Weiner wrote:
> The rmap walker checking page table references has historically
> ignored references from VMAs that were not part of the memcg that was
> being reclaimed during memcg hard limit reclaim.
>
> When transitioning global reclaim to memcg hierarchy reclaim, I missed
> that bit and now references from outside a memcg are ignored even
> during global reclaim.
>
> Reverting back to traditional behaviour - count all references during
> global reclaim and only mind references of the memcg being reclaimed
> during limit reclaim would be one option.
>
> However, the more generic idea is to ignore references exactly then
> when they are outside the hierarchy that is currently under reclaim;
> because only then will their reclamation be of any use to help the
> pressure situation.  It makes no sense to ignore references from a
> sibling memcg and then evict a page that will be immediately refaulted
> by that sibling which contributes to the same usage of the common
> ancestor under reclaim.
>
> The solution: make the rmap walker ignore references from VMAs that
> are not part of the hierarchy that is being reclaimed.
>
> Flat limit reclaim will stay the same, hierarchical limit reclaim will
> mind the references only to pages that the hierarchy owns.  Global
> reclaim, since it reclaims from all memcgs, will be fixed to regard
> all references.
>
> Reported-by: Konstantin Khlebnikov<khlebnikov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
> Signed-off-by: Johannes Weiner<hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Acked-by: KAMEZAWA Hiroyuki<kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> Acked-by: Michal Hocko<mhocko-AlSwsSmVLrQ@public.gmane.org>

Hooray, I already had planned to resend this together with my patchset =)

Acked-by: Konstantin Khlebnikov<khlebnikov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>

> ---
>   include/linux/memcontrol.h |    6 +++++-
>   mm/memcontrol.c            |   16 +++++++++++-----
>   mm/vmscan.c                |    6 ++++--
>   3 files changed, 20 insertions(+), 8 deletions(-)
>
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 58d820c..76f9d9b 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -78,6 +78,7 @@ extern void mem_cgroup_uncharge_cache_page(struct page *page);
>
>   extern void mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
>   				     int order);
> +bool __mem_cgroup_same_or_subtree(const struct mem_cgroup *, struct mem_cgroup *);
>   int task_in_mem_cgroup(struct task_struct *task, const struct mem_cgroup *memcg);
>
>   extern struct mem_cgroup *try_get_mem_cgroup_from_page(struct page *page);
> @@ -91,10 +92,13 @@ static inline
>   int mm_match_cgroup(const struct mm_struct *mm, const struct mem_cgroup *cgroup)
>   {
>   	struct mem_cgroup *memcg;
> +	int match;
> +
>   	rcu_read_lock();
>   	memcg = mem_cgroup_from_task(rcu_dereference((mm)->owner));
> +	match = memcg&&  __mem_cgroup_same_or_subtree(cgroup, memcg);
>   	rcu_read_unlock();
> -	return cgroup == memcg;
> +	return match;
>   }
>
>   extern struct cgroup_subsys_state *mem_cgroup_css(struct mem_cgroup *memcg);
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index a1fea51..b365ae3 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1143,17 +1143,23 @@ struct lruvec *mem_cgroup_lru_move_lists(struct zone *zone,
>    * Checks whether given mem is same or in the root_mem_cgroup's
>    * hierarchy subtree
>    */
> -static bool mem_cgroup_same_or_subtree(const struct mem_cgroup *root_memcg,
> -		struct mem_cgroup *memcg)
> +bool __mem_cgroup_same_or_subtree(const struct mem_cgroup *root_memcg,
> +				  struct mem_cgroup *memcg)
>   {
> -	bool ret;
> -
>   	if (root_memcg == memcg)
>   		return true;
>   	if (!root_memcg->use_hierarchy)
>   		return false;
> +	return css_is_ancestor(&memcg->css,&root_memcg->css);
> +}
> +
> +static bool mem_cgroup_same_or_subtree(const struct mem_cgroup *root_memcg,
> +				       struct mem_cgroup *memcg)
> +{
> +	bool ret;
> +
>   	rcu_read_lock();
> -	ret = css_is_ancestor(&memcg->css,&root_memcg->css);
> +	ret = __mem_cgroup_same_or_subtree(root_memcg, memcg);
>   	rcu_read_unlock();
>   	return ret;
>   }
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index d6122e7..7bc7b8b 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -632,7 +632,8 @@ static enum page_references page_check_references(struct page *page,
>   	int referenced_ptes, referenced_page;
>   	unsigned long vm_flags;
>
> -	referenced_ptes = page_referenced(page, 1, mz->mem_cgroup,&vm_flags);
> +	referenced_ptes = page_referenced(page, 1, sc->target_mem_cgroup,
> +					&vm_flags);

Argument "mz" in page_check_references() now unused.
Ok, I'll remove it in my patchset together with "struct mem_cgroup_zone"

>   	referenced_page = TestClearPageReferenced(page);
>
>   	/*
> @@ -1474,7 +1475,8 @@ static void shrink_active_list(unsigned long nr_to_scan,
>   			}
>   		}
>
> -		if (page_referenced(page, 0, mz->mem_cgroup,&vm_flags)) {
> +		if (page_referenced(page, 0, sc->target_mem_cgroup,
> +				&vm_flags)) {
>   			nr_rotated += hpage_nr_pages(page);
>   			/*
>   			 * Identify referenced, file-backed active pages and
