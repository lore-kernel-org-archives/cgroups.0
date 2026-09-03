Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 871324398E4
	for <cgroups@vger.kernel.org>; Thu,  3 Sep 2026 21:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788472600; cv=none; b=Z5TGzO0u4d5Ad0nFQs7nBR5V3MwottnVCHt93UOu+PqKZBAXQjGFQKa+jtT0mSaVzj5Uotw5B2RCh5BfU0GjMKN9yQK9Asf08DcQ7Imv4uATSExYF1xjMcobC+E3GZCU/ZTnWFz2ae2pXz+74Cr8rYWDyCImcFTSWhL7p2jkuHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788472600; c=relaxed/simple;
	bh=YJilABSOK1GlBEZVDRaW39Y4KVa7nE7Y1Ijf89QN/Ds=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=m935xynCNs2og4scABFCReviYoZfOB1SrWEnulDAMtesvKARweiyclNr7B6Pm9D4Hc5OGqrl3dYbl6odFkguDZWOvDlt4zWr4LOpx57VxhDaicKb7NQ1CGB6w1eSKLsb+ELSvde9IQaQs8VV97yYpFK4SNL6cPYoHeGE8Onbxxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XiE7kRUA; arc=none smtp.client-ip=209.85.210.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XiE7kRUA"
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-7e6b5737bb2so388667a34.1
        for <cgroups@vger.kernel.org>; Thu, 03 Sep 2026 14:56:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788472593; x=1789077393; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=V6x2A4XACvWMSkpNxGFvQMuExZ9LJ7tgOiNXZV9kzeM=;
        b=XiE7kRUAAI2oGoFD8Wbs7sDS01/Xtywt4MpYxKJ3IO6ydlZdN8YxoVQq8ol3MV2Pj4
         hk+gDfKr5J+OGMR+SEGnBZG4+3V02A4YoBEQWkeor77tj9tqhRx2OtrCwiX3gqBIJ4D1
         9//LbDSAtbMBnJGmaXLUFfuCw/PIR5dE1yHtEhWj7h9ICDMNbCXXZfaFltonY8bZVUau
         LMXzCo8lMcN+7Jh4UILiKjgRTSRBcnqgDTLWKTMpiajDjoRdkc/X/cq5OE1hfxdXaEmC
         v0do8o44hNvaMGte6HJbjb560Cm61SCi05bCIIfmPPCDm2pDpdt5SaL1N4c9RuR5nCFz
         PxOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788472593; x=1789077393;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=V6x2A4XACvWMSkpNxGFvQMuExZ9LJ7tgOiNXZV9kzeM=;
        b=SOv8O04cfJ+spKethO2KB+2mbm/D5bb6fckWXy/hsuee//p7JEfUwfccDUzZzYA58n
         7SA9bfZhijMKPP6Izt+BZWewj9qZixvh08RAF4cFukpCFb5ziUxnTweagyuaNeJksFXJ
         sSmueZyHTBftNNuq3ELCTmG/utQEEtFjsjPbJZqOnuCPiaL8ktlMA1R4Iipk9Y3E1kyw
         4uOvXS86pLBbq/qBAlpr4SwvyxQ3gRquMbtsDywjWoO9Bypr5PKT7sQ61EzcdBBArLae
         WhY6EZQRZE1HSvIqKithlZrYEEoYze2Zw3xTOdP/bxwNnZZ/LvDLkRkTaw8chwBbIMff
         71Uw==
X-Forwarded-Encrypted: i=1; AKwUvBy0PpcSP9TBnvMoRJzJI9e8/CJMZA/qtn5KO7fVojkGQaaw3vtucAAhCxZECcbUWF56vxhEDkgT@vger.kernel.org
X-Gm-Message-State: AFuF++mHy7e1bQrbclC5c6ite3/g2NsaE9TD8/WXi66Cdw9aOfLFV3ZV
	5l08rqMmh4SbrxhpjZcT1Y6gamFQ+bxJOqpF6foEXo+5u2ScW2CZRFWn
