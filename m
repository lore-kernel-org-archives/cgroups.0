Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBA7E3D16EF
	for <cgroups@vger.kernel.org>; Tue,  1 Sep 2026 23:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788305535; cv=none; b=IyQ/HR7rvvKdz8uUkw8Y/K2xwfo5ct6+/etrHFWv6R3bMwgbJncmwQiIrAKApAJPxVwhzNnHAeicpWAK1eIeXO9LYZ7GDp4axKi4kT6sVxHggOtH6T/oLM8zzzOyFkxiUOxQFB/sGhnTCrJsXPaB7qRFDG4ftU3gACFysbhJi4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788305535; c=relaxed/simple;
	bh=7GNW34xFWPTV8RBCa/qEfMJtFmU8d49xWd2Z1HmLfI8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DEHrSEAy/wvH4gy7JkH2obRCKe+HFLWY2aSbFxqh0RdBP/vrnW9+CIIIQKq+DRs5TGsBU5kXzZ54Y/Xt7TKVThAJ/w9SV1PcEjwt0UJbK6MYzFnzdxY2tTKNrEkOmjaFjyYFnx2yxayYx3RN5GwWtd5Nm6k10fue+yI/QQ0woCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aneYOtSA; arc=none smtp.client-ip=209.85.210.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aneYOtSA"
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-7f4f53975e6so279211a34.3
        for <cgroups@vger.kernel.org>; Tue, 01 Sep 2026 16:32:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788305530; x=1788910330; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=6FwLx62sj4L4VsnfgFBa8Hxb6mCsZ767qZJ6mrMig5c=;
        b=aneYOtSASwWRf4gCP8CkAdB5RjT5wailky1MUEKKteH5u/Ga9eTiAEdJaKI6rh1gNL
         WLmGb4HWcUzvCOBcupwREqHP8DNvwn0PlE28iMMhyBI+DQKkARWJlhPKNvfn26yH6sUJ
         ssB9US+JqFau1YuWOHPGIkfe6XIW9+5N8hyU//Mvop7fVPzVrrorqtAZAv7Li+dm1/XY
         Tfmps0yHGioKVXjtOwAEEE3lePtc3chjqQjPnEFgygKY+LuhsPiXCfEndHhs4VDWS8Pg
         8qERjkkeoodIPjOAUm/JSWPUpGqK+bBqyGWDtU+HYwqaxH6hLFW/MbY4TuFqTzbP0fLR
         Ql7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788305530; x=1788910330;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6FwLx62sj4L4VsnfgFBa8Hxb6mCsZ767qZJ6mrMig5c=;
        b=G2Lm7oXeizHrCAmNiBlfnGRICBvHDZi0KBXtA/VXOqEUdUNqMKSx6Q7VFKtP5TrEfr
         OEdt6itHQpxGKa+fxu4dnjz03Gfp/pqMjFSxZsMIjXjsDTSmLUnQy4XBpRHItZea6J6e
         6+zBWkPAYAGlkeYfwm54SNA6FC0/TfQrRyXYHts45GAnd7Y4s9vWRajxVvUZp+vtxUDO
         c3srTlsV+v/jnBoI76gRmgxXvIdQmKrLfwrKRhUAtNW6JrXzEOJ3FLgdTEB5sWcc+SY/
         ul7O4nN6CDQ5GzrSgKT6RBXTNkvvUxIQBIhEpD/kMPuzsUb+WZAkay6oXU/8b2h0+uuQ
         nH5A==
X-Forwarded-Encrypted: i=1; AHgh+RpLZpbzN9FmJb92uA49Zo+2SMmwQFTrV6mSSFmEFNRzPvX8t1ZSez8LLA5y59rH6f0hCs50Z1qI@vger.kernel.org
X-Gm-Message-State: AFuF++mxyu1IXQAkI2Az+Ukcu5x3AsyNlBpr13zc5vZL6KFZQD4ZlcwD
	6mLuyLWnQddu9B+9HbBtVzo36Zwtkp4EST1OjmRu9l10kzCLyJCuwgqy
X-Gm-Gg: AR+sD107Ep5o6e97yWc/tVRzjRsnvEdTnJBqJ+GwbC/aWj2I2GaSFO3u5iW4VM/Vn9Q
	d28Kr91KfDPA6QPwNDAU9lJpQQ4fFoQFeYsqf23ILJ0aBjqIAbR2vRcB6B9ZQ6iZZtFZ1/rKJ9e
	P2CHxpkDH78zFPljVX6LJNMUysoQfODm5adHx2DkXYKXGTeKBNhuyDDjNUlV6H9JyqBIVT6SB9O
	iIAlvAzKK1l9OYIhL8x5MCkfroAs+6MRp/QU8721lgNa0MuV8QViiLOoLHgb1ECdbrSohJsdrDj
	z+a59eaftUK3p22Ei8xhWyLth9/HzLqu3VXfpqrLRfhSG5Awr3NDCzHfoss/0GIF1i0aHamypJO
	LnzFlM9/tu6Yd7WFRKw63Ljch77kAzbhNDXgWeDUV8yZMTk7vNjQQiUyk6Ii/btLUQn5iQyITI9
	cm1W3D2bkdUfkE0WA4KrpZdtV1fFTtH7237w3ySoemh11yQu+k+hkqhJVI8iC57i96CDCjtyLbS
	Y0IqV52btV1ELgkHMItJ7JCBKiTIESsPfkGib0=
