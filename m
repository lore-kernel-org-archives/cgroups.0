From: Waiman Long <longman@redhat.com>
Subject: [PATCH v8 1/6] cpuset: Enable cpuset controller in default hierarchy
Date: Thu, 17 May 2018 16:55:40 -0400
Message-ID: <1526590545-3350-2-git-send-email-longman@redhat.com>
References: <1526590545-3350-1-git-send-email-longman@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1526590545-3350-1-git-send-email-longman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Waiman Long <longman@redhat.com>

Given the fact that thread mode had been merged into 4.14, it is now
time to enable cpuset to be used in the default hierarchy (cgroup v2)
as it is clearly threaded.

The cpuset controller had experienced feature creep since its
introduction more than a decade ago. Besides the core cpus and mems
control files to limit cpus and memory nodes, there are a bunch of
additional features that can be controlled from the userspace. Some of
the features are of doubtful usefulness and may not be actively used.

This patch enables cpuset controller in the default hierarchy with
a minimal set of features, namely just the cpus and mems and their
effective_* counterparts.  We can certainly add more features to the
default hierarchy in the future if there is a real user need for them
later on.

Alternatively, with the unified hiearachy, it may make more sense
to move some of those additional cpuset features, if desired, to
memory controller or may be to the cpu controller instead of staying
with cpuset.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 Documentation/cgroup-v2.txt | 90 ++++++++++++++++++++++++++++++++++++++++++---
 kernel/cgroup/cpuset.c      | 48 ++++++++++++++++++++++--
 2 files changed, 130 insertions(+), 8 deletions(-)

diff --git a/Documentation/cgroup-v2.txt b/Documentation/cgroup-v2.txt
index 74cdeae..cf7bac6 100644
--- a/Documentation/cgroup-v2.txt
+++ b/Documentation/cgroup-v2.txt
@@ -53,11 +53,13 @@ v1 is available under Documentation/cgroup-v1/.
        5-3-2. Writeback
      5-4. PID
        5-4-1. PID Interface Files
-     5-5. Device
-     5-6. RDMA
-       5-6-1. RDMA Interface Files
-     5-7. Misc
-       5-7-1. perf_event
+     5-5. Cpuset
+       5.5-1. Cpuset Interface Files
+     5-6. Device
+     5-7. RDMA
+       5-7-1. RDMA Interface Files
+     5-8. Misc
+       5-8-1. perf_event
      5-N. Non-normative information
        5-N-1. CPU controller root cgroup process behaviour
        5-N-2. IO controller root cgroup process behaviour
@@ -1435,6 +1437,84 @@ through fork() or clone(). These will return -EAGAIN if the creation
 of a new process would cause a cgroup policy to be violated.
 
 
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
+	cpuset-enabled cgroups.
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
+  cpuset.cpus.effective
+	A read-only multiple values file which exists on non-root
+	cpuset-enabled cgroups.
+
+	It lists the onlined CPUs that are actually allowed to be
+	used by tasks within the current cgroup.  If "cpuset.cpus"
+	is empty, it shows all the CPUs from the parent cgroup that
+	will be available to be used by this cgroup.  Otherwise, it is
+	a subset of "cpuset.cpus".  Its value will be affected by CPU
+	hotplug events.
+
+  cpuset.mems
+	A read-write multiple values file which exists on non-root
+	cpuset-enabled cgroups.
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
+  cpuset.mems.effective
+	A read-only multiple values file which exists on non-root
+	cpuset-enabled cgroups.
+
+	It lists the onlined memory nodes that are actually allowed to
+	be used by tasks within the current cgroup.  If "cpuset.mems"
+	is empty, it shows all the memory nodes from the parent cgroup
+	that will be available to be used by this cgroup.  Otherwise,
+	it is a subset of "cpuset.mems".  Its value will be affected
+	by memory nodes hotplug events.
+
+
 Device controller
 -----------------
 
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index b42037e..419b758 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1823,12 +1823,11 @@ static s64 cpuset_read_s64(struct cgroup_subsys_state *css, struct cftype *cft)
 	return 0;
 }
 
-
 /*
  * for the common functions, 'private' gives the type of file
  */
 
-static struct cftype files[] = {
+static struct cftype legacy_files[] = {
 	{
 		.name = "cpus",
 		.seq_show = cpuset_common_seq_show,
@@ -1931,6 +1930,47 @@ static s64 cpuset_read_s64(struct cgroup_subsys_state *css, struct cftype *cft)
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
+		.flags = CFTYPE_NOT_ON_ROOT,
+	},
+
+	{
+		.name = "mems",
+		.seq_show = cpuset_common_seq_show,
+		.write = cpuset_write_resmask,
+		.max_write_len = (100U + 6 * MAX_NUMNODES),
+		.private = FILE_MEMLIST,
+		.flags = CFTYPE_NOT_ON_ROOT,
+	},
+
+	{
+		.name = "cpus.effective",
+		.seq_show = cpuset_common_seq_show,
+		.private = FILE_EFFECTIVE_CPULIST,
+		.flags = CFTYPE_NOT_ON_ROOT,
+	},
+
+	{
+		.name = "mems.effective",
+		.seq_show = cpuset_common_seq_show,
+		.private = FILE_EFFECTIVE_MEMLIST,
+		.flags = CFTYPE_NOT_ON_ROOT,
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
@@ -2104,8 +2144,10 @@ struct cgroup_subsys cpuset_cgrp_subsys = {
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

