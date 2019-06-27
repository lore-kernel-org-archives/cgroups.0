From: Peng Wang <rocking@whu.edu.cn>
Subject: [PATCH] cgroup: provide a macro helper to iterate a cgroup's ancestors
Date: Thu, 27 Jun 2019 18:19:01 +0800
Message-ID: <20190627101901.26714-1-rocking@whu.edu.cn>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, lizefan@huawei.com, hannes@cmpxchg.org
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Peng Wang <rocking@whu.edu.cn>

Use for_each_ancestor macro to iterate a cgroup's ancestors for clarity.

Signed-off-by: Peng Wang <rocking@whu.edu.cn>
---
 include/linux/cgroup.h  | 11 +++++++++++
 kernel/cgroup/cgroup.c  |  7 +++----
 kernel/cgroup/freezer.c |  2 +-
 kernel/cgroup/rstat.c   |  4 ++--
 4 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 0297f930a56e..00b0a16bbc30 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -298,6 +298,17 @@ void css_task_iter_end(struct css_task_iter *it);
 			;						\
 		else
 
+/**
+ * for_each_ancestor - iterate a cgroup's ancestors
+ * @tcgrp: the loop cursor
+ * @cgrp: cgroup whose ancestors to iterate
+ *
+ * Iterate ancestors of @cgrp.
+ */
+#define for_each_ancestor(tcgrp, cgrp)					\
+	for ((tcgrp) = cgroup_parent((cgrp)); (tcgrp);			\
+		(tcgrp) = cgroup_parent((tcgrp)))
+
 /*
  * Inline functions.
  */
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index bf9dbffd46b1..32fa09679209 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -404,7 +404,7 @@ static bool cgroup_is_valid_domain(struct cgroup *cgrp)
 		return false;
 
 	/* but the ancestors can't be unless mixable */
-	while ((cgrp = cgroup_parent(cgrp))) {
+	for_each_ancestor(cgrp, cgrp) {
 		if (!cgroup_is_mixable(cgrp) && cgroup_is_thread_root(cgrp))
 			return false;
 		if (cgroup_is_threaded(cgrp))
@@ -4987,8 +4987,7 @@ static void css_release_work_fn(struct work_struct *work)
 			cgroup_rstat_flush(cgrp);
 
 		spin_lock_irq(&css_set_lock);
-		for (tcgrp = cgroup_parent(cgrp); tcgrp;
-		     tcgrp = cgroup_parent(tcgrp))
+		for_each_ancestor(tcgrp, cgrp)
 			tcgrp->nr_dying_descendants--;
 		spin_unlock_irq(&css_set_lock);
 
@@ -5518,7 +5517,7 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
 		parent->nr_threaded_children--;
 
 	spin_lock_irq(&css_set_lock);
-	for (tcgrp = cgroup_parent(cgrp); tcgrp; tcgrp = cgroup_parent(tcgrp)) {
+	for_each_ancestor(tcgrp, cgrp) {
 		tcgrp->nr_descendants--;
 		tcgrp->nr_dying_descendants++;
 		/*
diff --git a/kernel/cgroup/freezer.c b/kernel/cgroup/freezer.c
index 8cf010680678..4dfc2f04a82d 100644
--- a/kernel/cgroup/freezer.c
+++ b/kernel/cgroup/freezer.c
@@ -21,7 +21,7 @@ static void cgroup_propagate_frozen(struct cgroup *cgrp, bool frozen)
 	 *
 	 * Otherwise, all ancestor cgroups are forced into the non-frozen state.
 	 */
-	while ((cgrp = cgroup_parent(cgrp))) {
+	for_each_ancestor(cgrp, cgrp) {
 		if (frozen) {
 			cgrp->freezer.nr_frozen_descendants += desc;
 			if (!test_bit(CGRP_FROZEN, &cgrp->flags) &&
diff --git a/kernel/cgroup/rstat.c b/kernel/cgroup/rstat.c
index ca19b4c8acf5..58d352e0d76a 100644
--- a/kernel/cgroup/rstat.c
+++ b/kernel/cgroup/rstat.c
@@ -49,8 +49,7 @@ void cgroup_rstat_updated(struct cgroup *cgrp, int cpu)
 	raw_spin_lock_irqsave(cpu_lock, flags);
 
 	/* put @cgrp and all ancestors on the corresponding updated lists */
-	for (parent = cgroup_parent(cgrp); parent;
-	     cgrp = parent, parent = cgroup_parent(cgrp)) {
+	for_each_ancestor(parent, cgrp) {
 		struct cgroup_rstat_cpu *rstatc = cgroup_rstat_cpu(cgrp, cpu);
 		struct cgroup_rstat_cpu *prstatc = cgroup_rstat_cpu(parent, cpu);
 
@@ -63,6 +62,7 @@ void cgroup_rstat_updated(struct cgroup *cgrp, int cpu)
 
 		rstatc->updated_next = prstatc->updated_children;
 		prstatc->updated_children = cgrp;
+		cgrp = parent;
 	}
 
 	raw_spin_unlock_irqrestore(cpu_lock, flags);
-- 
2.19.1

