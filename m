From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2] cgroup: change cgroup_from_id() to css_from_id()
Date: Mon, 19 Aug 2013 10:05:24 +0800
Message-ID: <52117D64.1010709@huawei.com>
References: <520DCF2C.1020903@huawei.com> <20130816170659.GM2505@htj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130816170659.GM2505-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Now we want cgroup core to always provide the css to use to the
subsystems, so change this API to css_from_id().

Uninline css_from_id(), because it's getting bigger and cgroup_css()
has been unexported.

While at it, remove the #ifdef, and shuffle the order of the args.

Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---

v2: change the order of the args.

---
 include/linux/cgroup.h | 20 ++------------------
 kernel/cgroup.c        | 22 ++++++++++++++++++++++
 2 files changed, 24 insertions(+), 18 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 11a6419..3aac34d 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -742,27 +742,11 @@ static inline struct cgroup *task_cgroup(struct task_struct *task,
 	return task_css(task, subsys_id)->cgroup;
 }
 
-/**
- * cgroup_from_id - lookup cgroup by id
- * @ss: cgroup subsys to be looked into
- * @id: the cgroup id
- *
- * Returns the cgroup if there's valid one with @id, otherwise returns NULL.
- * Should be called under rcu_read_lock().
- */
-static inline struct cgroup *cgroup_from_id(struct cgroup_subsys *ss, int id)
-{
-#ifdef CONFIG_PROVE_RCU
-	rcu_lockdep_assert(rcu_read_lock_held() ||
-			   lockdep_is_held(&cgroup_mutex),
-			   "cgroup_from_id() needs proper protection");
-#endif
-	return idr_find(&ss->root->cgroup_idr, id);
-}
-
 struct cgroup_subsys_state *css_next_child(struct cgroup_subsys_state *pos,
 					   struct cgroup_subsys_state *parent);
 
+struct cgroup_subsys_state *css_from_id(int id, struct cgroup_subsys *ss);
+
 /**
  * css_for_each_child - iterate through children of a css
  * @pos: the css * to use as the loop cursor
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 99785d6..07740d3 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -5710,6 +5710,28 @@ struct cgroup_subsys_state *cgroup_css_from_dir(struct file *f, int id)
 	return css ? css : ERR_PTR(-ENOENT);
 }
 
+/**
+ * css_from_id - lookup css by id
+ * @id: the cgroup id
+ * @ss: cgroup subsys to be looked into
+ *
+ * Returns the css if there's valid one with @id, otherwise returns NULL.
+ * Should be called under rcu_read_lock().
+ */
+struct cgroup_subsys_state *css_from_id(int id, struct cgroup_subsys *ss)
+{
+	struct cgroup *cgrp;
+
+	rcu_lockdep_assert(rcu_read_lock_held() ||
+			   lockdep_is_held(&cgroup_mutex),
+			   "css_from_id() needs proper protection");
+
+	cgrp = idr_find(&ss->root->cgroup_idr, id);
+	if (cgrp)
+		return cgroup_css(cgrp, ss->subsys_id);
+	return NULL;
+}
+
 #ifdef CONFIG_CGROUP_DEBUG
 static struct cgroup_subsys_state *
 debug_css_alloc(struct cgroup_subsys_state *parent_css)
-- 
1.8.0.2
