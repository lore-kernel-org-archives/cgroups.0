Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A9713C1D70
	for <cgroups@vger.kernel.org>; Mon, 19 Oct 2026 06:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792392188; cv=none; b=cLmT7NbysfzRVih2RSiWoGjl1zR9+OlW8rmX5jQODt86NFC1W/zPGEjWZbX7hs0F+YzpBdTea5E+xAr7e1TfnO2UpQh0SyjsG+wmeWb2S0UD3T2ZXs0O/WvoLUaBSTXaQMEbIFf412YW/6RgbnmPrsFTdAwBbz4eEVyJPU+vx/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792392188; c=relaxed/simple;
	bh=aYn90Ed2Lj0BvJmtQoAqXFgzzqrh4al3KHmPoet1gxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=opaGjwa+8/JzE+mA+Q91UI4+t4WoCPGIxLePFSavVlJMtK/JgZOfckleuAsXOjLMKcrR14UAr7V3AsNzSX5DOMNJZKI2ELnxbeGXpzMfXBr2Kxkxz3c7Yq4Zvr9zb2j5dTQmfDqiC7uRmQ8lMu5/iMA8FdQawxNVZXNxSanF5Dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dZpasU/a; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dZpasU/a"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-8a07078200fso106824b3a.2
        for <cgroups@vger.kernel.org>; Sun, 18 Oct 2026 23:43:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792392186; x=1792996986; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yAD4QKN4phi8LftSY4gXSpqzCGJT6u7XrfX0ossVdRU=;
        b=dZpasU/a+MzFNWcaL/Zc7xzr3P9Qee+mOhzxF47ieakbY5QuNtM+N7gq6S6N241hJM
         9QQIjKvY7HJmn6m15xt404q5b5UusREe1eBFqcua4hJUgKpGIMXfn5ajYUsAuwsVMhTP
         zKGenwEhjdOKpJKfLtCWBW8xQ2am8o8F5BXOToPCazgYRGaCb/8tJR8noaGrCcp2CLMX
         4LilnYRkuKY6HcE3A6eM4ajINGQFSj2LagQv5sdblzfwaE9v+XcBbp63KFXUW2n9386v
         admqR/I+z0DgJqRoXJiWorra6dfJ19ze3ji/PK7Bi8Q5qnzZGUSkoxoo8dIY8SJaQw88
         vF6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792392186; x=1792996986;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=yAD4QKN4phi8LftSY4gXSpqzCGJT6u7XrfX0ossVdRU=;
        b=00WYPJcZeWMPC7GAKiH68vWuiouI/jdla3tuTGapeDMZS4Ub9Vp1MgNgJhOLhLfE6Q
         kVGvKKhbxziWmrFmWbPvqoxmTrzoIT/LuX+pQt/C98fdr9RurthZfGoCPCGk7MMo4kz/
         iyXfiWZyT3RcfdUkL9fi6TJ05pY5hU/HKY6XjcX4hQANtwG1JI+e/xD6vwk+z3/960u9
         kvmOZZVA0AGQmyMErlVxuTb1r/N0yZhWUYUQtAUjtXKSHG5ZYCzW3/LWNwQrq3vMSTq+
         0hPrYdd66VZfuhlWQ/EQqLgmLWK/NGiegYkC2Nu1R2x4+PiKcu8bnSP6+ek3/5fnXQcr
         GyFA==
X-Forwarded-Encrypted: i=1; AKwUvBxdRweXwKnUJT/6BHrocA2N6DVzVRoLZVE59Zm4kOwMfzHr/YRboW7CBoPJUnA/uJJNUa3IPDYo@vger.kernel.org
X-Gm-Message-State: AFq9FYINmrMDtOi8bY9Qo/LhrsgkbDKC3T8Wzd3QS7BJcBUskefGg0Po
	Dy3EpOS/Zz+8HnnxqkIdy1otm0W5kLSGsL0MO/nhWHUyVGFPkbo72xXY
