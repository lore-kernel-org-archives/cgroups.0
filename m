From: Waiman Long <longman@redhat.com>
Subject: [PATCH v5 2/2] cpuset: Add cpuset.flags control knob to v2
Date: Thu, 15 Mar 2018 17:20:42 -0400
Message-ID: <1521148842-15486-3-git-send-email-longman@redhat.com>
References: <1521148842-15486-1-git-send-email-longman@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1521148842-15486-1-git-send-email-longman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Waiman Long <longman@redhat.com>

In cgroup v1, there are a bunch of cpuset control knobs that are just
boolean flags. To reduce the proliteration of cpuset control knobs
in v2 where multiple controllers will be active in a single cgroup,
all the boolean flags are now consolidated into a single cpuset.flags
control knob.

Currently, the cpuset.flags control knob just has one flag -
sched_load_balance. This flag is needed to enable CPU isolation
similar to what can be done with the "isolcpus" kernel boot parameter.
More flags can be added in the future if desired.

When the "cpuset.flags" file is read, it shows what flags have been
currently enabled. Turning on or off specific flags are done in a
way similar to what controllers can be enabled or disabled in the
cgroup.subtree_control control knob.

To enable the sched_load_balance flag, use

  # echo +sched_load_balance > cpuset.flags

To disable it, use

  # echo -sched_load_balance > cpuset.flags

Signed-off-by: Waiman Long <longman@redhat.com>
---
 Documentation/cgroup-v2.txt | 32 +++++++++++++++
 kernel/cgroup/cpuset.c      | 98 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 130 insertions(+)

diff --git a/Documentation/cgroup-v2.txt b/Documentation/cgroup-v2.txt
index b91fd5d..362026a 100644
--- a/Documentation/cgroup-v2.txt
+++ b/Documentation/cgroup-v2.txt
@@ -1318,6 +1318,38 @@ Cpuset Interface Files
 	of "cpuset.mems".  Its value will be affected by memory nodes
 	hotplug events.
 
+  cpuset.flags
+	A read-write multiple values file which exists on non-root
+	cgroups.
+
+	On read, it lists the flags that are currently enabled.  On
+	write, the '+' or '-' prefix with the flag name is used to
+	enable and disable the flag respectively.
+
+	The currently supported flag is:
+
+	  sched_load_balance
+		When it is not set, there will be no load balancing
+		among CPUs on this cpuset.  Tasks will stay in the
+		CPUs they are running on and will not be moved to
+		other CPUs.
+
+		When it is set, tasks within this cpuset will be
+		load-balanced by the kernel scheduler.  Tasks will be
+		moved from CPUs with high load to other CPUs within
+		the same cpuset with less load periodically.
+
+		This flag is on by default and will have to be
+		explicitly turned off.
+
+	To set a flag, use the '+' prefix:
+
+	  # echo +sched_load_balance > cpuset.flags
+
+	To clear a flag, use the '-' prefix:
+
+	  # echo -sched_load_balance > cpuset.flags
+
 
 IO
 --
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 7837d1f..3145dc0 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1601,6 +1601,7 @@ static void cpuset_attach(struct cgroup_taskset *tset)
 	FILE_MEMORY_PRESSURE,
 	FILE_SPREAD_PAGE,
 	FILE_SPREAD_SLAB,
+	FILE_FLAGS,
 } cpuset_filetype_t;
 
 static int cpuset_write_u64(struct cgroup_subsys_state *css, struct cftype *cft,
@@ -1823,6 +1824,97 @@ static s64 cpuset_read_s64(struct cgroup_subsys_state *css, struct cftype *cft)
 	return 0;
 }
 
+static const struct {
+	char *name;
+	int  cs_bit;
+} cpuset_flags[] = {
+	{ "sched_load_balance", CS_SCHED_LOAD_BALANCE },
+};
+
+static int cpuset_read_flags(struct seq_file *sf, void *v)
+{
+	struct cpuset *cs = css_cs(seq_css(sf));
+	unsigned long enabled = READ_ONCE(cs->flags);
+	int i, cnt;
+
+	for (i = cnt = 0; i < ARRAY_SIZE(cpuset_flags); i++) {
+		if (!test_bit(cpuset_flags[i].cs_bit, &enabled))
+			continue;
+
+		if (cnt++)
+			seq_putc(sf, ' ');
+
+		seq_printf(sf, "%s", cpuset_flags[i].name);
+	}
+	seq_putc(sf, '\n');
+	return 0;
+}
+
+static ssize_t cpuset_write_flags(struct kernfs_open_file *of, char *buf,
+				  size_t nbytes, loff_t off)
+{
+	struct cpuset *cs = css_cs(of_css(of));
+	unsigned long enable = 0, disable = 0;
+	char *tok;
+	int i;
+
+	mutex_lock(&cpuset_mutex);
+	if (!is_cpuset_online(cs)) {
+		nbytes = -ENODEV;
+		goto out_unlock;
+	}
+
+	/*
+	 * Parse input - space seperated list of feature names prefixed
+	 * with either + or -.
+	 */
+	buf = strstrip(buf);
+	while ((tok = strsep(&buf, " "))) {
+		if (tok[0] == '\0')
+			continue;
+		for (i = 0; i < ARRAY_SIZE(cpuset_flags); i++)
+			if (!strcmp(tok + 1, cpuset_flags[i].name))
+				break;
+		if (i == ARRAY_SIZE(cpuset_flags)) {
+			nbytes = -EINVAL;
+			goto out_unlock;
+		}
+		if (*tok == '+') {
+			set_bit(cpuset_flags[i].cs_bit, &cs->flags);
+			enable  |= 1UL << cpuset_flags[i].cs_bit;
+			disable &= 1UL << cpuset_flags[i].cs_bit;
+		} else if (*tok == '-') {
+			disable |= 1UL << cpuset_flags[i].cs_bit;
+			enable  &= 1UL << cpuset_flags[i].cs_bit;
+		} else {
+			nbytes = -EINVAL;
+			goto out_unlock;
+		}
+	}
+
+	/*
+	 * Set/clear the flags individually. It is possible an error may
+	 * happen before all the flags are processed, but it should be rare.
+	 */
+	for  (i = 0; i < ARRAY_SIZE(cpuset_flags); i++) {
+		unsigned long flag = 1UL << cpuset_flags[i].cs_bit;
+		int retval;
+
+		if (flag & (enable|disable)) {
+			retval = update_flag(cpuset_flags[i].cs_bit, cs,
+					     enable & flag);
+			if (retval) {
+				nbytes = retval;
+				goto out_unlock;
+			}
+		}
+	}
+
+out_unlock:
+	mutex_unlock(&cpuset_mutex);
+	return nbytes;
+}
+
 /*
  * for the common functions, 'private' gives the type of file
  */
@@ -1962,6 +2054,12 @@ static s64 cpuset_read_s64(struct cgroup_subsys_state *css, struct cftype *cft)
 		.private = FILE_EFFECTIVE_MEMLIST,
 	},
 
+	{
+		.name = "flags",
+		.seq_show = cpuset_read_flags,
+		.write = cpuset_write_flags,
+		.private = FILE_FLAGS,
+	},
 	{ }	/* terminate */
 };
 
-- 
1.8.3.1

