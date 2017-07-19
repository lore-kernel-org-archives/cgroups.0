From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 6/6] cgroup: update debug controller to print out thread mode information
Date: Wed, 19 Jul 2017 15:44:39 -0400
Message-ID: <20170719194439.2915602-7-tj@kernel.org>
References: <20170719194439.2915602-1-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=K8aRQE0C8BtSb0RS5BRTySud1CgiGorBICva/DzwtFU=;
        b=XjWyQ78u72biiQu1NUiYN3NyfWbTyPSf/oC+V9SJUSnTv2+KZGxDq9Hdfz6+mgKksL
         xK0696N6Y+H1SalHHmaKGWtzCT2hxR7YZxUeHu8Ws7VsV+AQO+EUZuiwb08at58a0BRz
         2Ql3GziZoCPxHJKDwlYEFeTKOcxcNdZL6lXK6bs2CSJfRH6ytwmtGF2Z4laBp4zwLFtX
         iZY5cszaFNmJc8qD2vyOog4PKQ04q8YmQF5Y/qihOCT6+rIssjeKgHjYkVuawW/aoLjh
         vzteAbGRI8bRvn8Y0w8LqJ2crWcx8XD44pPjZpkpUsdA2s7M29piO1StCl6GlA7+7JOQ
         IFbg==
In-Reply-To: <20170719194439.2915602-1-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, hannes@cmpxchg.org, peterz@infradead.org, mingo@redhat.com, longman@redhat.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de, torvalds@linux-foundation.org, guro@fb.com, Tejun Heo <tj@kernel.org>

From: Waiman Long <longman@redhat.com>

Update debug controller so that it prints out debug info about thread
mode.

 1) The relationship between proc_cset and threaded_csets are displayed.
 2) The status of being a thread root or threaded cgroup is displayed.

This patch is extracted from Waiman's larger patch.

v2: - Removed [thread root] / [threaded] from debug.cgroup_css_links
      file as the same information is available from cgroup.type.
      Suggested by Waiman.
    - Threaded marking is moved to the previous patch.

Patch-originally-by: Waiman Long <longman@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup/cgroup-internal.h |  2 ++
 kernel/cgroup/cgroup.c          |  4 ++--
 kernel/cgroup/debug.c           | 52 ++++++++++++++++++++++++++++++-----------
 3 files changed, 42 insertions(+), 16 deletions(-)

diff --git a/kernel/cgroup/cgroup-internal.h b/kernel/cgroup/cgroup-internal.h
index f10eb19..c167a40 100644
--- a/kernel/cgroup/cgroup-internal.h
+++ b/kernel/cgroup/cgroup-internal.h
@@ -153,6 +153,8 @@ static inline void get_css_set(struct css_set *cset)
 
 bool cgroup_ssid_enabled(int ssid);
 bool cgroup_on_dfl(const struct cgroup *cgrp);
+bool cgroup_is_thread_root(struct cgroup *cgrp);
+bool cgroup_is_threaded(struct cgroup *cgrp);
 
 struct cgroup_root *cgroup_root_from_kf(struct kernfs_root *kf_root);
 struct cgroup *task_cgroup_from_root(struct task_struct *task,
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index c396e70..e9a377d 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -333,7 +333,7 @@ static bool cgroup_has_tasks(struct cgroup *cgrp)
 	return cgrp->nr_populated_csets;
 }
 
-static bool cgroup_is_threaded(struct cgroup *cgrp)
+bool cgroup_is_threaded(struct cgroup *cgrp)
 {
 	return cgrp->dom_cgrp != cgrp;
 }
@@ -372,7 +372,7 @@ static bool cgroup_can_be_thread_root(struct cgroup *cgrp)
 }
 
 /* is @cgrp root of a threaded subtree? */
-static bool cgroup_is_thread_root(struct cgroup *cgrp)
+bool cgroup_is_thread_root(struct cgroup *cgrp)
 {
 	/* thread root should be a domain */
 	if (cgroup_is_threaded(cgrp))
diff --git a/kernel/cgroup/debug.c b/kernel/cgroup/debug.c
index 787a242..f661b4c 100644
--- a/kernel/cgroup/debug.c
+++ b/kernel/cgroup/debug.c
@@ -114,27 +114,49 @@ static int cgroup_css_links_read(struct seq_file *seq, void *v)
 {
 	struct cgroup_subsys_state *css = seq_css(seq);
 	struct cgrp_cset_link *link;
-	int dead_cnt = 0, extra_refs = 0;
+	int dead_cnt = 0, extra_refs = 0, threaded_csets = 0;
 
 	spin_lock_irq(&css_set_lock);
+
 	list_for_each_entry(link, &css->cgroup->cset_links, cset_link) {
 		struct css_set *cset = link->cset;
 		struct task_struct *task;
 		int count = 0;
 		int refcnt = refcount_read(&cset->refcount);
 
-		seq_printf(seq, " %d", refcnt);
-		if (refcnt - cset->nr_tasks > 0) {
-			int extra = refcnt - cset->nr_tasks;
-
-			seq_printf(seq, " +%d", extra);
-			/*
-			 * Take out the one additional reference in
-			 * init_css_set.
-			 */
-			if (cset == &init_css_set)
-				extra--;
-			extra_refs += extra;
+		/*
+		 * Print out the proc_cset and threaded_cset relationship
+		 * and highlight difference between refcount and task_count.
+		 */
+		seq_printf(seq, "css_set %pK", cset);
+		if (rcu_dereference_protected(cset->dom_cset, 1) != cset) {
+			threaded_csets++;
+			seq_printf(seq, "=>%pK", cset->dom_cset);
+		}
+		if (!list_empty(&cset->threaded_csets)) {
+			struct css_set *tcset;
+			int idx = 0;
+
+			list_for_each_entry(tcset, &cset->threaded_csets,
+					    threaded_csets_node) {
+				seq_puts(seq, idx ? "," : "<=");
+				seq_printf(seq, "%pK", tcset);
+				idx++;
+			}
+		} else {
+			seq_printf(seq, " %d", refcnt);
+			if (refcnt - cset->nr_tasks > 0) {
+				int extra = refcnt - cset->nr_tasks;
+
+				seq_printf(seq, " +%d", extra);
+				/*
+				 * Take out the one additional reference in
+				 * init_css_set.
+				 */
+				if (cset == &init_css_set)
+					extra--;
+				extra_refs += extra;
+			}
 		}
 		seq_puts(seq, "\n");
 
@@ -163,10 +185,12 @@ static int cgroup_css_links_read(struct seq_file *seq, void *v)
 	}
 	spin_unlock_irq(&css_set_lock);
 
-	if (!dead_cnt && !extra_refs)
+	if (!dead_cnt && !extra_refs && !threaded_csets)
 		return 0;
 
 	seq_puts(seq, "\n");
+	if (threaded_csets)
+		seq_printf(seq, "threaded css_sets = %d\n", threaded_csets);
 	if (extra_refs)
 		seq_printf(seq, "extra references = %d\n", extra_refs);
 	if (dead_cnt)
-- 
2.9.3

