From: Miaohe Lin <linmiaohe@huawei.com>
Subject: [PATCH] cgroup: put cgroup_tryget_css() inside CONFIG_CGROUP_SCHED
Date: Tue, 11 Jul 2023 10:38:20 +0800
Message-ID: <20230711023820.3854596-1-linmiaohe@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, hannes@cmpxchg.org, sfr@canb.auug.org.au, lizefan.x@bytedance.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-next@vger.kernel.org, linmiaohe@huawei.com

Put cgroup_tryget_css() inside CONFIG_CGROUP_SCHED to fix the warning
of 'cgroup_tryget_css' defined but not used [-Wunused-function] when
CONFIG_CGROUP_SCHED is disabled.

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 kernel/cgroup/cgroup.c | 44 +++++++++++++++++++++---------------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index b990eda6b3cd..46401157028e 100644
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
-- 
2.33.0

