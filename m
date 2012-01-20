From: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Subject: [PATCH 2/2] cgroup: move struct cgroup_pidlist out from the header
 file
Date: Fri, 20 Jan 2012 11:58:43 +0800
Message-ID: <4F18E673.9070306@cn.fujitsu.com>
References: <4F18E651.2000109@cn.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F18E651.2000109-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

It's internally used only.

Signed-off-by: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
---
 include/linux/cgroup.h |   32 --------------------------------
 kernel/cgroup.c        |   32 ++++++++++++++++++++++++++++++++
 2 files changed, 32 insertions(+), 32 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index dee53bd..7da3e74 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -160,38 +160,6 @@ enum {
 	CGRP_CLONE_CHILDREN,
 };
 
-/* which pidlist file are we talking about? */
-enum cgroup_filetype {
-	CGROUP_FILE_PROCS,
-	CGROUP_FILE_TASKS,
-};
-
-/*
- * A pidlist is a list of pids that virtually represents the contents of one
- * of the cgroup files ("procs" or "tasks"). We keep a list of such pidlists,
- * a pair (one each for procs, tasks) for each pid namespace that's relevant
- * to the cgroup.
- */
-struct cgroup_pidlist {
-	/*
-	 * used to find which pidlist is wanted. doesn't change as long as
-	 * this particular list stays in the list.
-	 */
-	struct { enum cgroup_filetype type; struct pid_namespace *ns; } key;
-	/* array of xids */
-	pid_t *list;
-	/* how many elements the above list has */
-	int length;
-	/* how many files are using the current array */
-	int use_count;
-	/* each of these stored in a list by its cgroup */
-	struct list_head links;
-	/* pointer to the cgroup we belong to, for list removal purposes */
-	struct cgroup *owner;
-	/* protects the other fields */
-	struct rw_semaphore mutex;
-};
-
 struct cgroup {
 	unsigned long flags;		/* "unsigned long" so bitops work */
 
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index a5d3b53..6ca7aca 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -3043,6 +3043,38 @@ int cgroup_scan_tasks(struct cgroup_scanner *scan)
  *
  */
 
+/* which pidlist file are we talking about? */
+enum cgroup_filetype {
+	CGROUP_FILE_PROCS,
+	CGROUP_FILE_TASKS,
+};
+
+/*
+ * A pidlist is a list of pids that virtually represents the contents of one
+ * of the cgroup files ("procs" or "tasks"). We keep a list of such pidlists,
+ * a pair (one each for procs, tasks) for each pid namespace that's relevant
+ * to the cgroup.
+ */
+struct cgroup_pidlist {
+	/*
+	 * used to find which pidlist is wanted. doesn't change as long as
+	 * this particular list stays in the list.
+	*/
+	struct { enum cgroup_filetype type; struct pid_namespace *ns; } key;
+	/* array of xids */
+	pid_t *list;
+	/* how many elements the above list has */
+	int length;
+	/* how many files are using the current array */
+	int use_count;
+	/* each of these stored in a list by its cgroup */
+	struct list_head links;
+	/* pointer to the cgroup we belong to, for list removal purposes */
+	struct cgroup *owner;
+	/* protects the other fields */
+	struct rw_semaphore mutex;
+};
+
 /*
  * The following two functions "fix" the issue where there are more pids
  * than kmalloc will give memory for; in such cases, we use vmalloc/vfree.
-- 
1.7.3.1