X-Received: by 2002:a05:6830:67d2:b0:7e6:f2ef:e231 with SMTP id 46e09a7af769-7f77f3d22d3mr1244281a34.2.1788305529607;
        Tue, 01 Sep 2026 16:32:09 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:c::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7f74d0b9f77sm880492a34.9.2026.09.01.16.32.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 16:32:09 -0700 (PDT)
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
Subject: [PATCH v1] mm/memcontrol: drop non-hierarchical memcg-wide stats in non-v1 kernels
Date: Tue,  1 Sep 2026 16:28:34 -0700
Message-ID: <20260901232834.22221-1-joannelkoong@gmail.com>
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
non-hierarchial arrays are written to on every rstat flush, despite
their values never being read / accessed.

Compile this out and only carry the non-hierarchical memcg-wide stat
arrays if the kernel actually supports v1.

This makes flushes cheaper. mem_cgroup_stat_aggregate() can now skip the
read-modify-write of ac->local[i]. Nothing else on a kernel with
CONFIG_MEMCG_V1=n accesses state_local or events_local, so those
cachelines get pulled in solely for the writes, and they are separate
from the ones the loop is already walking / accessing.

On a 80-cpu x86_64 machine with 500 cgroups each running a workload that
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

Please note that the per-node lruvec array is left unchanged, as that is
not v1-only (count_shadow_nodes() needs to read
lruvec_page_state_local() under CONFIG_MEMCG rather than
CONFIG_MEMCG_V1).

This adds no functional changes to kernel builds with CONFIG_MEMCG_V1=y.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 mm/memcontrol.c | 49 ++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 42 insertions(+), 7 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 7ce50bccf126..b98b2d68c62b 100644
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
@@ -687,6 +689,32 @@ struct memcg_vmstats {
 	atomic_long_t		stats_updates;
 };
 
+/*
+ * The non-hierarchical memcg-wide counters are read back only by the legacy
+ * memory.stat and by reparenting on offline, both of which are v1-only.
+ */
+#ifdef CONFIG_MEMCG_V1
+static long *memcg_state_local_array(struct mem_cgroup *memcg)
+{
+	return memcg->vmstats->state_local;
+}
+
+static unsigned long *memcg_events_local_array(struct mem_cgroup *memcg)
+{
+	return memcg->vmstats->events_local;
+}
+#else
+static long *memcg_state_local_array(struct mem_cgroup *memcg)
+{
+	return NULL;
+}
+
+static unsigned long *memcg_events_local_array(struct mem_cgroup *memcg)
+{
+	return NULL;
+}
+#endif
+
 /*
  * memcg and lruvec stats flushing
  *
@@ -4468,7 +4496,10 @@ static void mem_cgroup_css_reset(struct cgroup_subsys_state *css)
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
@@ -4507,7 +4538,7 @@ static void mem_cgroup_stat_aggregate(struct aggregate_control *ac)
 		}
 
 		/* Aggregate counts on this level and propagate upwards */
-		if (delta_cpu)
+		if (delta_cpu && ac->local)
 			ac->local[i] += delta_cpu;
 
 		if (delta) {
@@ -4521,6 +4552,7 @@ static void mem_cgroup_stat_aggregate(struct aggregate_control *ac)
 #ifdef CONFIG_MEMCG_NMI_SAFETY_REQUIRES_ATOMIC
 static void flush_nmi_stats(struct mem_cgroup *memcg, struct mem_cgroup *parent)
 {
+	long *state_local = memcg_state_local_array(memcg);
 	int nid;
 
 	if (atomic_read(&memcg->kmem_stat)) {
@@ -4528,7 +4560,8 @@ static void flush_nmi_stats(struct mem_cgroup *memcg, struct mem_cgroup *parent)
 		int index = memcg_stats_index(MEMCG_KMEM);
 
 		memcg->vmstats->state[index] += kmem;
-		memcg->vmstats->state_local[index] += kmem;
+		if (state_local)
+			state_local[index] += kmem;
 		if (parent)
 			parent->vmstats->state_pending[index] += kmem;
 	}
@@ -4550,7 +4583,8 @@ static void flush_nmi_stats(struct mem_cgroup *memcg, struct mem_cgroup *parent)
 			if (plstats)
 				plstats->state_pending[index] += slab;
 			memcg->vmstats->state[index] += slab;
-			memcg->vmstats->state_local[index] += slab;
+			if (state_local)
+				state_local[index] += slab;
 			if (parent)
 				parent->vmstats->state_pending[index] += slab;
 		}
@@ -4563,7 +4597,8 @@ static void flush_nmi_stats(struct mem_cgroup *memcg, struct mem_cgroup *parent)
 			if (plstats)
 				plstats->state_pending[index] += slab;
 			memcg->vmstats->state[index] += slab;
-			memcg->vmstats->state_local[index] += slab;
+			if (state_local)
+				state_local[index] += slab;
 			if (parent)
 				parent->vmstats->state_pending[index] += slab;
 		}
@@ -4588,7 +4623,7 @@ static void mem_cgroup_css_rstat_flush(struct cgroup_subsys_state *css, int cpu)
 
 	ac = (struct aggregate_control) {
 		.aggregate = memcg->vmstats->state,
-		.local = memcg->vmstats->state_local,
+		.local = memcg_state_local_array(memcg),
 		.pending = memcg->vmstats->state_pending,
 		.ppending = parent ? parent->vmstats->state_pending : NULL,
 		.cstat = statc->state,
@@ -4599,7 +4634,7 @@ static void mem_cgroup_css_rstat_flush(struct cgroup_subsys_state *css, int cpu)
 
 	ac = (struct aggregate_control) {
 		.aggregate = memcg->vmstats->events,
-		.local = memcg->vmstats->events_local,
+		.local = memcg_events_local_array(memcg),
 		.pending = memcg->vmstats->events_pending,
 		.ppending = parent ? parent->vmstats->events_pending : NULL,
 		.cstat = statc->events,
-- 
2.52.0

