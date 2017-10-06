From: Waiman Long <longman@redhat.com>
Subject: [PATCH v3] cpuset: Enable cpuset controller in default hierarchy
Date: Fri,  6 Oct 2017 17:10:30 -0400
Message-ID: <1507324230-22996-1-git-send-email-longman@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, Mike Galbraith <efault@gmx.de>, Christian Brauner <christian.brauner@canonical.com>, =?UTF-8?q?St=C3=A9phane=20Graber?= <stgraber@ubuntu.com>, Serge Hallyn <serge@hallyn.com>, Waiman Long <longman@redhat.com>

Given the fact that thread mode had been merged into 4.14, it is now
time to enable cpuset to be used in the default hierarchy (cgroup v2)
as it is clearly threaded.

The cpuset controller had experienced feature creep since its
introduction more than a decade ago. Besides the core cpus and mems
control files to limit cpus and memory nodes, there are a bunch of
additional features that can be controlled from the userspace. Some of
the features are of doubtful usefulness and may not be actively used.

After examining the source code of some sample users like systemd,
libvirt and lxc for their use of those additional features, only
memory_migrate is used by libvirt.

This patch enables cpuset controller in the default hierarchy with a
minimal set of features. Currently, only memory_migrate is supported.
We can certainly add more features to the default hierarchy if there
is a real user need for them later on.

For features that are actually flags which are set internally, they are
being combined into a single "cpuset.flags" control file. That includes
the memory_migrate feature which is the only flag that is currently
supported. When the "cpuset.flags" file is read, it contains either
"+mem_migrate" (enabled) or "-mem_migrate" (disabled).

To enable it, use

  # echo +mem_migrate > cpuset.flags

To disable it, use

  # echo -mem_migrate > cpuset.flags

Note that the flag name is changed to "mem_migrate" for better naming
consistency.

v3:
 - Further trim the additional features down to just memory_migrate.
 - Update Documentation/cgroup-v2.txt.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 Documentation/cgroup-v2.txt | 122 ++++++++++++++++++++++++++++++++++++++++----
 kernel/cgroup/cpuset.c      | 112 +++++++++++++++++++++++++++++++++++++++-
 2 files changed, 223 insertions(+), 11 deletions(-)

diff --git a/Documentation/cgroup-v2.txt b/Documentation/cgroup-v2.txt
index 0bbdc72..f9fea87 100644
--- a/Documentation/cgroup-v2.txt
+++ b/Documentation/cgroup-v2.txt
@@ -48,15 +48,17 @@ v1 is available under Documentation/cgroup-v1/.
        5-2-1. Memory Interface Files
        5-2-2. Usage Guidelines
        5-2-3. Memory Ownership
-     5-3. IO
-       5-3-1. IO Interface Files
-       5-3-2. Writeback
-     5-4. PID
-       5-4-1. PID Interface Files
-     5-5. RDMA
-       5-5-1. RDMA Interface Files
-     5-6. Misc
-       5-6-1. perf_event
+     5-3. Cpuset
+       5.3-1. Cpuset Interface Files
+     5-4. IO
+       5-4-1. IO Interface Files
+       5-4-2. Writeback
+     5-5. PID
+       5-5-1. PID Interface Files
+     5-6. RDMA
+       5-6-1. RDMA Interface Files
+     5-7. Misc
+       5-7-1. perf_event
    6. Namespace
      6-1. Basics
      6-2. The Root and Views
@@ -1235,6 +1237,108 @@ POSIX_FADV_DONTNEED to relinquish the ownership of memory areas
 belonging to the affected files to ensure correct memory ownership.
 
 
