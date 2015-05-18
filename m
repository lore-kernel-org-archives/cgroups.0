From: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v12 5/8] cgroup: move enum cgroup_subsys_id definition
Date: Tue, 19 May 2015 00:51:04 +1000
Message-ID: <1431960667-26593-6-git-send-email-cyphar@cyphar.com>
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

This is in preparation for implementing the pids cgroup subsystem. It is
not a functional change and should not change any behavior.

Signed-off-by: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
---
 include/linux/cgroup.h | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index e7da0aa..35ba593 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -25,6 +25,14 @@
 
 #ifdef CONFIG_CGROUPS
 
+/* define the enumeration of all cgroup subsystems */
+#define SUBSYS(_x) _x ## _cgrp_id,
+enum cgroup_subsys_id {
+#include <linux/cgroup_subsys.h>
+	CGROUP_SUBSYS_COUNT,
+};
+#undef SUBSYS
+
 struct cgroup_root;
 struct cgroup_subsys;
 struct cgroup;
@@ -40,14 +48,6 @@ extern int cgroupstats_build(struct cgroupstats *stats,
 extern int proc_cgroup_show(struct seq_file *m, struct pid_namespace *ns,
 			    struct pid *pid, struct task_struct *tsk);
 
-/* define the enumeration of all cgroup subsystems */
-#define SUBSYS(_x) _x ## _cgrp_id,
-enum cgroup_subsys_id {
-#include <linux/cgroup_subsys.h>
-	CGROUP_SUBSYS_COUNT,
-};
-#undef SUBSYS
-
 /*
  * Per-subsystem/per-cgroup state maintained by the system.  This is the
  * fundamental structural building block that controllers deal with.
-- 
2.4.1
