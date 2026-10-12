Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C139647C10C
	for <cgroups@vger.kernel.org>; Mon, 12 Oct 2026 12:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791806762; cv=none; b=gsL3FeH0BshRNwSWdyNT+RseATF39iqGkUxUrkDJKe4aims0bRiqYyu5b6BMpjvowl9dpjuC4j5R1dkL8sTPdcBLcTSuoStSvKdxqjdLbXlGcaDG8pXKPHf++lU22fma6aMbDhEqy5QdW5d+C9uPCWzI9E6YRdPjpDTlHGBG/6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791806762; c=relaxed/simple;
	bh=Ac+dvp6Se/lnGpXxhzxfsk1QvvcSamsF74N5zYBUtXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hrHfBMeRCc3qyFZwoFdtMZxhonimc8iwhkJQ3hIH+RpGvHDquL64urczqmHt74HtZMpYSnH/8BD5c1UZCKwH4Gt8VqZ8X+IcAtFL6pp8guzetS7C7oTCPKgilqKD6oNALqzZE14LrenKt3YG4igBvuPU4qzovx0e3OUW5d51tZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B6PFteKV; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B6PFteKV"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-3ab62a8250aso983324a91.1
        for <cgroups@vger.kernel.org>; Mon, 12 Oct 2026 05:05:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791806756; x=1792411556; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mm12iLYNj8dHfuhY6D2/uuvm2SSZhahDIiqNgtVt6Cg=;
        b=B6PFteKV7Uddo+/i9D8Y/7RfCE00Sbx1SGuhXYrBqqwvof7zllIKbQeigDW32CEB3B
         XHDN72ku+3SlsUKOLhKdgGKwj/RWJDXYM/iMhQJus/agVscKhuu36R0TqXfFzTvsI4YJ
         z+xP9z5Doz0uNSMb9rypX0AmT8uPrjM37vKiPUlinz6X7Qyh8iM7w43zl9YMGY6hz6Cz
         YbGG8h0jgn1cKDboUspw9psGdY0fdz7zg4EiXP6It2CIHouO9tv2y7z2FBoOZihGBM2L
         F9VA9vOCrkOHw5GU0hh0E79St67xkBLYQbanVWgiOqM+CyJ+MUrUDX7xBkRVdzbed6il
         lhFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791806756; x=1792411556;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=mm12iLYNj8dHfuhY6D2/uuvm2SSZhahDIiqNgtVt6Cg=;
        b=zQnyHNvKpnhSVeABWsjCVmxpnNrkYGYgLSYe5VjDS7cF1znpKtoql9wspOV6/C3S9m
         AisNv1iiqfPn/bjIkdkwnt1uOxXzQtThXVHhrvIsVcLVUf5G6gGMrh4Htumkv/QhQocG
         zYQJOEG8IUf2ZwLs8ARvpZdwdelxIyZQvBQNzhodDciFOVWT7pYLD+iwyZOk4DNZ+xqi
         8rD4rVyWug+ZiZfoXVFOeGac+D5luu6rIUD1kXGikAHsHN27w6TjDOgR50wxxNT8gbyK
         IlUbhOGC509YmnOuMfpfDFjttWiKrRu4zsKe8Y60zFharhKNQS0m2Yte31xjjStbygUO
         aCKA==
X-Forwarded-Encrypted: i=1; AKwUvBwji29znVZgxTcSqGG3hez0Fb49u7rJ+6BGticxOsio5gRoDXP4SnGP3Hhi8zA+30RbRxFZ3Uqk@vger.kernel.org
X-Gm-Message-State: AFq9FYL8orV/QBipiURNeNx1c7XO2o/1nugX8cTReeW7CFeMaEcrZTay
	WA3J4+mfaBWj0d0D1H/nDy1THA4cTcYJESnycVZ0nULxLHFgKx/vrKxz
