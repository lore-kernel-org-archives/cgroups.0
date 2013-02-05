From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH for 3.2.34] memcg: do not trigger OOM from
 add_to_page_cache_locked
Date: Tue, 5 Feb 2013 14:49:42 +0100
Message-ID: <20130205134937.GA22804@dhcp22.suse.cz>
References: <20121217192301.829A7020@pobox.sk>
 <20121217195510.GA16375@dhcp22.suse.cz>
 <20121218152223.6912832C@pobox.sk>
 <20121218152004.GA25208@dhcp22.suse.cz>
 <20121224142526.020165D3@pobox.sk>
 <20121228162209.GA1455@dhcp22.suse.cz>
 <20121230020947.AA002F34@pobox.sk>
 <20121230110815.GA12940@dhcp22.suse.cz>
 <20130125160723.FAE73567@pobox.sk>
 <20130125163130.GF4721@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130125163130.GF4721-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: azurIt <azurit-Rm0zKEqwvD4@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups mailinglist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

On Fri 25-01-13 17:31:30, Michal Hocko wrote:
> On Fri 25-01-13 16:07:23, azurIt wrote:
> > Any news? Thnx!
> 
> Sorry, but I didn't get to this one yet.

Sorry, to get back to this that late but I was busy as hell since the
beginning of the year.

Has the issue repeated since then?

You said you didn't apply other than the above mentioned patch. Could
you apply also debugging part of the patches I have sent?
In case you don't have it handy then it should be this one:
---
From 1623420d964e7e8bc88e2a6239563052df891bf7 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Date: Mon, 3 Dec 2012 16:16:01 +0100
Subject: [PATCH] more debugging

---
 mm/huge_memory.c |    6 +++---
 mm/memcontrol.c  |    1 +
 2 files changed, 4 insertions(+), 3 deletions(-)

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
index c8425b1..1986c65 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2397,6 +2397,7 @@ done:
 	return 0;
 nomem:
 	*ptr = NULL;
+	__WARN_printf("gfp_mask:%u nr_pages:%u oom:%d ret:%d\n", gfp_mask, nr_pages, oom, ret);
 	return -ENOMEM;
 bypass:
 	*ptr = NULL;
-- 
1.7.10.4

-- 
Michal Hocko
SUSE Labs
