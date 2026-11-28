Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.136
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795827961;
	b=MG57e2n7s6Oh8wxbb95bRAf8Zd3G8PYlNIHoM4l6/ZzBC6tDAfGZpd7qlQO6yQt5/+TR
	 r4gOEBoVx7DV7qvBgfIW7v+XRv9my9wk65Z2KoPwN+wogtPvnLOPbFxZy7cPfND4ICe7J
	 jD7yguTwd0Vxbyg2hKfi5nMDk+5+RZjAu/3wl9mqhtilevCR58HUAe3khPcx7pcl5YeYV
	 dYsxzhocqzke4ti/EoooM0Bbidvv8V2MWGBZeaBv7OIOqB/+oRZbiy30ASbLcCvYwGm8n
	 bWPLlyYyYqsSUR51/W6bJ4X68M6CK6dogzQXb2VnINbooyiyVUji+0DqxIB6oyILGBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795827961;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=+zYXZvQ1eBUWJYLHgFwY23XJjKp2fFexOpnjIFJZ5w4=;
	b=SKJs8eCfLpAcj8R+Nb2UntPzacCruro4Tu9Q0q0TKXRwzR6boczFzzk1hya1Nt9x9Vg5
	 +sgcc36cNb8lvgwGjWT2502nl4ryEISX6rIgqRlrKELsW+f5xUhsDJHzdfAZzXnDpQpEH
	 jIr4AlJ9G39vPeJ0YvNagliCfPLuGMPn1aU9hjTdtwnRKaLd66WEDsB1jnjbLUu4YONfo
	 ubvLkL9/v/RbRn89uA30ARqwWuIfpUE+0tJMDGXKQn3VLLiALy3JahgF/FIDctcn+8qvi
	 WIVF8rzHDjL83o9weqxF7a3hOgZs+sI1A+AWzOb3pQK3Dw4AYk0zqiBnzY9xwv1IlAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=QT6dYP+p;
	arc=none smtp.remote-ip=95.215.58.136
Received: from mta1.migadu.com (out-136.mta1.migadu.com [95.215.58.136])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7749A606A31E
	for <cgroups@vger.kernel.org>; Sat, 28 Nov 2026 01:05:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7749A606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=QT6dYP+p
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=GUdrcGjdVPSvmjiLeH+nZFppbSikw7wi3nqfE1/0FPc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795827957; v=1; x=1796432757;
 b=QT6dYP+p+krVa9xFOajhbpxZmKlUhHIgK429qX8zqL++Mt0TJuqAGwTa1xcrufr/YcrkAmK2
 3fSSXguPKOJOmsHC8hNYGPQlKjO++XSxoe5Mane1DQZBrc9Kf52/rzZcd00PmrLUwLjp+M6EyPG
 JF4tm5Zylz7huEUxo3ksEiCs=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 1d0e79abe3b1ff23;
	Sat, 28 Nov 2026 01:05:56 +0000
X-Mizu-Trace-ID: 1d0e79abe3b1ff23
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>
Cc: Ridong Chen <ridong.chen@linux.dev>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Frederic Weisbecker <frederic@kernel.org>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH v2 cgroup/for-7.4-fixes] sched/isolation: Publish new HK_TYPE_DOMAIN cpumask under cpuset_mutex
Date: Sat, 28 Nov 2026 09:05:35 +0800
Message-Id: <20261128010535.1831141-1-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ridong Chen <chenridong@xiaomi.com>

Commit a84097e625f2 ("cgroup/cpuset: Call housekeeping_update() without
holding cpus_read_lock") calls housekeeping_update() after dropping
cpus_read_lock and cpuset_mutex, so the HK_TYPE_DOMAIN cpumask is now
switched and freed outside of those locks. But readers holding either
lock may still access it without rcu_read_lock() as allowed by
housekeeping_dereference_check(), and synchronize_rcu() doesn't wait
for them:

  CPU A                                  CPU B
  rebuild_sched_domains()                cpuset_update_sd_hk_unlock()
                                           mutex_unlock(&cpuset_mutex)
                                           cpus_read_unlock()
    mutex_lock(&cpuset_mutex)
    p = housekeeping_cpumask(DOMAIN)
                                           housekeeping_update()
                                             rcu_assign_pointer()
                                             synchronize_rcu()
                                             kfree(old)
    access p <- UAF

Fix it by moving the pointer switch into housekeeping_publish(), which
is called before dropping the locks. Then CPU A either finishes before
CPU B switches the pointer, or only sees the new cpumask:

  CPU A                                  CPU B
                                         cpuset_update_sd_hk_unlock()
                                           housekeeping_publish()
                                             rcu_assign_pointer()
    mutex_lock(&cpuset_mutex) <- wait
                                           mutex_unlock(&cpuset_mutex)
                                           cpus_read_unlock()
    p = housekeeping_cpumask(DOMAIN)       housekeeping_update()
        <- new cpumask                       synchronize_rcu()
                                             kfree(old)

The rest of housekeeping_update(), including the workqueue flushes,
still runs without those locks.

Fixes: a84097e625f2 ("cgroup/cpuset: Call housekeeping_update() without holding cpus_read_lock")
Acked-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Frederic Weisbecker <frederic@kernel.org>
Acked-by: Waiman Long <longman@redhat.com>
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
v2:
- Rebase onto cgroup/for-7.4-fixes; resolve context conflict with
  housekeeping_set_cpu() from commit 884e88175b95. No functional change.
- Add Acked-by from Tejun and Waiman, Reviewed-by from Frederic.

v1: https://lore.kernel.org/all/20261117083915.2971979-1-ridong.chen@linux.dev/

 include/linux/sched/isolation.h |  6 ++++--
 kernel/cgroup/cpuset.c          | 12 ++++++++----
 kernel/sched/isolation.c        | 23 ++++++++++++++++-------
 3 files changed, 28 insertions(+), 13 deletions(-)

diff --git a/include/linux/sched/isolation.h b/include/linux/sched/isolation.h
index ae5109450ac9..cb7f07cf1c41 100644
--- a/include/linux/sched/isolation.h
+++ b/include/linux/sched/isolation.h
@@ -43,7 +43,8 @@ extern const struct cpumask *housekeeping_cpumask(enum hk_type type);
 extern bool housekeeping_enabled(enum hk_type type);
 extern void housekeeping_affine(struct task_struct *t, enum hk_type type);
 extern bool housekeeping_test_cpu(int cpu, enum hk_type type);
-extern int housekeeping_update(struct cpumask *isol_mask);
+extern struct cpumask *housekeeping_publish(struct cpumask *isol_mask);
+extern void housekeeping_update(struct cpumask *isol_mask, struct cpumask *old);
 extern void __init housekeeping_set_cpu(int cpu, enum hk_type type);
 extern void __init housekeeping_init(void);
 
@@ -72,7 +73,8 @@ static inline bool housekeeping_test_cpu(int cpu, enum hk_type type)
 	return true;
 }
 