X-Gm-Gg: AYBFou0hKG2cyUf0Zf/1wzYXNWnvN9IMIrt3UGViwYireZB2ece1V5BRW1NVztUYzQv
	eXLrxeKJKYmQXXYE2FOgP1gKvp/cYZB/qrtYzBe+CyOrbKF9AG4Re4g07pz5jHbPjWKu7qyubMj
	dhjq2NFqOuF4B/nEHKb3zHrL1l8Me3CeHXIE/OXjXdI87Uff6s1DZcLvZ9qGWEKEnFYi3E4siOs
	7WgkHseUVqByXmEMm8mQOF5UVERC1rII/ceqPfb5kz85OyrJgaJ3It0E/ogQrdfLm5CDfVQrdpD
	yF2teEbY67WZauXwHUB7XbHZIlH0/OVyCXyTGVB/m0PhxTKv+fne3xZI027QVL1DalkxCTX8SCu
	6NohBXm168nB3e2eHKPCk97JmQjDP/4G49nYreJ26f3qhrgxKGKPARpXUhub5b4ubBWnPYmO2eM
	eT4AxOAeIatpaL0+xqAtspijVxGWbjDDjbJe/IFFWXT32jlw4Wy4XacOsOeosyA1uXqHYzWPQ3J
	h6HkM5SMX6Kh0u1kbjp9ATUBnTCS+DadoGerKDR
X-Received: by 2002:a05:6830:6a93:b0:7fa:5c49:5240 with SMTP id 46e09a7af769-7fa5c4954a3mr84931a34.25.1788472592944;
        Thu, 03 Sep 2026 14:56:32 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:53::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7f9f4615a20sm1108008a34.1.2026.09.03.14.56.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 14:56:31 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: akpm@linux-foundation.org,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev
Cc: yosry@kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org
Subject: [PATCH v3] mm/memcontrol: skip non-hierarchical memcg-wide stats when v1 is unavailable
Date: Thu,  3 Sep 2026 14:56:16 -0700
Message-ID: <20260903215616.1456239-1-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

memcg_vmstats keeps a non-hierarchical copy of every memcg-wide stat item
and event alongside the hierarchical one. The only readers however are
the legacy memory.stat and memory.numa_stat, and reparenting on offline.
All of them live under CONFIG_MEMCG_V1, and their accessors
(memcg_page_state_local() and memcg_events_local()) are already compiled
out with it. This means on a CONFIG_MEMCG_V1=n kernel, memcg_vmstats's
non-hierarchical arrays are written to on every rstat flush, despite
their values never being read / accessed.

The same holds when the kernel does support v1 but the controller has
been blocked from v1 hierarchies with the boot param
cgroup_no_v1={memory,all}. A v1 mount is refused in that case, so the
legacy memory.stat can never exist and the arrays are just as unread /
unaccessed.

Compile out the non-hierarchical memcg-wide arrays if CONFIG_MEMCG_V1 is
not set. If it is set but cgroup_no_v1= has blocked the controller, skip
updates on the arrays.

This makes flushes cheaper. mem_cgroup_stat_aggregate() can now skip the
read-modify-write of ac->local[i]. Nothing else accesses state_local or
events_local, so those cachelines were getting pulled in solely for the
writes and they are separate from the ones the loop is already walking.

On an 80-cpu x86_64 machine with 500 cgroups each running a workload that
dirties anon, file, dirty/writeback, slab, kmem, mlock, and reclaim
counters, timing mem_cgroup_css_rstat_flush() in-kernel in TSC ticks per
flush showed roughly

                         before   after    delta
memcg-wide aggregation   1231     1180     -4.1%
overall flush function   2452     2397     -2.2%

These numbers are from taking the median of 70 samples, one per 20s
window on each kernel. The 95% intervals observed on the two deltas are
[-5.41%, -1.76%] and [-4.53%, -0.14%]. The values above include the
timing overhead itself, so only the delta is meaningful here.

