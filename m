From: David Rientjes <rientjes@google.com>
Subject: [patch v3 -mm 1/6] mm, memcg: introduce per-memcg oom policy
 tunable
Date: Fri, 13 Jul 2018 16:07:25 -0700 (PDT)
Message-ID: <alpine.DEB.2.21.1807131605200.217600@chino.kir.corp.google.com>
References: <alpine.DEB.2.20.1803121755590.192200@chino.kir.corp.google.com> <alpine.DEB.2.20.1803151351140.55261@chino.kir.corp.google.com> <alpine.DEB.2.20.1803161405410.209509@chino.kir.corp.google.com> <alpine.DEB.2.20.1803221451370.17056@chino.kir.corp.google.com>
 <alpine.DEB.2.21.1807131604560.217600@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=drSc/yLyXYJewM0nnn0zDSduvYIMw4DeBViBIvRq4XU=;
        b=lpiLg3cjkAB12viMdRujE7ROHpAeZZh1tuwQSJ/ZkmxhkMMa7TVDSSSJ0ln895yeiR
         EvX1fNvRovwbNOjBsQYlINcOsRpMlhBxFZafXciWzrWmKrojnFa80EBulKCQ0I7yNDDE
         wWiEzvrzlpOxLJtxtq6jIglt0L8kB+VWL/1DvomcuxKXA4MB1qTFvR3yWiXLH5EXCmH4
         JHZU/vgIVB13osMH8Ay/v32TeespdFz+qnPNF4qQvRKE8/Ys2C29TtDRxFo0Wp/sosTL
         p99Cv8lhyitRmJ2wcuvlX3FZX9BDVF1FQDES61ygd0JsB/Z+WtF736qQnsS4Do+UjzE7
         SESg==
In-Reply-To: <alpine.DEB.2.21.1807131604560.217600@chino.kir.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>
Cc: Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org

The cgroup aware oom killer is needlessly enforced for the entire system
by a mount option.  It's unnecessary to force the system into a single
oom policy: either cgroup aware, or the traditional process aware.

This patch introduces a memory.oom_policy tunable for all mem cgroups.
It is currently a no-op: it can only be set to "none", which is its
default policy.  It will be expanded in the next patch to define cgroup
aware oom killer behavior for its subtree.

This is an extensible interface that can be used to define cgroup aware
assessment of mem cgroup subtrees or the traditional process aware
assessment.

Reading memory.oom_policy will specify the list of available policies.

Another benefit of such an approach is that an admin can lock in a
certain policy for the system or for a mem cgroup subtree and can
delegate the policy decision to the user to determine if the kill should
originate from a subcontainer, as indivisible memory consumers
themselves, or selection should be done per process.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 Documentation/admin-guide/cgroup-v2.rst | 11 ++++++++
 include/linux/memcontrol.h              | 11 ++++++++
 mm/memcontrol.c                         | 35 +++++++++++++++++++++++++
 3 files changed, 57 insertions(+)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1098,6 +1098,17 @@ PAGE_SIZE multiple when read back.
 	If cgroup-aware OOM killer is not enabled, ENOTSUPP error
 	is returned on attempt to access the file.
 
+  memory.oom_policy
+
+	A read-write single string file which exists on all cgroups.  The
+	default value is "none".
+
+	If "none", the OOM killer will use the default policy to choose a
+	victim; that is, it will choose the single process with the largest
+	memory footprint adjusted by /proc/pid/oom_score_adj (see
+	Documentation/filesystems/proc.txt).  This is the same policy as if
+	memory cgroups were not even mounted.
+
   memory.events
 	A read-only flat-keyed file which exists on non-root cgroups.
 	The following entries are defined.  Unless specified
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -66,6 +66,14 @@ enum mem_cgroup_protection {
 	MEMCG_PROT_MIN,
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
@@ -234,6 +242,9 @@ struct mem_cgroup {
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
@@ -4649,6 +4649,7 @@ mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
 	if (parent) {
 		memcg->swappiness = mem_cgroup_swappiness(parent);
 		memcg->oom_kill_disable = parent->oom_kill_disable;
+		memcg->oom_policy = parent->oom_policy;
 	}
 	if (parent && parent->use_hierarchy) {
 		memcg->use_hierarchy = true;
@@ -5810,6 +5811,34 @@ static int memory_stat_show(struct seq_file *m, void *v)
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
+		seq_puts(m, "[none]\n");
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
@@ -5857,6 +5886,12 @@ static struct cftype memory_files[] = {
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
 
