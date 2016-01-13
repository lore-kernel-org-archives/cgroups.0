From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: [PATCH] mm: memcontrol: do not uncharge old page in page cache replacement
Date: Wed, 13 Jan 2016 16:51:57 -0500
Message-ID: <1452721917-24614-1-git-send-email-hannes@cmpxchg.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Changing page->mem_cgroup of a live page is tricky and fragile. In
particular, the memcg writeback code relies on that mapping being
stable and users of mem_cgroup_replace_page() not overlapping with
dirtyable inodes.

Page cache replacement doesn't have to do that, though. Instead of
being clever and transfering the charge from the old page to the new,
force-charge the new page and leave the old page alone. A temporary
overcharge won't matter in practice, and the old page is going to be
freed shortly after this anyway. And this is not performance critical.

Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
---
 mm/memcontrol.c | 26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index d75028d..c26ffac 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -366,13 +366,6 @@ mem_cgroup_zone_zoneinfo(struct mem_cgroup *memcg, struct zone *zone)
  *
  * If memcg is bound to a traditional hierarchy, the css of root_mem_cgroup
  * is returned.
- *
- * XXX: The above description of behavior on the default hierarchy isn't
- * strictly true yet as replace_page_cache_page() can modify the
- * association before @page is released even on the default hierarchy;
- * however, the current and planned usages don't mix the the two functions
- * and replace_page_cache_page() will soon be updated to make the invariant
- * actually true.
  */
 struct cgroup_subsys_state *mem_cgroup_css_from_page(struct page *page)
 {
@@ -5463,7 +5456,8 @@ void mem_cgroup_uncharge_list(struct list_head *page_list)
 void mem_cgroup_replace_page(struct page *oldpage, struct page *newpage)
 {
 	struct mem_cgroup *memcg;
-	int isolated;
+	unsigned int nr_pages;
+	bool compound;
 
 	VM_BUG_ON_PAGE(!PageLocked(oldpage), oldpage);
 	VM_BUG_ON_PAGE(!PageLocked(newpage), newpage);
@@ -5483,11 +5477,21 @@ void mem_cgroup_replace_page(struct page *oldpage, struct page *newpage)
 	if (!memcg)
 		return;
 
-	lock_page_lru(oldpage, &isolated);
-	oldpage->mem_cgroup = NULL;
-	unlock_page_lru(oldpage, isolated);
+	/* Force-charge the new page. The old one will be freed soon */
+	compound = PageTransHuge(newpage);
+	nr_pages = compound ? hpage_nr_pages(newpage) : 1;
+
+	page_counter_charge(&memcg->memory, nr_pages);
+	if (do_memsw_account())
+		page_counter_charge(&memcg->memsw, nr_pages);
+	css_get_many(&memcg->css, nr_pages);
 
 	commit_charge(newpage, memcg, true);
+
+	local_irq_disable();
+	mem_cgroup_charge_statistics(memcg, newpage, compound, nr_pages);
+	memcg_check_events(memcg, newpage);
+	local_irq_enable();
 }
 
 DEFINE_STATIC_KEY_FALSE(memcg_sockets_enabled_key);
-- 
2.7.0
