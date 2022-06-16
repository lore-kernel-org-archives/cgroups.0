From: Lin Feng <linf-VqLewplIU37QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cgroup.c: add helper __cset_cgroup_from_root to cleanup duplicated codes
Date: Thu, 16 Jun 2022 18:38:30 +0800
Message-ID: <20220616103830.197458-1-linf@wangsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linf-VqLewplIU37QT0dZR+AlfA@public.gmane.org

No funtionality change, but save us some lines.

Signed-off-by: Lin Feng <linf-VqLewplIU37QT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup/cgroup.c | 58 ++++++++++++++++++++----------------------
 1 file changed, 27 insertions(+), 31 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 1779ccddb734..a8a46eb66f21 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -1376,6 +1376,31 @@ static void cgroup_destroy_root(struct cgroup_root *root)
 	cgroup_free_root(root);
 }
 
+static inline struct cgroup *__cset_cgroup_from_root(struct css_set *cset,
+					    struct cgroup_root *root)
+{
+	struct cgroup *res_cgroup = NULL;
+
+	if (cset == &init_css_set) {
+		res_cgroup = &root->cgrp;
+	} else if (root == &cgrp_dfl_root) {
+		res_cgroup = cset->dfl_cgrp;
+	} else {
+		struct cgrp_cset_link *link;
+
+		list_for_each_entry(link, &cset->cgrp_links, cgrp_link) {
+			struct cgroup *c = link->cgrp;
+
+			if (c->root == root) {
+				res_cgroup = c;
+				break;
+			}
+		}
+	}
+
+	return res_cgroup;
+}
+
 /*
  * look up cgroup associated with current task's cgroup namespace on the
  * specified hierarchy
@@ -1391,22 +1416,8 @@ current_cgns_cgroup_from_root(struct cgroup_root *root)
 	rcu_read_lock();
 
 	cset = current->nsproxy->cgroup_ns->root_cset;
-	if (cset == &init_css_set) {
-		res = &root->cgrp;
-	} else if (root == &cgrp_dfl_root) {
-		res = cset->dfl_cgrp;
-	} else {
-		struct cgrp_cset_link *link;
-
-		list_for_each_entry(link, &cset->cgrp_links, cgrp_link) {
-			struct cgroup *c = link->cgrp;
+	res = __cset_cgroup_from_root(cset, root);
 
-			if (c->root == root) {
-				res = c;
-				break;
-			}
-		}
-	}
 	rcu_read_unlock();
 
 	BUG_ON(!res);
@@ -1422,22 +1433,7 @@ static struct cgroup *cset_cgroup_from_root(struct css_set *cset,
 	lockdep_assert_held(&cgroup_mutex);
 	lockdep_assert_held(&css_set_lock);
 
-	if (cset == &init_css_set) {
-		res = &root->cgrp;
-	} else if (root == &cgrp_dfl_root) {
-		res = cset->dfl_cgrp;
-	} else {
-		struct cgrp_cset_link *link;
-
-		list_for_each_entry(link, &cset->cgrp_links, cgrp_link) {
-			struct cgroup *c = link->cgrp;
-
-			if (c->root == root) {
-				res = c;
-				break;
-			}
-		}
-	}
+	res = __cset_cgroup_from_root(cset, root);
 
 	BUG_ON(!res);
 	return res;
-- 
2.31.1