X-Gm-Gg: AYBFou0zxEcZol26JdKSVDJMT0QXf2Uko/M/cC+ZXnWBokk6p37uCK5/OXGFtBsOFJX
	oD/fUpFDAIUOSAL8bqvzEOIsvjhQrfbgGTAgZS4VytGzjhHA1YfQOLVtJktY2abzpt0k0wdKTV7
	uIuphcaQ8ILBFX3bcsx4dOzvOXBcPN6wz6aiQU+7KOdwqvxF1bUZJD6AeJnol7ZXVeSk9EcRJdH
	hSkMoIdsIEm6U7qkWaYJMTXAPY2mZaILymQCUyRr6kPB4mw6+sq3NSavwrRFXO2bQP9wqDtGHHc
	GPMvzGWBsqLKj9bMt58Ed6hrp4NYJwghllojUWKXAUyLUW/WFRAQJloUbS+Lcd182Nm9vEr4Gnv
	cYGs99BUXLsYC7IYGVbIke9dbufsBw9ui7ra3kE95KJTCBBdTs4avlhONJv6KmXxGMPHsM0Jr82
	F+Ifxqe0OEVNkUOZstNKYne/ZvZqRuvew4Lg4iz6QfCvgoCYh1OqDIzOjfgktu+ZHGUm8Jd5z98
	nKYZ7UONMsC16c88yFJExdS0nJI062tXUwVy00HNpLjmg==
X-Received: by 2002:a17:90b:224c:b0:3ab:2ad1:f10a with SMTP id 98e67ed59e1d1-3ab3a0ef48emr6942972a91.0.1791806755712;
        Mon, 12 Oct 2026 05:05:55 -0700 (PDT)
Received: from yafangs-Air ([101.82.170.24])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ab371c32cesm15722454a91.16.2026.10.12.05.05.35
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 12 Oct 2026 05:05:55 -0700 (PDT)
From: Yafang Shao <laoar.shao@gmail.com>
To: ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	eddyz87@gmail.com,
	memxor@gmail.com,
	mingo@redhat.com,
	peterz@infradead.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	gourry@gourry.net,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	shakeel.butt@linux.dev,
	roman.gushchin@linux.dev,
	yu.c.chen@intel.com,
	zhao1.liu@intel.com
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [RFC PATCH v2 1/3] sched: add helpers for numa balancing
Date: Mon, 12 Oct 2026 20:04:36 +0800
Message-ID: <20261012120438.52849-2-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20261012120438.52849-1-laoar.shao@gmail.com>
References: <20261012120438.52849-1-laoar.shao@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Two new helpers task_numab_enabled() and numab_mode_tiering() are
introduced to replace the scattered direct accesses to the
sched_numa_balancing static key and the sysctl_numa_balancing_mode
bitmask.

No functional change.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 include/linux/sched/numa_balancing.h | 31 ++++++++++++++++++++++++++++
 kernel/sched/fair.c                  | 16 +++++++-------
 kernel/sched/sched.h                 |  1 -
 mm/memory-tiers.c                    |  3 ++-
 mm/migrate.c                         |  7 ++++---
 mm/vmscan.c                          |  6 +++---
 6 files changed, 48 insertions(+), 16 deletions(-)

diff --git a/include/linux/sched/numa_balancing.h b/include/linux/sched/numa_balancing.h
index 52b22c5c396d..353772b49c5f 100644
--- a/include/linux/sched/numa_balancing.h
+++ b/include/linux/sched/numa_balancing.h
@@ -8,6 +8,7 @@
  */
 
 #include <linux/sched.h>
+#include <linux/sched/sysctl.h>
 
 #define TNF_MIGRATED	0x01
 #define TNF_NO_GROUP	0x02
@@ -32,6 +33,28 @@ extern void set_numabalancing_state(bool enabled);
 extern void task_numa_free(struct task_struct *p, bool final);
 bool should_numa_migrate_memory(struct task_struct *p, struct folio *folio,
 				int src_nid, int dst_cpu);
