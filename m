From: David Rientjes <rientjes@google.com>
Subject: [patch -mm 1/4] mm, memcg: introduce per-memcg oom policy tunable
Date: Tue, 16 Jan 2018 18:15:03 -0800 (PST)
Message-ID: <alpine.DEB.2.10.1801161813480.28198@chino.kir.corp.google.com>
References: <alpine.DEB.2.10.1801161812550.28198@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=/r9QU7TNFgK7N2BbTQ7+GVg0h/Tg4EiQ2sP5UPaR1fQ=;
        b=A3s7kuRhNogTWLJ0ssxJQ6fNp8COXTODSNi1AW1JDoYQrtAjGCXi0Ri8t6IRSrCuQT
         GeBhBvl13C+MW1Uzs5WppwFm/LrhUYB/c3iZFi9FJXUXOlUkhivRMrqEio+W/VN1f93f
         mU96KQ+X6QCUoME/eCROB8HbeROuoIgswfHDBkFxx+uFJl06C9HunnO/tIfgZyRjIWVo
         rtlYl56czUhVKeLQDN/pr13hgG4gW9CKyS1l5uLWB+k5xA25UqvqGlyzdlSXw1o8dyIP
         sbkhHmoo4fytPYO5OqxXl3uXhtlxoUbHVeoFbFVElGhdguF7qlj5LjNMW2a5MXkemHXu
         dRwg==
In-Reply-To: <alpine.DEB.2.10.1801161812550.28198@chino.kir.corp.google.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>
Cc: Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org

The cgroup aware oom killer is needlessly declared for the entire system
by a mount option.  It's unnecessary to force the system into a single
oom policy: either cgroup aware, or the traditional process aware.

This patch introduces a memory.oom_policy tunable for all mem cgroups.
It is currently a no-op: it can only be set to "none", which is its
default policy.  It will be expanded in the next patch to define cgroup
aware oom killer behavior.

This is an extensible interface that can be used to define cgroup aware
assessment of mem cgroup subtrees or the traditional process aware
assessment.

Another benefit of such an approach is that an admin can lock in a
certain policy for the system or for a mem cgroup subtree and can
delegate the policy decision to the user to determine if the kill should
originate from a subcontainer, as indivisible memory consumers
themselves, or selection should be done per process.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 Documentation/cgroup-v2.txt |  9 +++++++++
 include/linux/memcontrol.h  | 11 +++++++++++
 mm/memcontrol.c             | 35 +++++++++++++++++++++++++++++++++++
 3 files changed, 55 insertions(+)

diff --git a/Documentation/cgroup-v2.txt b/Documentation/cgroup-v2.txt
--- a/Documentation/cgroup-v2.txt
+++ b/Documentation/cgroup-v2.txt
@@ -1060,6 +1060,15 @@ PAGE_SIZE multiple when read back.
 	If cgroup-aware OOM killer is not enabled, ENOTSUPP error
 	is returned on attempt to access the file.
 
+  memory.oom_policy
+
+	A read-write single string file which exists on all cgroups.  The
+	default value is "none".
+
+	If "none", the OOM killer will use the default policy to choose a
+	victim; that is, it will choose the single process with the largest
+	memory footprint.
+
   memory.events
 	A read-only flat-keyed file which exists on non-root cgroups.
 	The following entries are defined.  Unless specified
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -58,6 +58,14 @@ enum memcg_event_item {
 	MEMCG_NR_EVENTS,
 };
 
+enum memcg_oom_policy {
+	/*
+	 * No special oom policy, process selection is determined by
+	 * oom_badness()
+	 */
+	MEMCG_OOM_POLICY_NONE,
+};
+
 struct mem_cgroup_reclaim_cookie {
 	pg_data_t *pgdat;
 	int priority;
@@ -203,6 +211,9 @@ struct mem_cgroup {
 	/* OOM-Killer disable */
 	int		oom_kill_disable;
 
+	/* OOM policy for this subtree */
+	enum memcg_oom_policy oom_policy;
+
 	/*
 	 * Treat the sub-tree as an indivisible memory consumer,
 	 * kill all belonging tasks if the memory cgroup selected
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4417,6 +4417,7 @@ mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
 	if (parent) {
 		memcg->swappiness = mem_cgroup_swappiness(parent);
 		memcg->oom_kill_disable = parent->oom_kill_disable;
+		memcg->oom_policy = parent->oom_policy;
 	}
 	if (parent && parent->use_hierarchy) {
 		memcg->use_hierarchy = true;
@@ -5534,6 +5535,34 @@ static int memory_stat_show(struct seq_file *m, void *v)
 	return 0;
 }
 
+static int memory_oom_policy_show(struct seq_file *m, void *v)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_css(seq_css(m));
+	enum memcg_oom_policy policy = READ_ONCE(memcg->oom_policy);
+
+	switch (policy) {
+	case MEMCG_OOM_POLICY_NONE:
+	default:
+		seq_puts(m, "none\n");
+	};
+	return 0;
+}
+
+static ssize_t memory_oom_policy_write(struct kernfs_open_file *of,
+				       char *buf, size_t nbytes, loff_t off)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
+	ssize_t ret = nbytes;
+
+	buf = strstrip(buf);
+	if (!memcmp("none", buf, min(sizeof("none")-1, nbytes)))
+		memcg->oom_policy = MEMCG_OOM_POLICY_NONE;
+	else
+		ret = -EINVAL;
+
+	return ret;
+}
+
 static struct cftype memory_files[] = {
 	{
 		.name = "current",
@@ -5575,6 +5604,12 @@ static struct cftype memory_files[] = {
 		.flags = CFTYPE_NOT_ON_ROOT,
 		.seq_show = memory_stat_show,
 	},
+	{
+		.name = "oom_policy",
+		.flags = CFTYPE_NS_DELEGATABLE,
+		.seq_show = memory_oom_policy_show,
+		.write = memory_oom_policy_write,
+	},
 	{ }	/* terminate */
 };
 

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