+Cpuset
+------
+
+The "cpuset" controller provides a mechanism for constraining
+the CPU and memory node placement of tasks to only the resources
+specified in the cpuset interface files in a task's current cgroup.
+This is especially valuable on large NUMA systems where placing jobs
+on properly sized subsets of the systems with careful processor and
+memory placement to reduce cross-node memory access and contention
+can improve overall system performance.
+
+The "cpuset" controller is hierarchical.  That means the controller
+cannot use CPUs or memory nodes not allowed in its parent.
+
+
+Cpuset Interface Files
+~~~~~~~~~~~~~~~~~~~~~~
+
+  cpuset.cpus
+	A read-write multiple values file which exists on non-root
+	cgroups.
+
+	It lists the CPUs allowed to be used by tasks within this
+	cgroup.  The CPU numbers are comma-separated numbers or
+	ranges.  For example:
+
+	  # cat cpuset.cpus
+	  0-4,6,8-10
+
+	An empty value indicates that the cgroup is using the same
+	setting as the nearest cgroup ancestor with a non-empty
+	"cpuset.cpus" or all the available CPUs if none is found.
+
+	The value of "cpuset.cpus" stays constant until the next update
+	and won't be affected by any CPU hotplug events.
+
+  cpuset.effective_cpus
+	A read-only multiple values file which exists on non-root
+	cgroups.
+
+	It lists the onlined CPUs that are actually allowed to be
+	used by tasks within the current cgroup. It is a subset of
+	"cpuset.cpus". Its value will be affected by CPU hotplug
+	events.
+
+  cpuset.mems
+	A read-write multiple values file which exists on non-root
+	cgroups.
+
+	It lists the memory nodes allowed to be used by tasks within
+	this cgroup.  The memory node numbers are comma-separated
+	numbers or ranges.  For example:
+
+	  # cat cpuset.mems
+	  0-1,3
+
+	An empty value indicates that the cgroup is using the same
+	setting as the nearest cgroup ancestor with a non-empty
+	"cpuset.mems" or all the available memory nodes if none
+	is found.
+
+	The value of "cpuset.mems" stays constant until the next update
+	and won't be affected by any memory nodes hotplug events.
+
+  cpuset.effective_mems
+	A read-only multiple values file which exists on non-root
+	cgroups.
+
+	It lists the onlined memory nodes that are actually allowed
+	to be used by tasks within the current cgroup. It is a subset
+	of "cpuset.mems". Its value will be affected by memory nodes
+	hotplug events.
+
+  cpuset.flags
+	A read-write multiple values file which exists on non-root
+	cgroups.
+
+	It lists the flags that are set (with a '+' prefix) and those
+	that are not set (with a '-' prefix).	The currently supported
+	flag is:
+
+	  mem_migrate
+		When it is not set, an allocated memory page will
+		stay in whatever node it was allocated independent
+		of changes in "cpuset.mems".
+
+		When it is set, tasks with memory pages not in
+		"cpuset.mems" will have those pages migrated over to
+		memory nodes specified in "cpuset.mems".  Any changes
+		to "cpuset.mems" will cause pages in nodes that are
+		no longer valid to be migrated over to the newly
+		valid nodes.
+
+	To set a flag, use the '+' prefix:
+
+	  # echo +mem_migrate > cpuset.flags
+
+	To clear a flag, use the '-' prefix:
+
+	  # echo -mem_migrate > cpuset.flags
+
+
 IO
 --
 
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 4657e29..ee98b69 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1606,6 +1606,7 @@ static void cpuset_attach(struct cgroup_taskset *tset)
 	FILE_MEMORY_PRESSURE,
 	FILE_SPREAD_PAGE,
 	FILE_SPREAD_SLAB,
+	FILE_FLAGS,
 } cpuset_filetype_t;
 
 static int cpuset_write_u64(struct cgroup_subsys_state *css, struct cftype *cft,
@@ -1828,12 +1829,73 @@ static s64 cpuset_read_s64(struct cgroup_subsys_state *css, struct cftype *cft)
 	return 0;
 }
 
