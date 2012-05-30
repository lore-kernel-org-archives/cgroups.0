From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V7 01/14] hugetlb: rename max_hstate to hugetlb_max_hstate
Date: Wed, 30 May 2012 20:08:46 +0530
Message-ID: <1338388739-22919-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1338388739-22919-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1338388739-22919-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm@kvack.org, kamezawa.hiroyu@jp.fujitsu.com, dhillf@gmail.com, rientjes@google.com, mhocko@suse.cz, akpm@linux-foundation.org, hannes@cmpxchg.org
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, Andrea Arcangeli <aarcange@redhat.com>

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

Rename max_hstate to hugetlb_max_hstate.  We will be using this from other
subsystems like hugetlb controller in later patches.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Hillf Danton <dhillf@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/hugetlb.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 285a81e..e07d4cd 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -34,7 +34,7 @@ const unsigned long hugetlb_zero = 0, hugetlb_infinity = ~0UL;
 static gfp_t htlb_alloc_mask = GFP_HIGHUSER;
 unsigned long hugepages_treat_as_movable;
 
-static int max_hstate;
+static int hugetlb_max_hstate;
 unsigned int default_hstate_idx;
 struct hstate hstates[HUGE_MAX_HSTATE];
 
@@ -46,7 +46,7 @@ static unsigned long __initdata default_hstate_max_huge_pages;
 static unsigned long __initdata default_hstate_size;
 
 #define for_each_hstate(h) \
-	for ((h) = hstates; (h) < &hstates[max_hstate]; (h)++)
+	for ((h) = hstates; (h) < &hstates[hugetlb_max_hstate]; (h)++)
 
 /*
  * Protects updates to hugepage_freelists, nr_huge_pages, and free_huge_pages
@@ -1897,9 +1897,9 @@ void __init hugetlb_add_hstate(unsigned order)
 		printk(KERN_WARNING "hugepagesz= specified twice, ignoring\n");
 		return;
 	}
-	BUG_ON(max_hstate >= HUGE_MAX_HSTATE);
+	BUG_ON(hugetlb_max_hstate >= HUGE_MAX_HSTATE);
 	BUG_ON(order == 0);
-	h = &hstates[max_hstate++];
+	h = &hstates[hugetlb_max_hstate++];
 	h->order = order;
 	h->mask = ~((1ULL << (order + PAGE_SHIFT)) - 1);
 	h->nr_huge_pages = 0;
@@ -1920,10 +1920,10 @@ static int __init hugetlb_nrpages_setup(char *s)
 	static unsigned long *last_mhp;
 
 	/*
-	 * !max_hstate means we haven't parsed a hugepagesz= parameter yet,
+	 * !hugetlb_max_hstate means we haven't parsed a hugepagesz= parameter yet,
 	 * so this hugepages= parameter goes to the "default hstate".
 	 */
-	if (!max_hstate)
+	if (!hugetlb_max_hstate)
 		mhp = &default_hstate_max_huge_pages;
 	else
 		mhp = &parsed_hstate->max_huge_pages;
@@ -1942,7 +1942,7 @@ static int __init hugetlb_nrpages_setup(char *s)
 	 * But we need to allocate >= MAX_ORDER hstates here early to still
 	 * use the bootmem allocator.
 	 */
-	if (max_hstate && parsed_hstate->order >= MAX_ORDER)
+	if (hugetlb_max_hstate && parsed_hstate->order >= MAX_ORDER)
 		hugetlb_hstate_alloc_pages(parsed_hstate);
 
 	last_mhp = mhp;
-- 
1.7.10

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
