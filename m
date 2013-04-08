From: Li Zefan <lizefan@huawei.com>
Subject: [PATCH 1/8] cgroup: implement cgroup_is_ancestor()
Date: Mon, 8 Apr 2013 16:20:11 +0800
Message-ID: <51627DBB.5050005@huawei.com>
References: <51627DA9.7020507@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <51627DA9.7020507@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, Glauber Costa <glommer@parallels.com>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, linux-mm@kvack.org

This will be used as a replacement for css_is_ancestor().

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 include/linux/cgroup.h |  3 +++
 kernel/cgroup.c        | 21 +++++++++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 2eaedc1..96072e4 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -177,6 +177,7 @@ struct cgroup {
 	atomic_t count;
 
 	int id;				/* ida allocated in-hierarchy ID */
+	int depth;			/* the depth of the cgroup */
 
 	/*
 	 * We link our 'sibling' struct into our parent's 'children'.
@@ -730,6 +731,8 @@ unsigned short css_id(struct cgroup_subsys_state *css);
 unsigned short css_depth(struct cgroup_subsys_state *css);
 struct cgroup_subsys_state *cgroup_css_from_dir(struct file *f, int id);
 
+bool cgroup_is_ancestor(struct cgroup *child, struct cgroup *root);
+
 #else /* !CONFIG_CGROUPS */
 
 static inline int cgroup_init_early(void) { return 0; }
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 7ee3bdf..e87872c 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4133,6 +4133,7 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
 	cgrp->dentry = dentry;
 
 	cgrp->parent = parent;
+	cgrp->depth = parent->depth + 1;
 	cgrp->root = parent->root;
 	cgrp->top_cgroup = parent->top_cgroup;
 
@@ -5299,6 +5300,26 @@ struct cgroup_subsys_state *cgroup_css_from_dir(struct file *f, int id)
 	return css ? css : ERR_PTR(-ENOENT);
 }
 
+/**
+ * cgroup_is_ancestor - test "root" cgroup is an ancestor of "child"
+ * @child: the cgroup to be tested.
+ * @root: the cgroup supposed to be an ancestor of the child.
+ *
+ * Returns true if "root" is an ancestor of "child" in its hierarchy.
+ */
+bool cgroup_is_ancestor(struct cgroup *child, struct cgroup *root)
+{
+	int depth = child->depth;
+
+	if (depth < root->depth)
+		return false;
+
+	while (depth-- != root->depth)
+		child = child->parent;
+
+	return (child == root);
+}
+
 #ifdef CONFIG_CGROUP_DEBUG
 static struct cgroup_subsys_state *debug_css_alloc(struct cgroup *cont)
 {
-- 
1.8.0.2
