From: Gang Li <ligang.bdlg-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: [RFC PATCH v1] mm: oom: introduce cpuset oom
Date: Wed, 21 Sep 2022 14:47:09 +0800
Message-ID: <20220921064710.89663-1-ligang.bdlg@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=YKmiNCL23WE57xBpMjvetlOGzH6dcSznAfjUp/F/KjI=;
        b=S/OWLpu8/5jFvci3PF6KKFjZAWV8sfpD6EB2HvvJtYHmbS1wDhf2tqEqrHhsxPdznr
         7Xl63Ro2rdWamL1oT8uEx/ZrWq2QnonCQijnSrGXJjznTUy+kMnvk5GmBUWryYjemC/T
         iF7482K53z7grnG8c8F87VkM0VIX164G7R7/xsKj6HuMAhwa4+0vM7D9+TCKrltHyEWx
         HLWv/DHgAtI6Sp9HJH6wCX/sjVQkaPS6sn99HM23MxS8s3XiJY15q1EaTL8YqK21MBsw
         Xr6SIM+1oU7JDT1DQiyRAewiPqdocLGFYdjYpzNi/PrqNFsKD8jowDT8NWtIiKLW4gaX
         Jy7w==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Gang Li <ligang.bdlg-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

cpuset confine processes to processor and memory node subsets.
When a process in cpuset triggers oom, it may kill a completely
irrelevant process on another numa node, which will not release any
memory for this cpuset.

It seems that `CONSTRAINT_CPUSET` is not really doing much these
days. Using CONSTRAINT_CPUSET, we can easily achieve node aware oom
killing by selecting victim from the cpuset which triggers oom.

Suggested-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Signed-off-by: Gang Li <ligang.bdlg-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
---
This idea comes from a previous patch:
mm, oom: Introduce per numa node oom for CONSTRAINT_MEMORY_POLICY
https://lore.kernel.org/all/YoJ%2FioXwGTdCywUE-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org/

Any comments are welcome.
---
 include/linux/cpuset.h |  6 ++++++
 kernel/cgroup/cpuset.c | 17 +++++++++++++++++
 mm/oom_kill.c          |  4 ++++
 3 files changed, 27 insertions(+)

diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
index d58e0476ee8e..7475f613ab90 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -178,6 +178,8 @@ static inline void set_mems_allowed(nodemask_t nodemask)
 	task_unlock(current);
 }
 
+int cpuset_cgroup_scan_tasks(int (*fn)(struct task_struct *, void *), void *arg);
+
 #else /* !CONFIG_CPUSETS */
 
 static inline bool cpusets_enabled(void) { return false; }
@@ -299,6 +301,10 @@ static inline bool read_mems_allowed_retry(unsigned int seq)
 	return false;
 }
 
+static inline int cpuset_cgroup_scan_tasks(int (*fn)(struct task_struct *, void *), void *arg)
+{
+	return 0;
+}
 #endif /* !CONFIG_CPUSETS */
 
 #endif /* _LINUX_CPUSET_H */
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index b474289c15b8..1f1238b4276d 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -3943,6 +3943,23 @@ void cpuset_print_current_mems_allowed(void)
 	rcu_read_unlock();
 }
 
+int cpuset_cgroup_scan_tasks(int (*fn)(struct task_struct *, void *), void *arg)
+{
+	int ret = 0;
+	struct cgroup *cgrp;
+	struct css_task_iter it;
+	struct task_struct *task;
+
+	rcu_read_lock();
+	css_task_iter_start(&(task_cs(current)->css), CSS_TASK_ITER_PROCS, &it);
+	while (!ret && (task = css_task_iter_next(&it)))
+		ret = fn(task, arg);
+	css_task_iter_end(&it);
+	rcu_read_unlock();
+
+	return ret;
+}
+
 /*
  * Collection of memory_pressure is suppressed unless
  * this flag is enabled by writing "1" to the special
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 46e7e073f137..8cea787b359c 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -367,6 +367,8 @@ static void select_bad_process(struct oom_control *oc)
 
 	if (is_memcg_oom(oc))
 		mem_cgroup_scan_tasks(oc->memcg, oom_evaluate_task, oc);
+	else if (oc->constraint == CONSTRAINT_CPUSET)
+		cpuset_cgroup_scan_tasks(oom_evaluate_task, oc);
 	else {
 		struct task_struct *p;
 
@@ -427,6 +429,8 @@ static void dump_tasks(struct oom_control *oc)
 
 	if (is_memcg_oom(oc))
 		mem_cgroup_scan_tasks(oc->memcg, dump_task, oc);
+	else if (oc->constraint == CONSTRAINT_CPUSET)
+		cpuset_cgroup_scan_tasks(dump_task, oc);
 	else {
 		struct task_struct *p;
 
-- 
2.20.1

