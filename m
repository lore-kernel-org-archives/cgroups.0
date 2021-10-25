From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/3] cgroup: reduce dependency on cgroup_mutex
Date: Sun, 24 Oct 2021 23:19:14 -0700
Message-ID: <20211025061916.3853623-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=AvgSYxSIhj04a4iCqNdbKAaA6wuU++C7nTwWAjHnasw=;
        b=QVvsNPaKhT9W53NjgKlg06MbBvd9TrNlBshp7HsaNKeoIz1bJqnkLVXhzhOWsN2Vlj
         pop9JnHT9hzums5WphcQ2wqzdyqcft6zVuQluJiJ73s/q1T6ZeECCAkLdB2mFirdJQx+
         twfqNsBynQUA7LbzAEX92775+jtyazZKF104dShVaD/QJTrIzYY8Ja7vL4vdVzaFrEbg
         0tTacCDqtp67YcJJgikaBVbmbD7FcpU2dyamb/nii+8MnA4mqXc28Eq9qjTxsTvjQ3iZ
         qckX6vYRQm3BAlbr6M9t2RodeUZdb1XjCCskiXWrBhp7ZFChl4oK/y9tjYR0u+06Dzcl
         1jqQ==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Currently cgroup_get_from_path() and cgroup_get_from_id() grab
cgroup_mutex before traversing the default hierarchy to find the
kernfs_node corresponding to the path/id and then extract the linked
cgroup. Since cgroup_mutex is still held, it is guaranteed that the
cgroup will be alive and the reference can be taken on it.

However similar guarantee can be provided without depending on the
cgroup_mutex and potentially reducing avenues of cgroup_mutex contentions.
The kernfs_node's priv pointer is RCU protected pointer and with just
rcu read lock we can grab the reference on the cgroup without
cgroup_mutex. So, remove cgroup_mutex from them.

Signed-off-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup/cgroup.c | 51 ++++++++++++++++++++++++------------------
 1 file changed, 29 insertions(+), 22 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 02e2ac83a94e..f8605caba7ed 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -5932,17 +5932,20 @@ struct cgroup *cgroup_get_from_id(u64 id)
 	struct kernfs_node *kn;
 	struct cgroup *cgrp = NULL;
 
-	mutex_lock(&cgroup_mutex);
 	kn = kernfs_find_and_get_node_by_id(cgrp_dfl_root.kf_root, id);
 	if (!kn)
-		goto out_unlock;
+		goto out;
+
+	rcu_read_lock();
 
-	cgrp = kn->priv;
-	if (cgroup_is_dead(cgrp) || !cgroup_tryget(cgrp))
+	cgrp = rcu_dereference(*(void __rcu __force **)&kn->priv);
+	if (cgrp && !cgroup_tryget(cgrp))
 		cgrp = NULL;
+
+	rcu_read_unlock();
+
 	kernfs_put(kn);
-out_unlock:
-	mutex_unlock(&cgroup_mutex);
+out:
 	return cgrp;
 }
 EXPORT_SYMBOL_GPL(cgroup_get_from_id);
@@ -6495,30 +6498,34 @@ struct cgroup_subsys_state *css_from_id(int id, struct cgroup_subsys *ss)
  *
  * Find the cgroup at @path on the default hierarchy, increment its
  * reference count and return it.  Returns pointer to the found cgroup on
- * success, ERR_PTR(-ENOENT) if @path doesn't exist and ERR_PTR(-ENOTDIR)
- * if @path points to a non-directory.
+ * success, ERR_PTR(-ENOENT) if @path doesn't exist or if the cgroup has already
+ * been released and ERR_PTR(-ENOTDIR) if @path points to a non-directory.
  */
 struct cgroup *cgroup_get_from_path(const char *path)
 {
 	struct kernfs_node *kn;
-	struct cgroup *cgrp;
-
-	mutex_lock(&cgroup_mutex);
+	struct cgroup *cgrp = ERR_PTR(-ENOENT);
 
 	kn = kernfs_walk_and_get(cgrp_dfl_root.cgrp.kn, path);
-	if (kn) {
-		if (kernfs_type(kn) == KERNFS_DIR) {
-			cgrp = kn->priv;
-			cgroup_get_live(cgrp);
-		} else {
-			cgrp = ERR_PTR(-ENOTDIR);
-		}
-		kernfs_put(kn);
-	} else {
-		cgrp = ERR_PTR(-ENOENT);
+	if (!kn)
+		goto out;
+
+	if (kernfs_type(kn) != KERNFS_DIR) {
+		cgrp = ERR_PTR(-ENOTDIR);
+		goto out_kernfs;
 	}
 
-	mutex_unlock(&cgroup_mutex);
+	rcu_read_lock();
+
+	cgrp = rcu_dereference(*(void __rcu __force **)&kn->priv);
+	if (!cgrp || !cgroup_tryget(cgrp))
+		cgrp = ERR_PTR(-ENOENT);
+
+	rcu_read_unlock();
+
+out_kernfs:
+	kernfs_put(kn);
+out:
 	return cgrp;
 }
 EXPORT_SYMBOL_GPL(cgroup_get_from_path);
-- 
2.33.0.1079.g6e70778dc9-goog

