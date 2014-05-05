From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH cgroup/for-3.15-fixes 1/2] cgroup: introduce
 task_css_is_root()
Date: Mon, 5 May 2014 18:35:57 -0400
Message-ID: <20140505223557.GU11231@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        bh=eXQmDDnDpHp7WrE4kI3i5kLlDUyiA1MLJc9SVBg58fE=;
        b=tnmNs9eiLWGvUx2d+N2RDSUUeDNilX5T76VAbEOzG/Mc0xv2wIz/PCcgM0BC0CsmSy
         wSMgpHTmsOCfkvaPRR5j6r73b/+82sOTEbK9dsvFQD4NjsVYd3VT/rumooLInEIjp1VZ
         FmP2d35DAHwsdNuxgUEphmARE2Tu1wMLg95/Nu36xRVTDgp78HtrXTiBO+jn5SCa4ILN
         Br5LqPX6n/9rAQ5r/PElvU3FTaVM+WVHO7AkYR6y2ey3ywZL4qm7Mcrica1wuktPvee8
         oOGdNEvQ+ud+jAGz90VmdOZ30DGUYWI/1Q00Oqy57gQA6iZTf++bfK37D2y7CH/XLJbX
         QrlA==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From fc4ef71935b1effe8612bfb39c7e3a41a2e2346c Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Date: Mon, 5 May 2014 18:35:12 -0400

Determining the css of a task usually requires RCU read lock as that's
the only thing which keeps the returned css accessible till its
reference is acquired; however, testing whether a task belongs to the
root can be performed without dereferencing the returned css by
comparing the returned pointer against the root one in init_css_set[]
which never changes.

Implement task_css_is_root() which can be invoked in any context.
This will be used by the scheduled cgroup_freezer change.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 include/linux/cgroup.h | 15 +++++++++++++++
 kernel/cgroup.c        |  3 ++-
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index c251585..d60904b 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -473,6 +473,7 @@ struct cftype {
 };
 
 extern struct cgroup_root cgrp_dfl_root;
+extern struct css_set init_css_set;
 
 static inline bool cgroup_on_dfl(const struct cgroup *cgrp)
 {
@@ -700,6 +701,20 @@ static inline struct cgroup_subsys_state *task_css(struct task_struct *task,
 	return task_css_check(task, subsys_id, false);
 }
 
+/**
+ * task_css_is_root - test whether a task belongs to the root css
+ * @task: the target task
+ * @subsys_id: the target subsystem ID
+ *
+ * Test whether @task belongs to the root css on the specified subsystem.
+ * May be invoked in any context.
+ */
+static inline bool task_css_is_root(struct task_struct *task, int subsys_id)
+{
+	return task_css_check(task, subsys_id, true) ==
+		init_css_set.subsys[subsys_id];
+}
+
 static inline struct cgroup *task_cgroup(struct task_struct *task,
 					 int subsys_id)
 {
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 11a03d6..7030b37 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -348,7 +348,7 @@ struct cgrp_cset_link {
  * reference-counted, to improve performance when child cgroups
  * haven't been created.
  */
-static struct css_set init_css_set = {
+struct css_set init_css_set = {
 	.refcount		= ATOMIC_INIT(1),
 	.cgrp_links		= LIST_HEAD_INIT(init_css_set.cgrp_links),
 	.tasks			= LIST_HEAD_INIT(init_css_set.tasks),
@@ -356,6 +356,7 @@ static struct css_set init_css_set = {
 	.mg_preload_node	= LIST_HEAD_INIT(init_css_set.mg_preload_node),
 	.mg_node		= LIST_HEAD_INIT(init_css_set.mg_node),
 };
+EXPORT_SYMBOL_GPL(init_css_set);
 
 static int css_set_count	= 1;	/* 1 for init_css_set */
 
-- 
1.9.0
