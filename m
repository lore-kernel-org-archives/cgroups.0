From: Rakib Mullick <rakib.mullick-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH]  Remove cpuset_update_active_cpus()'s parameter.
Date: Sun,  9 Apr 2017 07:36:14 +0600
Message-ID: <20170409013614.7138-1-rakib.mullick@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=spgWP1wuFX5M4FW3e0ajH6EJXYmtMmUdkpi3rM2j1io=;
        b=hYoHGjFa88zC7t6wrgrIMSMjLqSF1QUPANc9YfrEY+rEbg5mVSgq/buBJvQtwE51bM
         Pissf2UfUzp8smS2L5EnZFtrsi43iT+rbmGyP+G1DgTrEAdQY3RVsp7CIh8jseUne3Yk
         id7IUtQMICpR4b0yDeI/z7KcNMwFq3qXMGWVj9e/NNY7fVCDrMRClFJzuZJK9FiWKv2/
         ErulkOI7yRLWngfqDb3kO6Jzyb3VhCUH9T4qDGPtdfDynmakxpkbayXzUQ2BHSZ+7Wvk
         rt9jOX1Q46F66JzkRIQXgPoKN2gp2kWpfBPhZiOliIEOrJfg/OU9pAoYdYYQwHhtI3Kn
         VyOw==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Rakib Mullick <rakib.mullick-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

In cpuset_update_active_cpus(), cpu_online isn't used anymore. Remove
it.

Signed-off-by: Rakib Mullick<rakib.mullick-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 include/linux/cpuset.h | 4 ++--
 kernel/cgroup/cpuset.c | 2 +-
 kernel/sched/core.c    | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
index 611fce5..119a3f9 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -42,7 +42,7 @@ static inline void cpuset_dec(void)
 
 extern int cpuset_init(void);
 extern void cpuset_init_smp(void);
-extern void cpuset_update_active_cpus(bool cpu_online);
+extern void cpuset_update_active_cpus(void);
 extern void cpuset_cpus_allowed(struct task_struct *p, struct cpumask *mask);
 extern void cpuset_cpus_allowed_fallback(struct task_struct *p);
 extern nodemask_t cpuset_mems_allowed(struct task_struct *p);
@@ -155,7 +155,7 @@ static inline bool cpusets_enabled(void) { return false; }
 static inline int cpuset_init(void) { return 0; }
 static inline void cpuset_init_smp(void) {}
 
-static inline void cpuset_update_active_cpus(bool cpu_online)
+static inline void cpuset_update_active_cpus(void)
 {
 	partition_sched_domains(1, NULL, NULL);
 }
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 0f41292..d6e8ded 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2354,7 +2354,7 @@ static void cpuset_hotplug_workfn(struct work_struct *work)
 		rebuild_sched_domains();
 }
 
-void cpuset_update_active_cpus(bool cpu_online)
+void cpuset_update_active_cpus(void)
 {
 	/*
 	 * We're inside cpu hotplug critical region which usually nests
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 3b31fc0..430b046 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5732,7 +5732,7 @@ static void cpuset_cpu_active(void)
 		 * cpuset configurations.
 		 */
 	}
-	cpuset_update_active_cpus(true);
+	cpuset_update_active_cpus();
 }
 
 static int cpuset_cpu_inactive(unsigned int cpu)
@@ -5755,7 +5755,7 @@ static int cpuset_cpu_inactive(unsigned int cpu)
 
 		if (overflow)
 			return -EBUSY;
-		cpuset_update_active_cpus(false);
+		cpuset_update_active_cpus();
 	} else {
 		num_cpus_frozen++;
 		partition_sched_domains(1, NULL, NULL);
-- 
2.9.3
