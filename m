From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: [PATCH 4/7] memcg: remove 'uncharge' argument from mem_cgroup_move_account()
Date: Thu, 12 Apr 2012 20:24:14 +0900
Message-ID: <4F86BB5E.6080509@jp.fujitsu.com>
References: <4F86B9BE.8000105@jp.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F86B9BE.8000105-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

Only one call passes 'true'. remove it and handle it in caller.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
---
 mm/memcontrol.c |   29 ++++++++++++-----------------
 1 files changed, 12 insertions(+), 17 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 8246418..9ac7984 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2576,23 +2576,19 @@ void mem_cgroup_split_huge_fixup(struct page *head)
  * @pc:	page_cgroup of the page.
  * @from: mem_cgroup which the page is moved from.
  * @to:	mem_cgroup which the page is moved to. @from != @to.
- * @uncharge: whether we should call uncharge and css_put against @from.
  *
  * The caller must confirm following.
  * - page is not on LRU (isolate_page() is useful.)
  * - compound_lock is held when nr_pages > 1
  *
- * This function doesn't do "charge" nor css_get to new cgroup. It should be
- * done by a caller(__mem_cgroup_try_charge would be useful). If @uncharge is
- * true, this function does "uncharge" from old cgroup, but it doesn't if
- * @uncharge is false, so a caller should do "uncharge".
+ * This function doesn't access res_counter at all. Caller should take
+ * care of it.
  */
 static int mem_cgroup_move_account(struct page *page,
 				   unsigned int nr_pages,
 				   struct page_cgroup *pc,
 				   struct mem_cgroup *from,
-				   struct mem_cgroup *to,
-				   bool uncharge)
+				   struct mem_cgroup *to)
 {
 	unsigned long flags;
 	int ret;
@@ -2626,9 +2622,6 @@ static int mem_cgroup_move_account(struct page *page,
 		preempt_enable();
 	}
 	mem_cgroup_charge_statistics(from, anon, -nr_pages);
-	if (uncharge)
-		/* This is not "cancel", but cancel_charge does all we need. */
-		__mem_cgroup_cancel_charge(from, nr_pages);
 
 	/* caller should have done css_get */
 	pc->mem_cgroup = to;
@@ -2688,10 +2681,13 @@ static int mem_cgroup_move_parent(struct page *page,
 	if (nr_pages > 1)
 		flags = compound_lock_irqsave(page);
 
-	ret = mem_cgroup_move_account(page, nr_pages, pc, child, parent,
-					need_cancel);
-	if (!need_cancel && !ret)
-		__mem_cgroup_move_charge_parent(child, nr_pages);
+	ret = mem_cgroup_move_account(page, nr_pages, pc, child, parent);
+	if (!ret) {
+		if (need_cancel)
+			__mem_cgroup_cancel_charge(child, nr_pages);
+		else
+			__mem_cgroup_move_charge_parent(child, nr_pages);
+	}
 
 	if (nr_pages > 1)
 		compound_unlock_irqrestore(page, flags);
@@ -5451,8 +5447,7 @@ static int mem_cgroup_move_charge_pte_range(pmd_t *pmd,
 			if (!isolate_lru_page(page)) {
 				pc = lookup_page_cgroup(page);
 				if (!mem_cgroup_move_account(page, HPAGE_PMD_NR,
-							     pc, mc.from, mc.to,
-							     false)) {
+							pc, mc.from, mc.to)) {
 					mc.precharge -= HPAGE_PMD_NR;
 					mc.moved_charge += HPAGE_PMD_NR;
 				}
@@ -5482,7 +5477,7 @@ retry:
 				goto put;
 			pc = lookup_page_cgroup(page);
 			if (!mem_cgroup_move_account(page, 1, pc,
-						     mc.from, mc.to, false)) {
+						     mc.from, mc.to)) {
 				mc.precharge--;
 				/* we uncharge from mc.from later. */
 				mc.moved_charge++;
-- 
1.7.4.1