X-Gm-Gg: AYBFou0ysW/PIcg7rPonP92qbbpMOoDqPoG89+mDhD8IaarhdYwIA4Te5OfGu8HwdbB
	6/jFAzgwVynK6zfN57hUBRGlDx5tb/IwES8vXVWShmr8mq7toX+P4V0gVfPmmnqSP87G04jA7D5
	C6PS8SUbNCWJC2GqG9+ZuyzRFlxVSLVjcK4fBFcCh2tZsfojU8V375w6wjo2IYy2ZzqzX+F+PsA
	+xJxWR5qtiUv3c265oXCRYI2z2PP8RJw7Je/ZvcBYI7Ulx4O4llExZxX2Qia2+oo4FK8dLEdMPa
	AjbtpqvwN+D/jh4rZH/x+3/50/IsTY3puoqLu0hZsVcnoqjKNdkX9WZC/8GUgJGIeNw4bvNQB0a
	1j3QKvUburQ9xBEFR24gX7wBIzNvUjJlIVQtRTuRyOUuqpRXUMa1KG4k2+PkQO56Tngjico4j4F
	OAsjIBoVA38mtP9c0kq3Yn2dCTBzA8MozyfkRn+vmufXZCpvhWa6ISHdfABD09jPwwC2DyJDxB5
	su09L3vhBaJvfShx8FzwrHM4bzYqQXAGcKIHLVjGztfhb7b9qkLw802fjYG+DNUmZKSi0o=
X-Received: by 2002:a05:6a21:3a84:b0:3e1:1e99:9463 with SMTP id adf61e73a8af0-3e225f9c852mr5047641637.38.1792392185455;
        Sun, 18 Oct 2026 23:43:05 -0700 (PDT)
Received: from localhost.localdomain ([240e:46d:2100:3fed:6938:3f14:63eb:c479])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cd654a3a592sm3688960a12.30.2026.10.18.23.42.56
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 18 Oct 2026 23:43:04 -0700 (PDT)
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
	lizhe.67@bytedance.com
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [RFC PATCH v3 bpf-next 4/5] sched: add BPF-based per-cgroup NUMA balancing mode selection
Date: Mon, 19 Oct 2026 14:41:56 +0800
Message-ID: <20261019064157.29885-5-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20261019064157.29885-1-laoar.shao@gmail.com>
References: <20261019064157.29885-1-laoar.shao@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Global NUMA balancing offers no per-workload choice: kernel.numa_balancing
is a single system-wide sysctl, where zero disables the machinery and the
set bits select normal balancing, memory tiering, or both for every
workload alike. However, a latency-sensitive service wants NUMA balancing
disabled, while a batch service wants its PMEM-resident memory promoted
when hot without paying for scheduler-driven migration. No single global
setting serves both.

Add a per-cgroup request. cgroup::numab_mode stores the mode a cgroup asks
for: NUMAB_FOLLOW_SYSTEM (-1) defers to the global sysctl state, anything
else is a NUMA_BALANCING_* bitmask. It is initialized to -1 at cgroup
creation since kzalloc's 0 would read as an explicit opt-out. Two kfuncs
manage it: bpf_numab_set_mode() writes the request, bpf_numab_get_mode()
reads the combined request back.

The hot paths combine the requests of the matching cgroup and of every
ancestor: task callsites walk the task's cgroup chain, folio callsites walk
the chain of the memcg the folio is charged to, so a memory answer is keyed
on the folio's owner rather than on whoever happens to touch it. A kswapd
or demotion pass decides the same way the fault path does. An opt-out
wins: a DISABLED request anywhere in the chain opts the cgroup's tasks
out entirely, and nothing below can re-enable it. Otherwise the
requested bits OR together and the kernel reads them independently, the
way kernel.numa_balancing reads them, so a combined NORMAL|TIERING
engages both modes. A DISABLED request only speaks for tasks, never for
the cgroup's memory. Demotion and the misplaced-migration fallback stay
global, keyed on node-level reclaim state rather than on any cgroup's
request. On the folio side the top-tier scanning exemption asks the
placement question, so a NORMAL|TIERING request also feeds the
placement statistics.

