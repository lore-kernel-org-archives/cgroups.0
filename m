From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/2][UPDATED] cgroup: make serial_nr_cursor available throughout
 cgroup.c
Date: Tue, 18 Jun 2013 18:53:53 +0800
Message-ID: <51C03C41.2040704@huawei.com>
References: <51C03AF2.7050702@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51C03AF2.7050702-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

The next patch will use it to determine if a cgroup is newly created
while we're iterating the cgroup hierarchy.

Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---

forgot to remove the old comment in cgroup_create().

---
 kernel/cgroup.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index e8a40e3..60383e8 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -198,6 +198,15 @@ static DEFINE_IDR(cgroup_hierarchy_idr);
 
 static struct cgroup_name root_cgroup_name = { .name = "/" };
 
+/*
+ * Assign a monotonically increasing serial number.  It guarantees
+ * cgroups with bigger numbers are newer than those with smaller
+ * numbers. Also with the list appending, it guarantees that sibling
+ * cgroups are always sorted in the ascending serial number order on
+ * the parent's ->children.
+ */
+static atomic64_t cgroup_serial_nr_cursor = ATOMIC64_INIT(0);
+
 /* This flag indicates whether tasks in the fork and exit paths should
  * check for fork/exit handlers to call. This avoids us having to do
  * extra work in the fork/exit path if none of the subsystems need to
@@ -4212,7 +4221,6 @@ static void offline_css(struct cgroup_subsys *ss, struct cgroup *cgrp)
 static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
 			     umode_t mode)
 {
-	static atomic64_t serial_nr_cursor = ATOMIC64_INIT(0);
 	struct cgroup *cgrp;
 	struct cgroup_name *name;
 	struct cgroupfs_root *root = parent->root;
@@ -4299,13 +4307,7 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
 		goto err_free_all;
 	lockdep_assert_held(&dentry->d_inode->i_mutex);
 
-	/*
-	 * Assign a monotonically increasing serial number.  With the list
-	 * appending below, it guarantees that sibling cgroups are always
-	 * sorted in the ascending serial number order on the parent's
-	 * ->children.
-	 */
-	cgrp->serial_nr = atomic64_inc_return(&serial_nr_cursor);
+	cgrp->serial_nr = atomic64_inc_return(&cgroup_serial_nr_cursor);
 
 	/* allocation complete, commit to creation */
 	list_add_tail(&cgrp->allcg_node, &root->allcg_list);
-- 
1.8.0.2
