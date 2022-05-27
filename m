From: Hongchen Zhang <zhanghongchen@loongson.cn>
Subject: [PATCH] cgroup: wait for css offline when rmdir
Date: Fri, 27 May 2022 10:39:18 +0800
Message-ID: <1653619158-27607-1-git-send-email-zhanghongchen@loongson.cn>
Return-path: <linux-kernel-owner@vger.kernel.org>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Hongchen Zhang <zhanghongchen@loongson.cn>

when remove a cgroup dir, make sure all the csses associated which
the cgroup are all offlined,so that we will be sure that the resources
allocated by the csses are all freed when rmdir exit successfully.

Signed-off-by: Hongchen Zhang <zhanghongchen@loongson.cn>
---
 kernel/cgroup/cgroup.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index adb820e..12d3a14 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -3020,6 +3020,31 @@ void cgroup_lock_and_drain_offline(struct cgroup *cgrp)
 	}
 }
 
+/* wait all cgrp's csses become offlined */
+void cgroup_wait_css_offline(struct cgroup *cgrp)
+{
+	struct cgroup_subsys *ss;
+	int ssid;
+
+	lockdep_assert_held(&cgroup_mutex);
+	for_each_subsys(ss, ssid) {
+		struct cgroup_subsys_state *css = cgroup_css(cgrp, ss);
+		DEFINE_WAIT(wait);
+
+		if (!css || !percpu_ref_is_dying(&css->refcnt))
+			continue;
+
+		prepare_to_wait(&cgrp->offline_waitq, &wait,
+				TASK_UNINTERRUPTIBLE);
+
+		mutex_unlock(&cgroup_mutex);
+		schedule();
+		finish_wait(&cgrp->offline_waitq, &wait);
+
+		mutex_lock(&cgroup_mutex);
+	}
+}
+
 /**
  * cgroup_save_control - save control masks and dom_cgrp of a subtree
  * @cgrp: root of the target subtree
@@ -5724,6 +5749,7 @@ int cgroup_rmdir(struct kernfs_node *kn)
 	if (!ret)
 		TRACE_CGROUP_PATH(rmdir, cgrp);
 
+	cgroup_wait_css_offline(cgrp);
 	cgroup_kn_unlock(kn);
 	return ret;
 }
-- 
1.8.3.1

