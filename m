From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 3/3] cgroup/cpuset: Allow only one active attach operation per cpuset
Date: Fri, 31 Mar 2023 10:50:45 -0400
Message-ID: <20230331145045.2251683-4-longman@redhat.com>
References: <20230331145045.2251683-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680274279;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=spcnenCmiq2qvQdcV7Gzytx8zR6D02wtS5KoOT6JRrs=;
        b=TmyIha7SbcMZwtlKksOLE6lHICiktsHNdlYM/hRvXxGAfdUdWeZhhYDqfC+IcztR7g4oQg
        xWSzxgHGdrLbeiavHUhLPf/sxK2RN0ytKUMzfA5hafNH7qoyW5xfvOT8VsuXbgyGPD1Qax
        NizYx1SU1MiU6gAqniujagjBfC2t738=
In-Reply-To: <20230331145045.2251683-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, gscrivan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

The current cpuset code uses the global cpuset_attach_old_cs variable
to store the old cpuset value between consecutive cpuset_can_attach()
and cpuset_attach() calls. Since a caller of cpuset_can_attach() may
not need to hold the global cgroup_threadgroup_rwsem, parallel cpuset
attach operations are possible.

When there are concurrent cpuset attach operations in progress,
cpuset_attach() may fetch the wrong value from cpuset_attach_old_cs
causing incorrect result.  To avoid this problem while still allowing
certain level of parallelism, drop cpuset_attach_old_cs and use a
per-cpuset attach_old_cs value. Also restrict to at most one active
attach operation per cpuset to avoid corrupting the value of the
per-cpuset attach_old_cs value.

Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup/cpuset.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 2367de611c42..3f925c261513 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -198,6 +198,8 @@ struct cpuset {
 
 	/* Handle for cpuset.cpus.partition */
 	struct cgroup_file partition_file;
+
+	struct cpuset *attach_old_cs;
 };
 
 /*
@@ -2456,22 +2458,27 @@ static int fmeter_getrate(struct fmeter *fmp)
 	return val;
 }
 
-static struct cpuset *cpuset_attach_old_cs;
-
 /* Called by cgroups to determine if a cpuset is usable; cpuset_rwsem held */
 static int cpuset_can_attach(struct cgroup_taskset *tset)
 {
 	struct cgroup_subsys_state *css;
-	struct cpuset *cs;
+	struct cpuset *cs, *oldcs;
 	struct task_struct *task;
 	int ret;
 
 	/* used later by cpuset_attach() */
-	cpuset_attach_old_cs = task_cs(cgroup_taskset_first(tset, &css));
+	oldcs = task_cs(cgroup_taskset_first(tset, &css));
 	cs = css_cs(css);
 
 	percpu_down_write(&cpuset_rwsem);
 
+	/*
+	 * Only one cpuset attach operation is allowed for each cpuset.
+	 */
+	ret = -EBUSY;
+	if (cs->attach_in_progress)
+		goto out_unlock;
+
 	/* allow moving tasks into an empty cpuset if on default hierarchy */
 	ret = -ENOSPC;
 	if (!is_in_v2_mode() &&
@@ -2498,6 +2505,7 @@ static int cpuset_can_attach(struct cgroup_taskset *tset)
 	 * changes which zero cpus/mems_allowed.
 	 */
 	cs->attach_in_progress++;
+	cs->attach_old_cs = oldcs;
 	ret = 0;
 out_unlock:
 	percpu_up_write(&cpuset_rwsem);
@@ -2548,7 +2556,7 @@ static void cpuset_attach(struct cgroup_taskset *tset)
 	struct task_struct *leader;
 	struct cgroup_subsys_state *css;
 	struct cpuset *cs;
-	struct cpuset *oldcs = cpuset_attach_old_cs;
+	struct cpuset *oldcs;
 	bool cpus_updated, mems_updated;
 
 	cgroup_taskset_first(tset, &css);
@@ -2556,6 +2564,7 @@ static void cpuset_attach(struct cgroup_taskset *tset)
 
 	lockdep_assert_cpus_held();	/* see cgroup_attach_lock() */
 	percpu_down_write(&cpuset_rwsem);
+	oldcs = cs->attach_old_cs;
 	cpus_updated = !cpumask_equal(cs->effective_cpus,
 				      oldcs->effective_cpus);
 	mems_updated = !nodes_equal(cs->effective_mems, oldcs->effective_mems);
-- 
2.31.1

