Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.179
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794281388;
	b=RLSLGpo7648aYwulTBAluMO5PJUqVf3GmhOLLO1G2hlcRTn4QcuYIX6cb7ST1V00kIYh
	 nygWiHfEnJEN+MF07zrX60cwlPTQgFAV2YdFMW0sk09PYiAtogU3LyMwpeFzQ1GZhqe4t
	 0izFUiXcrF4n/bHtKQeVqGqAwAXuvhNVbANXvt5lX9N+7QC7bzTI90tcJRTm1dvA46CnA
	 km5KJfR4B6a30Q5ZwR/Sz0WeXbqH3scYb3GWy0xaE102yM5d5dAIU79DwhHmcW2cEjcnX
	 PqIkuoLs6dSkuTHD0In7Ltd7xJ0cnbx3jYuyp2z5qnSAuXEK9VabFpDwj4CTXJmh9Gw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794281388;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CiQU8Ol4JXLsovxT69Zshs9sbZpZnsM4NsuiwfxRUXk=;
	b=iLZqo5sbc/SzLLD63Q3wblA2Jl4mQZ3l7GGdLBSA9uTYVUMgjuVgdpk/kolCGP3ybx4K
	 8hnc5T1Z6UBe16R9nqjOXeHARdpk7ShbJ6zbS7PGhyLg1yKOCe+cxYmXaxTRJ8y0KvKyW
	 3S+5DKWrqM6j+0N36+j4ss7GWnClaHmQVH1falHSRTnplKjoigqQ7Ol7p96wI4CWBPfB6
	 vcI4SKYcDNMU1F0ZB2rJGlhmShO0ui2hCfbTXuko2v86VYK46+Ra4Yc+LTc6L6hgBYw7h
	 uwbc78FfozTR7FfWLvWx/RI+CDyjWTp45f9kCW/gTrAmaAgwgNtqVmm5JUxxmKuSlvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=B6jsAJYy;
	arc=none smtp.remote-ip=209.85.210.179
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BAEE606A31C
	for <cgroups@vger.kernel.org>; Tue, 10 Nov 2026 03:29:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2BAEE606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=B6jsAJYy
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-8b904d10882so679735b3a.0
        for <cgroups@vger.kernel.org>; Mon, 09 Nov 2026 19:29:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794281386; x=1794886186; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CiQU8Ol4JXLsovxT69Zshs9sbZpZnsM4NsuiwfxRUXk=;
        b=B6jsAJYy6u6L47iyNUPe4/6gzl2wY9Ykw4xVGZEfqyOAbUhAQXVmRpezLLAbD5yd05
         lF/CjVFuzSqSVxlEVjPVOILK+IZhSf556ECJRT50u525WzctxLvQiUknD7mG5BhxZnJE
         EQTnfPshVh35VRwNYbzUS42khaHmIhFvGdo0/wkk36X+EE7JDkS0aPmfjuiYUKQqNmXc
         YaNNuCLRTNV3lHhfV2DELMeLDTwXLHRhxeBZ5cNIn9fguv7lpMhqMt0d/gYx8Fa3nVte
         u9k3LUWE6AMVGXLultFahouoQPHgFTICELwjDQZKx409fGVNA+Y1Ll0AqvRrd+ONQzBA
         5m8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794281386; x=1794886186;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=CiQU8Ol4JXLsovxT69Zshs9sbZpZnsM4NsuiwfxRUXk=;
        b=KL7emR8bAjBHQfYyjzFw4TcKVaVLmZQx2NcS1tOYV1+3U1QUoomosBAX1AGCY+WPdo
         1/4J7dngbVe2dGx4a3F3nDOvn0OBAYCBFfyrThNW+vaMd3DIoIpe+iSfzlI4VG7wMRf6
         9ZBDtuB8wffHz8gHdoas5zKH30xsV2fHNnIbuYItLq4owwgZsY4WypljhieecfWZ/4aK
         C3wRTYbcEWYrtMN2y00KDpm875K6nHev84TY5q+x29GHaPs1bYidPkezlUfo2Tc6NBTc
         xTk1m5w6+hVVGV0lWeE20NqFOQo6JuEoHQb819l6Oo5wjCuWFMSqkHFPoabOmgwEykz3
         o8iA==
X-Forwarded-Encrypted: i=1; AL+hErEuWzZVElKUxdg6pj88rGQBqL4NtzL7rdO/DVCGG0Kt2HZ1jk/NSeHjN9UbXeUcvssU5NEQUd5i@vger.kernel.org
X-Gm-Message-State: APuU4Z/BhIt4rKy4pNMEQrUULmq/ldvDEimWdGLwhqqwcm7JI3BGRhFq
	iPfUvIAwI+gIjovgatpZh770Naql7olByOm96WMVg0Q/JNN4AfPc5iL/