Counting the items that actually changed, a median of 1.5 of the 77
memcg-wide items (57 state + 20 events) had a non-zero per-cpu delta at
each flush, which means the benchmarks above are with one or two fewer
cachelines pulled in per flush. The count is low because the benchmark
reads memory.stat in a loop to keep the flush rate up. For cases where
flushes are triggered only by the 2s periodic worker, more changes will
have accumulated between flushes, so more cachelines are skipped and the
per-flush saving should be larger.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
v2: https://lore.kernel.org/linux-mm/20260902205406.624782-1-joannelkoong@gmail.com/
Changes since v2:
  * Drop the default hierarchy gating which added extra complexity and just
    add additional gate on boot param, as recommended by Yosry

v1: https://lore.kernel.org/linux-mm/20260901232834.22221-1-joannelkoong@gmail.com/
Changes since v1:
  * Change from gating on builds w/out CONFIG_MEMCG_V1 to gating on the
    default hierarchy so CONFIG_MEMCG_V1=y kernels that do not use v1 benefit
    too (Yosry)

 include/linux/cgroup.h          |  3 +++
 kernel/cgroup/cgroup-internal.h |  1 -
 mm/memcontrol.c                 | 48 ++++++++++++++++++++++++++++-----
 3 files changed, 44 insertions(+), 8 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 5dfa915a630e..2afb4cb2bb4f 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -154,6 +154,9 @@ struct cgroup *cgroup_get_from_path(const char *path);
 struct cgroup *cgroup_get_from_fd(int fd);
 struct cgroup *cgroup_v1v2_get_from_fd(int fd);
 
+/* Was this controller blocked from v1 hierarchies by cgroup_no_v1= ? */
+bool cgroup1_ssid_disabled(int ssid);
+
 int cgroup_attach_task_all(struct task_struct *from, struct task_struct *);
 int cgroup_transfer_tasks(struct cgroup *to, struct cgroup *from);
 
diff --git a/kernel/cgroup/cgroup-internal.h b/kernel/cgroup/cgroup-internal.h
index 58797123b752..7c367c8d0cbe 100644
--- a/kernel/cgroup/cgroup-internal.h
+++ b/kernel/cgroup/cgroup-internal.h
@@ -285,7 +285,6 @@ extern struct kernfs_syscall_ops cgroup1_kf_syscall_ops;
 extern const struct fs_parameter_spec cgroup1_fs_parameters[];
 
 int proc_cgroupstats_show(struct seq_file *m, void *v);
-bool cgroup1_ssid_disabled(int ssid);
 void cgroup1_pidlist_destroy_all(struct cgroup *cgrp);
 void cgroup1_release_agent(struct work_struct *work);
 void cgroup1_check_for_release(struct cgroup *cgrp);
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 7ce50bccf126..e02f968504e1 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -675,9 +675,11 @@ struct memcg_vmstats {
 	long			state[MEMCG_VMSTAT_SIZE];
 	unsigned long		events[NR_MEMCG_EVENTS];
 
+#ifdef CONFIG_MEMCG_V1
 	/* Non-hierarchical (CPU aggregated) page state & events */
 	long			state_local[MEMCG_VMSTAT_SIZE];
 	unsigned long		events_local[NR_MEMCG_EVENTS];
+#endif
 
 	/* Pending child counts during tree propagation */
 	long			state_pending[MEMCG_VMSTAT_SIZE];
@@ -687,6 +689,31 @@ struct memcg_vmstats {
 	atomic_long_t		stats_updates;
 };
 
+/*
+ * The non-hierarchical memcg-wide counters are read back only by the legacy
+ * memory.stat and memory.numa_stat, and by reparenting on offline, all of which
+ * are v1-only. If the kernel is built without CONFIG_MEMCG_V1, or if the boot
+ * param cgroup_no_v1= has blocked the memory controller from v1 hierarchies,
+ * then nothing reads them and writers can skip the updates.
+ */
+static long *memcg_state_local_array(struct mem_cgroup *memcg)
+{
+#ifdef CONFIG_MEMCG_V1
+	if (!cgroup1_ssid_disabled(memory_cgrp_id))
+		return memcg->vmstats->state_local;
+#endif
+	return NULL;
+}
+
+static unsigned long *memcg_events_local_array(struct mem_cgroup *memcg)
+{
+#ifdef CONFIG_MEMCG_V1
+	if (!cgroup1_ssid_disabled(memory_cgrp_id))
+		return memcg->vmstats->events_local;
+#endif
+	return NULL;
+}
+
 /*
  * memcg and lruvec stats flushing
  *
@@ -4468,7 +4495,10 @@ static void mem_cgroup_css_reset(struct cgroup_subsys_state *css)
 struct aggregate_control {
 	/* pointer to the aggregated (CPU and subtree aggregated) counters */
 	long *aggregate;
-	/* pointer to the non-hierarchichal (CPU aggregated) counters */
+	/*
+	 * pointer to the non-hierarchical (CPU aggregated) counters or NULL to
+	 * skip updating them (see memcg_state_local_array())
+	 */
 	long *local;
 	/* pointer to the pending child counters during tree propagation */
 	long *pending;
@@ -4507,7 +4537,7 @@ static void mem_cgroup_stat_aggregate(struct aggregate_control *ac)
 		}
 
 		/* Aggregate counts on this level and propagate upwards */
