From: "Pratik R. Sampat" <psampat@linux.ibm.com>
Subject: [RFC 3/5] cpuset/cpuns: Make cgroup CPUset CPU namespace aware
Date: Sat,  9 Oct 2021 20:42:41 +0530
Message-ID: <20211009151243.8825-4-psampat@linux.ibm.com>
References: <20211009151243.8825-1-psampat@linux.ibm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : subject :
 date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=qaKVf2iG3jJrJdTiPzN0ACJ6YGlKml1RY1+qmab/pd4=;
 b=aRTT0GYC6A4Rrx/GXzW1CpLNwxLZSD37TyFEKMyE63m57ioB3Eq7XPEBiYkOlAY3dIWV
 JL/FkNEhwfOC9ApafaVLAUKnPeUwbWupFndhQ7blr1/dENaZCFP0Zk768GUcedVxRpYX
 dTK/51ooNsf8P1u2Qrx7XOt3UaCATEmicaQW4awzjsbU5WoWsDAZYh3UwoHyNWFnoXNW
 jE8PvAb2ONsyycVQyiyt6e2DQOl6uqnsJEuNQwFFuOGGP2znlmeE3uKG1vUzj42uMQZs
 CXWoDPPr93PZiNNoWrE9sC8JiwlQHVBjljNIKh1RFqXxIQ1kmAE7pHrQXYth7UjEKhnV Cg== 
In-Reply-To: <20211009151243.8825-1-psampat@linux.ibm.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: bristot@redhat.com, christian@brauner.io, ebiederm@xmission.com, lizefan.x@bytedance.com, tj@kernel.org, hannes@cmpxchg.org, mingo@kernel.org, juri.lelli@redhat.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org, containers@lists.linux.dev, containers@lists.linux-foundation.org, psampat@linux.ibm.com, pratik.r.sampat@gmail.com

When a new cgroup is created or a cpuset is updated, the mask supplied
to it looks for its corresponding CPU translations for the restrictions
to apply on.

The patch also updates the display interface such that tasks within the
namespace can view the corresponding virtual CPUset based on the
requested CPU namespace context.

Signed-off-by: Pratik R. Sampat <psampat@linux.ibm.com>
---
 kernel/cgroup/cpuset.c | 57 +++++++++++++++++++++++++++++++++++++++---
 1 file changed, 54 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index adb5190c4429..eb1e950543cf 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -65,6 +65,7 @@
 #include <linux/mutex.h>
 #include <linux/cgroup.h>
 #include <linux/wait.h>
+#include <linux/cpu_namespace.h>
 
 DEFINE_STATIC_KEY_FALSE(cpusets_pre_enable_key);
 DEFINE_STATIC_KEY_FALSE(cpusets_enabled_key);
@@ -1061,8 +1062,19 @@ static void update_tasks_cpumask(struct cpuset *cs)
 	struct task_struct *task;
 
 	css_task_iter_start(&cs->css, 0, &it);
-	while ((task = css_task_iter_next(&it)))
+	while ((task = css_task_iter_next(&it))) {
+#ifdef CONFIG_CPU_NS
+		cpumask_t pcpus;
+		cpumask_t vcpus;
+
+		pcpus = get_pcpus_cpuns(current->nsproxy->cpu_ns, cs->effective_cpus);
+		vcpus = get_vcpus_cpuns(task->nsproxy->cpu_ns, &pcpus);
+		cpumask_copy(&task->nsproxy->cpu_ns->v_cpuset_cpus, &vcpus);
+		set_cpus_allowed_ptr(task, &pcpus);
+#else
 		set_cpus_allowed_ptr(task, cs->effective_cpus);
+#endif
+	}
 	css_task_iter_end(&it);
 }
 
@@ -2212,8 +2224,18 @@ static void cpuset_attach(struct cgroup_taskset *tset)
 		 * can_attach beforehand should guarantee that this doesn't
 		 * fail.  TODO: have a better way to handle failure here
 		 */
-		WARN_ON_ONCE(set_cpus_allowed_ptr(task, cpus_attach));
+#ifdef CONFIG_CPU_NS
+		cpumask_t pcpus;
+		cpumask_t vcpus;
 
+		pcpus = get_pcpus_cpuns(current->nsproxy->cpu_ns, cpus_attach);
+		vcpus = get_vcpus_cpuns(task->nsproxy->cpu_ns, &pcpus);
+		cpumask_copy(&task->nsproxy->cpu_ns->v_cpuset_cpus, &vcpus);
+
+		WARN_ON_ONCE(set_cpus_allowed_ptr(task, &pcpus));
+#else
+		WARN_ON_ONCE(set_cpus_allowed_ptr(task, cpus_attach));
+#endif
 		cpuset_change_task_nodemask(task, &cpuset_attach_nodemask_to);
 		cpuset_update_task_spread_flag(cs, task);
 	}
@@ -2436,13 +2458,33 @@ static int cpuset_common_seq_show(struct seq_file *sf, void *v)
 
 	switch (type) {
 	case FILE_CPULIST:
+#ifdef CONFIG_CPU_NS
+		if (current->nsproxy->cpu_ns == &init_cpu_ns) {
+			seq_printf(sf, "%*pbl\n",
+				   cpumask_pr_args(cs->cpus_allowed));
+		} else {
+			seq_printf(sf, "%*pbl\n",
+				   cpumask_pr_args(&current->nsproxy->cpu_ns->v_cpuset_cpus));
+		}
+#else
 		seq_printf(sf, "%*pbl\n", cpumask_pr_args(cs->cpus_allowed));
+#endif
 		break;
 	case FILE_MEMLIST:
 		seq_printf(sf, "%*pbl\n", nodemask_pr_args(&cs->mems_allowed));
 		break;
 	case FILE_EFFECTIVE_CPULIST:
+#ifdef CONFIG_CPU_NS
+		if (current->nsproxy->cpu_ns == &init_cpu_ns) {
+			seq_printf(sf, "%*pbl\n",
+				   cpumask_pr_args(cs->effective_cpus));
+		} else {
+			seq_printf(sf, "%*pbl\n",
+				   cpumask_pr_args(&current->nsproxy->cpu_ns->v_cpuset_cpus));
+		}
+#else
 		seq_printf(sf, "%*pbl\n", cpumask_pr_args(cs->effective_cpus));
+#endif
 		break;
 	case FILE_EFFECTIVE_MEMLIST:
 		seq_printf(sf, "%*pbl\n", nodemask_pr_args(&cs->effective_mems));
@@ -2884,9 +2926,18 @@ static void cpuset_bind(struct cgroup_subsys_state *root_css)
  */
 static void cpuset_fork(struct task_struct *task)
 {
+#ifdef CONFIG_CPU_NS
+	cpumask_t vcpus;
+#endif
+
 	if (task_css_is_root(task, cpuset_cgrp_id))
 		return;
-
+#ifdef CONFIG_CPU_NS
+	if (task->nsproxy->cpu_ns != &init_cpu_ns) {
+		vcpus = get_vcpus_cpuns(task->nsproxy->cpu_ns, current->cpus_ptr);
+		cpumask_copy(&task->nsproxy->cpu_ns->v_cpuset_cpus, &vcpus);
+	}
+#endif
 	set_cpus_allowed_ptr(task, current->cpus_ptr);
 	task->mems_allowed = current->mems_allowed;
 }
-- 
2.31.1

