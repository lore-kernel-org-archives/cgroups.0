From: riel@redhat.com
Subject: [PATCH 3/4] cpusets,isolcpus: add file to show isolated cpus in cpuset
Date: Mon,  9 Mar 2015 12:12:09 -0400
Message-ID: <1425917530-1771-4-git-send-email-riel@redhat.com>
References: <1425917530-1771-1-git-send-email-riel@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1425917530-1771-1-git-send-email-riel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj@kernel.org
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, lizefan@huawei.com, Rik van Riel <riel@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Clark Williams <williams@redhat.com>, Ingo Molnar <mingo@redhat.com>, Luiz Capitulino <lcapitulino@redhat.com>, David Rientjes <rientjes@google.com>, Mike Galbraith <umgwanakikbuti@gmail.com>

From: Rik van Riel <riel@redhat.com>

The previous patch makes it so the code skips over isolcpus when
building scheduler load balancing domains. This makes it hard to
see for a user which of the CPUs in a cpuset are participating in
load balancing, and which ones are isolated cpus.

Add a cpuset.isolcpus file with info on which cpus in a cpuset are
isolated CPUs.

This file is read-only for now. In the future we could extend things
so isolcpus can be changed at run time, for the root (system wide)
cpuset only.

Acked-by: David Rientjes <rientjes@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Clark Williams <williams@redhat.com>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Luiz Capitulino <lcapitulino@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: cgroups@vger.kernel.org
Signed-off-by: Rik van Riel <riel@redhat.com>
---
 kernel/cpuset.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index b544e5229d99..5462e1ca90bd 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1563,6 +1563,7 @@ typedef enum {
 	FILE_MEMORY_PRESSURE,
 	FILE_SPREAD_PAGE,
 	FILE_SPREAD_SLAB,
+	FILE_ISOLCPUS,
 } cpuset_filetype_t;
 
 static int cpuset_write_u64(struct cgroup_subsys_state *css, struct cftype *cft,
@@ -1704,6 +1705,16 @@ static ssize_t cpuset_write_resmask(struct kernfs_open_file *of,
 	return retval ?: nbytes;
 }
 
+/* protected by the lock in cpuset_common_seq_show */
+static cpumask_var_t print_isolated_cpus;
+
+static void cpuset_seq_print_isolcpus(struct seq_file *sf, struct cpuset *cs)
+{
+	cpumask_and(print_isolated_cpus, cs->cpus_allowed, cpu_isolated_map);
+
+	seq_printf(sf, "%*pbl\n", cpumask_pr_args(print_isolated_cpus));
+}
+
 /*
  * These ascii lists should be read in a single call, by using a user
  * buffer large enough to hold the entire map.  If read in smaller
@@ -1733,6 +1744,9 @@ static int cpuset_common_seq_show(struct seq_file *sf, void *v)
 	case FILE_EFFECTIVE_MEMLIST:
 		seq_printf(sf, "%*pbl\n", nodemask_pr_args(&cs->effective_mems));
 		break;
+	case FILE_ISOLCPUS:
+		cpuset_seq_print_isolcpus(sf, cs);
+		break;
 	default:
 		ret = -EINVAL;
 	}
@@ -1893,6 +1907,12 @@ static struct cftype files[] = {
 		.private = FILE_MEMORY_PRESSURE_ENABLED,
 	},
 
+	{
+		.name = "isolcpus",
+		.seq_show = cpuset_common_seq_show,
+		.private = FILE_ISOLCPUS,
+	},
+
 	{ }	/* terminate */
 };
 
@@ -2070,6 +2090,8 @@ int __init cpuset_init(void)
 		BUG();
 	if (!alloc_cpumask_var(&top_cpuset.effective_cpus, GFP_KERNEL))
 		BUG();
+	if (!alloc_cpumask_var(&print_isolated_cpus, GFP_KERNEL))
+		BUG();
 
 	cpumask_setall(top_cpuset.cpus_allowed);
 	nodes_setall(top_cpuset.mems_allowed);
-- 
2.1.0
