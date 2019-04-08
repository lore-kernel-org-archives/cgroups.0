From: Song Liu <songliubraving@fb.com>
Subject: [PATCH 5/7] sched/fair: global idleness counter for cpu.headroom
Date: Mon, 8 Apr 2019 14:45:37 -0700
Message-ID: <20190408214539.2705660-6-songliubraving@fb.com>
References: <20190408214539.2705660-1-songliubraving@fb.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=71jwMW3DLj1Y0qARI7vL6lQXr6moJopGA2vrTbvAKZY=;
 b=IFnokjdBqKBbNDyHAhzFonMssV3LqPdtM0epDC+Rm1ZlQCjqnHfITvIA9dfznHG/Qq8X
 tvgR3bD4vzKzSyCORx7WxtaQ+vRYuoJrkmtqhVRMNf5FpQCjKV1kT4/R5XfJDOknNd+Y
 vTkYz5QQoGDP9GKKp7GsXm+XyXqJSHQxlSQ= 
In-Reply-To: <20190408214539.2705660-1-songliubraving@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Cc: mingo@redhat.com, peterz@infradead.org, vincent.guittot@linaro.org, tglx@linutronix.de, morten.rasmussen@arm.com, kernel-team@fb.com, Song Liu <songliubraving@fb.com>

This patch introduces a global idleness counter in fair.c for the
cpu.headroom knob. This counter is based on per cpu get_idle_time().

The counter is used via function call:

  unsigned long cfs_global_idleness_update(u64 now, u64 period);

The function returns global idleness in fixed-point percentage since
previous call of the function. If the time between previous call of the
function is called and @now is shorter than @period, the function will
return idleness calculated in previous call.

cfs_global_idleness_update() will be called from a non-preemptible
context, struct cfs_global_idleness uses raw_spin_lock instead of
spin_lock.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 fs/proc/stat.c              |  4 +--
 include/linux/kernel_stat.h |  2 ++
 kernel/sched/fair.c         | 64 +++++++++++++++++++++++++++++++++++++
 3 files changed, 68 insertions(+), 2 deletions(-)

diff --git a/fs/proc/stat.c b/fs/proc/stat.c
index 80c305f206bb..b327ffdb169f 100644
--- a/fs/proc/stat.c
+++ b/fs/proc/stat.c
@@ -23,7 +23,7 @@
 
 #ifdef arch_idle_time
 
-static u64 get_idle_time(struct kernel_cpustat *kcs, int cpu)
+u64 get_idle_time(struct kernel_cpustat *kcs, int cpu)
 {
 	u64 idle;
 
@@ -45,7 +45,7 @@ static u64 get_iowait_time(struct kernel_cpustat *kcs, int cpu)
 
 #else
 
-static u64 get_idle_time(struct kernel_cpustat *kcs, int cpu)
+u64 get_idle_time(struct kernel_cpustat *kcs, int cpu)
 {
 	u64 idle, idle_usecs = -1ULL;
 
diff --git a/include/linux/kernel_stat.h b/include/linux/kernel_stat.h
index 7ee2bb43b251..337135272391 100644
--- a/include/linux/kernel_stat.h
+++ b/include/linux/kernel_stat.h
@@ -97,4 +97,6 @@ extern void account_process_tick(struct task_struct *, int user);
 
 extern void account_idle_ticks(unsigned long ticks);
 
+u64 get_idle_time(struct kernel_cpustat *kcs, int cpu);
+
 #endif /* _LINUX_KERNEL_STAT_H */
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 65aa9d3b665f..49c68daffe7e 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -116,6 +116,62 @@ static unsigned int capacity_margin			= 1280;
  * (default: 5 msec, units: microseconds)
  */
 unsigned int sysctl_sched_cfs_bandwidth_slice		= 5000UL;
+
+/* tracking global idlenesss for cpu.headroom */
+struct cfs_global_idleness {
+	u64		prev_total_idle_time;
+	u64		prev_timestamp;
+	unsigned long	idle_percent; /* fixed-point */
+	raw_spinlock_t	lock;
+};
+
+static struct cfs_global_idleness global_idleness;
+
+/*
+ * Calculate global idleness in fixed-point percentage since previous call
+ * of the function. If the time between previous call of the function is
+ * called and @now is shorter than @period, return idleness calculated in
+ * previous call.
+ */
+static unsigned long cfs_global_idleness_update(u64 now, u64 period)
+{
+	u64 prev_timestamp, total_idle_time, delta_idle_time;
+	unsigned long idle_percent;
+	int cpu;
+
+	/*
+	 * Fastpath: if idleness has been updated within the last period
+	 * of time, just return previous idleness.
+	 */
+	prev_timestamp = READ_ONCE(global_idleness.prev_timestamp);
+	if (prev_timestamp + period >= now)
+		return READ_ONCE(global_idleness.idle_percent);
+
+	raw_spin_lock_irq(&global_idleness.lock);
+	if (global_idleness.prev_timestamp + period >= now) {
+		idle_percent = global_idleness.idle_percent;
+		goto out;
+	}
+
+	/* Slowpath: calculate the average idleness since prev_timestamp */
+	total_idle_time = 0;
+	for_each_online_cpu(cpu)
+		total_idle_time += get_idle_time(&kcpustat_cpu(cpu), cpu);
+
+	delta_idle_time = total_idle_time -
+		global_idleness.prev_total_idle_time;
+
+	idle_percent = div64_u64((delta_idle_time << FSHIFT) * 100,
+				 num_online_cpus() *
+				 (now - global_idleness.prev_timestamp));
+
+	WRITE_ONCE(global_idleness.prev_total_idle_time, total_idle_time);
+	WRITE_ONCE(global_idleness.prev_timestamp, now);
+	WRITE_ONCE(global_idleness.idle_percent, idle_percent);
+out:
+	raw_spin_unlock_irq(&global_idleness.lock);
+	return idle_percent;
+}
 #endif
 
 static inline void update_load_add(struct load_weight *lw, unsigned long inc)
@@ -4293,6 +4349,11 @@ void __refill_cfs_bandwidth_runtime(struct cfs_bandwidth *cfs_b)
 	cfs_b->runtime = cfs_b->quota;
 	cfs_b->runtime_expires = now + ktime_to_ns(cfs_b->period);
 	cfs_b->expires_seq++;
+
+	if (cfs_b->target_idle == 0)
+		return;
+
+	cfs_global_idleness_update(now, cfs_b->period);
 }
 
 static inline struct cfs_bandwidth *tg_cfs_bandwidth(struct task_group *tg)
@@ -10676,4 +10737,7 @@ __init void init_sched_fair_class(void)
 #endif
 #endif /* SMP */
 
+#ifdef CONFIG_CFS_BANDWIDTH
+	raw_spin_lock_init(&global_idleness.lock);
+#endif
 }
-- 
2.17.1

