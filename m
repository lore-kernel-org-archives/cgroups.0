From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: [PATCH 3/4] Move part of cpuacct code
Date: Thu, 24 Nov 2011 23:33:25 -0200
Message-ID: <1322184806-20421-4-git-send-email-glommer@parallels.com>
References: <1322184806-20421-1-git-send-email-glommer@parallels.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1322184806-20421-1-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org, daniel.lezcano-GANU6spQydw@public.gmane.org, a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org, jbottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>

This patch is just a preparation patch for the next one in the series.
It moves the cpuacct structure definition and some helper functions early
in the file so we can access its members from here on.

Signed-off-by: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
CC: Paul Tuner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
CC: Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>
---
 kernel/sched.c |   77 +++++++++++++++++++++++++++----------------------------
 1 files changed, 38 insertions(+), 39 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index d504c7b..9b70305 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1596,6 +1596,44 @@ enum cpuacct_stat_index {
 };
 
 #ifdef CONFIG_CGROUP_CPUACCT
+/*
+ * CPU accounting code for task groups.
+ *
+ * Based on the work by Paul Menage (menage-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org) and Balbir Singh
+ * (balbir-xthvdsQ13ZrQT0dZR+AlfA@public.gmane.org).
+ */
+
+/* track cpu usage of a group of tasks and its child groups */
+struct cpuacct {
+	struct cgroup_subsys_state css;
+	/* cpuusage holds pointer to a u64-type object on every cpu */
+	u64 __percpu *cpuusage;
+	struct percpu_counter cpustat[CPUACCT_STAT_NSTATS];
+};
+
+struct cgroup_subsys cpuacct_subsys;
+
+/* return cpu accounting group corresponding to this container */
+static inline struct cpuacct *cgroup_ca(struct cgroup *cgrp)
+{
+	return container_of(cgroup_subsys_state(cgrp, cpuacct_subsys_id),
+			    struct cpuacct, css);
+}
+
+/* return cpu accounting group to which this task belongs */
+static inline struct cpuacct *task_ca(struct task_struct *tsk)
+{
+	return container_of(task_subsys_state(tsk, cpuacct_subsys_id),
+			    struct cpuacct, css);
+}
+
+static inline struct cpuacct *parent_ca(struct cpuacct *ca)
+{
+	if (!ca || !ca->css.cgroup->parent)
+		return NULL;
+	return cgroup_ca(ca->css.cgroup->parent);
+}
+
 static void cpuacct_charge(struct task_struct *tsk, u64 cputime);
 static void cpuacct_update_stats(struct task_struct *tsk,
 		enum cpuacct_stat_index idx, cputime_t val);
@@ -9495,45 +9533,6 @@ struct cgroup_subsys cpu_cgroup_subsys = {
 #endif	/* CONFIG_CGROUP_SCHED */
 
 #ifdef CONFIG_CGROUP_CPUACCT
-
-/*
- * CPU accounting code for task groups.
- *
- * Based on the work by Paul Menage (menage-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org) and Balbir Singh
- * (balbir-xthvdsQ13ZrQT0dZR+AlfA@public.gmane.org).
- */
-
-/* track cpu usage of a group of tasks and its child groups */
-struct cpuacct {
-	struct cgroup_subsys_state css;
-	/* cpuusage holds pointer to a u64-type object on every cpu */
-	u64 __percpu *cpuusage;
-	struct percpu_counter cpustat[CPUACCT_STAT_NSTATS];
-};
-
-struct cgroup_subsys cpuacct_subsys;
-
-/* return cpu accounting group corresponding to this container */
-static inline struct cpuacct *cgroup_ca(struct cgroup *cgrp)
-{
-	return container_of(cgroup_subsys_state(cgrp, cpuacct_subsys_id),
-			    struct cpuacct, css);
-}
-
-/* return cpu accounting group to which this task belongs */
-static inline struct cpuacct *task_ca(struct task_struct *tsk)
-{
-	return container_of(task_subsys_state(tsk, cpuacct_subsys_id),
-			    struct cpuacct, css);
-}
-
-static inline struct cpuacct *parent_ca(struct cpuacct *ca)
-{
-	if (!ca || !ca->css.cgroup->parent)
-		return NULL;
-	return cgroup_ca(ca->css.cgroup->parent);
-}
-
 /* create a new cpu accounting group */
 static struct cgroup_subsys_state *cpuacct_create(
 	struct cgroup_subsys *ss, struct cgroup *cgrp)
-- 
1.7.6.4

--
To unsubscribe from this list: send the line "unsubscribe cgroups" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