X-Gm-Gg: AYBFou1MggzIaF5GnE8NPJMylzVs9+fjFfjkijyo4SchqLrU8hQMVkdvVjuC5SsKDbp
	n1aGiLYxxkXBhqG0WLGZ7RTIBZtXbbjwTeWOwhdau1R4nQS4qfj079IpRcWen9z9iEDzF056eXX
	QSQqIJMHklNGXrGa6uvHVeYwbaQD7IdTRBLFStt4v8OxgxZRzQBgAPJ+/XpVnZkhCXL5YuhivAp
	bCi3j7OSkTEmavqq5KEswveiJr26seGTdtk3r+NGbpPkEVvX2CEWUzyYggZECIeP4rgIQ+BnOFh
	JSu1HU4ByFBLvzMehSRBYGtsykxFk/ihaQ/ZmMz7WhvBoCKQ5ipZk/bKTOlX1fWwi7uN80Te118
	xqcNh4sXnzBBH11QeCaZ0ogCuQzhwfjejQCOeRHq7ztzkcmQCAb6PhG3XEMkEomCYrL7qwPGCP3
	Aim4JbalEHYaMFyppqLpQpWGL+tP81ARe/t1tBsf6h7Px31VmJEb4kLz6Fqkq7cf9s5FkY8Aa/j
	HbXY8z+mhMjA5vRkrCcOtzW4zoU4FKKkPZpKQ3KH+y2BBh4G6YfS83nJa4rf8N4WEO6jDZniUFv
	+hLym9FLq5lDnnMHiQ+pGBbX46oOXXjGtapjc5VSyt5h1fIS9oEnjuj9hmkA5hgM3c1wp9ypaVw
	rbK5c7l+W+gRKcXRT8FWILo5U
X-Received: by 2002:a05:6a00:410d:b0:886:458a:42e9 with SMTP id d2e1a72fcca58-8ba87e0a231mr1422297b3a.49.1794281386416;
        Mon, 09 Nov 2026 19:29:46 -0800 (PST)
Received: from localhost.localdomain ([240e:46d:1d00:5ed4:58d0:d294:d44c:6ae8])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8baab21835fsm336973b3a.42.2026.11.09.19.29.35
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 09 Nov 2026 19:29:45 -0800 (PST)
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
	zhao1.liu@intel.com,
	tim.c.chen@linux.intel.com,
	lizhe.67@bytedance.com,
	ziy@nvidia.com,
	mgorman@suse.de
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [RFC PATCH bpf-next v4 1/4] sched: add helpers for numa balancing
Date: Tue, 10 Nov 2026 11:29:10 +0800
Message-ID: <20261110032913.71974-2-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20261110032913.71974-1-laoar.shao@gmail.com>
References: <20261110032913.71974-1-laoar.shao@gmail.com>
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

Introduce task_numab_enabled(), numab_in_normal_mode() and
numab_in_tiering_mode() to replace the direct accesses to the
sched_numa_balancing static key and the sysctl_numa_balancing_mode
bitmask.

No functional change.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
---
 include/linux/sched/numa_balancing.h | 36 ++++++++++++++++++++++++++++
 kernel/sched/fair.c                  | 22 ++++++++---------
 kernel/sched/sched.h                 |  1 -
 mm/memory-tiers.c                    |  3 ++-
 mm/mempolicy.c                       |  3 +--
 mm/migrate.c                         |  7 +++---
 mm/vmscan.c                          |  6 ++---
 7 files changed, 57 insertions(+), 21 deletions(-)

diff --git a/include/linux/sched/numa_balancing.h b/include/linux/sched/numa_balancing.h
index 52b22c5c396d..61ab161fb481 100644
--- a/include/linux/sched/numa_balancing.h
+++ b/include/linux/sched/numa_balancing.h
@@ -8,6 +8,7 @@
  */
 
 #include <linux/sched.h>
+#include <linux/sched/sysctl.h>
 
 #define TNF_MIGRATED	0x01
 #define TNF_NO_GROUP	0x02
@@ -32,6 +33,26 @@ extern void set_numabalancing_state(bool enabled);
 extern void task_numa_free(struct task_struct *p, bool final);
 bool should_numa_migrate_memory(struct task_struct *p, struct folio *folio,
 				int src_nid, int dst_cpu);
