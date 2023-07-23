From: Miaohe Lin <linmiaohe@huawei.com>
Subject: [PATCH] cgroup: minor cleanup for cgroup_local_stat_show()
Date: Sun, 23 Jul 2023 11:19:32 +0800
Message-ID: <20230723031932.3152951-1-linmiaohe@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, hannes@cmpxchg.org, lizefan.x@bytedance.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linmiaohe@huawei.com

Make it under CONFIG_CGROUP_SCHED to rid of __maybe_unused annotation.
Also put cgroup_tryget_css() inside CONFIG_CGROUP_SCHED as it's only
called when CONFIG_CGROUP_SCHED. No functional change intended.

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 kernel/cgroup/cgroup.c | 63 ++++++++++++++++++++++--------------------
 1 file changed, 33 insertions(+), 30 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 31603146e7c2..7296331c7582 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -492,28 +492,6 @@ static struct cgroup_subsys_state *cgroup_css(struct cgroup *cgrp,
 		return &cgrp->self;
 }
 
-/**
- * cgroup_tryget_css - try to get a cgroup's css for the specified subsystem
- * @cgrp: the cgroup of interest
- * @ss: the subsystem of interest
- *
- * Find and get @cgrp's css associated with @ss.  If the css doesn't exist
- * or is offline, %NULL is returned.
- */
-static struct cgroup_subsys_state *cgroup_tryget_css(struct cgroup *cgrp,
-						     struct cgroup_subsys *ss)
-{
-	struct cgroup_subsys_state *css;
-
-	rcu_read_lock();
-	css = cgroup_css(cgrp, ss);
-	if (css && !css_tryget_online(css))
-		css = NULL;
-	rcu_read_unlock();
-
-	return css;
-}
-
 /**
  * cgroup_e_css_by_mask - obtain a cgroup's effective css for the specified ss
  * @cgrp: the cgroup of interest
@@ -3655,6 +3633,28 @@ static int cgroup_stat_show(struct seq_file *seq, void *v)
 }
 
 #ifdef CONFIG_CGROUP_SCHED
+/**
+ * cgroup_tryget_css - try to get a cgroup's css for the specified subsystem
+ * @cgrp: the cgroup of interest
+ * @ss: the subsystem of interest
+ *
+ * Find and get @cgrp's css associated with @ss.  If the css doesn't exist
+ * or is offline, %NULL is returned.
+ */
+static struct cgroup_subsys_state *cgroup_tryget_css(struct cgroup *cgrp,
+						     struct cgroup_subsys *ss)
+{
+	struct cgroup_subsys_state *css;
+
+	rcu_read_lock();
+	css = cgroup_css(cgrp, ss);
+	if (css && !css_tryget_online(css))
+		css = NULL;
+	rcu_read_unlock();
+
+	return css;
+}
+
 static int cgroup_extra_stat_show(struct seq_file *seq, int ssid)
 {
 	struct cgroup *cgrp = seq_css(seq)->cgroup;
@@ -3686,8 +3686,9 @@ static int cpu_stat_show(struct seq_file *seq, void *v)
 	return ret;
 }
 
-static int __maybe_unused cgroup_local_stat_show(struct seq_file *seq,
-						 struct cgroup *cgrp, int ssid)
+#ifdef CONFIG_CGROUP_SCHED
+static int cgroup_local_stat_show(struct seq_file *seq,
+				  struct cgroup *cgrp, int ssid)
 {
 	struct cgroup_subsys *ss = cgroup_subsys[ssid];
 	struct cgroup_subsys_state *css;
@@ -3707,14 +3708,16 @@ static int __maybe_unused cgroup_local_stat_show(struct seq_file *seq,
 
 static int cpu_local_stat_show(struct seq_file *seq, void *v)
 {
-	struct cgroup __maybe_unused *cgrp = seq_css(seq)->cgroup;
-	int ret = 0;
+	struct cgroup *cgrp = seq_css(seq)->cgroup;
 
-#ifdef CONFIG_CGROUP_SCHED
-	ret = cgroup_local_stat_show(seq, cgrp, cpu_cgrp_id);
-#endif
-	return ret;
+	return cgroup_local_stat_show(seq, cgrp, cpu_cgrp_id);
+}
+#else
+static int cpu_local_stat_show(struct seq_file *seq, void *v)
+{
+	return 0;
 }
+#endif
 
 #ifdef CONFIG_PSI
 static int cgroup_io_pressure_show(struct seq_file *seq, void *v)
-- 
2.33.0

