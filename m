From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH cgroup/for-4.14] cgroup: misc changes
Date: Fri, 11 Aug 2017 05:53:35 -0700
Message-ID: <20170811125335.GA2999988@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=EB9lHQG/hoSMEZWoh9Zd+dui8+1WQTBSvXOKG3vRZRQ=;
        b=Ond1k4q2jYfCuLa3irCjlnIfPqkF0Ap9QuEZjgwCq5XS+QxHr/7RI9ib/3kuCfB1X/
         bN59RYlMERL3+GkmRwHxhgUszTlfqg/yEK3ULQt0sHPABF0Cjj4on7h8Y2IP1b6nxmtv
         dujOr7GOnbOvzb00orNLHXA1R9FjI2o+3MfWVT8lxtAYMbteITIt3A7lO2iNrG/DQcnc
         s1URme+1v3N2PAWS3ijuBGygy97Ss4mA12f9K3RxVeTrvK7ag56qrDIiXjknIF/wn5OC
         wNQprniPvu6O5Ca5NKqPiBKTZ/3sWqShF6Zd11JOavPWlt4ZK0IU4uhSZDAD8qXDhbz6
         4YKg==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From 3e48930cc74f0c212ee1838f89ad0ca7fcf2fea1 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Date: Fri, 11 Aug 2017 05:49:01 -0700

Misc trivial changes to prepare for future changes.  No functional
difference.

* Expose cgroup_get(), cgroup_tryget() and cgroup_parent().

* Implement task_dfl_cgroup() which dereferences css_set->dfl_cgrp.

* Rename cgroup_stats_show() to cgroup_stat_show() for consistency
  with the file name.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
Applied to cgroup/for-4.14.

Thanks.

 include/linux/cgroup.h | 24 ++++++++++++++++++++++++
 kernel/cgroup/cgroup.c | 23 ++---------------------
 2 files changed, 26 insertions(+), 21 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 79faa64..085056e 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -398,6 +398,16 @@ static inline void css_put_many(struct cgroup_subsys_state *css, unsigned int n)
 		percpu_ref_put_many(&css->refcnt, n);
 }
 
+static inline void cgroup_get(struct cgroup *cgrp)
+{
+	css_get(&cgrp->self);
+}
+
+static inline bool cgroup_tryget(struct cgroup *cgrp)
+{
+	return css_tryget(&cgrp->self);
+}
+
 static inline void cgroup_put(struct cgroup *cgrp)
 {
 	css_put(&cgrp->self);
@@ -510,6 +520,20 @@ static inline struct cgroup *task_cgroup(struct task_struct *task,
 	return task_css(task, subsys_id)->cgroup;
 }
 
+static inline struct cgroup *task_dfl_cgroup(struct task_struct *task)
+{
+	return task_css_set(task)->dfl_cgrp;
+}
+
+static inline struct cgroup *cgroup_parent(struct cgroup *cgrp)
+{
+	struct cgroup_subsys_state *parent_css = cgrp->self.parent;
+
+	if (parent_css)
+		return container_of(parent_css, struct cgroup, self);
+	return NULL;
+}
+
 /**
  * cgroup_is_descendant - test ancestry
  * @cgrp: the cgroup to be tested
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index f5ca55d..c038ccf 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -319,15 +319,6 @@ static void cgroup_idr_remove(struct idr *idr, int id)
 	spin_unlock_bh(&cgroup_idr_lock);
 }
 
-static struct cgroup *cgroup_parent(struct cgroup *cgrp)
-{
-	struct cgroup_subsys_state *parent_css = cgrp->self.parent;
-
-	if (parent_css)
-		return container_of(parent_css, struct cgroup, self);
-	return NULL;
-}
-
 static bool cgroup_has_tasks(struct cgroup *cgrp)
 {
 	return cgrp->nr_populated_csets;
@@ -534,22 +525,12 @@ struct cgroup_subsys_state *cgroup_get_e_css(struct cgroup *cgrp,
 	return css;
 }
 
-static void __maybe_unused cgroup_get(struct cgroup *cgrp)
-{
-	css_get(&cgrp->self);
-}
-
 static void cgroup_get_live(struct cgroup *cgrp)
 {
 	WARN_ON_ONCE(cgroup_is_dead(cgrp));
 	css_get(&cgrp->self);
 }
 
-static bool cgroup_tryget(struct cgroup *cgrp)
-{
-	return css_tryget(&cgrp->self);
-}
-
 struct cgroup_subsys_state *of_css(struct kernfs_open_file *of)
 {
 	struct cgroup *cgrp = of->kn->parent->priv;
@@ -3306,7 +3287,7 @@ static int cgroup_events_show(struct seq_file *seq, void *v)
 	return 0;
 }
 
-static int cgroup_stats_show(struct seq_file *seq, void *v)
+static int cgroup_stat_show(struct seq_file *seq, void *v)
 {
 	struct cgroup *cgroup = seq_css(seq)->cgroup;
 
@@ -4423,7 +4404,7 @@ static struct cftype cgroup_base_files[] = {
 	},
 	{
 		.name = "cgroup.stat",
-		.seq_show = cgroup_stats_show,
+		.seq_show = cgroup_stat_show,
 	},
 	{ }	/* terminate */
 };
-- 
2.9.3