The combination is deliberate: a nearest-request-wins rule would let
any descendant re-enable machinery an ancestor turned off, and an
opt-out is only a subtree-wide guarantee if it binds. Requests add
instead, and the opt-out is what binds. The cost is that an ancestor
cannot cap tiering short of a full opt-out: a descendant's TIERING
request re-engages promotion for its own memory, and promotion is the
mode that consumes the shared fast tier.

The requests are combined at read time rather than propagated at write
time. The walk costs a few loads up a chain a handful of levels deep, a new
cgroup is correct by construction because it starts transparent and sees
its ancestors' current state, and bpf_numab_get_mode() runs the same walk
the kernel applies. Propagating a combined value down the subtree instead
would need hooks on cgroup creation to stay coherent with concurrent sets,
and cache a second field for the folio view, which reads opt-outs
differently.

The consult is behind the numab_cgroup_mode_set static key: while no cgroup
overrides the global state, the hot paths pay one patched-out branch and
nothing else. The readers run in atomic context (the scheduler tick,
hinting faults, load balancing, hardirq included), so the walk takes no
reference: rcu_read_lock() keeps the chain alive and the field is read
with READ_ONCE(). The kfunc accounts the static key transitions under a
mutex, and the cgroup free path drops the count of a request nobody
cleared, so the key goes off again once the last request is gone.
bpf_numab_set_mode() takes numab_mode_mutex and the jump label locks
inside static_branch_inc()/static_branch_dec(), so it is marked
KF_SLEEPABLE and only sleepable programs may call it.
bpf_numab_get_mode() never sleeps, so it carries no flag.
BPF_PROG_TYPE_SYSCALL programs run from user context, where sleeping is
allowed, so they qualify.

Suggested-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 include/linux/cgroup-defs.h          |  10 ++
 include/linux/sched/numa_balancing.h | 118 +++++++++++++++-
 init/Kconfig                         |  20 +++
 kernel/cgroup/cgroup.c               |  14 ++
 kernel/sched/bpf_numab.c             | 195 +++++++++++++++++++++++++++
 kernel/sched/build_policy.c          |   4 +
 kernel/sched/fair.c                  |   4 +-
 mm/memory-tiers.c                    |   8 +-
 mm/mempolicy.c                       |   2 +-
 mm/migrate.c                         |   4 +-
 10 files changed, 369 insertions(+), 10 deletions(-)
 create mode 100644 kernel/sched/bpf_numab.c

diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index 3754d697854b..5e97806634e4 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -639,6 +639,16 @@ struct cgroup {
 #ifdef CONFIG_EXT_SUB_SCHED
 	struct scx_sched __rcu *scx_sched;
 #endif
+#ifdef CONFIG_BPF_NUMAB
+	/*
+	 * The NUMA balancing mode requested for this cgroup:
+	 * NUMAB_FOLLOW_SYSTEM (-1) defers to the global sysctl state,
+	 * anything else is a NUMA_BALANCING_* bitmask. Written by
+	 * bpf_numab_set_mode() under numab_mode_mutex, read locklessly
+	 * under RCU.
+	 */
+	int numab_mode;
+#endif
 
 	/* All ancestors including self */
 	union {
diff --git a/include/linux/sched/numa_balancing.h b/include/linux/sched/numa_balancing.h
index 36de57f7fb06..d63891a8be01 100644
--- a/include/linux/sched/numa_balancing.h
+++ b/include/linux/sched/numa_balancing.h
@@ -36,9 +36,51 @@ bool should_numa_migrate_memory(struct task_struct *p, struct folio *folio,
 
 extern struct static_key_false sched_numa_balancing;
 
-/* Whether NUMA balancing applies to @p. */
+#ifdef CONFIG_BPF_NUMAB
+/*
+ * A cgroup can override the global NUMA balancing state for the tasks it
+ * runs and the memory it owns: the bpf_numab_set_mode() kfunc stores a
+ * requested mode in struct cgroup, and the readers below combine the
+ * requests of the matching cgroup and of every ancestor.
+ * numab_cgroup_mode_set stays off while no cgroup makes a request, so
+ * the consult costs the hot paths nothing until then.
+ */
+extern struct static_key_false numab_cgroup_mode_set;
+
+/* The per-cgroup request domain: this, or a NUMA_BALANCING_* bitmask. */
+#define NUMAB_FOLLOW_SYSTEM (-1)
+
+/*
+ * The combined request for the chain of @p's cgroup:
+ * NUMA_BALANCING_DISABLED when any cgroup in the chain opts out, the OR
+ * of the requested bits otherwise, NUMAB_FOLLOW_SYSTEM when no cgroup
+ * makes a request.
+ */
+int task_numab_mode(struct task_struct *p);
+
+/*
+ * The combined request for the chain of the memcg @folio is charged to.
+ * An opt-out never speaks for memory, so it is not part of the answer;
+ * an uncharged folio makes no request.
+ */
+int folio_numab_mode(struct folio *folio);
+#endif
+
+/*
+ * Whether NUMA balancing applies to @p: the global sysctl state, possibly
+ * overridden by the requests of @p's cgroup and of every ancestor.
+ * A cgroup's request always takes priority over the system setting.
+ */
 static inline bool task_numab_enabled(struct task_struct *p)
 {
+#ifdef CONFIG_BPF_NUMAB
+	if (static_branch_unlikely(&numab_cgroup_mode_set)) {
+		int mode = task_numab_mode(p);
+
+		if (mode != NUMAB_FOLLOW_SYSTEM)
+			return mode != NUMA_BALANCING_DISABLED;
+	}
+#endif
 	return static_branch_likely(&sched_numa_balancing);
 }
 
@@ -53,6 +95,68 @@ static inline bool numab_in_normal_mode(void)
 {
 	return sysctl_numa_balancing_mode & NUMA_BALANCING_NORMAL;
 }
+
+/*
+ * Whether @p runs in tiering mode, i.e. whether faults on non-top-tier
+ * memory still feed its NUMA statistics. The requests of the task's
+ * cgroup and of every ancestor are combined; an opt-out wins, otherwise
+ * the bits are read independently, as the sysctl reads them. Without
+ * any request, the global sysctl decides.
+ */
+static inline bool task_numab_in_tiering_mode(struct task_struct *p)
+{
+#ifdef CONFIG_BPF_NUMAB
+	if (static_branch_unlikely(&numab_cgroup_mode_set)) {
+		int mode = task_numab_mode(p);
+
+		if (mode != NUMAB_FOLLOW_SYSTEM)
+			return mode & NUMA_BALANCING_MEMORY_TIERING;
+	}
+#endif
+	return numab_in_tiering_mode();
+}
+
+/*
+ * Whether @folio's memory participates in tiering, i.e. whether its
+ * _last_cpupid carries an access time instead of a cpupid. The
+ * requests of the owner cgroup and of every ancestor are combined.
+ * DISABLED never speaks for memory (it is a task-side request), so only
+ * NORMAL and TIERING are consulted here; without either, the global
+ * sysctl decides.
+ */
+static inline bool folio_numab_in_tiering_mode(struct folio *folio)
+{
+#ifdef CONFIG_BPF_NUMAB
+	if (static_branch_unlikely(&numab_cgroup_mode_set)) {
+		int mode = folio_numab_mode(folio);
+
+		if (mode != NUMAB_FOLLOW_SYSTEM)
+			return mode & NUMA_BALANCING_MEMORY_TIERING;
+	}
+#endif
+	return numab_in_tiering_mode();
+}
+
+/*
+ * Whether @folio's owner asks for the normal mode, i.e. whether hinting
+ * faults on its top-tier pages should still feed the scheduler's
+ * placement statistics. The requests of the owner cgroup and of every
+ * ancestor are combined; without any request, the global sysctl
+ * decides. This is deliberately independent of tiering participation:
+ * a folio can record access times and still keep its top-tier scanning.
+ */
+static inline bool folio_numab_in_normal_mode(struct folio *folio)
+{
+#ifdef CONFIG_BPF_NUMAB
+	if (static_branch_unlikely(&numab_cgroup_mode_set)) {
+		int mode = folio_numab_mode(folio);
+
+		if (mode != NUMAB_FOLLOW_SYSTEM)
+			return mode & NUMA_BALANCING_NORMAL;
+	}
+#endif
+	return numab_in_normal_mode();
+}
 #else
 static inline void task_numa_fault(int last_node, int node, int pages,
 				   int flags)
@@ -85,6 +189,18 @@ static inline bool numab_in_normal_mode(void)
 {
 	return false;
 }
+static inline bool task_numab_in_tiering_mode(struct task_struct *p)
+{
+	return false;
+}
+static inline bool folio_numab_in_tiering_mode(struct folio *folio)
+{
+	return false;
+}
+static inline bool folio_numab_in_normal_mode(struct folio *folio)
+{
+	return false;
+}
 #endif
 
 #endif /* _LINUX_SCHED_NUMA_BALANCING_H */
diff --git a/init/Kconfig b/init/Kconfig
index ad592fdf29af..2db065d97eab 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1036,6 +1036,26 @@ config NUMA_BALANCING
 
 	  This system will be inactive on UMA systems.
 
+config BPF_NUMAB
+	bool "Per-cgroup NUMA balancing mode selection"
+	default y
+	depends on NUMA_BALANCING && MEMCG && BPF_SYSCALL
+	help
+	  Allow BPF programs to select the NUMA balancing mode (disabled,
+	  normal, memory tiering, or both) on a per-cgroup basis, overriding the
+	  global NUMA balancing sysctl. A latency-sensitive service can
+	  opt its tasks out of balancing, or a batch service can have its
+	  PMEM-resident memory promoted when hot, without changing the
+	  mode for the rest of the system.
+
+	  The request is written and read back through the
+	  bpf_numab_set_mode() and bpf_numab_get_mode() kfuncs, callable
+	  from BPF_PROG_TYPE_SYSCALL programs. While no cgroup makes a
+	  request, the NUMA balancing hot paths pay a single patched-out
+	  branch and nothing else.
+
+	  If unsure, say Y.
+
 config SCHED_CACHE
 	bool "Cache aware load balance"
 	default y
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 227d09704ca5..e9c01a017a1d 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -39,6 +39,7 @@
 #include <linux/proc_fs.h>
 #include <linux/rcupdate.h>
 #include <linux/sched.h>
+#include <linux/sched/numa_balancing.h>
 #include <linux/sched/task.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
@@ -2122,6 +2123,9 @@ static void init_cgroup_housekeeping(struct cgroup *cgrp)
 	for (int i = 0; i < ARRAY_SIZE(cgrp->bpf.revisions); i++)
 		cgrp->bpf.revisions[i] = 1;
 #endif
+#ifdef CONFIG_BPF_NUMAB
+	cgrp->numab_mode = NUMAB_FOLLOW_SYSTEM;
+#endif
 
 	init_waitqueue_head(&cgrp->offline_waitq);
 	INIT_WORK(&cgrp->release_agent_work, cgroup1_release_agent);
@@ -5719,6 +5723,16 @@ static void css_free_rwork_fn(struct work_struct *work)
 			cgroup1_pidlist_destroy_all(cgrp);
 		cancel_work_sync(&cgrp->release_agent_work);
 		bpf_cgrp_storage_free(cgrp);
+#ifdef CONFIG_BPF_NUMAB
+		/*
+		 * Drop the static key count of a request the caller never
+		 * cleared. No setter can race: this path runs only after
+		 * the last css ref is gone, and the kfunc pins the cgroup
+		 * while it runs.
+		 */
+		if (cgrp->numab_mode != NUMAB_FOLLOW_SYSTEM)
+			static_branch_dec(&numab_cgroup_mode_set);
+#endif
 
 		if (cgroup_parent(cgrp)) {
 			/*
diff --git a/kernel/sched/bpf_numab.c b/kernel/sched/bpf_numab.c
new file mode 100644
index 000000000000..4a9da305ccb1
--- /dev/null
+++ b/kernel/sched/bpf_numab.c
@@ -0,0 +1,195 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Per-cgroup NUMA balancing mode
+ *
+ * A cgroup can override the global NUMA balancing state for the tasks it
+ * runs and the memory it owns: the bpf_numab_set_mode() kfunc stores a
+ * requested mode in struct cgroup, and the NUMA balancing hot paths combine
+ * the requests of the matching cgroup and of every ancestor. For a task
+ * that is the chain of the task's cgroup; for a folio it is the chain of
+ * the memcg the folio is charged to. An opt-out wins and binds the
+ * subtree; otherwise the requested bits OR together and are read
+ * independently, the way the sysctl reads them.
+ *
+ * Author: Yafang Shao <laoar.shao@gmail.com>
+ */
+#include <linux/bpf.h>
+#include <linux/btf.h>
+#include <linux/cgroup.h>
+#include <linux/memcontrol.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/sched.h>
+#include <linux/sched/numa_balancing.h>
+
+/*
+ * Set while any cgroup overrides the global state: the hot paths skip the
+ * consult entirely while it stays off. Counted per cgroup that makes a
+ * request, so the key goes off again once the last request is gone.
+ */
+DEFINE_STATIC_KEY_FALSE(numab_cgroup_mode_set);
+
+/*
+ * Combine the requests of @cgrp and of every ancestor. A task chain
+ * stops at an explicit opt-out: a task can never be forced into
+ * balancing. A folio chain skips opt-outs instead (a cgroup's DISABLED
+ * request only speaks for its tasks, never for its memory) and keeps
+ * collecting the remaining requests.
+ */
+static int numab_cgroup_mode(struct cgroup *cgrp, bool folio_side)
+{
+	int req = 0;
+
+	for (; cgrp; cgrp = cgroup_parent(cgrp)) {
+		/* data_race: the field is written under numab_mode_mutex. */
+		int mode = data_race(READ_ONCE(cgrp->numab_mode));
+
+		if (mode == NUMAB_FOLLOW_SYSTEM)
+			continue;
+		if (mode == NUMA_BALANCING_DISABLED) {
+			if (!folio_side)
+				return NUMA_BALANCING_DISABLED;
+			continue;
+		}
+		req |= mode;
+	}
+	return req ?: NUMAB_FOLLOW_SYSTEM;
+}
+
+/*
+ * The combined request for @p. Kernel threads have no user memory to
+ * balance, so they make no request. The walk needs no reference: the
+ * cgroup chain is freed only after an RCU grace period, so
+ * rcu_read_lock() keeps it alive for the whole walk.
+ */
+int task_numab_mode(struct task_struct *p)
+{
+	int mode;
+
+	if (!p->mm)
+		return NUMAB_FOLLOW_SYSTEM;
+
+	rcu_read_lock();
+	mode = numab_cgroup_mode(task_dfl_cgroup(p), false);
+	rcu_read_unlock();
+	return mode;
+}
+
+/*
+ * The combined request for @folio's owner. An uncharged folio makes no
+ * request. A folio charged to a v1 memcg resolves to a cgroup chain the
+ * kfunc cannot reach, so it carries no request either and the folio
+ * follows the global state.
+ */
+int folio_numab_mode(struct folio *folio)
+{
+	struct mem_cgroup *memcg;
+	struct cgroup *cgrp;
+	int mode;
+
+	rcu_read_lock();
+	memcg = folio_memcg(folio);
+	cgrp = memcg ? memcg->css.cgroup : NULL;
+	mode = cgrp ? numab_cgroup_mode(cgrp, true) : NUMAB_FOLLOW_SYSTEM;
+	rcu_read_unlock();
+	return mode;
+}
+
+/*
+ * Serialize the static key accounting: without it, two concurrent
+ * setters on the same cgroup could both count one transition, and the
+ * key would stay on after the last request is gone.
+ */
+static DEFINE_MUTEX(numab_mode_mutex);
+
+__bpf_kfunc_start_defs();
+
+/**
+ * bpf_numab_set_mode() - Set the NUMA balancing mode requested for a cgroup.
+ * @cgid: kernfs id of the cgroup, e.g. from name_to_handle_at() on its
+ * directory or from bpf_get_current_cgroup_id()
+ * @mode: NUMAB_FOLLOW_SYSTEM to defer to the global sysctl state, or a
+ * NUMA_BALANCING_* bitmask. The kernel reads the bits independently,
+ * the way kernel.numa_balancing reads them, so NORMAL|TIERING engages
+ * both modes. A DISABLED request only speaks for the cgroup's tasks,
+ * never for its memory, which follows the remaining requests of its
+ * ancestors.
+ *
+ * Return: 0 on success, -EINVAL for a mode outside the domain, -ENOENT
+ * for an id that resolves to no cgroup.
+ */
+__bpf_kfunc int bpf_numab_set_mode(u64 cgid, s64 mode)
+{
+	struct cgroup *cgrp;
+	int old;
+
+	if (mode != NUMAB_FOLLOW_SYSTEM &&
+	    (mode < 0 || mode > (NUMA_BALANCING_NORMAL |
+				 NUMA_BALANCING_MEMORY_TIERING)))
+		return -EINVAL;
+
+	cgrp = __cgroup_get_from_id(cgid);
+	if (IS_ERR(cgrp))
+		return PTR_ERR(cgrp);
+
+	mutex_lock(&numab_mode_mutex);
+	old = cgrp->numab_mode;
+	if (old == NUMAB_FOLLOW_SYSTEM && mode != NUMAB_FOLLOW_SYSTEM)
+		static_branch_inc(&numab_cgroup_mode_set);
+	else if (old != NUMAB_FOLLOW_SYSTEM && mode == NUMAB_FOLLOW_SYSTEM)
+		static_branch_dec(&numab_cgroup_mode_set);
+	WRITE_ONCE(cgrp->numab_mode, (int)mode);
+	mutex_unlock(&numab_mode_mutex);
+	cgroup_put(cgrp);
+	return 0;
+}
+
+/**
+ * bpf_numab_get_mode() - Read the NUMA balancing mode that applies to a cgroup.
+ * @cgid: kernfs id of the cgroup
+ *
+ * The combined request of the cgroup and of every ancestor: an opt-out
+ * wins, otherwise the requested bits OR together, and the kernel reads
+ * them independently, as kernel.numa_balancing does, so a combined
+ * NORMAL|TIERING engages both modes. NUMAB_FOLLOW_SYSTEM when nobody
+ * makes a request. This is the view of the cgroup's tasks: its memory
+ * follows the remaining requests of the chain when it opts out, and
+ * that folio-side view stays internal to the kernel.
+ *
+ * Return: the combined mode, NUMAB_FOLLOW_SYSTEM (-1) included, or
+ * -ENOENT for an id that resolves to no cgroup.
+ */
+__bpf_kfunc s64 bpf_numab_get_mode(u64 cgid)
+{
+	struct cgroup *cgrp;
+	s64 mode;
+
+	cgrp = __cgroup_get_from_id(cgid);
+	if (IS_ERR(cgrp))
+		return PTR_ERR(cgrp);
+
+	rcu_read_lock();
+	mode = numab_cgroup_mode(cgrp, false);
+	rcu_read_unlock();
+
+	cgroup_put(cgrp);
+	return mode;
+}
+
+__bpf_kfunc_end_defs();
+
+BTF_KFUNCS_START(numab_kfunc_ids)
+BTF_ID_FLAGS(func, bpf_numab_set_mode, KF_SLEEPABLE)
+BTF_ID_FLAGS(func, bpf_numab_get_mode)
+BTF_KFUNCS_END(numab_kfunc_ids)
+
+static const struct btf_kfunc_id_set numab_kfunc_set = {
+	.owner = THIS_MODULE,
+	.set   = &numab_kfunc_ids,
+};
+
+static int __init numab_kfunc_init(void)
+{
+	return register_btf_kfunc_id_set(BPF_PROG_TYPE_SYSCALL, &numab_kfunc_set);
+}
+late_initcall(numab_kfunc_init);
diff --git a/kernel/sched/build_policy.c b/kernel/sched/build_policy.c
index 2a828725a7f9..3746c6675ff3 100644
--- a/kernel/sched/build_policy.c
+++ b/kernel/sched/build_policy.c
@@ -75,4 +75,8 @@
 # include "ext/sub.c"
 #endif
 
+#ifdef CONFIG_BPF_NUMAB
+#include "bpf_numab.c"
+#endif
+
 #include "syscalls.c"
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 066818498c76..2a4ad93a262a 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2965,7 +2965,7 @@ bool should_numa_migrate_memory(struct task_struct *p, struct folio *folio,
 	this_cpupid = cpu_pid_to_cpupid(dst_cpu, current->pid);
 	last_cpupid = folio_xchg_last_cpupid(folio, this_cpupid);
 
-	if (!(numab_in_tiering_mode()) && !node_is_toptier(src_nid) &&
+	if (!folio_numab_in_tiering_mode(folio) && !node_is_toptier(src_nid) &&
 	    !cpupid_valid(last_cpupid))
 		return false;
 
@@ -4208,7 +4208,7 @@ void task_numa_fault(int last_cpupid, int mem_node, int pages, int flags)
 	 * node for memory tiering mode.
 	 */
 	if (!node_is_toptier(mem_node) &&
-	    (numab_in_tiering_mode() || !cpupid_valid(last_cpupid)))
+	    (task_numab_in_tiering_mode(p) || !cpupid_valid(last_cpupid)))
 		return;
 
 	/* Allocate buffer to track faults on a per-node basis */
diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
index 9009b164edc2..c68ce7f9171e 100644
--- a/mm/memory-tiers.c
+++ b/mm/memory-tiers.c
@@ -57,15 +57,15 @@ static const struct bus_type memory_tier_subsys = {
  * folio_use_access_time - check if a folio reuses cpupid for page access time
  * @folio: folio to check
  *
- * folio's _last_cpupid field is repurposed by memory tiering. In memory
- * tiering mode, cpupid of slow memory folio (not toptier memory) is used to
- * record page access time.
+ * folio's _last_cpupid field is repurposed by memory tiering. When the
+ * owner of @folio participates in tiering, cpupid of slow memory folio
+ * (not toptier memory) is used to record page access time.
  *
  * Return: the folio _last_cpupid is used to record page access time
  */
 bool folio_use_access_time(struct folio *folio)
 {
-	return numab_in_tiering_mode() &&
+	return folio_numab_in_tiering_mode(folio) &&
 	       !node_is_toptier(folio_nid(folio));
 }
 #endif
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 442c93079fb0..fe8ae6cf5c58 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -871,7 +871,7 @@ bool folio_can_map_prot_numa(struct folio *folio, struct vm_area_struct *vma,
 	 * Skip scanning top tier node if normal numa
 	 * balancing is disabled
 	 */
-	if (!numab_in_normal_mode() && node_is_toptier(nid))
+	if (!folio_numab_in_normal_mode(folio) && node_is_toptier(nid))
 		return false;
 
 	if (folio_use_access_time(folio))
diff --git a/mm/migrate.c b/mm/migrate.c
index a622df9a9b42..4b87d465c5fd 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -819,7 +819,7 @@ void folio_migrate_flags(struct folio *newfolio, struct folio *folio)
 	 * memory node, reset cpupid, because that is used to record
 	 * page access time in slow memory node.
 	 */
-	if (numab_in_tiering_mode()) {
+	if (folio_numab_in_tiering_mode(folio)) {
 		bool f_toptier = node_is_toptier(folio_nid(folio));
 		bool t_toptier = node_is_toptier(folio_nid(newfolio));
 
@@ -2771,7 +2771,7 @@ int migrate_misplaced_folio(struct folio *folio, int node)
 	if (nr_succeeded) {
 		count_vm_numa_events(NUMA_PAGE_MIGRATE, nr_succeeded);
 		count_memcg_events(memcg, NUMA_PAGE_MIGRATE, nr_succeeded);
-		if ((numab_in_tiering_mode())
+		if (folio_numab_in_tiering_mode(folio)
 		    && !node_is_toptier(folio_nid(folio))
 		    && node_is_toptier(node))
 			mod_lruvec_state(lruvec, PGPROMOTE_SUCCESS, nr_succeeded);
-- 
2.52.0

