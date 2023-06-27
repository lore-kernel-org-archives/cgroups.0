From: Waiman Long <longman@redhat.com>
Subject: [PATCH v4 1/9] cgroup/cpuset: Inherit parent's load balance state in v2
Date: Tue, 27 Jun 2023 10:35:00 -0400
Message-ID: <20230627143508.1576882-2-longman@redhat.com>
References: <20230627143508.1576882-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687876854;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HxXXRG19n9JIA9MH1iFO6LWghYV5obKh5ig/aXiH0Xo=;
        b=Nr91JhniCyJ5YnFJ0lxxd/vDwd4cMfXxD+am4efr/LW3a4PB/2YNZLwLflPExxHYkNvVNu
        zybfnIKJ4oHhQNmxATH76xEIvV9sWIVcc/5Gjuk1D8q7A4uA8jdCUbhK1xR9EuwJb6XFf+
        wafraWg8UuaBJQbbF97af7eY5lTGQn0=
In-Reply-To: <20230627143508.1576882-1-longman@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Juri Lelli <juri.lelli@redhat.com>, Valentin Schneider <vschneid@redhat.com>, Frederic Weisbecker <frederic@kernel.org>, Mrunal Patel <mpatel@redhat.com>, Ryan Phillips <rphillips@redhat.com>, Brent Rowsell <browsell@redhat.com>, Peter Hunt <pehunt@redhat.com>, Phil Auld <pauld@redhat.com>, Waiman Long <longman@redhat.com>

Since commit f28e22441f35 ("cgroup/cpuset: Add a new isolated
cpus.partition type"), the CS_SCHED_LOAD_BALANCE bit of a v2 cpuset
can be on or off. The child cpusets of a partition root must have the
same setting as its parent or it may screw up the rebuilding of sched
domains. Fix this problem by making sure the a child v2 cpuset will
follows its parent cpuset load balance state unless the child cpuset
is a new partition root itself.

Fixes: f28e22441f35 ("cgroup/cpuset: Add a new isolated cpus.partition type")
Signed-off-by: Waiman Long <longman@redhat.com>
---
 kernel/cgroup/cpuset.c | 33 ++++++++++++++++++++++++++++++---
 1 file changed, 30 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 58e6f18f01c1..170e342b07e3 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1588,11 +1588,16 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp,
 		}
 
 		/*
-		 * Skip the whole subtree if the cpumask remains the same
-		 * and has no partition root state and force flag not set.
+		 * Skip the whole subtree if
+		 * 1) the cpumask remains the same,
+		 * 2) has no partition root state,
+		 * 3) force flag not set, and
+		 * 4) for v2 load balance state same as its parent.
 		 */
 		if (!cp->partition_root_state && !force &&
-		    cpumask_equal(tmp->new_cpus, cp->effective_cpus)) {
+		    cpumask_equal(tmp->new_cpus, cp->effective_cpus) &&
+		    (!cgroup_subsys_on_dfl(cpuset_cgrp_subsys) ||
+		    (is_sched_load_balance(parent) == is_sched_load_balance(cp)))) {
 			pos_css = css_rightmost_descendant(pos_css);
 			continue;
 		}
@@ -1675,6 +1680,20 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp,
 
 		update_tasks_cpumask(cp, tmp->new_cpus);
 
+		/*
+		 * On default hierarchy, inherit the CS_SCHED_LOAD_BALANCE
+		 * from parent if current cpuset isn't a valid partition root
+		 * and their load balance states differ.
+		 */
+		if (cgroup_subsys_on_dfl(cpuset_cgrp_subsys) &&
+		    !is_partition_valid(cp) &&
+		    (is_sched_load_balance(parent) != is_sched_load_balance(cp))) {
+			if (is_sched_load_balance(parent))
+				set_bit(CS_SCHED_LOAD_BALANCE, &cp->flags);
+			else
+				clear_bit(CS_SCHED_LOAD_BALANCE, &cp->flags);
+		}
+
 		/*
 		 * On legacy hierarchy, if the effective cpumask of any non-
 		 * empty cpuset is changed, we need to rebuild sched domains.
@@ -3222,6 +3241,14 @@ static int cpuset_css_online(struct cgroup_subsys_state *css)
 		cs->use_parent_ecpus = true;
 		parent->child_ecpus_count++;
 	}
+
+	/*
+	 * For v2, clear CS_SCHED_LOAD_BALANCE if parent is isolated
+	 */
+	if (cgroup_subsys_on_dfl(cpuset_cgrp_subsys) &&
+	    !is_sched_load_balance(parent))
+		clear_bit(CS_SCHED_LOAD_BALANCE, &cs->flags);
+
 	spin_unlock_irq(&callback_lock);
 
 	if (!test_bit(CGRP_CPUSET_CLONE_CHILDREN, &css->cgroup->flags))
-- 
2.31.1

