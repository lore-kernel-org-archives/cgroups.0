From: Waiman Long <longman@redhat.com>
Subject: [PATCH v14 11/12] cpuset: Expose cpuset.cpus.subpartitions with cgroup_debug
Date: Mon, 15 Oct 2018 16:29:36 -0400
Message-ID: <1539635377-22335-12-git-send-email-longman@redhat.com>
References: <1539635377-22335-1-git-send-email-longman@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1539635377-22335-1-git-send-email-longman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Patrick Bellasi <patrick.bellasi@arm.com>, Tom Hromatka <tom.hromatka@oracle.com>, Waiman Long <longman@redhat.com>

For debugging purpose, it will be useful to expose the content of the
subparts_cpus as a read-only file to see if the code work correctly.
However, subparts_cpus will not be used at all in most use cases. So
adding a new cpuset file that clutters the cgroup directory may not be
desirable.  This is now being done by using the hidden "cgroup_debug"
kernel command line option to expose a new "cpuset.cpus.subpartitions"
file.

That option was originally used by the debug controller to expose
itself when configured into the kernel. This is now extended to set an
internal flag used by cgroup_addrm_files(). A new CFTYPE_DEBUG flag
can now be used to specify that a cgroup file should only be created
when the "cgroup_debug" option is specified.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 include/linux/cgroup-defs.h     |  1 +
 kernel/cgroup/cgroup-internal.h |  2 ++
 kernel/cgroup/cgroup.c          | 14 +++++++++++++-
 kernel/cgroup/cpuset.c          | 11 +++++++++++
 kernel/cgroup/debug.c           |  4 +---
 5 files changed, 28 insertions(+), 4 deletions(-)

diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index ff20b677fb9f..94c7a78dd563 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -91,6 +91,7 @@ enum {
 
 	CFTYPE_NO_PREFIX	= (1 << 3),	/* (DON'T USE FOR NEW FILES) no subsys prefix */
 	CFTYPE_WORLD_WRITABLE	= (1 << 4),	/* (DON'T USE FOR NEW FILES) S_IWUGO */
+	CFTYPE_DEBUG		= (1 << 5),	/* create when cgroup_debug */
 
 	/* internal flags, do not use outside cgroup core proper */
 	__CFTYPE_ONLY_ON_DFL	= (1 << 16),	/* only on default hierarchy */
diff --git a/kernel/cgroup/cgroup-internal.h b/kernel/cgroup/cgroup-internal.h
index 75568fcf2180..c950864016e2 100644
--- a/kernel/cgroup/cgroup-internal.h
+++ b/kernel/cgroup/cgroup-internal.h
@@ -11,6 +11,8 @@
 #define TRACE_CGROUP_PATH_LEN 1024
 extern spinlock_t trace_cgroup_path_lock;
 extern char trace_cgroup_path[TRACE_CGROUP_PATH_LEN];
+extern bool cgroup_debug;
+extern void __init enable_debug_cgroup(void);
 
 /*
  * cgroup_path() takes a spin lock. It is good practice not to take
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index aae10baf1902..067e48aaa7a3 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -85,6 +85,7 @@ EXPORT_SYMBOL_GPL(css_set_lock);
 
 DEFINE_SPINLOCK(trace_cgroup_path_lock);
 char trace_cgroup_path[TRACE_CGROUP_PATH_LEN];
+bool cgroup_debug __read_mostly;
 
 /*
  * Protects cgroup_idr and css_idr so that IDs can be released without
@@ -3616,7 +3617,8 @@ static int cgroup_addrm_files(struct cgroup_subsys_state *css,
 			continue;
 		if ((cft->flags & CFTYPE_ONLY_ON_ROOT) && cgroup_parent(cgrp))
 			continue;
-
+		if ((cft->flags & CFTYPE_DEBUG) && !cgroup_debug)
+			continue;
 		if (is_add) {
 			ret = cgroup_add_file(css, cgrp, cft);
 			if (ret) {
@@ -5695,6 +5697,16 @@ static int __init cgroup_disable(char *str)
 }
 __setup("cgroup_disable=", cgroup_disable);
 
+void __init __weak enable_debug_cgroup(void) { }
+
+static int __init enable_cgroup_debug(char *str)
+{
+	cgroup_debug = true;
+	enable_debug_cgroup();
+	return 1;
+}
+__setup("cgroup_debug", enable_cgroup_debug);
+
 /**
  * css_tryget_online_from_dir - get corresponding css from a cgroup dentry
  * @dentry: directory dentry of interest
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index b9832e355e36..34d47e43c98a 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2199,6 +2199,7 @@ typedef enum {
 	FILE_MEMLIST,
 	FILE_EFFECTIVE_CPULIST,
 	FILE_EFFECTIVE_MEMLIST,
+	FILE_SUBPARTS_CPULIST,
 	FILE_CPU_EXCLUSIVE,
 	FILE_MEM_EXCLUSIVE,
 	FILE_MEM_HARDWALL,
@@ -2380,6 +2381,9 @@ static int cpuset_common_seq_show(struct seq_file *sf, void *v)
 	case FILE_EFFECTIVE_MEMLIST:
 		seq_printf(sf, "%*pbl\n", nodemask_pr_args(&cs->effective_mems));
 		break;
+	case FILE_SUBPARTS_CPULIST:
+		seq_printf(sf, "%*pbl\n", cpumask_pr_args(cs->subparts_cpus));
+		break;
 	default:
 		ret = -EINVAL;
 	}
@@ -2585,6 +2589,13 @@ static struct cftype dfl_files[] = {
 		.flags = CFTYPE_NOT_ON_ROOT,
 	},
 
+	{
+		.name = "cpus.subpartitions",
+		.seq_show = cpuset_common_seq_show,
+		.private = FILE_SUBPARTS_CPULIST,
+		.flags = CFTYPE_DEBUG,
+	},
+
 	{ }	/* terminate */
 };
 
diff --git a/kernel/cgroup/debug.c b/kernel/cgroup/debug.c
index 9caeda610249..5f1b87330bee 100644
--- a/kernel/cgroup/debug.c
+++ b/kernel/cgroup/debug.c
@@ -373,11 +373,9 @@ struct cgroup_subsys debug_cgrp_subsys = {
  * On v2, debug is an implicit controller enabled by "cgroup_debug" boot
  * parameter.
  */
-static int __init enable_cgroup_debug(char *str)
+void __init enable_debug_cgroup(void)
 {
 	debug_cgrp_subsys.dfl_cftypes = debug_files;
 	debug_cgrp_subsys.implicit_on_dfl = true;
 	debug_cgrp_subsys.threaded = true;
-	return 1;
 }
-__setup("cgroup_debug", enable_cgroup_debug);
-- 
2.18.0

