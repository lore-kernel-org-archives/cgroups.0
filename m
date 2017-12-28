From: Hou Tao <houtao1@huawei.com>
Subject: [PATCH] blktrace: output io cgroup name for cgroup v1
Date: Thu, 28 Dec 2017 15:04:00 +0800
Message-ID: <20171228070400.26328-1-houtao1@huawei.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-block@vger.kernel.org, cgroups@vger.kernel.org
Cc: shli@kernel.org, tj@kernel.org, houtao1@huawei.com

Now the output of io cgroup name in blktrace is controlled by
blk_cgroup & blk_cgname options in trace_options files. When
using cgroup v1 for io controller, there is no output of cgroup
name in trace file, because cgroup_path_from_kernfs_id() uses
cgrp_dfl_root.kf_root to find the cgroup file and cgrp_dfl_root
is only valid for cgroup v2.

So fix cgroup_path_from_kernfs_id() to support both cgroup v1 and v2.

Fixes: 69fd5c3 ("blktrace: add an option to allow displaying cgroup path")
Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 include/linux/cgroup.h  |  6 +++---
 kernel/cgroup/cgroup.c  | 39 ++++++++++++++++++++++++++++++++++++---
 kernel/trace/blktrace.c |  4 ++--
 3 files changed, 41 insertions(+), 8 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 473e0c0..ed80490 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -651,7 +651,7 @@ static inline union kernfs_node_id *cgroup_get_kernfs_id(struct cgroup *cgrp)
 	return &cgrp->kn->id;
 }
 
-void cgroup_path_from_kernfs_id(const union kernfs_node_id *id,
+void cgroup_path_from_kernfs_id(int ssid, const union kernfs_node_id *id,
 					char *buf, size_t buflen);
 #else /* !CONFIG_CGROUPS */
 
@@ -686,8 +686,8 @@ static inline bool task_under_cgroup_hierarchy(struct task_struct *task,
 	return true;
 }
 
-static inline void cgroup_path_from_kernfs_id(const union kernfs_node_id *id,
-	char *buf, size_t buflen) {}
+static inline void cgroup_path_from_kernfs_id(int ssid,
+		const union kernfs_node_id *id, char *buf, size_t buflen) {}
 #endif /* !CONFIG_CGROUPS */
 
 /*
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 0b1ffe1..49d63c6 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -5354,16 +5354,49 @@ static int __init cgroup_wq_init(void)
 }
 core_initcall(cgroup_wq_init);
 
-void cgroup_path_from_kernfs_id(const union kernfs_node_id *id,
+void cgroup_path_from_kernfs_id(int ssid, const union kernfs_node_id *id,
 					char *buf, size_t buflen)
 {
+	struct kernfs_root *root;
 	struct kernfs_node *kn;
+	struct cgroup *root_cgrp = NULL;
 
-	kn = kernfs_get_node_by_id(cgrp_dfl_root.kf_root, id);
-	if (!kn)
+	if (ssid >= CGROUP_SUBSYS_COUNT)
 		return;
+
+	if (likely(static_key_enabled(cgroup_subsys_on_dfl_key[ssid]))) {
+		root = cgrp_dfl_root.kf_root;
+	} else {
+		struct cgroup_subsys *subsys = cgroup_subsys[ssid];
+
+		/*
+		 * It seems we can not use rcu_read_lock() to protect
+		 * the liveness check of subsys->root->cgrp. Although
+		 * root->cgrp is freed by RCU, when we dereference the
+		 * old root, the old root may been destroying by
+		 * cgroup_destroy_root().
+		 */
+		mutex_lock(&cgroup_mutex);
+		if (percpu_ref_tryget_live(&subsys->root->cgrp.self.refcnt)) {
+			root_cgrp = &subsys->root->cgrp;
+			root = subsys->root->kf_root;
+		}
+		mutex_unlock(&cgroup_mutex);
+
+		if (!root_cgrp)
+			goto out;
+	}
+
+	kn = kernfs_get_node_by_id(root, id);
+	if (!kn)
+		goto out;
+
 	kernfs_path(kn, buf, buflen);
 	kernfs_put(kn);
+
+out:
+	if (root_cgrp)
+		cgroup_put(root_cgrp);
 }
 
 /*
diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 987d9a9a..79890e0 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -1279,8 +1279,8 @@ static void blk_log_action(struct trace_iterator *iter, const char *act,
 		if (blk_tracer_flags.val & TRACE_BLK_OPT_CGNAME) {
 			char blkcg_name_buf[NAME_MAX + 1] = "<...>";
 
-			cgroup_path_from_kernfs_id(id, blkcg_name_buf,
-				sizeof(blkcg_name_buf));
+			cgroup_path_from_kernfs_id(io_cgrp_id, id,
+				blkcg_name_buf, sizeof(blkcg_name_buf));
 			trace_seq_printf(&iter->seq, "%3d,%-3d %s %2s %3s ",
 				 MAJOR(t->device), MINOR(t->device),
 				 blkcg_name_buf, act, rwbs);
-- 
2.9.5

