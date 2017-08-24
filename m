From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2] cpuset: Allow cpuset controller in default hierarchy
Date: Thu, 24 Aug 2017 15:59:32 -0400
Message-ID: <1503604772-24815-1-git-send-email-longman@redhat.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Galbraith <efault-Mmb7MZpHnFY@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Given the fact that thread mode is now queued for 4.14, it is now
time to enable cpuset to be used in the default hierarchy (cgroup v2)
as it is clearly threaded.

While we are at it, the following changes are also made for v2:

 1) The "cpu_exclusive" and "mem_exclusive" files are no longer
    supported.  An application can always perform exclusive
    partitioning of CPUs and memory by itself without using either
    cpu_exclusive or mem_exclusive.

 2) The "mem_hardwall", "memory_migrate", "memory_spread_page",
    "memory_spread_slab" and "sched_load_balance" files are now
    collapsed into a single "features" file where each of these
    features can be enabled or disabled by specifying the feature name
    with a '+' or '-' prefix, just like the "cgroup.subtree_control"
    fie.  On read, both the enabled and disabled features will be
    shown so that the users will know what options are available for
    them to set.

 3) All cpuset control file or feature names with a "memory"
    substring in them are renamed to just "mem" to be consistent with
    each others.

Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup/cpuset.c | 146 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 144 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 84ba237..fba6e9b 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1597,6 +1597,7 @@ static void cpuset_attach(struct cgroup_taskset *tset)
 	FILE_MEMORY_PRESSURE,
 	FILE_SPREAD_PAGE,
 	FILE_SPREAD_SLAB,
+	FILE_FEATURES,
 } cpuset_filetype_t;
 
 static int cpuset_write_u64(struct cgroup_subsys_state *css, struct cftype *cft,
@@ -1819,12 +1820,89 @@ static s64 cpuset_read_s64(struct cgroup_subsys_state *css, struct cftype *cft)
 	return 0;
 }
 
+static const struct {
+	char *name;
+	int  flag;
+} cpuset_features[] = {
+	{ "mem_hardwall",	  CS_MEM_HARDWALL,	 },
+	{ "mem_migrate",	  CS_MEMORY_MIGRATE,	 },
+	{ "mem_spread_page",	  CS_SPREAD_PAGE,	 },
+	{ "mem_spread_slab",	  CS_SPREAD_SLAB,	 },
+	{ "sched_load_balance",	  CS_SCHED_LOAD_BALANCE, },
+};
+
+static int cpuset_read_features(struct seq_file *sf, void *v)
+{
+	struct cpuset *cs = css_cs(seq_css(sf));
+	unsigned long enabled = READ_ONCE(cs->flags);
+	unsigned long disabled = ~enabled;
+	int i, cnt;
+
+	seq_puts(sf, "Enabled:  ");
+	for (i = cnt = 0; i < ARRAY_SIZE(cpuset_features); i++) {
+		if (test_bit(cpuset_features[i].flag, &enabled)) {
+			if (cnt++)
+				seq_putc(sf, ' ');
+			seq_puts(sf, cpuset_features[i].name);
+		}
+	}
+
+	seq_puts(sf, "\nDisabled: ");
+	for (i = cnt = 0; i < ARRAY_SIZE(cpuset_features); i++) {
+		if (test_bit(cpuset_features[i].flag, &disabled)) {
+			if (cnt++)
+				seq_puts(sf, " ");
+			seq_puts(sf, cpuset_features[i].name);
+		}
+	}
+
+	seq_putc(sf, '\n');
+	return 0;
+}
+
+static ssize_t cpuset_write_features(struct kernfs_open_file *of,
+				     char *buf, size_t nbytes, loff_t off)
+{
+	struct cpuset *cs = css_cs(of_css(of));
+	unsigned long enable = 0, disable = 0;
+	char *tok;
+	int i;
+
+	/*
+	 * Parse input - space seperated list of feature names prefixed
+	 * with either + or -.
+	 */
+	buf = strstrip(buf);
+	while ((tok = strsep(&buf, " "))) {
+		if (tok[0] == '\0')
+			continue;
+		for (i = 0; i < ARRAY_SIZE(cpuset_features); i++)
+			if (!strcmp(tok + 1, cpuset_features[i].name))
+				break;
+		if (i == ARRAY_SIZE(cpuset_features))
+			return -EINVAL;
+		if (*tok == '+') {
+			enable  |= 1UL << cpuset_features[i].flag;
+			disable &= 1UL << cpuset_features[i].flag;
+		} else if (*tok == '-') {
+			disable |= 1UL << cpuset_features[i].flag;
+			enable  &= 1UL << cpuset_features[i].flag;
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
@@ -1926,6 +2004,68 @@ static s64 cpuset_read_s64(struct cgroup_subsys_state *css, struct cftype *cft)
 	{ }	/* terminate */
 };
 
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
+		.name = "features",
+		.seq_show = cpuset_read_features,
+		.write = cpuset_write_features,
+		.private = FILE_FEATURES,
+	},
+
+	{
+		.name = "sched_relax_domain_level",
+		.read_s64 = cpuset_read_s64,
+		.write_s64 = cpuset_write_s64,
+		.private = FILE_SCHED_RELAX_DOMAIN_LEVEL,
+	},
+
+	{
+		.name = "mem_pressure",
+		.read_u64 = cpuset_read_u64,
+		.private = FILE_MEMORY_PRESSURE,
+	},
+
+	{
+		.name = "mem_pressure_enabled",
+		.flags = CFTYPE_ONLY_ON_ROOT,
+		.read_u64 = cpuset_read_u64,
+		.write_u64 = cpuset_write_u64,
+		.private = FILE_MEMORY_PRESSURE_ENABLED,
+	},
+
+
+	{ }	/* terminate */
+};
+
+
 /*
  *	cpuset_css_alloc - allocate a cpuset css
  *	cgrp:	control group that the new cpuset will be part of
@@ -2100,8 +2240,10 @@ struct cgroup_subsys cpuset_cgrp_subsys = {
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