-static inline int housekeeping_update(struct cpumask *isol_mask) { return 0; }
+static inline struct cpumask *housekeeping_publish(struct cpumask *isol_mask) { return NULL; }
+static inline void housekeeping_update(struct cpumask *isol_mask, struct cpumask *old) { }
 static inline void housekeeping_set_cpu(int cpu, enum hk_type type) { }
 static inline void housekeeping_init(void) { }
 #endif /* CONFIG_CPU_ISOLATION */
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index db32d330cfbc..aa82080dd1fa 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1472,17 +1472,21 @@ static void cpuset_update_sd_hk_unlock(void)
 		rebuild_sched_domains_locked();
 
 	if (update_housekeeping) {
+		struct cpumask *old;
+
 		update_housekeeping = false;
 		cpumask_copy(isolated_hk_cpus, isolated_cpus);
 
 		/*
-		 * housekeeping_update() is now called without holding
-		 * cpus_read_lock and cpuset_mutex. Only cpuset_top_mutex
-		 * is still being held for mutual exclusion.
+		 * Publish the new cpumask with cpus_read_lock and cpuset_mutex
+		 * held, but call housekeeping_update() without them. Only
+		 * cpuset_top_mutex is still being held for mutual exclusion.
 		 */
+		old = housekeeping_publish(isolated_hk_cpus);
 		mutex_unlock(&cpuset_mutex);
 		cpus_read_unlock();
-		WARN_ON_ONCE(housekeeping_update(isolated_hk_cpus));
+		if (!WARN_ON_ONCE(IS_ERR(old)))
+			housekeeping_update(isolated_hk_cpus, old);
 		mutex_unlock(&cpuset_top_mutex);
 	} else {
 		cpuset_full_unlock();
diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
index c0c8b8862cbd..d6318f81c216 100644
--- a/kernel/sched/isolation.c
+++ b/kernel/sched/isolation.c
@@ -131,23 +131,26 @@ void __init housekeeping_set_cpu(int cpu, enum hk_type type)
 		cpumask_set_cpu(cpu, housekeeping_cpumask_dereference(type));
 }
 
-int housekeeping_update(struct cpumask *isol_mask)
+/* Called with cpus_read_lock and cpuset_mutex held */
+struct cpumask *housekeeping_publish(struct cpumask *isol_mask)
 {
 	struct cpumask *trial, *old = NULL;
-	int err;
+
+	lockdep_assert_cpus_held();
+	lockdep_assert_cpuset_lock_held();
 
 	trial = kmalloc(cpumask_size(), GFP_KERNEL);
 	if (!trial)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	cpumask_andnot(trial, housekeeping_cpumask(HK_TYPE_DOMAIN_BOOT), isol_mask);
 	if (!cpumask_intersects(trial, cpu_online_mask)) {
 		kfree(trial);
-		return -EINVAL;
+		return ERR_PTR(-EINVAL);
 	}
 
 	if (!housekeeping.flags)
-		static_branch_enable(&housekeeping_overridden);
+		static_branch_enable_cpuslocked(&housekeeping_overridden);
 
 	if (housekeeping.flags & HK_FLAG_DOMAIN)
 		old = housekeeping_cpumask_dereference(HK_TYPE_DOMAIN);
@@ -155,6 +158,14 @@ int housekeeping_update(struct cpumask *isol_mask)
 		WRITE_ONCE(housekeeping.flags, housekeeping.flags | HK_FLAG_DOMAIN);
 	rcu_assign_pointer(housekeeping.cpumasks[HK_TYPE_DOMAIN], trial);
 
+	return old;
+}
+
+/* Called without cpus_read_lock and cpuset_mutex held */
+void housekeeping_update(struct cpumask *isol_mask, struct cpumask *old)
+{
+	int err;
+
 	synchronize_rcu();
 
 	pci_probe_flush_workqueue();
@@ -171,8 +182,6 @@ int housekeeping_update(struct cpumask *isol_mask)
 	WARN_ON_ONCE(err < 0);
 
 	kfree(old);
-
-	return 0;
 }
 
 void __init housekeeping_init(void)

base-commit: af8b797b745780ff011d38e3fe6aeae775248242
-- 
2.34.1

