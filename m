From: Song Liu <songliubraving@fb.com>
Subject: [PATCH 2/7] cgroup: introduce hook css_has_tasks_changed
Date: Mon, 8 Apr 2019 14:45:34 -0700
Message-ID: <20190408214539.2705660-3-songliubraving@fb.com>
References: <20190408214539.2705660-1-songliubraving@fb.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=gwcpzJCNH9zTKl6c0+rR3lwfn5Cb+QEquraGGM3w8eg=;
 b=GNHw49efVqUrBpQIsK1cfbNcOF4clyurX8JZsvNaLB2dCP1YHHNTax2kCkaSge50lhbD
 aF6Zqcupfeis+vKQF9Q+tDlcRQEZ0Z52yykMXmIotCxxN+cPUoStO8840UDq0+7SAk9s
 JexNMq9HGVvM/db59wem8ckF4c0/dVzQ2xM= 
In-Reply-To: <20190408214539.2705660-1-songliubraving@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Cc: mingo@redhat.com, peterz@infradead.org, vincent.guittot@linaro.org, tglx@linutronix.de, morten.rasmussen@arm.com, kernel-team@fb.com, Song Liu <songliubraving@fb.com>

This patch introduces a new hook css_has_tasks_changed:

   void (*css_has_tasks_changed)(struct cgroup_subsys_state *css,
                                 bool has_tasks);

The hook is called when the cgroup gets its first task and when the cgroup
loses its last task. It is called under css_set_lock.

Note: has_task is different to populated. It only considers directly
attached tasks.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 include/linux/cgroup-defs.h |  2 ++
 kernel/cgroup/cgroup.c      | 14 ++++++++++++++
 2 files changed, 16 insertions(+)

diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index 1c70803e9f77..ba499ed5309c 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -594,6 +594,8 @@ struct cgroup_subsys {
 	void (*css_released)(struct cgroup_subsys_state *css);
 	void (*css_free)(struct cgroup_subsys_state *css);
 	void (*css_reset)(struct cgroup_subsys_state *css);
+	void (*css_has_tasks_changed)(struct cgroup_subsys_state *css,
+				      bool has_tasks);
 	void (*css_rstat_flush)(struct cgroup_subsys_state *css, int cpu);
 	int (*css_extra_stat_show)(struct seq_file *seq,
 				   struct cgroup_subsys_state *css);
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 3f2b4bde0f9c..b0df96132476 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -200,6 +200,7 @@ static u16 have_fork_callback __read_mostly;
 static u16 have_exit_callback __read_mostly;
 static u16 have_release_callback __read_mostly;
 static u16 have_canfork_callback __read_mostly;
+static u16 have_has_tasks_changed_callback __read_mostly;
 
 /* cgroup namespace for init task */
 struct cgroup_namespace init_cgroup_ns = {
@@ -762,8 +763,11 @@ static bool css_set_populated(struct css_set *cset)
  */
 static void cgroup_update_populated(struct cgroup *cgrp, bool populated)
 {
+	struct cgroup *orig_cgrp = cgrp;
 	struct cgroup *child = NULL;
 	int adj = populated ? 1 : -1;
+	struct cgroup_subsys *ss;
+	int ssid;
 
 	lockdep_assert_held(&css_set_lock);
 
@@ -788,6 +792,14 @@ static void cgroup_update_populated(struct cgroup *cgrp, bool populated)
 		child = cgrp;
 		cgrp = cgroup_parent(cgrp);
 	} while (cgrp);
+
+	do_each_subsys_mask(ss, ssid, have_has_tasks_changed_callback) {
+		struct cgroup_subsys_state *css;
+
+		css = cgroup_css(orig_cgrp, ss);
+		if (css)
+			ss->css_has_tasks_changed(css, populated);
+	} while_each_subsys_mask();
 }
 
 /**
@@ -5370,6 +5382,8 @@ static void __init cgroup_init_subsys(struct cgroup_subsys *ss, bool early)
 	have_exit_callback |= (bool)ss->exit << ss->id;
 	have_release_callback |= (bool)ss->release << ss->id;
 	have_canfork_callback |= (bool)ss->can_fork << ss->id;
+	have_has_tasks_changed_callback |=
+		(bool)ss->css_has_tasks_changed << ss->id;
 
 	/* At system boot, before all subsystems have been
 	 * registered, no tasks have been forked, so we don't
-- 
2.17.1

