From: Parav Pandit <pandit.parav@gmail.com>
Subject: [PATCH 3/7] devcg: Added infrastructure for rdma device cgroup.
Date: Tue,  8 Sep 2015 02:08:19 +0530
Message-ID: <1441658303-18081-4-git-send-email-pandit.parav@gmail.com>
References: <1441658303-18081-1-git-send-email-pandit.parav@gmail.com>
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=xmgipIGjUomxqq23TD/5bu+tfzMEDARTiBXxQVqDE6Y=;
        b=bOgjAZeWr6Q8x3DoCiwuhu5RvJ/WbjKpYzg/qGVnmULXpqNBd30MYgFog42MIPNRyw
         3uzKdOmWKNM+FGldawo+knywQvJG768sNc/1xjz0AIOAlLH49/UpvLp/lpAR+cK5R5Fs
         JscTbMOqOMauI6yQNpfYzISpPTzMAX4ZYKf5kBMjKWMXRojo4wO29UqNpMWfxBRdKGrd
         Q7lEDJwou1jPaq1q7DQPJGdWefDC+XSVywoKNZEETIE6LPdEQMIRadBbXZpO0Oi8PwfI
         KQUdClPjMCtUNIY27I5dW0Mmc+grgUR0Z+Mk7ELrmyQ4sn5Kd3q5RXgrF/G4xtO+esp3
         rZIw==
In-Reply-To: <1441658303-18081-1-git-send-email-pandit.parav@gmail.com>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, tj@kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, dledford@redhat.com
Cc: corbet@lwn.net, james.l.morris@oracle.com, serge@hallyn.com, haggaie@mellanox.com, ogerlitz@mellanox.com, matanb@mellanox.com, raindel@mellanox.com, akpm@linux-foundation.org, linux-security-module@vger.kernel.org, pandit.parav@gmail.com

1. Moved necessary functions and data structures to header file to
reuse them at device cgroup white list functionality and for rdma
functionality.
2. Added infrastructure to invoke RDMA specific routines for resource
configuration, query and during fork handling.
3. Added sysfs interface files for configuring max limit of each rdma
resource and one file for querying controllers current resource usage.

Signed-off-by: Parav Pandit <pandit.parav@gmail.com>
---
 include/linux/device_cgroup.h |  53 +++++++++++++++++++
 security/device_cgroup.c      | 119 +++++++++++++++++++++++++++++-------------
 2 files changed, 136 insertions(+), 36 deletions(-)

diff --git a/include/linux/device_cgroup.h b/include/linux/device_cgroup.h
index 8b64221..cdbdd60 100644
--- a/include/linux/device_cgroup.h
+++ b/include/linux/device_cgroup.h
@@ -1,6 +1,57 @@
+#ifndef _DEVICE_CGROUP
+#define _DEVICE_CGROUP
+
 #include <linux/fs.h>
+#include <linux/cgroup.h>
+#include <linux/device_rdma_cgroup.h>
 
 #ifdef CONFIG_CGROUP_DEVICE
+
+enum devcg_behavior {
+	DEVCG_DEFAULT_NONE,
+	DEVCG_DEFAULT_ALLOW,
+	DEVCG_DEFAULT_DENY,
+};
+
+/*
+ * exception list locking rules:
+ * hold devcgroup_mutex for update/read.
+ * hold rcu_read_lock() for read.
+ */
+
+struct dev_exception_item {
+	u32 major, minor;
+	short type;
+	short access;
+	struct list_head list;
+	struct rcu_head rcu;
+};
+
+struct dev_cgroup {
+	struct cgroup_subsys_state css;
+	struct list_head exceptions;
+	enum devcg_behavior behavior;
+
+#ifdef CONFIG_CGROUP_RDMA_RESOURCE
+	struct devcgroup_rdma rdma;
+#endif
+};
+
+static inline struct dev_cgroup *css_to_devcgroup(struct cgroup_subsys_state *s)
+{
+	return s ? container_of(s, struct dev_cgroup, css) : NULL;
+}
+
+static inline struct dev_cgroup *parent_devcgroup(struct dev_cgroup *dev_cg)
+{
+	return css_to_devcgroup(dev_cg->css.parent);
+}
+
+static inline struct dev_cgroup *task_devcgroup(struct task_struct *task)
+{
+	return css_to_devcgroup(task_css(task, devices_cgrp_id));
+}
+
 extern int __devcgroup_inode_permission(struct inode *inode, int mask);
 extern int devcgroup_inode_mknod(int mode, dev_t dev);
 static inline int devcgroup_inode_permission(struct inode *inode, int mask)
@@ -17,3 +68,5 @@ static inline int devcgroup_inode_permission(struct inode *inode, int mask)
 static inline int devcgroup_inode_mknod(int mode, dev_t dev)
 { return 0; }
 #endif
+
+#endif
diff --git a/security/device_cgroup.c b/security/device_cgroup.c
index 188c1d2..a0b3239 100644
--- a/security/device_cgroup.c
+++ b/security/device_cgroup.c
@@ -25,42 +25,6 @@
 
 static DEFINE_MUTEX(devcgroup_mutex);
 