+
+extern struct static_key_false sched_numa_balancing;
+
+/*
+ * Whether NUMA balancing applies to @p.  The @p argument is unused for
+ * now: a later patch will consult a per-cgroup BPF policy with it.
+ */
+static inline bool task_numab_enabled(struct task_struct *p)
+{
+	return static_branch_unlikely(&sched_numa_balancing);
+}
+
+/*
+ * The global sysctl state, for the system-wide tiering machinery: this
+ * reflects kernel.numa_balancing_mode only and takes no task.
+ */
+static inline bool numab_mode_tiering(void)
+{
+	if (sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING)
+		return true;
+	return false;
+}
 #else
 static inline void task_numa_fault(int last_node, int node, int pages,
 				   int flags)
@@ -52,6 +75,14 @@ static inline bool should_numa_migrate_memory(struct task_struct *p,
 {
 	return true;
 }
+static inline bool task_numab_enabled(struct task_struct *p)
+{
+	return false;
+}
+static inline bool numab_mode_tiering(void)
+{
+	return false;
+}
 #endif
 
 #endif /* _LINUX_SCHED_NUMA_BALANCING_H */
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 57360f5cdde4..45086e6f246c 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -39,6 +39,7 @@
 #include <linux/sched/cputime.h>
 #include <linux/sched/isolation.h>
 #include <linux/sched/nohz.h>
+#include <linux/sched/numa_balancing.h>
 #include <linux/sched/prio.h>
 #include <linux/static_call.h>
 
@@ -2963,8 +2964,8 @@ bool should_numa_migrate_memory(struct task_struct *p, struct folio *folio,
 	this_cpupid = cpu_pid_to_cpupid(dst_cpu, current->pid);
 	last_cpupid = folio_xchg_last_cpupid(folio, this_cpupid);
 
-	if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING) &&
-	    !node_is_toptier(src_nid) && !cpupid_valid(last_cpupid))
+	if (!(numab_mode_tiering()) && !node_is_toptier(src_nid) &&
+	    !cpupid_valid(last_cpupid))
 		return false;
 
 	/*
@@ -4194,7 +4195,7 @@ void task_numa_fault(int last_cpupid, int mem_node, int pages, int flags)
 	struct numa_group *ng;
 	int priv;
 
-	if (!static_branch_likely(&sched_numa_balancing))
+	if (!task_numab_enabled(p))
 		return;
 
 	/* for example, ksmd faulting in a user's mm */
@@ -4206,8 +4207,7 @@ void task_numa_fault(int last_cpupid, int mem_node, int pages, int flags)
 	 * node for memory tiering mode.
 	 */
 	if (!node_is_toptier(mem_node) &&
-	    (sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING ||
-	     !cpupid_valid(last_cpupid)))
+	    (numab_mode_tiering() || !cpupid_valid(last_cpupid)))
 		return;
 
 	/* Allocate buffer to track faults on a per-node basis */
@@ -4665,7 +4665,7 @@ static void update_scan_period(struct task_struct *p, int new_cpu)
 	int src_nid = cpu_to_node(task_cpu(p));
 	int dst_nid = cpu_to_node(new_cpu);
 
-	if (!static_branch_likely(&sched_numa_balancing))
+	if (!task_numab_enabled(p))
 		return;
 
 	if (!p->mm || !p->numa_faults || (p->flags & PF_EXITING))
@@ -10697,7 +10697,7 @@ static long migrate_degrades_locality(struct task_struct *p, struct lb_env *env)
 	unsigned long src_weight, dst_weight;
 	int src_nid, dst_nid, dist;
 
-	if (!static_branch_likely(&sched_numa_balancing))
+	if (!task_numab_enabled(p))
 		return 0;
 
 	if (!p->numa_faults || !(env->sd->flags & SD_NUMA))
@@ -15351,7 +15351,7 @@ static void task_tick_fair(struct rq *rq, struct task_struct *curr, int queued)
 	if (queued)
 		return;
 
-	if (static_branch_unlikely(&sched_numa_balancing))
+	if (task_numab_enabled(curr))
 		task_tick_numa(rq, curr);
 
 	task_tick_cache(rq, curr);
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index e656c7059bf8..38e21c8c57dd 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -2465,7 +2465,6 @@ extern struct static_key sched_feat_keys[__SCHED_FEAT_NR];
 
 #endif /* !CONFIG_JUMP_LABEL */
 