+static const struct {
+	char *name;
+	int  flag;
+} cpuset_flags[] = {
+	{ "mem_migrate", CS_MEMORY_MIGRATE },
+};
+
+static int cpuset_read_flags(struct seq_file *sf, void *v)
+{
+	struct cpuset *cs = css_cs(seq_css(sf));
+	unsigned long enabled = READ_ONCE(cs->flags);
+	int i, cnt;
+
+	for (i = cnt = 0; i < ARRAY_SIZE(cpuset_flags); i++) {
+		if (cnt++)
+			seq_putc(sf, ' ');
+		seq_printf(sf, "%c%s",
+			test_bit(cpuset_flags[i].flag, &enabled) ? '+' : '-',
+			cpuset_flags[i].name);
+	}
+	seq_putc(sf, '\n');
+	return 0;
+}
+
+static ssize_t cpuset_write_flags(struct kernfs_open_file *of,
+				     char *buf, size_t nbytes, loff_t off)
+{
+	struct cpuset *cs = css_cs(of_css(of));
+	unsigned long enable = 0, disable = 0;
+	char *tok;
+	int i;
+
+	/*
+	 * Parse input - space separated list of feature names prefixed
+	 * with either + or -.
+	 */
+	buf = strstrip(buf);
+	while ((tok = strsep(&buf, " "))) {
+		if (tok[0] == '\0')
+			continue;
+		for (i = 0; i < ARRAY_SIZE(cpuset_flags); i++)
+			if (!strcmp(tok + 1, cpuset_flags[i].name))
+				break;
+		if (i == ARRAY_SIZE(cpuset_flags))
+			return -EINVAL;
+		if (*tok == '+') {
+			enable  |= 1UL << cpuset_flags[i].flag;
+			disable &= 1UL << cpuset_flags[i].flag;
+		} else if (*tok == '-') {
+			disable |= 1UL << cpuset_flags[i].flag;
+			enable  &= 1UL << cpuset_flags[i].flag;
+		} else {
+			return -EINVAL;
+		}
+	}
+
+	enable |= READ_ONCE(cs->flags);
+	enable &= ~disable;
+	WRITE_ONCE(cs->flags, enable);
+	return nbytes;
+}
 
 /*
  * for the common functions, 'private' gives the type of file
  */
 
-static struct cftype files[] = {
+static struct cftype legacy_files[] = {
 	{
 		.name = "cpus",
 		.seq_show = cpuset_common_seq_show,
@@ -1936,6 +1998,50 @@ static s64 cpuset_read_s64(struct cgroup_subsys_state *css, struct cftype *cft)
 };
 
 /*
+ * This is currently a minimal set for the default hierarchy. It can be
+ * expanded later on by migrating more features and control files from v1.
+ */
+static struct cftype dfl_files[] = {
+	{
+		.name = "cpus",
+		.seq_show = cpuset_common_seq_show,
+		.write = cpuset_write_resmask,
+		.max_write_len = (100U + 6 * NR_CPUS),
+		.private = FILE_CPULIST,
+	},
+
+	{
+		.name = "mems",
+		.seq_show = cpuset_common_seq_show,
+		.write = cpuset_write_resmask,
+		.max_write_len = (100U + 6 * MAX_NUMNODES),
+		.private = FILE_MEMLIST,
+	},
+
+	{
+		.name = "effective_cpus",
+		.seq_show = cpuset_common_seq_show,
+		.private = FILE_EFFECTIVE_CPULIST,
+	},
+
+	{
+		.name = "effective_mems",
+		.seq_show = cpuset_common_seq_show,
+		.private = FILE_EFFECTIVE_MEMLIST,
+	},
+
+	{
+		.name = "flags",
+		.seq_show = cpuset_read_flags,
+		.write = cpuset_write_flags,
+		.private = FILE_FLAGS,
+	},
+
+	{ }	/* terminate */
+};
+
+
+/*
  *	cpuset_css_alloc - allocate a cpuset css
  *	cgrp:	control group that the new cpuset will be part of
  */
@@ -2109,8 +2215,10 @@ struct cgroup_subsys cpuset_cgrp_subsys = {
 	.post_attach	= cpuset_post_attach,
 	.bind		= cpuset_bind,
 	.fork		= cpuset_fork,
-	.legacy_cftypes	= files,
+	.legacy_cftypes	= legacy_files,
+	.dfl_cftypes	= dfl_files,
 	.early_init	= true,
+	.threaded	= true,
 };
 
 /**
-- 
1.8.3.1

