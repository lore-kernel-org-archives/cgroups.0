From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [patch 03/12] mm: huge_memory: use GFP_TRANSHUGE when charging
 huge pages
Date: Tue, 17 Jun 2014 11:38:14 -0400
Message-ID: <20140617153814.GB7331@cmpxchg.org>
References: <1402948472-8175-1-git-send-email-hannes@cmpxchg.org>
 <1402948472-8175-4-git-send-email-hannes@cmpxchg.org>
 <20140617142317.GD19886@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org; s=zene;
	h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date; bh=zGSTVhqPAmtrv7XFc+VL2qCDb+NopoZAZLny64BwMbY=;
	b=Iz1I8NFqOUg/wR2gcPlFDn+f+5xH2a3DcVp2nuY83PXF5z+7T2oWMMxeiycjdwSroCgdJFJjz1xKkzoQNWWvRclpPvxqSY4+fFnIvyyhIjOwJLTtmyJo2dZZKDg/IZZvrqNJgofjJNse9CWReMB+xh+/pTqm/iKZM79hpS6zL+w=;
Content-Disposition: inline
In-Reply-To: <20140617142317.GD19886-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Jun 17, 2014 at 04:23:17PM +0200, Michal Hocko wrote:
> On Mon 16-06-14 15:54:23, Johannes Weiner wrote:
> > Transparent huge page charges prefer falling back to regular pages
> > rather than spending a lot of time in direct reclaim.
> > 
> > Desired reclaim behavior is usually declared in the gfp mask, but THP
> > charges use GFP_KERNEL and then rely on the fact that OOM is disabled
> > for THP charges, and that OOM-disabled charges currently skip reclaim.
> > Needless to say, this is anything but obvious and quite error prone.
> > 
> > Convert THP charges to use GFP_TRANSHUGE instead, which implies
> > __GFP_NORETRY, to indicate the low-latency requirement.
> 
> Maybe we can get one step further and even get rid of oom parameter.
> It is only THP (handled by this patch) and mem_cgroup_do_precharge that
> want OOM disabled explicitly.

Great idea!

> GFP_KERNEL & (~__GFP_NORETRY) is ugly and something like GFP_NO_OOM
> would be better but this is just a quick scratch.

I think it's fine, actually.

> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 52550bbff1ef..5d247822b03a 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2555,15 +2555,13 @@ static int memcg_cpu_hotplug_callback(struct notifier_block *nb,
>   * mem_cgroup_try_charge - try charging a memcg
>   * @memcg: memcg to charge
>   * @nr_pages: number of pages to charge
> - * @oom: trigger OOM if reclaim fails
>   *
>   * Returns 0 if @memcg was charged successfully, -EINTR if the charge
>   * was bypassed to root_mem_cgroup, and -ENOMEM if the charge failed.
>   */
>  static int mem_cgroup_try_charge(struct mem_cgroup *memcg,
>  				 gfp_t gfp_mask,
> -				 unsigned int nr_pages,
> -				 bool oom)
> +				 unsigned int nr_pages)
>  {
>  	unsigned int batch = max(CHARGE_BATCH, nr_pages);
>  	int nr_retries = MEM_CGROUP_RECLAIM_RETRIES;
> @@ -2647,7 +2645,7 @@ retry:
>  	if (fatal_signal_pending(current))
>  		goto bypass;
>  
> -	if (!oom)
> +	if (!oom_gfp_allowed(gfp_mask))
>  		goto nomem;

We don't actually need that check: if __GFP_NORETRY is set, we goto
nomem directly after reclaim fails and don't even reach here.

So here is the patch I have now - can I get your sign-off on this?

---
From eda800d2aa2376d347d6d4f7660e3450bd4c5dbb Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Date: Tue, 17 Jun 2014 11:10:59 -0400
Subject: [patch] mm: memcontrol: remove explicit OOM parameter in charge path

For the page allocator, __GFP_NORETRY implies that no OOM should be
triggered, whereas memcg has an explicit parameter to disable OOM.

The only callsites that want OOM disabled are THP charges and charge
moving.  THP already uses __GFP_NORETRY and charge moving can use it
as well - one full reclaim cycle should be plenty.  Switch it over,
then remove the OOM parameter.

Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
---
 mm/memcontrol.c | 32 ++++++++++----------------------
 1 file changed, 10 insertions(+), 22 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 9c646b9b56f4..c765125694e2 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2555,15 +2555,13 @@ static int memcg_cpu_hotplug_callback(struct notifier_block *nb,
  * mem_cgroup_try_charge - try charging a memcg
  * @memcg: memcg to charge
  * @nr_pages: number of pages to charge
- * @oom: trigger OOM if reclaim fails
  *
  * Returns 0 if @memcg was charged successfully, -EINTR if the charge
  * was bypassed to root_mem_cgroup, and -ENOMEM if the charge failed.
  */
 static int mem_cgroup_try_charge(struct mem_cgroup *memcg,
 				 gfp_t gfp_mask,
-				 unsigned int nr_pages,
-				 bool oom)
+				 unsigned int nr_pages)
 {
 	unsigned int batch = max(CHARGE_BATCH, nr_pages);
 	int nr_retries = MEM_CGROUP_RECLAIM_RETRIES;
@@ -2647,9 +2645,6 @@ retry:
 	if (fatal_signal_pending(current))
 		goto bypass;
 
-	if (!oom)
-		goto nomem;
-
 	mem_cgroup_oom(mem_over_limit, gfp_mask, get_order(batch));
 nomem:
 	if (!(gfp_mask & __GFP_NOFAIL))
@@ -2675,15 +2670,14 @@ done:
  */
 static struct mem_cgroup *mem_cgroup_try_charge_mm(struct mm_struct *mm,
 				 gfp_t gfp_mask,
-				 unsigned int nr_pages,
-				 bool oom)
+				 unsigned int nr_pages)
 
 {
 	struct mem_cgroup *memcg;
 	int ret;
 
 	memcg = get_mem_cgroup_from_mm(mm);
-	ret = mem_cgroup_try_charge(memcg, gfp_mask, nr_pages, oom);
+	ret = mem_cgroup_try_charge(memcg, gfp_mask, nr_pages);
 	css_put(&memcg->css);
 	if (ret == -EINTR)
 		memcg = root_mem_cgroup;
@@ -2900,8 +2894,7 @@ static int memcg_charge_kmem(struct mem_cgroup *memcg, gfp_t gfp, u64 size)
 	if (ret)
 		return ret;
 
-	ret = mem_cgroup_try_charge(memcg, gfp, size >> PAGE_SHIFT,
-				    oom_gfp_allowed(gfp));
+	ret = mem_cgroup_try_charge(memcg, gfp, size >> PAGE_SHIFT);
 	if (ret == -EINTR)  {
 		/*
 		 * mem_cgroup_try_charge() chosed to bypass to root due to
@@ -3650,7 +3643,6 @@ int mem_cgroup_charge_anon(struct page *page,
 {
 	unsigned int nr_pages = 1;
 	struct mem_cgroup *memcg;
-	bool oom = true;
 
 	if (mem_cgroup_disabled())
 		return 0;
@@ -3662,14 +3654,9 @@ int mem_cgroup_charge_anon(struct page *page,
 	if (PageTransHuge(page)) {
 		nr_pages <<= compound_order(page);
 		VM_BUG_ON_PAGE(!PageTransHuge(page), page);
-		/*
-		 * Never OOM-kill a process for a huge page.  The
-		 * fault handler will fall back to regular pages.
-		 */
-		oom = false;
 	}
 
-	memcg = mem_cgroup_try_charge_mm(mm, gfp_mask, nr_pages, oom);
+	memcg = mem_cgroup_try_charge_mm(mm, gfp_mask, nr_pages);
 	if (!memcg)
 		return -ENOMEM;
 	__mem_cgroup_commit_charge(memcg, page, nr_pages,
@@ -3706,7 +3693,7 @@ static int __mem_cgroup_try_charge_swapin(struct mm_struct *mm,
 		memcg = try_get_mem_cgroup_from_page(page);
 	if (!memcg)
 		memcg = get_mem_cgroup_from_mm(mm);
-	ret = mem_cgroup_try_charge(memcg, mask, 1, true);
+	ret = mem_cgroup_try_charge(memcg, mask, 1);
 	css_put(&memcg->css);
 	if (ret == -EINTR)
 		memcg = root_mem_cgroup;
@@ -3733,7 +3720,7 @@ int mem_cgroup_try_charge_swapin(struct mm_struct *mm, struct page *page,
 	if (!PageSwapCache(page)) {
 		struct mem_cgroup *memcg;
 
-		memcg = mem_cgroup_try_charge_mm(mm, gfp_mask, 1, true);
+		memcg = mem_cgroup_try_charge_mm(mm, gfp_mask, 1);
 		if (!memcg)
 			return -ENOMEM;
 		*memcgp = memcg;
@@ -3802,7 +3789,7 @@ int mem_cgroup_charge_file(struct page *page, struct mm_struct *mm,
 		return 0;
 	}
 
-	memcg = mem_cgroup_try_charge_mm(mm, gfp_mask, 1, true);
+	memcg = mem_cgroup_try_charge_mm(mm, gfp_mask, 1);
 	if (!memcg)
 		return -ENOMEM;
 	__mem_cgroup_commit_charge(memcg, page, 1, type, false);
@@ -6414,7 +6401,8 @@ one_by_one:
 			batch_count = PRECHARGE_COUNT_AT_ONCE;
 			cond_resched();
 		}
-		ret = mem_cgroup_try_charge(memcg, GFP_KERNEL, 1, false);
+		ret = mem_cgroup_try_charge(memcg,
+					    GFP_KERNEL & ~__GFP_NORETRY, 1);
 		if (ret)
 			/* mem_cgroup_clear_mc() will do uncharge later */
 			return ret;
-- 
2.0.0
