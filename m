From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/2] cgroup/cpuset: Optimize cpuset_attach() on v2
Date: Sat, 12 Nov 2022 17:19:39 -0500
Message-ID: <20221112221939.1272764-3-longman@redhat.com>
References: <20221112221939.1272764-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668291614;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oU8Uioe5AqDTtnEdw4klUnNv+nnvIMtyMCYaMWGnjIg=;
        b=BqMPbMJCN0ru4lLzlhhR0TGJXkPnOiyS+Qqc6gcNFakDEWqA12+spsHPrg0kIYbz7OVBG2
        gPu8iSfN+FZVc8bqV+N867aMB6tD/7LH6NoC2qceZA4dg7UOC6r1kpmgO8jjUtGMw7m5R2
        tGcSiMBOiW2QJHfJZHgtSbtwhzNt/Kc=
In-Reply-To: <20221112221939.1272764-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

It was found that with the default hierarchy, enabling cpuset in the
child cgroups can trigger a cpuset_attach() call in each of the child
cgroups that have tasks with no change in effective cpus and mems. If
there are many processes in those child cgroups, it will burn quite a
lot of cpu cycles iterating all the tasks without doing useful work.

Optimizing this case by comparing between the old and new cpusets and
skip useless update if there is no change in effective cpus and mems.
Also mems_allowed are less likely to be changed than cpus_allowed. So
skip changing mm if there is no change in effective_mems and
CS_MEMORY_MIGRATE is not set.

By inserting some instrumentation code and running a simple command in
a container 200 times in a cgroup v2 system, it was found that all the
cpuset_attach() calls are skipped (401 times in total) as there was no
change in effective cpus and mems.

Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup/cpuset.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 2525905cdf48..b8361f55ef36 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2513,12 +2513,28 @@ static void cpuset_attach(struct cgroup_taskset *tset)
 	struct cgroup_subsys_state *css;
 	struct cpuset *cs;
 	struct cpuset *oldcs = cpuset_attach_old_cs;
+	bool cpus_updated, mems_updated;
 
 	cgroup_taskset_first(tset, &css);
 	cs = css_cs(css);
 
 	lockdep_assert_cpus_held();	/* see cgroup_attach_lock() */
 	percpu_down_write(&cpuset_rwsem);
+	cpus_updated = !cpumask_equal(cs->effective_cpus,
+				      oldcs->effective_cpus);
+	mems_updated = !nodes_equal(cs->effective_mems, oldcs->effective_mems);
+
+	/*
+	 * In the default hierarchy, enabling cpuset in the child cgroups
+	 * will trigger a number of cpuset_attach() calls with no change
+	 * in effective cpus and mems. In that case, we can optimize out
+	 * by skipping the task iteration and update.
+	 */
+	if (cgroup_subsys_on_dfl(cpuset_cgrp_subsys) &&
+	    !cpus_updated && !mems_updated) {
+		cpuset_attach_nodemask_to = cs->effective_mems;
+		goto out;
+	}
 
 	guarantee_online_mems(cs, &cpuset_attach_nodemask_to);
 
@@ -2539,9 +2555,14 @@ static void cpuset_attach(struct cgroup_taskset *tset)
 
 	/*
 	 * Change mm for all threadgroup leaders. This is expensive and may
-	 * sleep and should be moved outside migration path proper.
+	 * sleep and should be moved outside migration path proper. Skip it
+	 * if there is no change in effective_mems and CS_MEMORY_MIGRATE is
+	 * not set.
 	 */
 	cpuset_attach_nodemask_to = cs->effective_mems;
+	if (!is_memory_migrate(cs) && !mems_updated)
+		goto out;
+
 	cgroup_taskset_for_each_leader(leader, css, tset) {
 		struct mm_struct *mm = get_task_mm(leader);
 
@@ -2564,6 +2585,7 @@ static void cpuset_attach(struct cgroup_taskset *tset)
 		}
 	}
 
+out:
 	cs->old_mems_allowed = cpuset_attach_nodemask_to;
 
 	cs->attach_in_progress--;
-- 
2.31.1

