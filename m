From: Hao Xu <haoxu@linux.alibaba.com>
Subject: [PATCH for-5.15 v2] io_uring: consider cgroup setting when binding sqpoll cpu
Date: Fri, 27 Aug 2021 22:13:15 +0800
Message-ID: <20210827141315.235974-1-haoxu@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <io-uring-owner@vger.kernel.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe@kernel.dk>, Zefan Li <lizefan.x@bytedance.com>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, cgroups@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>

Since sqthread is userspace like thread now, it should respect cgroup
setting, thus we should consider current allowed cpuset when doing
cpu binding for sqthread.

Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---

v1-->v2
 - add a helper in cpuset.c so that we can directly leverage task_cs()
 - remove v1 code which we don't need now

 fs/io_uring.c          | 21 ++++++++++++++++-----
 include/linux/cpuset.h |  7 +++++++
 kernel/cgroup/cpuset.c | 11 +++++++++++
 3 files changed, 34 insertions(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index be3c3aea6398..a0f54c545158 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -79,6 +79,7 @@
 #include <linux/pagemap.h>
 #include <linux/io_uring.h>
 #include <linux/tracehook.h>
+#include <linux/cpuset.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/io_uring.h>
@@ -7000,6 +7001,16 @@ static bool io_sqd_handle_event(struct io_sq_data *sqd)
 	return did_sig || test_bit(IO_SQ_THREAD_SHOULD_STOP, &sqd->state);
 }
 
+static int io_sq_bind_cpu(int cpu)
+{
+	if (!test_cpu_in_current_cpuset(cpu))
+		pr_warn("sqthread %d: bound cpu not allowed\n", current->pid);
+	else
+		set_cpus_allowed_ptr(current, cpumask_of(cpu));
+
+	return 0;
+}
+
 static int io_sq_thread(void *data)
 {
 	struct io_sq_data *sqd = data;
@@ -7010,11 +7021,9 @@ static int io_sq_thread(void *data)
 
 	snprintf(buf, sizeof(buf), "iou-sqp-%d", sqd->task_pid);
 	set_task_comm(current, buf);
-
 	if (sqd->sq_cpu != -1)
-		set_cpus_allowed_ptr(current, cpumask_of(sqd->sq_cpu));
-	else
-		set_cpus_allowed_ptr(current, cpu_online_mask);
+		io_sq_bind_cpu(sqd->sq_cpu);
+
 	current->flags |= PF_NO_SETAFFINITY;
 
 	mutex_lock(&sqd->lock);
@@ -8208,8 +8217,10 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
 			int cpu = p->sq_thread_cpu;
 
 			ret = -EINVAL;
-			if (cpu >= nr_cpu_ids || !cpu_online(cpu))
+			if (cpu >= nr_cpu_ids || !cpu_online(cpu) ||
+			    !test_cpu_in_current_cpuset(cpu))
 				goto err_sqpoll;
+
 			sqd->sq_cpu = cpu;
 		} else {
 			sqd->sq_cpu = -1;
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

