From: Michal Hocko <mhocko@kernel.org>
Subject: [PATCH] mm, oom: simplify alloc_pages_before_oomkill handling
Date: Fri, 1 Dec 2017 10:14:25 +0100
Message-ID: <20171201091425.ekrpxsmkwcusozua@dhcp22.suse.cz>
References: <20171130152824.1591-1-guro@fb.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20171130152824.1591-1-guro@fb.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: linux-mm@vger.kernel.org, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, David Rientjes <rientjes@google.com>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org

Recently added alloc_pages_before_oomkill gained new caller with this
patchset and I think it just grown to deserve a simpler code flow.
What do you think about this on top of the series?

---
From f1f6035ea0df65e7619860b013f2fabdda65233e Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.com>
Date: Fri, 1 Dec 2017 10:05:25 +0100
Subject: [PATCH] mm, oom: simplify alloc_pages_before_oomkill handling

alloc_pages_before_oomkill is the last attempt to allocate memory before
we go and try to kill a process or a memcg. It's success path always has
to properly clean up the oc state (namely victim reference count). Let's
pull this into alloc_pages_before_oomkill directly rather than risk
somebody will forget to do it in future. Also document that we _know_
alloc_pages_before_oomkill violates proper layering and that is a
pragmatic decision.

Signed-off-by: Michal Hocko <mhocko@suse.com>
---
 include/linux/oom.h |  2 +-
 mm/oom_kill.c       | 21 +++------------------
 mm/page_alloc.c     | 24 ++++++++++++++++++++++--
 3 files changed, 26 insertions(+), 21 deletions(-)

diff --git a/include/linux/oom.h b/include/linux/oom.h
index 10f495c8454d..7052e0a20e13 100644
--- a/include/linux/oom.h
+++ b/include/linux/oom.h
@@ -121,7 +121,7 @@ extern void oom_killer_enable(void);
 
 extern struct task_struct *find_lock_task_mm(struct task_struct *p);
 
-extern struct page *alloc_pages_before_oomkill(const struct oom_control *oc);
+extern bool alloc_pages_before_oomkill(struct oom_control *oc);
 
 extern int oom_evaluate_task(struct task_struct *task, void *arg);
 
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 4678468bae17..5c2cd299757b 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -1102,8 +1102,7 @@ bool out_of_memory(struct oom_control *oc)
 	if (!is_memcg_oom(oc) && sysctl_oom_kill_allocating_task &&
 	    current->mm && !oom_unkillable_task(current, NULL, oc->nodemask) &&
 	    current->signal->oom_score_adj != OOM_SCORE_ADJ_MIN) {
-		oc->page = alloc_pages_before_oomkill(oc);
-		if (oc->page)
+		if (alloc_pages_before_oomkill(oc))
 			return true;
 		get_task_struct(current);
 		oc->chosen_task = current;
@@ -1112,13 +1111,8 @@ bool out_of_memory(struct oom_control *oc)
 	}
 
 	if (mem_cgroup_select_oom_victim(oc)) {
-		oc->page = alloc_pages_before_oomkill(oc);
-		if (oc->page) {
-			if (oc->chosen_memcg &&
-			    oc->chosen_memcg != INFLIGHT_VICTIM)
-				mem_cgroup_put(oc->chosen_memcg);
+		if (alloc_pages_before_oomkill(oc))
 			return true;
-		}
 
 		if (oom_kill_memcg_victim(oc)) {
 			delay = true;
@@ -1127,17 +1121,8 @@ bool out_of_memory(struct oom_control *oc)
 	}
 
 	select_bad_process(oc);
-	/*
-	 * Try really last second allocation attempt after we selected an OOM
-	 * victim, for somebody might have managed to free memory while we were
-	 * selecting an OOM victim which can take quite some time.
-	 */
-	oc->page = alloc_pages_before_oomkill(oc);
-	if (oc->page) {
-		if (oc->chosen_task && oc->chosen_task != INFLIGHT_VICTIM)
-			put_task_struct(oc->chosen_task);
+	if (alloc_pages_before_oomkill(oc))
 		return true;
-	}
 	/* Found nothing?!?! Either we hang forever, or we panic. */
 	if (!oc->chosen_task && !is_sysrq_oom(oc) && !is_memcg_oom(oc)) {
 		dump_header(oc, NULL);
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 0d518e9b2ee8..9e65fa06ee10 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4146,7 +4146,17 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	return page;
 }
 
-struct page *alloc_pages_before_oomkill(const struct oom_control *oc)
+/*
+ * Try really last second allocation attempt after we selected an OOM victim,
+ * for somebody might have managed to free memory while we were selecting an
+ * OOM victim which can take quite some time.
+ *
+ * This function is a blatant layer violation example because we cross the page
+ * allocator and reclaim (OOM killer) layers. Doing this right from the design
+ * POV would be much more complex though so let's close our eyes and pretend
+ * everything is allright.
+ */
+bool alloc_pages_before_oomkill(struct oom_control *oc)
 {
 	/*
 	 * Go through the zonelist yet one more time, keep very high watermark
@@ -4167,7 +4177,17 @@ struct page *alloc_pages_before_oomkill(const struct oom_control *oc)
 	reserve_flags = __gfp_pfmemalloc_flags(gfp_mask);
 	if (reserve_flags)
 		alloc_flags = reserve_flags;
-	return get_page_from_freelist(gfp_mask, oc->order, alloc_flags, oc->ac);
+	oc->page = get_page_from_freelist(gfp_mask, oc->order, alloc_flags, oc->ac);
+	if (!oc->page)
+		return false;
+
+	/*
+	 * we are skipping the remaining oom steps so clean up the pending oc
+	 * state
+	 */
+	if (oc->chosen_task && oc->chosen_task != INFLIGHT_VICTIM)
+		put_task_struct(oc->chosen_task);
+	return true;
 }
 
 static inline bool prepare_alloc_pages(gfp_t gfp_mask, unsigned int order,
-- 
2.15.0

-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