+
+extern struct static_key_false sched_numa_balancing;
+
+/* Whether NUMA balancing is enabled. */
+static inline bool task_numab_enabled(void)
+{
+	return static_branch_likely(&sched_numa_balancing);
+}
+
+/* Whether NUMA balancing is in normal mode. */
+static inline bool numab_in_normal_mode(void)
+{
+	return sysctl_numa_balancing_mode & NUMA_BALANCING_NORMAL;
+}
+
+/* Whether NUMA balancing is in memory tiering mode. */
+static inline bool numab_in_tiering_mode(void)
+{
+	return sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING;
+}
 #else
 static inline void task_numa_fault(int last_node, int node, int pages,
 				   int flags)
@@ -52,6 +73,21 @@ static inline bool should_numa_migrate_memory(struct task_struct *p,
 {
 	return true;
 }
+
+static inline bool task_numab_enabled(void)
+{
+	return false;
+}
+
+static inline bool numab_in_normal_mode(void)
+{
+	return false;
+}
+
+static inline bool numab_in_tiering_mode(void)
+{
+	return false;
+}
 #endif
 
 #endif /* _LINUX_SCHED_NUMA_BALANCING_H */
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index cfc982205b98..672dda541458 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -39,6 +39,7 @@
 #include <linux/sched/cputime.h>
 #include <linux/sched/isolation.h>
 #include <linux/sched/nohz.h>
+#include <linux/sched/numa_balancing.h>
 #include <linux/sched/prio.h>
 #include <linux/static_call.h>
 
@@ -1434,7 +1435,7 @@ static bool exceed_llc_capacity(struct sched_cache_group *grp, int cpu)
 	if (!sd)
 		return true;
 
-	if (static_branch_likely(&sched_numa_balancing)) {
+	if (task_numab_enabled()) {
 		/*
 		 * TBD: RDT exclusive LLC ways reserved should be
 		 * excluded.
@@ -1822,7 +1823,7 @@ static int get_pref_llc(struct task_struct *p, struct sched_cache_group *grp)
 		 * than sched_setnuma() at least -- and thus the
 		 * conflict only exists for a short period of time.
 		 */
-		if (static_branch_likely(&sched_numa_balancing) &&
+		if (task_numab_enabled() &&
 		    p->numa_preferred_nid >= 0 &&
 		    cpu_to_node(mm_sched_cpu) != p->numa_preferred_nid)
 			mm_sched_llc = -1;
@@ -1923,7 +1924,7 @@ static void get_scan_cpumasks(cpumask_var_t cpus, struct task_struct *p,
 #ifdef CONFIG_NUMA_BALANCING
 	int cpu, curr_cpu, nid, pref_nid;
 
-	if (!static_branch_likely(&sched_numa_balancing))
+	if (!task_numab_enabled())
 		goto out;
 
 	cpu = READ_ONCE(grp->cpu);
@@ -2906,8 +2907,8 @@ bool should_numa_migrate_memory(struct task_struct *p, struct folio *folio,
 	this_cpupid = cpu_pid_to_cpupid(dst_cpu, current->pid);
 	last_cpupid = folio_xchg_last_cpupid(folio, this_cpupid);
 
-	if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING) &&
-	    !node_is_toptier(src_nid) && !cpupid_valid(last_cpupid))
+	if (!numab_in_tiering_mode() && !node_is_toptier(src_nid) &&
+	    !cpupid_valid(last_cpupid))
 		return false;
 
 	/*
@@ -4140,7 +4141,7 @@ void task_numa_fault(int last_cpupid, int mem_node, int pages, int flags)
 	struct numa_group *ng;
 	int priv;
 
-	if (!static_branch_likely(&sched_numa_balancing))
+	if (!task_numab_enabled())
 		return;
 
 	/* for example, ksmd faulting in a user's mm */
@@ -4152,8 +4153,7 @@ void task_numa_fault(int last_cpupid, int mem_node, int pages, int flags)
 	 * node for memory tiering mode.
 	 */
 	if (!node_is_toptier(mem_node) &&
-	    (sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING ||
-	     !cpupid_valid(last_cpupid)))
+	    (numab_in_tiering_mode() || !cpupid_valid(last_cpupid)))
 		return;
 
 	/* Allocate buffer to track faults on a per-node basis */
@@ -4611,7 +4611,7 @@ static void update_scan_period(struct task_struct *p, int new_cpu)
 	int src_nid = cpu_to_node(task_cpu(p));
 	int dst_nid = cpu_to_node(new_cpu);
 
-	if (!static_branch_likely(&sched_numa_balancing))
+	if (!task_numab_enabled())
 		return;
 
 	if (!p->mm || !p->numa_faults || (p->flags & PF_EXITING))
@@ -10702,7 +10702,7 @@ static long migrate_degrades_locality(struct task_struct *p, struct lb_env *env)
 	unsigned long src_weight, dst_weight;
 	int src_nid, dst_nid, dist;
 
-	if (!static_branch_likely(&sched_numa_balancing))
+	if (!task_numab_enabled())
 		return 0;
 
 	if (!p->numa_faults || !(env->sd->flags & SD_NUMA))
@@ -15362,7 +15362,7 @@ static void task_tick_fair(struct rq *rq, struct task_struct *curr, int queued)
 	if (queued)
 		return;
 
-	if (static_branch_unlikely(&sched_numa_balancing))
+	if (task_numab_enabled())
 		task_tick_numa(rq, curr);
 
 	task_tick_cache(rq, curr);
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 6c7c5633524a..9b616abf5c9c 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -2496,7 +2496,6 @@ extern union sched_feat_key sched_feat_keys[__SCHED_FEAT_NR];
 
 #endif /* !CONFIG_JUMP_LABEL */
 
-extern struct static_key_false sched_numa_balancing;
 extern struct static_key_false sched_schedstats;
 
 static inline u64 global_rt_period(void)
diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
index 25e121851b58..c49071261078 100644
--- a/mm/memory-tiers.c
+++ b/mm/memory-tiers.c
@@ -6,6 +6,7 @@
 #include <linux/memory.h>
 #include <linux/memory-tiers.h>
 #include <linux/notifier.h>
+#include <linux/sched/numa_balancing.h>
 #include <linux/sched/sysctl.h>
 
 #include "internal.h"
@@ -64,7 +65,7 @@ static const struct bus_type memory_tier_subsys = {
  */
 bool folio_use_access_time(struct folio *folio)
 {
-	return (sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING) &&
+	return numab_in_tiering_mode() &&
 	       !node_is_toptier(folio_nid(folio));
 }
 #endif
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 0884c629670d..991b80d5e899 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -887,8 +887,7 @@ bool folio_can_map_prot_numa(struct folio *folio, struct vm_area_struct *vma,
 	 * Skip scanning top tier node if normal numa
 	 * balancing is disabled
 	 */
-	if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_NORMAL) &&
-	    node_is_toptier(nid))
+	if (!numab_in_normal_mode() && node_is_toptier(nid))
 		return false;
 
 	if (folio_use_access_time(folio))
diff --git a/mm/migrate.c b/mm/migrate.c
index 7bdcdb57652f..4659ecdc4d0c 100644
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
+	if (numab_in_tiering_mode()) {
 		bool f_toptier = node_is_toptier(folio_nid(folio));
 		bool t_toptier = node_is_toptier(folio_nid(newfolio));
 
@@ -2717,7 +2718,7 @@ int migrate_misplaced_folio_prepare(struct folio *folio,
 	if (!migrate_balanced_pgdat(pgdat, nr_pages)) {
 		int z;
 
-		if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING))
+		if (!numab_in_tiering_mode())
 			return -EAGAIN;
 		for (z = pgdat->nr_zones - 1; z >= 0; z--) {
 			if (managed_zone(pgdat->node_zones + z))
@@ -2769,7 +2770,7 @@ int migrate_misplaced_folio(struct folio *folio, int node)
 	if (nr_succeeded) {
 		count_vm_numa_events(NUMA_PAGE_MIGRATE, nr_succeeded);
 		count_memcg_events(memcg, NUMA_PAGE_MIGRATE, nr_succeeded);
-		if ((sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING)
+		if (numab_in_tiering_mode()
 		    && !node_is_toptier(folio_nid(folio))
 		    && node_is_toptier(node))
 			mod_lruvec_state(lruvec, PGPROMOTE_SUCCESS, nr_succeeded);
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 9959ca158ce8..7ef4205b6a4e 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -65,6 +65,7 @@
 
 #include <linux/swapops.h>
 #include <linux/sched/sysctl.h>
+#include <linux/sched/numa_balancing.h>
 
 #include "internal.h"
 #include "page_alloc.h"
@@ -5224,8 +5225,7 @@ static bool should_abort_scan(struct lruvec *lruvec, struct scan_control *sc)
 	if (!current_is_kswapd() || sc->order)
 		return false;
 
-	mark = sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING ?
-	       WMARK_PROMO : WMARK_HIGH;
+	mark = numab_in_tiering_mode() ? WMARK_PROMO : WMARK_HIGH;
 
 	for (i = 0; i <= sc->reclaim_idx; i++) {
 		struct zone *zone = lruvec_pgdat(lruvec)->node_zones + i;
@@ -7131,7 +7131,7 @@ static bool pgdat_balanced(pg_data_t *pgdat, int order, int highest_zoneidx)
 		enum zone_stat_item item;
 		unsigned long free_pages;
 
-		if (sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING)
+		if (numab_in_tiering_mode())
 			mark = promo_wmark_pages(zone);
 		else
 			mark = high_wmark_pages(zone);
-- 
2.52.0

