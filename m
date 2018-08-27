From: Waiman Long <longman@redhat.com>
Subject: [PATCH v12 3/9] cpuset: Simulate auto-off of sched.partition at cgroup removal
Date: Mon, 27 Aug 2018 10:41:18 -0400
Message-ID: <1535380884-31308-4-git-send-email-longman@redhat.com>
References: <1535380884-31308-1-git-send-email-longman@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1535380884-31308-1-git-send-email-longman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Patrick Bellasi <patrick.bellasi@arm.com>, Waiman Long <longman@redhat.com>

Making a cgroup a partition root will reserve cpu resource at its parent.
So when a partition root cgroup is destroyed, we need to free the
reserved cpus at its parent. This is now done by doing an auto-off of
the sched.partition flag in the offlining phase when a partition root
cgroup is being removed.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 kernel/cgroup/cpuset.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index fdaa051..d9e821c 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2253,7 +2253,12 @@ static int cpuset_css_online(struct cgroup_subsys_state *css)
 /*
  * If the cpuset being removed has its flag 'sched_load_balance'
  * enabled, then simulate turning sched_load_balance off, which
- * will call rebuild_sched_domains_locked().
+ * will call rebuild_sched_domains_locked(). That is not needed
+ * in the default hierarchy where only changes in partition
+ * will cause repartitioning.
+ *
+ * If the cpuset has the 'sched.partition' flag enabled, simulate
+ * turning 'sched.partition" off.
  */
 
 static void cpuset_css_offline(struct cgroup_subsys_state *css)
@@ -2262,7 +2267,18 @@ static void cpuset_css_offline(struct cgroup_subsys_state *css)
 
 	mutex_lock(&cpuset_mutex);
 
-	if (is_sched_load_balance(cs))
+	/*
+	 * A WARN_ON_ONCE() check after calling update_flag() to make
+	 * sure that the operation succceeds without failure.
+	 */
+	if (is_partition_root(cs)) {
+		int ret = update_flag(CS_PARTITION_ROOT, cs, 0);
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

