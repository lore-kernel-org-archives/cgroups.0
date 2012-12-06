From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH for 3.2.34] memcg: do not trigger OOM from
 add_to_page_cache_locked
Date: Thu, 6 Dec 2012 10:54:23 +0100
Message-ID: <20121206095423.GB10931@dhcp22.suse.cz>
References: <20121130144427.51A09169@pobox.sk>
 <20121130144431.GI29317@dhcp22.suse.cz>
 <20121130160811.6BB25BDD@pobox.sk>
 <20121130153942.GL29317@dhcp22.suse.cz>
 <20121130165937.F9564EBE@pobox.sk>
 <20121130161923.GN29317@dhcp22.suse.cz>
 <20121203151601.GA17093@dhcp22.suse.cz>
 <20121205023644.18C3006B@pobox.sk>
 <20121205141722.GA9714@dhcp22.suse.cz>
 <20121206012924.FE077FD7@pobox.sk>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20121206012924.FE077FD7-Rm0zKEqwvD4@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: azurIt <azurit-Rm0zKEqwvD4@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups mailinglist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

On Thu 06-12-12 01:29:24, azurIt wrote:
> >OK, so the ENOMEM seems to be leaking from mem_cgroup_newpage_charge.
> >This can only happen if this was an atomic allocation request
> >(!__GFP_WAIT) or if oom is not allowed which is the case only for
> >transparent huge page allocation.
> >The first case can be excluded (in the clean 3.2 stable kernel) because
> >all callers of mem_cgroup_newpage_charge use GFP_KERNEL. The later one
> >should be OK because the page fault should fallback to a regular page if
> >THP allocation/charge fails.
> >[/me goes to double check]
> >Hmm do_huge_pmd_wp_page seems to charge a huge page and fails with
> >VM_FAULT_OOM without any fallback. We should do_huge_pmd_wp_page_fallback
> >instead. This has been fixed in 3.5-rc1 by 1f1d06c3 (thp, memcg: split
> >hugepage for memcg oom on cow) but it hasn't been backported to 3.2. The
> >patch applies to 3.2 without any further modifications. I didn't have
> >time to test it but if it helps you we should push this to the stable
> >tree.
> 
> 
> This, unfortunately, didn't fix the problem :(
> http://www.watchdog.sk/lkml/oom_mysqld3

Dohh. The very same stack mem_cgroup_newpage_charge called from the page
fault. The heavy inlining is not particularly helping here... So there
must be some other THP charge leaking out.
[/me is diving into the code again]

* do_huge_pmd_anonymous_page falls back to handle_pte_fault
* do_huge_pmd_wp_page_fallback falls back to simple pages so it doesn't
  charge the huge page
* do_huge_pmd_wp_page splits the huge page and retries with fallback to
  handle_pte_fault
* collapse_huge_page is not called in the page fault path
* do_wp_page, do_anonymous_page and __do_fault  operate on a single page
  so the memcg charging cannot return ENOMEM

There are no other callers AFAICS so I am getting clueless. Maybe more
debugging will tell us something (the inlining has been reduced for thp
paths which can reduce performance in thp page fault heavy workloads but
this will give us better traces - I hope).

Anyway do you see the same problem if transparent huge pages are
disabled?
echo never > /sys/kernel/mm/transparent_hugepage/enabled)
---
From 93a30140b50d8474a047b91c698f4880149635db Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Date: Thu, 6 Dec 2012 10:40:17 +0100
Subject: [PATCH] more debugging

---
 mm/huge_memory.c |    6 +++---
 mm/memcontrol.c  |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 470cbb4..01a11f1 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -671,7 +671,7 @@ static inline struct page *alloc_hugepage(int defrag)
 }
 #endif
 
-int do_huge_pmd_anonymous_page(struct mm_struct *mm, struct vm_area_struct *vma,
+noinline int do_huge_pmd_anonymous_page(struct mm_struct *mm, struct vm_area_struct *vma,
 			       unsigned long address, pmd_t *pmd,
 			       unsigned int flags)
 {
@@ -790,7 +790,7 @@ pgtable_t get_pmd_huge_pte(struct mm_struct *mm)
 	return pgtable;
 }
 
-static int do_huge_pmd_wp_page_fallback(struct mm_struct *mm,
+static noinline int do_huge_pmd_wp_page_fallback(struct mm_struct *mm,
 					struct vm_area_struct *vma,
 					unsigned long address,
 					pmd_t *pmd, pmd_t orig_pmd,
@@ -883,7 +883,7 @@ out_free_pages:
 	goto out;
 }
 
-int do_huge_pmd_wp_page(struct mm_struct *mm, struct vm_area_struct *vma,
+noinline int do_huge_pmd_wp_page(struct mm_struct *mm, struct vm_area_struct *vma,
 			unsigned long address, pmd_t *pmd, pmd_t orig_pmd)
 {
 	int ret = 0;
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 9e5b56b..1986c65 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2397,7 +2397,7 @@ done:
 	return 0;
 nomem:
 	*ptr = NULL;
-	__WARN();
+	__WARN_printf("gfp_mask:%u nr_pages:%u oom:%d ret:%d\n", gfp_mask, nr_pages, oom, ret);
 	return -ENOMEM;
 bypass:
 	*ptr = NULL;
-- 
1.7.10.4

-- 
Michal Hocko
SUSE Labs
