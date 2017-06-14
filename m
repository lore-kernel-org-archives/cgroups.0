From: Waiman Long <longman@redhat.com>
Subject: [RFC PATCH-cgroup 6/6] cgroup: Make debug controller display bypass and subtree root modes info
Date: Wed, 14 Jun 2017 11:05:37 -0400
Message-ID: <1497452737-11125-7-git-send-email-longman@redhat.com>
References: <1497452737-11125-1-git-send-email-longman@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.redhat.com DEC3561D03
In-Reply-To: <1497452737-11125-1-git-send-email-longman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de, torvalds@linux-foundation.org, Waiman Long <longman@redhat.com>

This patch enables the debug controller to display the new bypass
mode and subtree root mode information.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 kernel/cgroup/cgroup-internal.h | 12 ++++++++++++
 kernel/cgroup/cgroup.c          |  9 ---------
 kernel/cgroup/debug.c           | 27 ++++++++++++++++++++-------
 3 files changed, 32 insertions(+), 16 deletions(-)

diff --git a/kernel/cgroup/cgroup-internal.h b/kernel/cgroup/cgroup-internal.h
index 0e81c61..6bb0a6a 100644
--- a/kernel/cgroup/cgroup-internal.h
+++ b/kernel/cgroup/cgroup-internal.h
@@ -151,6 +151,18 @@ static inline void get_css_set(struct css_set *cset)
 	refcount_inc(&cset->refcount);
 }
 
+/*
+ * Return the cgroup parent.
+ */
+static inline struct cgroup *cgroup_parent(struct cgroup *cgrp)
+{
+	struct cgroup_subsys_state *parent_css = cgrp->self.parent;
+
+	if (parent_css)
+		return container_of(parent_css, struct cgroup, self);
+	return NULL;
+}
+
 bool cgroup_ssid_enabled(int ssid);
 bool cgroup_on_dfl(const struct cgroup *cgrp);
 
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 2a5bd49..6ffe900 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -322,15 +322,6 @@ static void cgroup_idr_remove(struct idr *idr, int id)
 	spin_unlock_bh(&cgroup_idr_lock);
 }
 
-static struct cgroup *cgroup_parent(struct cgroup *cgrp)
-{
-	struct cgroup_subsys_state *parent_css = cgrp->self.parent;
-
-	if (parent_css)
-		return container_of(parent_css, struct cgroup, self);
-	return NULL;
-}
-
 /* is @cgrp threaded? regardless of mixed / root / member? */
 static bool cgroup_is_threaded(struct cgroup *cgrp)
 {
diff --git a/kernel/cgroup/debug.c b/kernel/cgroup/debug.c
index be901c0..561539d 100644
--- a/kernel/cgroup/debug.c
+++ b/kernel/cgroup/debug.c
@@ -198,6 +198,7 @@ static int cgroup_css_links_read(struct seq_file *seq, void *v)
 static int cgroup_subsys_states_read(struct seq_file *seq, void *v)
 {
 	struct cgroup *cgrp = seq_css(seq)->cgroup;
+	struct cgroup *parent = cgroup_parent(cgrp);
 	struct cgroup_subsys *ss;
 	struct cgroup_subsys_state *css;
 	char pbuf[16];
@@ -206,9 +207,16 @@ static int cgroup_subsys_states_read(struct seq_file *seq, void *v)
 	mutex_lock(&cgroup_mutex);
 	for_each_subsys(ss, i) {
 		css = rcu_dereference_check(cgrp->subsys[ss->id], true);
-		if (!css)
+		if (!css) {
+			u16 bypass = cgrp->bypass_ss_mask;
+
+			if (parent)
+				bypass |= parent->subtree_bypass;
+			if (bypass & (1 << ss->id))
+				seq_printf(seq, "%2d: %-4s\t- [Bypass]\n",
+					   ss->id, ss->name);
 			continue;
-
+		}
 		pbuf[0] = '\0';
 
 		/* Show the parent CSS if applicable*/
@@ -234,6 +242,8 @@ static int cgroup_masks_read(struct seq_file *seq, void *v)
 	} mask_list[] = {
 		{ &cgrp->subtree_control,  "subtree_control"  },
 		{ &cgrp->subtree_ss_mask,  "subtree_ss_mask"  },
+		{ &cgrp->subtree_bypass,   "subtree_bypass"   },
+		{ &cgrp->bypass_ss_mask,   "bypass_ss_mask"   },
 	};
 
 	mutex_lock(&cgroup_mutex);
@@ -255,6 +265,8 @@ static int cgroup_masks_read(struct seq_file *seq, void *v)
 	if (cgrp->proc_cgrp)
 		seq_printf(seq, "thread mode      : %s\n",
 			  (cgrp->proc_cgrp == cgrp) ? "root" : "threaded");
+	if (test_bit(CGRP_SUBTREE_ROOT_MODE, &cgrp->flags))
+		seq_puts(seq,   "subtree root mode: on\n");
 
 	mutex_unlock(&cgroup_mutex);
 	return 0;
@@ -314,11 +326,12 @@ static u64 releasable_read(struct cgroup_subsys_state *css, struct cftype *cft)
 };
 
 struct cgroup_subsys debug_cgrp_subsys = {
-	.css_alloc	= debug_css_alloc,
-	.css_free	= debug_css_free,
-	.legacy_cftypes	= debug_files,
-	.dfl_cftypes	= debug_files,
-	.threaded	= true,
+	.css_alloc	 = debug_css_alloc,
+	.css_free	 = debug_css_free,
+	.legacy_cftypes	 = debug_files,
+	.dfl_cftypes	 = debug_files,
+	.threaded	 = true,
+	.enabled_on_root = true,
 };
 
 /*
-- 
1.8.3.1

