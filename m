From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: [patch] mm: memcontrol: fold move_anon() and move_file()
Date: Tue, 13 Jan 2015 13:59:52 -0500
Message-ID: <1421175592-14179-1-git-send-email-hannes__40485.4871951558$1421175631$gmane$org@cmpxchg.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Turn the move type enum into flags and give the flags field a shorter
name.  Once that is done, move_anon() and move_file() are simple
enough to just fold them into the callsites.

Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
---
 mm/memcontrol.c | 49 ++++++++++++++++++-------------------------------
 1 file changed, 18 insertions(+), 31 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 5a5769e8b12c..692e96407627 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -360,21 +360,18 @@ static bool memcg_kmem_is_active(struct mem_cgroup *memcg)
 
 /* Stuffs for move charges at task migration. */
 /*
- * Types of charges to be moved. "move_charge_at_immitgrate" and
- * "immigrate_flags" are treated as a left-shifted bitmap of these types.
+ * Types of charges to be moved.
  */
-enum move_type {
-	MOVE_CHARGE_TYPE_ANON,	/* private anonymous page and swap of it */
-	MOVE_CHARGE_TYPE_FILE,	/* file page(including tmpfs) and swap of it */
-	NR_MOVE_TYPE,
-};
+#define MOVE_ANON	0x1U
+#define MOVE_FILE	0x2U
+#define MOVE_MASK	0x3U
 
 /* "mc" and its members are protected by cgroup_mutex */
 static struct move_charge_struct {
 	spinlock_t	  lock; /* for from, to */
 	struct mem_cgroup *from;
 	struct mem_cgroup *to;
-	unsigned long immigrate_flags;
+	unsigned long flags;
 	unsigned long precharge;
 	unsigned long moved_charge;
 	unsigned long moved_swap;
@@ -385,16 +382,6 @@ static struct move_charge_struct {
 	.waitq = __WAIT_QUEUE_HEAD_INITIALIZER(mc.waitq),
 };
 
-static bool move_anon(void)
-{
-	return test_bit(MOVE_CHARGE_TYPE_ANON, &mc.immigrate_flags);
-}
-
-static bool move_file(void)
-{
-	return test_bit(MOVE_CHARGE_TYPE_FILE, &mc.immigrate_flags);
-}
-
 /*
  * Maximum loops in mem_cgroup_hierarchical_reclaim(), used for soft
  * limit reclaim to prevent infinite loops, if they ever occur.
@@ -3476,7 +3463,7 @@ static int mem_cgroup_move_charge_write(struct cgroup_subsys_state *css,
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
 
-	if (val >= (1 << NR_MOVE_TYPE))
+	if (val & ~MOVE_MASK)
 		return -EINVAL;
 
 	/*
@@ -4698,12 +4685,12 @@ static struct page *mc_handle_present_pte(struct vm_area_struct *vma,
 	if (!page || !page_mapped(page))
 		return NULL;
 	if (PageAnon(page)) {
-		/* we don't move shared anon */
-		if (!move_anon())
+		if (!(mc.flags & MOVE_ANON))
 			return NULL;
-	} else if (!move_file())
-		/* we ignore mapcount for file pages */
-		return NULL;
+	} else {
+		if (!(mc.flags & MOVE_FILE))
+			return NULL;
+	}
 	if (!get_page_unless_zero(page))
 		return NULL;
 
@@ -4717,7 +4704,7 @@ static struct page *mc_handle_swap_pte(struct vm_area_struct *vma,
 	struct page *page = NULL;
 	swp_entry_t ent = pte_to_swp_entry(ptent);
 
-	if (!move_anon() || non_swap_entry(ent))
+	if (!(mc.flags & MOVE_ANON) || non_swap_entry(ent))
 		return NULL;
 	/*
 	 * Because lookup_swap_cache() updates some statistics counter,
@@ -4746,7 +4733,7 @@ static struct page *mc_handle_file_pte(struct vm_area_struct *vma,
 
 	if (!vma->vm_file) /* anonymous vma */
 		return NULL;
-	if (!move_file())
+	if (!(mc.flags & MOVE_FILE))
 		return NULL;
 
 	mapping = vma->vm_file->f_mapping;
@@ -4828,7 +4815,7 @@ static enum mc_target_type get_mctgt_type_thp(struct vm_area_struct *vma,
 
 	page = pmd_page(pmd);
 	VM_BUG_ON_PAGE(!page || !PageHead(page), page);
-	if (!move_anon())
+	if (!(mc.flags & MOVE_ANON))
 		return ret;
 	if (page->mem_cgroup == mc.from) {
 		ret = MC_TARGET_PAGE;
@@ -4970,15 +4957,15 @@ static int mem_cgroup_can_attach(struct cgroup_subsys_state *css,
 	struct task_struct *p = cgroup_taskset_first(tset);
 	int ret = 0;
 	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
-	unsigned long move_charge_at_immigrate;
+	unsigned long move_flags;
 
 	/*
 	 * We are now commited to this value whatever it is. Changes in this
 	 * tunable will only affect upcoming migrations, not the current one.
 	 * So we need to save it, and keep it going.
 	 */
-	move_charge_at_immigrate  = memcg->move_charge_at_immigrate;
-	if (move_charge_at_immigrate) {
+	move_flags = ACCESS_ONCE(memcg->move_charge_at_immigrate);
+	if (move_flags) {
 		struct mm_struct *mm;
 		struct mem_cgroup *from = mem_cgroup_from_task(p);
 
@@ -4998,7 +4985,7 @@ static int mem_cgroup_can_attach(struct cgroup_subsys_state *css,
 			spin_lock(&mc.lock);
 			mc.from = from;
 			mc.to = memcg;
-			mc.immigrate_flags = move_charge_at_immigrate;
+			mc.flags = move_flags;
 			spin_unlock(&mc.lock);
 			/* We set mc.moving_task later */
 
-- 
2.2.0
