From: Hao Xu <haoxu-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: [PATCH 1/2] cpuset: add a helper to check if cpu in cpuset of current task
Date: Wed,  1 Sep 2021 20:43:21 +0800
Message-ID: <20210901124322.164238-2-haoxu@linux.alibaba.com>
References: <20210901124322.164238-1-haoxu@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20210901124322.164238-1-haoxu-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Pavel Begunkov <asml.silence-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: io-uring-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Joseph Qi <joseph.qi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>

Check if a cpu is in the cpuset of current task, not guaranteed that
cpu is online.

Signed-off-by: Hao Xu <haoxu-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
---
 include/linux/cpuset.h |  7 +++++++
 kernel/cgroup/cpuset.c | 11 +++++++++++
 2 files changed, 18 insertions(+)

diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
index 04c20de66afc..fad77c91bc1f 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -116,6 +116,8 @@ static inline int cpuset_do_slab_mem_spread(void)
 
 extern bool current_cpuset_is_being_rebound(void);
 
+extern bool test_cpu_in_current_cpuset(int cpu);
+
 extern void rebuild_sched_domains(void);
 
 extern void cpuset_print_current_mems_allowed(void);
@@ -257,6 +259,11 @@ static inline bool current_cpuset_is_being_rebound(void)
 	return false;
 }
 
+static inline bool test_cpu_in_current_cpuset(int cpu)
+{
+	return false;
+}
+
 static inline void rebuild_sched_domains(void)
 {
 	partition_sched_domains(1, NULL, NULL);
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index adb5190c4429..a63c27e9430e 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1849,6 +1849,17 @@ bool current_cpuset_is_being_rebound(void)
 	return ret;
 }
 
+bool test_cpu_in_current_cpuset(int cpu)
+{
+	bool ret;
+
+	rcu_read_lock();
+	ret = cpumask_test_cpu(cpu, task_cs(current)->effective_cpus);
+	rcu_read_unlock();
+
+	return ret;
+}
+
 static int update_relax_domain_level(struct cpuset *cs, s64 val)
 {
 #ifdef CONFIG_SMP
-- 
2.24.4

