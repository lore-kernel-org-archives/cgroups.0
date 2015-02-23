From: riel@redhat.com
Subject: [PATCH 2/2] cpusets,isolcpus: add file to show isolated cpus in cpuset
Date: Mon, 23 Feb 2015 16:45:06 -0500
Message-ID: <1424727906-4460-3-git-send-email-riel@redhat.com>
References: <1424727906-4460-1-git-send-email-riel@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1424727906-4460-1-git-send-email-riel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: Rik van Riel <riel@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Clark Williams <williams@redhat.com>, Li Zefan <lizefan@huawei.com>, Ingo Molnar <mingo@redhat.com>, Luiz Capitulino <lcapitulino@redhat.com>, cgroups@vger.kernel.org

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

Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Clark Williams <williams@redhat.com>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Luiz Capitulino <lcapitulino@redhat.com>
Cc: cgroups@vger.kernel.org
Signed-off-by: Rik van Riel <riel@redhat.com>
---
 kernel/cpuset.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 1ad63fa37cb4..19ad5d3377f8 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1563,6 +1563,7 @@ typedef enum {
 	FILE_MEMORY_PRESSURE,
 	FILE_SPREAD_PAGE,
 	FILE_SPREAD_SLAB,
+	FILE_ISOLCPUS,
 } cpuset_filetype_t;
 
 static int cpuset_write_u64(struct cgroup_subsys_state *css, struct cftype *cft,
@@ -1704,6 +1705,23 @@ static ssize_t cpuset_write_resmask(struct kernfs_open_file *of,
 	return retval ?: nbytes;
 }
 
+static size_t cpuset_sprintf_isolcpus(char *s, ssize_t pos, struct cpuset *cs)
+{
+	cpumask_var_t my_isolated_cpus;
+	ssize_t count;
+	
+	if (!alloc_cpumask_var(&my_isolated_cpus, GFP_KERNEL))
+		return 0;
+
+	cpumask_and(my_isolated_cpus, cs->cpus_allowed, cpu_isolated_map);
+
+	count = cpulist_scnprintf(s, pos, my_isolated_cpus);
+
+	free_cpumask_var(my_isolated_cpus);
+
+	return count;
+}
+
 /*
  * These ascii lists should be read in a single call, by using a user
  * buffer large enough to hold the entire map.  If read in smaller
@@ -1738,6 +1756,9 @@ static int cpuset_common_seq_show(struct seq_file *sf, void *v)
 	case FILE_EFFECTIVE_MEMLIST:
 		s += nodelist_scnprintf(s, count, cs->effective_mems);
 		break;
+	case FILE_ISOLCPUS:
+		s += cpuset_sprintf_isolcpus(s, count, cs);
+		break;
 	default:
 		ret = -EINVAL;
 		goto out_unlock;
@@ -1906,6 +1927,12 @@ static struct cftype files[] = {
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
 
-- 
1.9.3