-extern struct static_key_false sched_numa_balancing;
 extern struct static_key_false sched_schedstats;
 
 static inline u64 global_rt_period(void)
diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
index 54851d8a195b..ec7b9aadda98 100644
--- a/mm/memory-tiers.c
+++ b/mm/memory-tiers.c
@@ -7,6 +7,7 @@
 #include <linux/memory-tiers.h>
 #include <linux/notifier.h>
 #include <linux/sched/sysctl.h>
+#include <linux/sched/numa_balancing.h>
 
 #include "internal.h"
 
@@ -64,7 +65,7 @@ static const struct bus_type memory_tier_subsys = {
  */
 bool folio_use_access_time(struct folio *folio)
 {
-	return (sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING) &&
+	return numab_mode_tiering() &&
 	       !node_is_toptier(folio_nid(folio));
 }
 #endif
diff --git a/mm/migrate.c b/mm/migrate.c
index 15b45832bcfa..4d2ba87eaa34 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -41,6 +41,7 @@
 #include <linux/ptrace.h>
 #include <linux/memory.h>
 #include <linux/sched/sysctl.h>
+#include <linux/sched/numa_balancing.h>
 #include <linux/memory-tiers.h>
 #include <linux/pagewalk.h>
 
@@ -818,7 +819,7 @@ void folio_migrate_flags(struct folio *newfolio, struct folio *folio)
 	 * memory node, reset cpupid, because that is used to record
 	 * page access time in slow memory node.
 	 */
-	if (sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING) {
+	if (numab_mode_tiering()) {
 		bool f_toptier = node_is_toptier(folio_nid(folio));
 		bool t_toptier = node_is_toptier(folio_nid(newfolio));
 
@@ -2718,7 +2719,7 @@ int migrate_misplaced_folio_prepare(struct folio *folio,
 	if (!migrate_balanced_pgdat(pgdat, nr_pages)) {
 		int z;
 
-		if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING))
+		if (!(numab_mode_tiering()))
 			return -EAGAIN;
 		for (z = pgdat->nr_zones - 1; z >= 0; z--) {
 			if (managed_zone(pgdat->node_zones + z))
@@ -2770,7 +2771,7 @@ int migrate_misplaced_folio(struct folio *folio, int node)
 	if (nr_succeeded) {
 		count_vm_numa_events(NUMA_PAGE_MIGRATE, nr_succeeded);
 		count_memcg_events(memcg, NUMA_PAGE_MIGRATE, nr_succeeded);
-		if ((sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING)
+		if ((numab_mode_tiering())
 		    && !node_is_toptier(folio_nid(folio))
 		    && node_is_toptier(node))
 			mod_lruvec_state(lruvec, PGPROMOTE_SUCCESS, nr_succeeded);
diff --git a/mm/vmscan.c b/mm/vmscan.c
index f11491ee9ed5..af46869bb15e 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -65,6 +65,7 @@
 
 #include <linux/swapops.h>
 #include <linux/sched/sysctl.h>
+#include <linux/sched/numa_balancing.h>
 
 #include "internal.h"
 #include "page_alloc.h"
@@ -5029,8 +5030,7 @@ static bool should_abort_scan(struct lruvec *lruvec, struct scan_control *sc)
 	if (!current_is_kswapd() || sc->order)
 		return false;
 
-	mark = sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING ?
-	       WMARK_PROMO : WMARK_HIGH;
+	mark = numab_mode_tiering() ? WMARK_PROMO : WMARK_HIGH;
 
 	for (i = 0; i <= sc->reclaim_idx; i++) {
 		struct zone *zone = lruvec_pgdat(lruvec)->node_zones + i;
@@ -6974,7 +6974,7 @@ static bool pgdat_balanced(pg_data_t *pgdat, int order, int highest_zoneidx)
 		enum zone_stat_item item;
 		unsigned long free_pages;
 
-		if (sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING)
+		if (numab_mode_tiering())
 			mark = promo_wmark_pages(zone);
 		else
 			mark = high_wmark_pages(zone);
-- 
2.52.0

