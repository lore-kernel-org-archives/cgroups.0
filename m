From: Rik van Riel <riel@redhat.com>
Subject: [PATCH v4 2/2] cpusets,isolcpus: add file to show isolated cpus in
 cpuset
Date: Thu, 26 Feb 2015 12:12:31 -0500
Message-ID: <20150226121231.6fcba7e8@annuminas.surriel.com>
References: <1424882288-2910-1-git-send-email-riel@redhat.com>
	<1424882288-2910-3-git-send-email-riel@redhat.com>
	<54EEFE15.3010005@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <54EEFE15.3010005@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Zefan Li <lizefan@huawei.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, Clark Williams <williams@redhat.com>, Ingo Molnar <mingo@redhat.com>, Luiz Capitulino <lcapitulino@redhat.com>, David Rientjes <rientjes@google.com>, Mike Galbraith <umgwanakikbuti@gmail.com>, cgroups@vger.kernel.org

On Thu, 26 Feb 2015 19:05:57 +0800
Zefan Li <lizefan@huawei.com> wrote:

> Make it return -ENOMEM ? Or make it a global variable and allocate memory for it
> in cpuset_init().

Here you are. This addresses your concern, as well as the
issue David Rientjes found earlier.

---8<---

Subject: cpusets,isolcpus: add file to show isolated cpus in cpuset

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