-		if (delta_cpu)
+		if (delta_cpu && ac->local)
 			ac->local[i] += delta_cpu;
 
 		if (delta) {
@@ -4521,6 +4551,7 @@ static void mem_cgroup_stat_aggregate(struct aggregate_control *ac)
 #ifdef CONFIG_MEMCG_NMI_SAFETY_REQUIRES_ATOMIC
 static void flush_nmi_stats(struct mem_cgroup *memcg, struct mem_cgroup *parent)
 {
+	long *state_local = memcg_state_local_array(memcg);
 	int nid;
 
 	if (atomic_read(&memcg->kmem_stat)) {
@@ -4528,7 +4559,8 @@ static void flush_nmi_stats(struct mem_cgroup *memcg, struct mem_cgroup *parent)
 		int index = memcg_stats_index(MEMCG_KMEM);
 
 		memcg->vmstats->state[index] += kmem;
-		memcg->vmstats->state_local[index] += kmem;
+		if (state_local)
+			state_local[index] += kmem;
 		if (parent)
 			parent->vmstats->state_pending[index] += kmem;
 	}
@@ -4550,7 +4582,8 @@ static void flush_nmi_stats(struct mem_cgroup *memcg, struct mem_cgroup *parent)
 			if (plstats)
 				plstats->state_pending[index] += slab;
 			memcg->vmstats->state[index] += slab;
-			memcg->vmstats->state_local[index] += slab;
+			if (state_local)
+				state_local[index] += slab;
 			if (parent)
 				parent->vmstats->state_pending[index] += slab;
 		}
@@ -4563,7 +4596,8 @@ static void flush_nmi_stats(struct mem_cgroup *memcg, struct mem_cgroup *parent)
 			if (plstats)
 				plstats->state_pending[index] += slab;
 			memcg->vmstats->state[index] += slab;
-			memcg->vmstats->state_local[index] += slab;
+			if (state_local)
+				state_local[index] += slab;
 			if (parent)
 				parent->vmstats->state_pending[index] += slab;
 		}
@@ -4588,7 +4622,7 @@ static void mem_cgroup_css_rstat_flush(struct cgroup_subsys_state *css, int cpu)
 
 	ac = (struct aggregate_control) {
 		.aggregate = memcg->vmstats->state,
-		.local = memcg->vmstats->state_local,
+		.local = memcg_state_local_array(memcg),
 		.pending = memcg->vmstats->state_pending,
 		.ppending = parent ? parent->vmstats->state_pending : NULL,
 		.cstat = statc->state,
@@ -4599,7 +4633,7 @@ static void mem_cgroup_css_rstat_flush(struct cgroup_subsys_state *css, int cpu)
 
 	ac = (struct aggregate_control) {
 		.aggregate = memcg->vmstats->events,
-		.local = memcg->vmstats->events_local,
+		.local = memcg_events_local_array(memcg),
 		.pending = memcg->vmstats->events_pending,
 		.ppending = parent ? parent->vmstats->events_pending : NULL,
 		.cstat = statc->events,
-- 
2.52.0