-enum devcg_behavior {
-	DEVCG_DEFAULT_NONE,
-	DEVCG_DEFAULT_ALLOW,
-	DEVCG_DEFAULT_DENY,
-};
-
-/*
- * exception list locking rules:
- * hold devcgroup_mutex for update/read.
- * hold rcu_read_lock() for read.
- */
-
-struct dev_exception_item {
-	u32 major, minor;
-	short type;
-	short access;
-	struct list_head list;
-	struct rcu_head rcu;
-};
-
-struct dev_cgroup {
-	struct cgroup_subsys_state css;
-	struct list_head exceptions;
-	enum devcg_behavior behavior;
-};
-
-static inline struct dev_cgroup *css_to_devcgroup(struct cgroup_subsys_state *s)
-{
-	return s ? container_of(s, struct dev_cgroup, css) : NULL;
-}
-
-static inline struct dev_cgroup *task_devcgroup(struct task_struct *task)
-{
-	return css_to_devcgroup(task_css(task, devices_cgrp_id));
-}
-
 /*
  * called under devcgroup_mutex
  */
@@ -223,6 +187,9 @@ devcgroup_css_alloc(struct cgroup_subsys_state *parent_css)
 	INIT_LIST_HEAD(&dev_cgroup->exceptions);
 	dev_cgroup->behavior = DEVCG_DEFAULT_NONE;
 
+#ifdef CONFIG_CGROUP_RDMA_RESOURCE
+	init_devcgroup_rdma_tracker(dev_cgroup);
+#endif
 	return &dev_cgroup->css;
 }
 
@@ -234,6 +201,25 @@ static void devcgroup_css_free(struct cgroup_subsys_state *css)
 	kfree(dev_cgroup);
 }
 
+#ifdef CONFIG_CGROUP_RDMA_RESOURCE
+static int devcgroup_can_attach(struct cgroup_subsys_state *dst_css,
+				struct cgroup_taskset *tset)
+{
+	return devcgroup_rdma_can_attach(dst_css, tset);
+}
+
+static void devcgroup_cancel_attach(struct cgroup_subsys_state *dst_css,
+				    struct cgroup_taskset *tset)
+{
+	devcgroup_cancel_attach(dst_css, tset);
+}
+
+static void devcgroup_fork(struct task_struct *task, void *priv)
+{
+	devcgroup_rdma_fork(task, priv);
+}
+#endif
+
 #define DEVCG_ALLOW 1
 #define DEVCG_DENY 2
 #define DEVCG_LIST 3
@@ -788,6 +774,62 @@ static struct cftype dev_cgroup_files[] = {
 		.seq_show = devcgroup_seq_show,
 		.private = DEVCG_LIST,
 	},
+
+#ifdef CONFIG_CGROUP_RDMA_RESOURCE
+	{
+		.name = "rdma.resource.uctx.max",
+		.write = devcgroup_rdma_set_max_resource,
+		.seq_show = devcgroup_rdma_get_max_resource,
+		.private = DEVCG_RDMA_RES_TYPE_UCTX,
+	},
+	{
+		.name = "rdma.resource.cq.max",
+		.write = devcgroup_rdma_set_max_resource,
+		.seq_show = devcgroup_rdma_get_max_resource,
+		.private = DEVCG_RDMA_RES_TYPE_CQ,
+	},
+	{
+		.name = "rdma.resource.ah.max",
+		.write = devcgroup_rdma_set_max_resource,
+		.seq_show = devcgroup_rdma_get_max_resource,
+		.private = DEVCG_RDMA_RES_TYPE_AH,
+	},
+	{
+		.name = "rdma.resource.pd.max",
+		.write = devcgroup_rdma_set_max_resource,
+		.seq_show = devcgroup_rdma_get_max_resource,
+		.private = DEVCG_RDMA_RES_TYPE_PD,
+	},
+	{
+		.name = "rdma.resource.flow.max",
+		.write = devcgroup_rdma_set_max_resource,
+		.seq_show = devcgroup_rdma_get_max_resource,
+		.private = DEVCG_RDMA_RES_TYPE_FLOW,
+	},
+	{
+		.name = "rdma.resource.srq.max",
+		.write = devcgroup_rdma_set_max_resource,
+		.seq_show = devcgroup_rdma_get_max_resource,
+		.private = DEVCG_RDMA_RES_TYPE_SRQ,
+	},
+	{
+		.name = "rdma.resource.qp.max",
+		.write = devcgroup_rdma_set_max_resource,
+		.seq_show = devcgroup_rdma_get_max_resource,
+		.private = DEVCG_RDMA_RES_TYPE_QP,
+	},
+	{
+		.name = "rdma.resource.mr.max",
+		.write = devcgroup_rdma_set_max_resource,
+		.seq_show = devcgroup_rdma_get_max_resource,
+		.private = DEVCG_RDMA_RES_TYPE_MR,
+	},
+	{
+		.name = "rdma.resource.usage",
+		.seq_show = devcgroup_rdma_show_usage,
+		.private = DEVCG_RDMA_LIST_USAGE,
+	},
+#endif
 	{ }	/* terminate */
 };
 
@@ -796,6 +838,11 @@ struct cgroup_subsys devices_cgrp_subsys = {
 	.css_free = devcgroup_css_free,
 	.css_online = devcgroup_online,
 	.css_offline = devcgroup_offline,
+#ifdef CONFIG_CGROUP_RDMA_RESOURCE
+	.fork = devcgroup_fork,
+	.can_attach = devcgroup_can_attach,
+	.cancel_attach = devcgroup_cancel_attach,
+#endif
 	.legacy_cftypes = dev_cgroup_files,
 };
 
-- 
1.8.3.1

