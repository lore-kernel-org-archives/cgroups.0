From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v6 2/6] cgroup/cpuset: Show invalid partition reason string
Date: Sat, 14 Aug 2021 16:57:39 -0400
Message-ID: <20210814205743.3039-3-longman@redhat.com>
References: <20210814205743.3039-1-longman@redhat.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628974693;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=/FWymyrQLciNwrWKD+P1AGL1QQGB0Rc+iBXvPqYeYy8=;
        b=agFBhvEm2g/ZO5fuyMq/W0ZDnb52dlHwGlVF4Qa7TTj7SZeQLGk3PqWLweF9a6rgjzbleG
        N+/Y27wOf3a8t30yapcHMn0Qmj4qVY6Fw985DKbBjnzBxG4a7wUgYIyd5T8AxOpILfvhfS
        8NB+hZ1h3AXFszN40AMt9e0Q6dzmQow=
In-Reply-To: <20210814205743.3039-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Phil Auld <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

There are a number of different reasons which can cause a partition to
become invalid. A user seeing an invalid partition may not know exactly
why. To help user to get a better understanding of the underlying reason,
The cpuset.cpus.partition control file, when read, will now report the
reason why a partition become invalid. When a partition does become
invalid, reading the control file will show "root invalid (<reason>)"
where <reason> is a string that describes why the partition is invalid.

Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup/cpuset.c | 46 +++++++++++++++++++++++++++++++++++++++---
 1 file changed, 43 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 3ac88a6a57a2..7548e07a9874 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -78,6 +78,24 @@ struct fmeter {
 	spinlock_t lock;	/* guards read or write of above */
 };
 
+/*
+ * Invalid partition error code
+ */
+enum prs_errcode {
+	PERR_NONE = 0,
+	PERR_INVCPUS,
+	PERR_NOCPUS,
+	PERR_PARENT,
+	PERR_HOTPLUG,
+};
+
+static const char * const perr_strings[] = {
+	[PERR_INVCPUS] = "Invalid change to cpuset.cpus",
+	[PERR_PARENT]  = "Parent is no longer a partition root",
+	[PERR_NOCPUS]  = "Parent unable to distribute cpu downstream",
+	[PERR_HOTPLUG] = "No cpu available due to hotplug",
+};
+
 struct cpuset {
 	struct cgroup_subsys_state css;
 
@@ -163,6 +181,9 @@ struct cpuset {
 
 	/* Handle for cpuset.cpus.partition */
 	struct cgroup_file partition_file;
+
+	/* Invalid partiton error code, not lock protected */
+	enum prs_errcode prs_err;
 };
 
 /*
@@ -272,8 +293,13 @@ static inline int is_partition_root(const struct cpuset *cs)
 static inline void notify_partition_change(struct cpuset *cs,
 					   int old_prs, int new_prs)
 {
-	if (old_prs != new_prs)
-		cgroup_file_notify(&cs->partition_file);
+	if (old_prs == new_prs)
+		return;
+	cgroup_file_notify(&cs->partition_file);
+
+	/* Reset prs_err if not invalid */
+	if (new_prs != PRS_ERROR)
+		WRITE_ONCE(cs->prs_err, PERR_NONE);
 }
 
 static struct cpuset top_cpuset = {
@@ -1243,6 +1269,8 @@ static int update_parent_subparts_cpumask(struct cpuset *cpuset, int cmd,
 					      cpu_active_mask))
 				part_error = true;
 			cpumask_copy(tmp->addmask, parent->effective_cpus);
+			if ((READ_ONCE(cpuset->prs_err) == PERR_NONE) && part_error)
+				WRITE_ONCE(cpuset->prs_err, PERR_INVCPUS);
 		}
 	} else {
 		/*
@@ -1264,6 +1292,8 @@ static int update_parent_subparts_cpumask(struct cpuset *cpuset, int cmd,
 		part_error = (is_partition_root(cpuset) &&
 			      !parent->nr_subparts_cpus) ||
 			     cpumask_equal(tmp->addmask, parent->effective_cpus);
+		if (is_partition_root(cpuset) && part_error)
+			WRITE_ONCE(cpuset->prs_err, PERR_NOCPUS);
 	}
 
 	if (cmd == partcmd_update) {
@@ -1427,6 +1457,7 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp)
 				 * When parent is invalid, it has to be too.
 				 */
 				new_prs = PRS_ERROR;
+				WRITE_ONCE(cp->prs_err, PERR_PARENT);
 				break;
 			}
 		}
@@ -2541,6 +2572,7 @@ static s64 cpuset_read_s64(struct cgroup_subsys_state *css, struct cftype *cft)
 static int sched_partition_show(struct seq_file *seq, void *v)
 {
 	struct cpuset *cs = css_cs(seq_css(seq));
+	const char *err;
 
 	switch (cs->partition_root_state) {
 	case PRS_ENABLED:
@@ -2550,7 +2582,11 @@ static int sched_partition_show(struct seq_file *seq, void *v)
 		seq_puts(seq, "member\n");
 		break;
 	case PRS_ERROR:
-		seq_puts(seq, "root invalid\n");
+		err = perr_strings[READ_ONCE(cs->prs_err)];
+		if (err)
+			seq_printf(seq, "root invalid (%s)\n", err);
+		else
+			seq_puts(seq, "root invalid\n");
 		break;
 	}
 	return 0;
@@ -3150,6 +3186,10 @@ static void cpuset_hotplug_update_tasks(struct cpuset *cs, struct tmpmasks *tmp)
 			spin_lock_irq(&callback_lock);
 			cs->partition_root_state = PRS_ERROR;
 			spin_unlock_irq(&callback_lock);
+			if (parent->partition_root_state == PRS_ERROR)
+				WRITE_ONCE(cs->prs_err, PERR_PARENT);
+			else
+				WRITE_ONCE(cs->prs_err, PERR_HOTPLUG);
 			notify_partition_change(cs, old_prs, PRS_ERROR);
 		}
 		cpuset_force_rebuild();
-- 
2.18.1

