From: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [RFC PATCH bpf-next 2/8] cgroup: Enable task_under_cgroup_hierarchy() on cgroup1
Date: Fri, 22 Sep 2023 11:28:40 +0000
Message-ID: <20230922112846.4265-3-laoar.shao@gmail.com>
References: <20230922112846.4265-1-laoar.shao@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695382148; x=1695986948; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DtklZII5h1uoYCXRNe+Jd8s2AyutOaiGxtLZvkF5nNg=;
        b=clBXYtOSYXNPBpTEclQPQQ8+t6XK2x15ADB9Hsb8LeW8sNnP+2YVdHFGADMOuT6HJB
         NXiOG2WQRXMTA388pVk5YJxQdp/3XBIExf5Ycn9KcvdlM+WwBPI9JcsoesenTemAeb7b
         oEl7xz/eBMHtbVOeHLIOdN5MuuUCaIiaI+v+0TVx7z9H3C0Uyz5+163dglxeIxLtnA6r
         Vd0YbH66a/qHa1K/ofpA3fHfe755Ow4a4614XmtTA7Ul6U9Q1mZk5eyya/2NoY9uecjb
         UX55yMvvL4O8IW/sgRTTSh+xl2kJzccSD0G/qgAm2jF2B5eF9ioaLzoxspOgfdZiH4dY
         EO5g==
In-Reply-To: <20230922112846.4265-1-laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org, john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, martin.lau-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, song-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, yonghong.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, jolsa-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

At present, the task_under_cgroup_hierarchy() function serves the purpose
of determining whether a task resides exclusively within a cgroup2
hierarchy. However, considering the ongoing prevalence of cgroup1 and the
substantial effort and time required to migrate all cgroup1-based
applications to the cgroup2 framework, it becomes beneficial to make a
minor adjustment that expands its functionality to encompass cgroup1 as
well. By implementing this modification, we will gain the capability to
easily confirm a task's cgroup membership within BPF programs. For example,
we can effortlessly verify if a task belongs to a cgroup1 directory, such
as '/sys/fs/cgroup/cpu,cpuacct/kubepods/', or
'/sys/fs/cgroup/cpu,cpuacct/system.slice/'.

Signed-off-by: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 include/linux/cgroup-defs.h     | 20 ++++++++++++++++++++
 include/linux/cgroup.h          | 30 ++++++++++++++++++++++++++----
 kernel/cgroup/cgroup-internal.h | 20 --------------------
 3 files changed, 46 insertions(+), 24 deletions(-)

diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index f1b3151ac30b..5795825a04ff 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -299,6 +299,26 @@ struct css_set {
 	struct rcu_head rcu_head;
 };
 
+/*
+ * A cgroup can be associated with multiple css_sets as different tasks may
+ * belong to different cgroups on different hierarchies.  In the other
+ * direction, a css_set is naturally associated with multiple cgroups.
+ * This M:N relationship is represented by the following link structure
+ * which exists for each association and allows traversing the associations
+ * from both sides.
+ */
+struct cgrp_cset_link {
+	/* the cgroup and css_set this link associates */
+	struct cgroup		*cgrp;
+	struct css_set		*cset;
+
+	/* list of cgrp_cset_links anchored at cgrp->cset_links */
+	struct list_head	cset_link;
+
+	/* list of cgrp_cset_links anchored at css_set->cgrp_links */
+	struct list_head	cgrp_link;
+};
+
 struct cgroup_base_stat {
 	struct task_cputime cputime;
 
diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index b307013b9c6c..e16cfb98b44c 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -387,8 +387,8 @@ static inline void cgroup_unlock(void)
  * The caller can also specify additional allowed conditions via @__c, such
  * as locks used during the cgroup_subsys::attach() methods.
  */
-#ifdef CONFIG_PROVE_RCU
 extern spinlock_t css_set_lock;
+#ifdef CONFIG_PROVE_RCU
 #define task_css_set_check(task, __c)					\
 	rcu_dereference_check((task)->cgroups,				\
 		rcu_read_lock_sched_held() ||				\
@@ -543,15 +543,37 @@ static inline struct cgroup *cgroup_ancestor(struct cgroup *cgrp,
  * @ancestor: possible ancestor of @task's cgroup
  *
  * Tests whether @task's default cgroup hierarchy is a descendant of @ancestor.
- * It follows all the same rules as cgroup_is_descendant, and only applies
- * to the default hierarchy.
+ * It follows all the same rules as cgroup_is_descendant.
  */
 static inline bool task_under_cgroup_hierarchy(struct task_struct *task,
 					       struct cgroup *ancestor)
 {
 	struct css_set *cset = task_css_set(task);
+	struct cgrp_cset_link *link;
+	struct cgroup *cgrp = NULL;
+	bool ret = false;
+
+	if (ancestor->root == &cgrp_dfl_root)
+		return cgroup_is_descendant(cset->dfl_cgrp, ancestor);
+
+	if (cset == &init_css_set)
+		return ancestor == &ancestor->root->cgrp;
+
+	spin_lock_irq(&css_set_lock);
+	list_for_each_entry(link, &cset->cgrp_links, cgrp_link) {
+		struct cgroup *c = link->cgrp;
+
+		if (c->root == ancestor->root) {
+			cgrp = c;
+			break;
+		}
+	}
+	spin_unlock_irq(&css_set_lock);
 
-	return cgroup_is_descendant(cset->dfl_cgrp, ancestor);
+	WARN_ON_ONCE(!cgrp);
+	if (cgroup_is_descendant(cgrp, ancestor))
+		ret = true;
+	return ret;
 }
 
 /* no synchronization, the result can only be used as a hint */
diff --git a/kernel/cgroup/cgroup-internal.h b/kernel/cgroup/cgroup-internal.h
index c56071f150f2..620c60c9daa3 100644
--- a/kernel/cgroup/cgroup-internal.h
+++ b/kernel/cgroup/cgroup-internal.h
@@ -83,26 +83,6 @@ struct cgroup_file_ctx {
 	} procs1;
 };
 
-/*
- * A cgroup can be associated with multiple css_sets as different tasks may
- * belong to different cgroups on different hierarchies.  In the other
- * direction, a css_set is naturally associated with multiple cgroups.
- * This M:N relationship is represented by the following link structure
- * which exists for each association and allows traversing the associations
- * from both sides.
- */
-struct cgrp_cset_link {
-	/* the cgroup and css_set this link associates */
-	struct cgroup		*cgrp;
-	struct css_set		*cset;
-
-	/* list of cgrp_cset_links anchored at cgrp->cset_links */
-	struct list_head	cset_link;
-
-	/* list of cgrp_cset_links anchored at css_set->cgrp_links */
-	struct list_head	cgrp_link;
-};
-
 /* used to track tasks and csets during migration */
 struct cgroup_taskset {
 	/* the src and dst cset list running through cset->mg_node */
-- 
2.30.1 (Apple Git-130)

