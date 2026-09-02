Received: from mail-oo1-f44.google.com (mail-oo1-f44.google.com [209.85.161.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BA3239B943
	for <cgroups@vger.kernel.org>; Wed,  2 Sep 2026 20:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788382596; cv=none; b=Stlk6mjaevuBRpfOjmnwFTZczK28Li2MKkUyXGg+AmulAkqbwTvlI3HuSLAvLKs5krFSGt6dteEJjihJD0k0DqkCZn1Ys2ThWWtszr7vHpkd5jl0bRljDlah4Q6nL5zWbCh6K8tBCQ5YrSamzEdM+IEb+wr/6khplAxsVBpNUtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788382596; c=relaxed/simple;
	bh=UDFKQJTgg0GDa+pTbWvwU3VzhNJt+YLiXajk4VhPPHo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=e8OKMt2hAcAUEdbrKd8UvejJI1tYAmtTC+uSEsGuHcv2f6fCool7HT8KcTAlI+klqAEPB8MfmtBV/kAkPp3ShL3hA4p52YK8PYqqcB6TaBo3oQ+5iZ/bjwf57GTA43GSHiJFp9wuUDEQtZtDkp6z8rzRfrVP2+oZBsYVWlHQg48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=oFOobdLh; arc=none smtp.client-ip=209.85.161.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oFOobdLh"
Received: by mail-oo1-f44.google.com with SMTP id 006d021491bc7-6b35cc0a8c3so1194552eaf.0
        for <cgroups@vger.kernel.org>; Wed, 02 Sep 2026 13:56:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788382590; x=1788987390; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=L0HzSKuqv/KV9cbmP7FkA9jDEFtUZ8WtgRJiztbD2Xk=;
        b=oFOobdLhGuo22UW8Ui3jMWWP8oNYyvp61/E7y3kr1k/hg/dYifd3ywqOALLB3JbQN+
         SNi/6WrboJoE9mZCk4YcQGDqgbDsVzGSrLvbp5EE5xufRG/n+dWLGzgUBrRGmeb+BjpX
         2n55Mf81R8ukh7TXD7K+5+lQYttcLOC+8h/HemqrZd48QC89RV//YKZA9dccKhNVWz/o
         2y0P6rvgBiynrW5uvZbu7Qb82MlqHPTj8AcElRZGRIBJ5AMvvYAH9Btdmls3m981zfov
         ieACuLRoXFke+ANhSuNo8VFdRrrmI/YglKP62e+2XdareIpErF5lNulgjl5BeMEo3+3B
         19VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788382590; x=1788987390;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=L0HzSKuqv/KV9cbmP7FkA9jDEFtUZ8WtgRJiztbD2Xk=;
        b=iF0cn5vOegcvtEz+vaYoee8bYNPHWd1xqWsN55/jiiB1IKM3GOm+1uztqscPZ1LoNM
         6HMrTNRuPCdp3P6zdxlcCIOJNzBs9mBUV5iKwWiItpo6r03eStlwRj0tsm7p1639L3IT
         ZUTSBsZBMwBg2VIa/0CDFLbZQvgvf4YOd11hZGXcXKS1bUPPa5MA3CEpyMZBCdig/f7b
         pACBFJMEed3NjdNWgL5ElIvpFbncqKKbRMMMJVtwLX+1IerBTVHO6+5kRGQhMNTsk3uH
         KL+3MRk4wH6A3mgCf5Q9kTvZu/QLltnSoYNfnEv3rRXFU4Qolddz5r1i/Ko7ExYZ3wpP
         whvw==
X-Forwarded-Encrypted: i=1; AHgh+RqL7GgNE5bz57e60sU7Qthrc55BR3OTgb2YPPa7W+FkcNgrt4yFw/WxluaJcFUUFZRjjaXUXaSI@vger.kernel.org
X-Gm-Message-State: AFuF++mimY9C5Z6u3+9Aq/w/2DOZkHkbntXjP06cVRlPaBzYcRYs4iH4
	5kYASZYXhJ+nFOasqQfmfwrVgaXXgXoxD8kmg5trH0thrU4z8ToTV7NV
X-Gm-Gg: AR+sD11QO/CB2SKUrxOfjZEj+ZOXJU/ZbZbWSgix2pu2TPBAo19kehcEb/mllRfruWM
	WUyj+64WA/GKQxTOIqzy0PUul9SJnu/YLVoNiwbY3lI3XfqhqedXJKkStrV/rowx9nKvdi/hgAS
	CMC5YrkhdPUCYiGZOuZDFLHvfDQ+UZ/034h6NNfateWevk3P0KXGsraHakpUEvFQ+eFodyRiGEL
	HxRjrs0+Wy+vUgRiXBzKQqq87ZDZJApiO/ZvnUVgLQDEDC0sngeMuTTbGUtBnZMXzchJ3nefR45
	tL0IAHCZPj+mi7TmvR2s9GRwTn+mZB6uQrO5z//GBb/Uj5cIq2BYmAafaS/usCWlZ2xEeTXsZis
	1uuULdy8FTr2hlOPc0EXpfmS6DDJawnQWjnf3EjxksMPb+5unahStPwWVUKjap+8b4QdsLnEH5N
	D6nI+FxjU9Ty/igTHSUp0NgjvzcEfjwgDJXtUCoJ2X0Q41Ut216oVb/db03w83JkRjIyZ/VmiAX
	vay3v9Eju4PyK5rUntC1Jylt7faY9gA1Jy3G4Cl
X-Received: by 2002:a05:6820:4dfb:b0:6b1:b639:12f2 with SMTP id 006d021491bc7-6b480a4894emr6073552eaf.17.1788382589237;
        Wed, 02 Sep 2026 13:56:29 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:72::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6b40c8381b7sm3877884eaf.8.2026.09.02.13.56.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 13:56:27 -0700 (PDT)
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
Subject: [PATCH v2] mm/memcontrol: skip non-hierarchical memcg-wide stats on the default hierarchy
Date: Wed,  2 Sep 2026 13:54:06 -0700
Message-ID: <20260902205406.624782-1-joannelkoong@gmail.com>
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
the legacy memory.stat and memory.numa_stat, and reparenting on offline,
which are only used when on the legacy v1 hierarchy.

On the default hierarchy, memcg_vmstats's non-hierarchical arrays are
written to on every rstat flush, despite their values never being read /
accessed.

Instead, skip non-hierarchical memcg-wide stats on the default hierarchy.
This makes flushes cheaper. mem_cgroup_stat_aggregate() can now skip the
read-modify-write of ac->local[i]. When on the default hierarchy,
nothing else accesses state_local or events_local, so those cachelines
were getting pulled in solely for the writes, and they are separate from
the ones the loop is already walking / accessing.

There is the unlikely case where a controller can be moved from the
default hierarchy to the legacy v1 hierarchy at runtime, which means the
non-hierarchical memcg-wide arrays will need to be populated with the
correct values. This can be handled through the bind callback, which
gets called by rebind_subsystems(). We can copy over the counters from
the hierarchical arrays since rebinding is only allowed when the root is
the only memcg, so the hierarchical arrays and the non-hierarchical
arrays values should be the same.

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
v1: https://lore.kernel.org/linux-mm/20260901232834.22221-1-joannelkoong@gmail.com/
Changes since v1:
  * Change from gating on builds w/out CONFIG_MEMCG_V1 to gating on the
    default hierarchy so CONFIG_MEMCG_V1=y kernels that do not use v1 benefit
    too (Yosry)

 mm/memcontrol.c | 89 +++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 82 insertions(+), 7 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 7ce50bccf126..196e1791c10d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -687,6 +687,29 @@ struct memcg_vmstats {
 	atomic_long_t		stats_updates;
 };
 
+/*
+ * The non-hierarchical memcg-wide counters are read back only by the legacy
+ * memory.stat and by reparenting on offline, both of which are v1-only.
+ * They are skipped if the controller sits on the default hierarchy
+ * (mem_cgroup_bind() populates them if it is later moved onto the legacy
+ * hierarchy).
+ */
+static long *memcg_state_local_array(struct mem_cgroup *memcg)
+{
+	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
+		return NULL;
+
+	return memcg->vmstats->state_local;
+}
+
+static unsigned long *memcg_events_local_array(struct mem_cgroup *memcg)
+{
+	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
+		return NULL;
+
+	return memcg->vmstats->events_local;
+}
+
 /*
  * memcg and lruvec stats flushing
  *
@@ -4468,7 +4491,10 @@ static void mem_cgroup_css_reset(struct cgroup_subsys_state *css)
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
@@ -4507,7 +4533,7 @@ static void mem_cgroup_stat_aggregate(struct aggregate_control *ac)
 		}
 
 		/* Aggregate counts on this level and propagate upwards */
-		if (delta_cpu)
+		if (delta_cpu && ac->local)
 			ac->local[i] += delta_cpu;
 
 		if (delta) {
@@ -4521,6 +4547,7 @@ static void mem_cgroup_stat_aggregate(struct aggregate_control *ac)
 #ifdef CONFIG_MEMCG_NMI_SAFETY_REQUIRES_ATOMIC
 static void flush_nmi_stats(struct mem_cgroup *memcg, struct mem_cgroup *parent)
 {
+	long *state_local = memcg_state_local_array(memcg);
 	int nid;
 
 	if (atomic_read(&memcg->kmem_stat)) {
@@ -4528,7 +4555,8 @@ static void flush_nmi_stats(struct mem_cgroup *memcg, struct mem_cgroup *parent)
 		int index = memcg_stats_index(MEMCG_KMEM);
 
 		memcg->vmstats->state[index] += kmem;
-		memcg->vmstats->state_local[index] += kmem;
+		if (state_local)
+			state_local[index] += kmem;
 		if (parent)
 			parent->vmstats->state_pending[index] += kmem;
 	}
@@ -4550,7 +4578,8 @@ static void flush_nmi_stats(struct mem_cgroup *memcg, struct mem_cgroup *parent)
 			if (plstats)
 				plstats->state_pending[index] += slab;
 			memcg->vmstats->state[index] += slab;
-			memcg->vmstats->state_local[index] += slab;
+			if (state_local)
+				state_local[index] += slab;
 			if (parent)
 				parent->vmstats->state_pending[index] += slab;
 		}
@@ -4563,7 +4592,8 @@ static void flush_nmi_stats(struct mem_cgroup *memcg, struct mem_cgroup *parent)
 			if (plstats)
 				plstats->state_pending[index] += slab;
 			memcg->vmstats->state[index] += slab;
-			memcg->vmstats->state_local[index] += slab;
+			if (state_local)
+				state_local[index] += slab;
 			if (parent)
 				parent->vmstats->state_pending[index] += slab;
 		}
@@ -4588,7 +4618,7 @@ static void mem_cgroup_css_rstat_flush(struct cgroup_subsys_state *css, int cpu)
 
 	ac = (struct aggregate_control) {
 		.aggregate = memcg->vmstats->state,
-		.local = memcg->vmstats->state_local,
+		.local = memcg_state_local_array(memcg),
 		.pending = memcg->vmstats->state_pending,
 		.ppending = parent ? parent->vmstats->state_pending : NULL,
 		.cstat = statc->state,
@@ -4599,7 +4629,7 @@ static void mem_cgroup_css_rstat_flush(struct cgroup_subsys_state *css, int cpu)
 
 	ac = (struct aggregate_control) {
 		.aggregate = memcg->vmstats->events,
-		.local = memcg->vmstats->events_local,
+		.local = memcg_events_local_array(memcg),
 		.pending = memcg->vmstats->events_pending,
 		.ppending = parent ? parent->vmstats->events_pending : NULL,
 		.cstat = statc->events,
@@ -5183,6 +5213,50 @@ static struct cftype memory_files[] = {
 	{ }	/* terminate */
 };
 
+#ifdef CONFIG_MEMCG_V1
+/*
+ * Called after the controller has moved between hierarchies, with the on_dfl
+ * key already in its new state.
+ *
+ * If the controller is moving from the default hierarchy to the legacy
+ * hierarchy, vmstats's state_local and events_local arrays need to be populated
+ * since they get read by the legacy hierarchy. Those values can just be taken
+ * from the vmstats's state and events arrays since rebind_subsystems() only
+ * allows the move when the root is the only memcg.
+ */
+static void mem_cgroup_bind(struct cgroup_subsys_state *root_css)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_css(root_css);
+	int i;
+
+	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
+		return;
+
+	/*
+	 * The flush is necessary because there might be descendants that got
+	 * destroyed right before the rebind that may have left counts in the
+	 * pending arrays that haven't yet been folded into the state and events
+	 * arrays
+	 */
+	__mem_cgroup_flush_stats(memcg, true);
+
+	/*
+	 * Not serialized against a concurrent flush. The periodic flusher runs
+	 * on root_mem_cgroup without cgroup_mutex and a flush increments state
+	 * and state_local together. If the flush happens in between when we
+	 * read state and write to state_local, its state_local increment is
+	 * overwritten and the counter stays short, but the difference would be
+	 * a single CPU's accumulated charges since the last flush and the
+	 * counters are approximate values.
+	 */
+	for (i = 0; i < MEMCG_VMSTAT_SIZE; i++)
+		memcg->vmstats->state_local[i] = memcg->vmstats->state[i];
+
+	for (i = 0; i < NR_MEMCG_EVENTS; i++)
+		memcg->vmstats->events_local[i] = memcg->vmstats->events[i];
+}
+#endif /* CONFIG_MEMCG_V1 */
+
 struct cgroup_subsys memory_cgrp_subsys = {
 	.css_alloc = mem_cgroup_css_alloc,
 	.css_online = mem_cgroup_css_online,
@@ -5196,6 +5270,7 @@ struct cgroup_subsys memory_cgrp_subsys = {
 	.exit = mem_cgroup_exit,
 	.dfl_cftypes = memory_files,
 #ifdef CONFIG_MEMCG_V1
+	.bind = mem_cgroup_bind,
 	.legacy_cftypes = mem_cgroup_legacy_files,
 #endif
 	.early_init = 0,
-- 
2.52.0

