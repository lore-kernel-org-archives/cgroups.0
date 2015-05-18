From: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v12 7/8] cgroup: add a tset_get_css macro
Date: Tue, 19 May 2015 00:51:06 +1000
Message-ID: <1431960667-26593-8-git-send-email-cyphar@cyphar.com>
References: <1431960667-26593-1-git-send-email-cyphar@cyphar.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431960667-26593-1-git-send-email-cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org
Cc: richard-/L3Ra7n9ekc@public.gmane.org, fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>

This adds a macro to get the css of a tset (using task_get_css()) by
just grabbing a ref to the first item in the tset (since there is a
guarantee that all tasks in a tset share a css).

This is in preparation for implementing the pids cgroup subsystem.

Signed-off-by: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
---
 include/linux/cgroup.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 886a883..773846d 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -639,6 +639,18 @@ struct task_struct *cgroup_taskset_next(struct cgroup_taskset *tset);
 	for ((task) = cgroup_taskset_first((tset)); (task);		\
 	     (task) = cgroup_taskset_next((tset)))
 
+/**
+ * tset_get_css - obtain and get css for (tset, subsys_id)
+ * @tset: target taskset
+ * @subsys_id: target subsystem id
+ *
+ * Since all of the tasks in a taskset are guaranteed to have the same css, it's
+ * safe to grab the ref of just the first task's css and treat it as though you
+ * have a ref on the taskset's "collective" css.
+ */
+#define tset_get_css(tset, subsys_id)					\
+	task_get_css(cgroup_taskset_first(tset), subsys_id)
+
 /*
  * Control Group subsystem type.
  * See Documentation/cgroups/cgroups.txt for details
-- 
2.4.1
