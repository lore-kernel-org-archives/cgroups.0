From: Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 2/2] cpusets,isolcpus: add file to show isolated cpus in
 cpuset
Date: Wed, 25 Feb 2015 16:32:31 -0500
Message-ID: <20150225163231.74aa78d5@cuia.bos.redhat.com>
References: <1424882288-2910-1-git-send-email-riel@redhat.com>
	<1424882288-2910-3-git-send-email-riel@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1424882288-2910-3-git-send-email-riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Clark Williams <williams-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Luiz Capitulino <lcapitulino-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

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

Acked-by: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Clark Williams <williams-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Luiz Capitulino <lcapitulino-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Signed-off-by: Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
OK, I suck. Thanks to David Rientjes for spotting the silly mistake.

 kernel/cpuset.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index b544e5229d99..455df101ceec 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1563,6 +1563,7 @@ typedef enum {
 	FILE_MEMORY_PRESSURE,
 	FILE_SPREAD_PAGE,
 	FILE_SPREAD_SLAB,
+	FILE_ISOLCPUS,
 } cpuset_filetype_t;
 
 static int cpuset_write_u64(struct cgroup_subsys_state *css, struct cftype *cft,
@@ -1704,6 +1705,20 @@ static ssize_t cpuset_write_resmask(struct kernfs_open_file *of,
 	return retval ?: nbytes;
 }
 
+static void cpuset_seq_print_isolcpus(struct seq_file *sf, struct cpuset *cs)
+{
+	cpumask_var_t my_isolated_cpus;
+
+	if (!alloc_cpumask_var(&my_isolated_cpus, GFP_KERNEL))
+		return;
+
+	cpumask_and(my_isolated_cpus, cs->cpus_allowed, cpu_isolated_map);
+
+	seq_printf(sf, "%*pbl\n", cpumask_pr_args(my_isolated_cpus));
+
+	free_cpumask_var(my_isolated_cpus);
+}
+
 /*
  * These ascii lists should be read in a single call, by using a user
  * buffer large enough to hold the entire map.  If read in smaller
@@ -1733,6 +1748,9 @@ static int cpuset_common_seq_show(struct seq_file *sf, void *v)
 	case FILE_EFFECTIVE_MEMLIST:
 		seq_printf(sf, "%*pbl\n", nodemask_pr_args(&cs->effective_mems));
 		break;
+	case FILE_ISOLCPUS:
+		cpuset_seq_print_isolcpus(sf, cs);
+		break;
 	default:
 		ret = -EINVAL;
 	}
@@ -1893,6 +1911,12 @@ static struct cftype files[] = {
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
 
