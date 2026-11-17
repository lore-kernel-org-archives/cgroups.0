Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.15
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794904777;
	b=ZR6/LbKxI3SiGOws2boyvRA2uenqAHVHBLcn72Bulp0pJHHjQFqRgHpFLTipB0e655Rl
	 Ba43sGvZTCCToya73iL8sXe6ue9cYCI6MHQvSwKoWADiUoldu+pVUByXGMq8hHzY3gwVV
	 5A0e4E15+ehCDasE7mzSTEHZuaIOurQQAc4ZfCj1lXC+OOyHqeTnn6Tco51Ka7zrttjCn
	 Xe5Lg1eBhuEUAKJasEoBka0efwOhE0TVRsRRpZAjsRUemsXyex0ljcr/zfQRjJYgy532y
	 WY2KvbNbUUuT+7ShFxkf3OYy9S+dSIFM2obHqzQ5BLTs6Ur5hNRFA2oqeRmEXHCjVIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794904777;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=XmS2Ybw4fClc4m3xDQofcdzVpjOmLTbkgJAH30zx6Wc=;
	b=HFSpNHJUEJ5qHRqs6MXbwsAq9jLsFhhHbQWaYc5Ms7i7xmdEi2jmi2Rc/VN1ANEN5dQa
	 XHdAE6d8U3276mqBC2oD5rL2c1ooGFmsZr0kd8dGNTuERreD9i+rJ3K7lbo0LO0cWD3iB
	 OD+CRrnQySWyBGwcdafPAOXvgaYvB3VMAGjMxLrEP67ao9EEt/f8nL0ShUkU0AA2F/+GB
	 t+h+gAt1XTXzktBkJJkQS1AS35bgw4AU+QTCm+ufAuCgcmEeUSC05igVZBLEP4IAbGeYH
	 Qk96IfbTZgDQX8iipON8TIqEzlMCXnEfdsBpoHwVgV4AyfZhsCM93NhCRT1C/rcLzyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=i9BqFDhw;
	arc=none smtp.remote-ip=95.215.58.15
Received: from mta1.migadu.com (out-15.mta1.migadu.com [95.215.58.15])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4A66606A893
	for <cgroups@vger.kernel.org>; Tue, 17 Nov 2026 08:39:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B4A66606A893
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=i9BqFDhw
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=LW7CTRXKDIQ0Q2Yz6X6SCI0G0kzOFEfnSjvu1UtxrG8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794904774; v=1; x=1795509574;
 b=i9BqFDhwC5oGb8EJWma/HXQGfC/0s2xQ8XhkV3tiZVfxfDGBCB+RzKxJ8Tq0EmveScJq1Y4u
 RHiINo/SlU2akhKz9ayYeZt73OGInrqhczlqURtACTlK+vLXY2j2oRxE8t82tqunjP5z62Kx3u1
 kc7SLNDsFWT2yeI+MniYieq4=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 31bfc8e230cb5987;
	Tue, 17 Nov 2026 08:39:34 +0000
X-Mizu-Trace-ID: 31bfc8e230cb5987
X-Migadu-Flow: FLOW_OUT
From: Ridong <ridong.chen@linux.dev>
To: longman@redhat.com,
	frederic@kernel.org,
	tj@kernel.org,
	peterz@infradead.org,
	mingo@redhat.com,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	dietmar.eggemann@arm.com,
	rostedt@goodmis.org,
	bsegall@google.com,
	mgorman@suse.de,
	vschneid@redhat.com,
	kprateek.nayak@amd.com,
	hannes@cmpxchg.org,
	mkoutny@suse.com
Cc: linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	guopeng.zhang@linux.dev,
	mathieu.desnoyers@efficios.com,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH] sched/isolation: Publish new HK_TYPE_DOMAIN cpumask under cpuset_mutex
Date: Tue, 17 Nov 2026 16:39:15 +0800
Message-Id: <20261117083915.2971979-1-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <054a53a3-c038-48fe-ac01-fc24fd8065d0@linux.dev>
References: <054a53a3-c038-48fe-ac01-fc24fd8065d0@linux.dev>
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
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 include/linux/sched/isolation.h |  6 ++++--
 kernel/cgroup/cpuset.c          | 12 ++++++++----
 kernel/sched/isolation.c        | 23 ++++++++++++++++-------
 3 files changed, 28 insertions(+), 13 deletions(-)

diff --git a/include/linux/sched/isolation.h b/include/linux/sched/isolation.h
index cf0fd03dd7a24..09fabf42e3224 100644
--- a/include/linux/sched/isolation.h
+++ b/include/linux/sched/isolation.h
@@ -43,7 +43,8 @@ extern const struct cpumask *housekeeping_cpumask(enum hk_type type);
 extern bool housekeeping_enabled(enum hk_type type);
 extern void housekeeping_affine(struct task_struct *t, enum hk_type type);
 extern bool housekeeping_test_cpu(int cpu, enum hk_type type);
-extern int housekeeping_update(struct cpumask *isol_mask);
+extern struct cpumask *housekeeping_publish(struct cpumask *isol_mask);
+extern void housekeeping_update(struct cpumask *isol_mask, struct cpumask *old);
 extern void __init housekeeping_init(void);
 
 #else
@@ -71,7 +72,8 @@ static inline bool housekeeping_test_cpu(int cpu, enum hk_type type)
 	return true;
 }
 
-static inline int housekeeping_update(struct cpumask *isol_mask) { return 0; }
+static inline struct cpumask *housekeeping_publish(struct cpumask *isol_mask) { return NULL; }
+static inline void housekeeping_update(struct cpumask *isol_mask, struct cpumask *old) { }
 static inline void housekeeping_init(void) { }
 #endif /* CONFIG_CPU_ISOLATION */
 
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 8a8a424a389f3..1673bb25a797b 100644
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
index 156025ef81b75..9e202269e42f6 100644
--- a/kernel/sched/isolation.c
+++ b/kernel/sched/isolation.c
@@ -120,23 +120,26 @@ bool housekeeping_test_cpu(int cpu, enum hk_type type)
 }
 EXPORT_SYMBOL_GPL(housekeeping_test_cpu);
 
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
@@ -144,6 +147,14 @@ int housekeeping_update(struct cpumask *isol_mask)
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
@@ -160,8 +171,6 @@ int housekeeping_update(struct cpumask *isol_mask)
 	WARN_ON_ONCE(err < 0);
 
 	kfree(old);
-
-	return 0;
 }
 
 void __init housekeeping_init(void)
-- 
2.34.1

