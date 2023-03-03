From: Cai Xinchen <caixinchen1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 4.19 1/3] cgroup/cpuset: Change cpuset_rwsem and hotplug lock order
Date: Fri, 3 Mar 2023 04:50:48 +0000
Message-ID: <20230303045050.139985-2-caixinchen1@huawei.com>
References: <20230303045050.139985-1-caixinchen1@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20230303045050.139985-1-caixinchen1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, sashal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: mkoutny-IBi9RG/b67k@public.gmane.org, zhangqiao22-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From: Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

commit d74b27d63a8bebe2fe634944e4ebdc7b10db7a39 upstream.

commit 1243dc518c9da ("cgroup/cpuset: Convert cpuset_mutex to
percpu_rwsem") is performance patch which is not backport. So
convert percpu_rwsem to cpuset_mutex.

original commit message:

cpuset_rwsem is going to be acquired from sched_setscheduler() with a
following patch. There are however paths (e.g., spawn_ksoftirqd) in
which sched_scheduler() is eventually called while holding hotplug lock;
this creates a dependecy between hotplug lock (to be always acquired
first) and cpuset_rwsem (to be always acquired after hotplug lock).

Fix paths which currently take the two locks in the wrong order (after
a following patch is applied).

Tested-by: Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>
Signed-off-by: Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: claudio-YOzL5CV4y4YG1A2ADO40+w@public.gmane.org
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: luca.abeni-5rdYK369eBLQB0XuIGIEkQ@public.gmane.org
Cc: mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: tommaso.cucinotta-5rdYK369eBLQB0XuIGIEkQ@public.gmane.org
Link: https://lkml.kernel.org/r/20190719140000.31694-7-juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Signed-off-by: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Signed-off-by: Cai Xinchen <caixinchen1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 include/linux/cpuset.h |  8 ++++----
 kernel/cgroup/cpuset.c | 18 ++++++++++++++----
 2 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
index 934633a05d20..7f1478c26a33 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -40,14 +40,14 @@ static inline bool cpusets_enabled(void)
 
 static inline void cpuset_inc(void)
 {
-	static_branch_inc(&cpusets_pre_enable_key);
-	static_branch_inc(&cpusets_enabled_key);
+	static_branch_inc_cpuslocked(&cpusets_pre_enable_key);
+	static_branch_inc_cpuslocked(&cpusets_enabled_key);
 }
 
 static inline void cpuset_dec(void)
 {
-	static_branch_dec(&cpusets_enabled_key);
-	static_branch_dec(&cpusets_pre_enable_key);
+	static_branch_dec_cpuslocked(&cpusets_enabled_key);
+	static_branch_dec_cpuslocked(&cpusets_pre_enable_key);
 }
 
 extern int cpuset_init(void);
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index dcd5755b1fe2..2ee0e7a06dd9 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -830,8 +830,8 @@ static void rebuild_sched_domains_locked(void)
 	cpumask_var_t *doms;
 	int ndoms;
 
+	lockdep_assert_cpus_held();
 	lockdep_assert_held(&cpuset_mutex);
-	get_online_cpus();
 
 	/*
 	 * We have raced with CPU hotplug. Don't do anything to avoid
@@ -839,15 +839,13 @@ static void rebuild_sched_domains_locked(void)
 	 * Anyways, hotplug work item will rebuild sched domains.
 	 */
 	if (!cpumask_equal(top_cpuset.effective_cpus, cpu_active_mask))
-		goto out;
+		return;
 
 	/* Generate domain masks and attrs */
 	ndoms = generate_sched_domains(&doms, &attr);
 
 	/* Have scheduler rebuild the domains */
 	partition_sched_domains(ndoms, doms, attr);
-out:
-	put_online_cpus();
 }
 #else /* !CONFIG_SMP */
 static void rebuild_sched_domains_locked(void)
@@ -857,9 +855,11 @@ static void rebuild_sched_domains_locked(void)
 
 void rebuild_sched_domains(void)
 {
+	get_online_cpus();
 	mutex_lock(&cpuset_mutex);
 	rebuild_sched_domains_locked();
 	mutex_unlock(&cpuset_mutex);
+	put_online_cpus();
 }
 
 /**
@@ -1617,6 +1617,7 @@ static int cpuset_write_u64(struct cgroup_subsys_state *css, struct cftype *cft,
 	cpuset_filetype_t type = cft->private;
 	int retval = 0;
 
+	get_online_cpus();
 	mutex_lock(&cpuset_mutex);
 	if (!is_cpuset_online(cs)) {
 		retval = -ENODEV;
@@ -1654,6 +1655,7 @@ static int cpuset_write_u64(struct cgroup_subsys_state *css, struct cftype *cft,
 	}
 out_unlock:
 	mutex_unlock(&cpuset_mutex);
+	put_online_cpus();
 	return retval;
 }
 
@@ -1664,6 +1666,7 @@ static int cpuset_write_s64(struct cgroup_subsys_state *css, struct cftype *cft,
 	cpuset_filetype_t type = cft->private;
 	int retval = -ENODEV;
 
+	get_online_cpus();
 	mutex_lock(&cpuset_mutex);
 	if (!is_cpuset_online(cs))
 		goto out_unlock;
@@ -1678,6 +1681,7 @@ static int cpuset_write_s64(struct cgroup_subsys_state *css, struct cftype *cft,
 	}
 out_unlock:
 	mutex_unlock(&cpuset_mutex);
+	put_online_cpus();
 	return retval;
 }
 
@@ -1716,6 +1720,7 @@ static ssize_t cpuset_write_resmask(struct kernfs_open_file *of,
 	kernfs_break_active_protection(of->kn);
 	flush_work(&cpuset_hotplug_work);
 
+	get_online_cpus();
 	mutex_lock(&cpuset_mutex);
 	if (!is_cpuset_online(cs))
 		goto out_unlock;
@@ -1741,6 +1746,7 @@ static ssize_t cpuset_write_resmask(struct kernfs_open_file *of,
 	free_trial_cpuset(trialcs);
 out_unlock:
 	mutex_unlock(&cpuset_mutex);
+	put_online_cpus();
 	kernfs_unbreak_active_protection(of->kn);
 	css_put(&cs->css);
 	flush_workqueue(cpuset_migrate_mm_wq);
@@ -1985,6 +1991,7 @@ static int cpuset_css_online(struct cgroup_subsys_state *css)
 	if (!parent)
 		return 0;
 
+	get_online_cpus();
 	mutex_lock(&cpuset_mutex);
 
 	set_bit(CS_ONLINE, &cs->flags);
@@ -2035,6 +2042,7 @@ static int cpuset_css_online(struct cgroup_subsys_state *css)
 	spin_unlock_irq(&callback_lock);
 out_unlock:
 	mutex_unlock(&cpuset_mutex);
+	put_online_cpus();
 	return 0;
 }
 
@@ -2048,6 +2056,7 @@ static void cpuset_css_offline(struct cgroup_subsys_state *css)
 {
 	struct cpuset *cs = css_cs(css);
 
+	get_online_cpus();
 	mutex_lock(&cpuset_mutex);
 
 	if (is_sched_load_balance(cs))
@@ -2057,6 +2066,7 @@ static void cpuset_css_offline(struct cgroup_subsys_state *css)
 	clear_bit(CS_ONLINE, &cs->flags);
 
 	mutex_unlock(&cpuset_mutex);
+	put_online_cpus();
 }
 
 static void cpuset_css_free(struct cgroup_subsys_state *css)
-- 
2.17.1

