From: Waiman Long <longman@redhat.com>
Subject: [PATCH v10 3/9] cpuset: Simulate auto-off of sched.domain_root at cgroup removal
Date: Mon, 18 Jun 2018 12:14:02 +0800
Message-ID: <1529295249-5207-4-git-send-email-longman@redhat.com>
References: <1529295249-5207-1-git-send-email-longman@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1529295249-5207-1-git-send-email-longman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Patrick Bellasi <patrick.bellasi@arm.com>, Waiman Long <longman@redhat.com>

Making a cgroup a domain root will reserve cpu resource at its parent.
So when a domain root cgroup is destroyed, we need to free the
reserved cpus at its parent. This is now done by doing an auto-off of
the sched.domain_root flag in the offlining phase when a domain root
cgroup is being removed.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 kernel/cgroup/cpuset.c | 34 +++++++++++++++++++++++++++++-----
 1 file changed, 29 insertions(+), 5 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 68a9c25..a1d5ccd 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -995,7 +995,8 @@ static void update_cpumasks_hier(struct cpuset *cs, struct cpumask *new_cpus)
  * If the sched_domain_root flag changes, either the delmask (0=>1) or the
  * addmask (1=>0) will be NULL.
  *
- * Called with cpuset_mutex held.
+ * Called with cpuset_mutex held. Some of the checks are skipped if the
+ * cpuset is being offlined (dying).
  */
 static int update_reserved_cpumask(struct cpuset *cpuset,
 	struct cpumask *delmask, struct cpumask *addmask)
@@ -1005,6 +1006,7 @@ static int update_reserved_cpumask(struct cpuset *cpuset,
 	struct cpuset *sibling;
 	struct cgroup_subsys_state *pos_css;
 	int old_count = parent->nr_reserved;
+	bool dying = cpuset->css.flags & CSS_DYING;
 
 	/*
 	 * The parent must be a scheduling domain root.
@@ -1026,9 +1028,9 @@ static int update_reserved_cpumask(struct cpuset *cpuset,
 
 	/*
 	 * A sched_domain_root state change is not allowed if there are
-	 * online children.
+	 * online children and the cpuset is not dying.
 	 */
-	if (css_has_online_children(&cpuset->css))
+	if (!dying && css_has_online_children(&cpuset->css))
 		return -EBUSY;
 
 	if (!old_count) {
@@ -1058,7 +1060,12 @@ static int update_reserved_cpumask(struct cpuset *cpuset,
 	 * Check if any CPUs in addmask or delmask are in the effective_cpus
 	 * of a sibling cpuset. The implied cpu_exclusive of a scheduling
 	 * domain root will ensure there are no overlap in cpus_allowed.
+	 *
+	 * This check is skipped if the cpuset is dying.
 	 */
+	if (dying)
+		goto updated_reserved_cpus;
+
 	rcu_read_lock();
 	cpuset_for_each_child(sibling, pos_css, parent) {
 		if ((sibling == cpuset) || !(sibling->css.flags & CSS_ONLINE))
@@ -1077,6 +1084,7 @@ static int update_reserved_cpumask(struct cpuset *cpuset,
 	 * Newly added reserved CPUs will be removed from effective_cpus
 	 * and newly deleted ones will be added back if they are online.
 	 */
+updated_reserved_cpus:
 	spin_lock_irq(&callback_lock);
 	if (addmask) {
 		cpumask_or(parent->reserved_cpus,
@@ -2278,7 +2286,12 @@ static int cpuset_css_online(struct cgroup_subsys_state *css)
 /*
  * If the cpuset being removed has its flag 'sched_load_balance'
  * enabled, then simulate turning sched_load_balance off, which
- * will call rebuild_sched_domains_locked().
+ * will call rebuild_sched_domains_locked(). That is not needed
+ * in the default hierarchy where only changes in domain_root
+ * will cause repartitioning.
+ *
+ * If the cpuset has the 'sched.domain_root' flag enabled, simulate
+ * turning 'sched.domain_root" off.
  */
 
 static void cpuset_css_offline(struct cgroup_subsys_state *css)
@@ -2287,7 +2300,18 @@ static void cpuset_css_offline(struct cgroup_subsys_state *css)
 
 	mutex_lock(&cpuset_mutex);
 
-	if (is_sched_load_balance(cs))
+	/*
+	 * A WARN_ON_ONCE() check after calling update_flag() to make
+	 * sure that the operation succceeds without failure.
+	 */
+	if (is_sched_domain_root(cs)) {
+		int ret = update_flag(CS_SCHED_DOMAIN_ROOT, cs, 0);
+
+		WARN_ON_ONCE(ret);
+	}
+
+	if (!cgroup_subsys_on_dfl(cpuset_cgrp_subsys) &&
+	    is_sched_load_balance(cs))
 		update_flag(CS_SCHED_LOAD_BALANCE, cs, 0);
 
 	cpuset_dec();
-- 
1.8.3.1

