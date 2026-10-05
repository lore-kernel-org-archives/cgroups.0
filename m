Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C15AB376490
	for <cgroups@vger.kernel.org>; Mon,  5 Oct 2026 07:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791184002; cv=none; b=urZfhpC7scyQmLHL2IF5bYlYMZ2QEU6HcPCQQQQ6KTVLdY1V1G+ad6nUVdmzQJOJnkk56McPFTq+UJzuaz+NGSyHrEtBVCnFWdiFXjJdvmtSixv6tGmhY7t+mCWn8xos4/XCvTMiyG0e0S0VPI97N0xQ5GU0TDWde+25qBBFmnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791184002; c=relaxed/simple;
	bh=jUeOtuB74Cd2qDp6fyl4nJDnylvPrgujwz/d7BC4LUE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=I5d67yRmdrhxpCff7i0oJs9UQJ6SgOv5Vmil02RmIDnk2rcGcEiPdlR6/czh9j8qPipjzFtuGhb/pS2FTAjDxVo2hcOhtNkOhhJa2VohSIPOQ2dofHuHwR+BNt3mtiyl/mbGuAjPC7Zl6SPXSIYOpWNkbSKtR354XIYpDnCM0E4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=S6jKydiQ; arc=none smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="S6jKydiQ"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49e79a408deso7702715e9.2
        for <cgroups@vger.kernel.org>; Mon, 05 Oct 2026 00:06:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791183997; x=1791788797; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jo7S1SVJIVFyNaxR02icLv8UsKmGCeJaeAs0M/mr6sE=;
        b=S6jKydiQLnhi7ppF8U2zxD+08WOjsfcD3aTPdrK4pb8IKjwXtICsE+y6VcqaU+gPi2
         LsWnQx4KMSMajFKAYTm+IuQJ404EkMDWXhmRsvXDwUrKuU2uZRQ5G+xoxnEkd0+fttA/
         9huCOTYJ2ILZIWyk/CWXZtCUzsRP+yp1e+ljjaDYr2WpoONWcSDu0oHMuA+uMVJ9aG/M
         hxzKAiqe1ojtCkpm0pAvK1ozQkOc6ZSeMhK5BfvGygrC4kUx2J10AQUErtpD8WLNuvpJ
         ppWOZxx4ec9Fc9xKf2aYugYmPcahNK4tar4WClmgSudeFKB8s4AnNfuEQ6AWyiWx2Tt8
         Lbmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791183997; x=1791788797;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=jo7S1SVJIVFyNaxR02icLv8UsKmGCeJaeAs0M/mr6sE=;
        b=M9Vwa2ApMeBUHGeCk9fFmbwbayTjEGNFlklh7bTVEQ0eI5IgnD8+IV8cjzOVFWYKmI
         arYgIzmRnXPq0ynYYw77nishntNGb2rLJEKnY/yN5zwldgBAexd9C6I7HmiosMzf6sFl
         GHGPm5Gx+22FX7a9t+uPuDsZ99AAhXGeE+gF4ItDxD/3KIfB/37a9NTjWh5ziJYR0T6y
         bNTYf6IDPtmot0WET0d99Sn2AByVUHskig8qt6LE4PjG430PzVcjd2eczuLCMslwvhjh
         SoWgK5BFxEY1HTnuEJXWY61N/8ctECTqZYgbRrgisWx7oX6HzyK8f98N/+tf/6roXRo2
         9SLQ==
X-Forwarded-Encrypted: i=1; AKwUvBySBrcpGU+E31LbrPaUoZgu3GTELT4QnxvC1oDA0jfoZaZfHKOP5kDm+JdzgdWjH+M/RCebbhf5@vger.kernel.org
X-Gm-Message-State: AFuF++nCOEHIEdyDBR4vxcmV9rPOWN7Nh6AJv1tH11POeq0wohfAtYIH
	nkspyccSreR35ITP5Q7S7p5OHc9eHBemn2X8YOrTFMwnK2eB0od0ux0R
X-Gm-Gg: AYBFou1fi3tffyk8OmTWAwOqgCpAj4xD43zh2YkAxQyYALIRxZv7nSQ3CPXZo/lTXjP
	yWq3/5Ubj6BsmIxRETSqTrFr/Vj+JUs0t/GrRyDFUMKBxhrq323juAfxKdvKXLbLwkRneNr9Ot8
	aCtg4Y86EMLQXCwc/bdKJGTfssQgYIdb71LNbrBjGurDw77Oif5WgkraDhluxPE5Xw7HIQ+G+Zl
	NFeDr3XWFYPT+Lg1lDFvovFvsutKmt0WVhqvKYmF1dsA7WVUMy/0YScSsaIGkblNmh3fqCfmdXd
	L0gpHLkR64d7sxj6pO08oJ0Dpoct669BX79nLI7Jyz9iqobb8Dv7K6InbjcwsiQ1o3Pz6fO1/st
	8TIflk0Km2imMSS96DfgcRoZkccXKXOM3vQM9IJEghFZ4QEc8Ig2mrG665SqgwYRCWxRE0CpeZ4
	4Y6o248vftqLZRJCPKlak9mJCxPitVQexxcyN9frA5zJLu49IJyOptnbfK5qbt3TJoOdbFKDzNq
	anN473s1zhokKbG7o70fgiRk2z+daaQujoMGGWiSf3DbXSKe8DwfhcCwAOoYudknhS3f/saBWDx
	jNqTm7s7H/JGksXfu+Pxvyd8NRiICdguwsw6ssVcmo3UW/mP1Y/isYce7aUt/z+Q5UjQ+l3NHbn
	fbPw=
X-Received: by 2002:a05:600c:c165:b0:4a0:108:3b54 with SMTP id 5b1f17b1804b1-4a02758e674mr172507215e9.32.1791183996516;
        Mon, 05 Oct 2026 00:06:36 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-b305-2001-39fa-3d24-821a-4eae.310.pool.telefonica.de. [2a02:3100:b305:2001:39fa:3d24:821a:4eae])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a16bcb9a21sm283461465e9.10.2026.10.05.00.06.34
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 05 Oct 2026 00:06:36 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Ingo Molnar <mingo@redhat.com>,
	Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>,
	Waiman Long <longman@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	David Hildenbrand <david@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	David Stevens <stevensd@google.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Shuah Khan <shuah@kernel.org>,
	Amery Hung <ameryhung@gmail.com>,
	Swaraj Gaikwad <swarajgaikwad1925@gmail.com>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org,
	linux-rt-devel@lists.linux.dev,
	bpf@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: [RFC PATCH v2 2/3] mm: use atomic RT trylocks for no-lock allocation
Date: Mon,  5 Oct 2026 09:06:24 +0200
Message-Id: <20261005070625.8871-3-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20261005070625.8871-1-kmehltretter@gmail.com>
References: <20261005070625.8871-1-kmehltretter@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit 073d5f156292 ("slab: simplify kmalloc_nolock()") allowed no-lock
slab allocation from preempt-disabled sections again on PREEMPT_RT. The
remaining global allocator locks are backed by rtmutexes. Releasing one
after a successful trylock can enter the rtmutex priority inheritance and
wakeup paths.

BPF task storage from sched_waking can reach this while try_to_wake_up()
holds p->pi_lock:

  try_to_wake_up()
    raw_spin_lock_irqsave(&p->pi_lock)
      bpf_task_storage_get()
        kmalloc_nolock()
          spin_trylock_irqsave(&n->list_lock)
          spin_unlock_irqrestore(&n->list_lock)
            rtmutex wakeup paths

The wakeup from the allocator unlock can re-enter scheduler locking and
deadlock.

Use spin_trylock_nolock_irqsave() for the global SLUB and page allocator
locks. Its atomic owner state avoids the rtmutex slow path for
non-preemptible RT callers. Preemptible callers keep regular RT spinlock
semantics.

Skip per-CPU allocator and memcg caches for non-preemptible RT callers.
Their regular RT local-lock slow paths can take current->pi_lock.

Skipping the per-CPU objcg stock on every accounted no-lock allocation
would otherwise charge a full page each time. Matching frees add prepaid
bytes to objcg->nr_charged_bytes, but the next allocation did not consume
them. Reuse and refill those centralized bytes with cmpxchg when the local
stock cannot be used, and return complete pages once the retained credit
crosses the existing thresholds.

The page allocator has accepted the same contexts since its no-lock
interface was introduced, so apply the atomic trylock rule to both slab
and page no-lock paths. The prerequisite page-free fix keeps successful
no-lock frees out of allocator shuffling and page-reporting notification.

Bypassing the local objcg stock can make a no-lock charge reach
memory.high handling more often. Apply this after David Stevens's pending
change which defers memory.high work from contexts where spinning is not
allowed. Otherwise the existing schedule_work() hazard remains. There is
no build dependency between the changes.

Fixes: 073d5f156292 ("slab: simplify kmalloc_nolock()")
Link: https://lore.kernel.org/r/20260919171443.90512-1-kmehltretter@gmail.com
Link: https://lore.kernel.org/r/20260904173145.2028377-1-stevensd@google.com
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
 mm/internal.h   | 27 ++++++++++-----
 mm/memcontrol.c | 90 +++++++++++++++++++++++++++++++++++++++----------
 mm/page_alloc.c | 33 +++++++++++++++---
 mm/slub.c       | 36 +++++++++++++-------
 4 files changed, 142 insertions(+), 44 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 38b1165212c9..5b8cabaf86df 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1631,18 +1631,27 @@ static inline void mm_prepare_for_swap_entries(struct mm_struct *mm)
 	}
 }
 
+/*
+ * On PREEMPT_RT, local_trylock() uses a regular rtmutex-backed spinlock.
+ * Its slow path can take current->pi_lock. Skip these caches when a no-lock
+ * caller is already non-preemptible.
+ */
+#define mm_local_trylock_nolock(lock)					\
+({									\
+	bool __locked = false;						\
+									\
+	if (!IS_ENABLED(CONFIG_PREEMPT_RT) || preemptible())		\
+		__locked = local_trylock(lock);				\
+	__locked;							\
+})
+
 static inline bool can_spin_trylock(void)
 {
 	/*
-	 * In PREEMPT_RT spin_trylock() will call raw_spin_lock() which is
-	 * unsafe in NMI. If spin_trylock() is called from hard IRQ the current
-	 * task may be waiting for one rt_spin_lock, but rt_spin_trylock() will
-	 * mark the task as the owner of another rt_spin_lock which will
-	 * confuse PI logic, so return immediately if called from hard IRQ or
-	 * NMI.
-	 *
-	 * Note, irqs_disabled() case is ok. spin_trylock() can be called
-	 * from raw_spin_lock_irqsave region.
+	 * PREEMPT_RT no-lock allocation has not been validated in NMI or hard
+	 * IRQ context. Other atomic contexts use
+	 * spin_trylock_nolock_irqsave(), which does not enter the rtmutex PI
+	 * machinery.
 	 */
 	if (IS_ENABLED(CONFIG_PREEMPT_RT) && (in_nmi() || in_hardirq()))
 		return false;
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 856a7d07586c..03a83664f99b 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2129,7 +2129,7 @@ static bool consume_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
 	int i;
 
 	if (nr_pages > MEMCG_CHARGE_BATCH ||
-	    !local_trylock(&memcg_stock.lock))
+	    !mm_local_trylock_nolock(&memcg_stock.lock))
 		return ret;
 
 	stock = this_cpu_ptr(&memcg_stock);
@@ -2243,7 +2243,7 @@ static void refill_stock(struct mem_cgroup *memcg, unsigned int nr_pages)
 	VM_WARN_ON_ONCE(mem_cgroup_is_root(memcg));
 
 	if (nr_pages > MEMCG_CHARGE_BATCH ||
-	    !local_trylock(&memcg_stock.lock)) {
+	    !mm_local_trylock_nolock(&memcg_stock.lock)) {
 		/*
 		 * In case of larger than batch refill or unlikely failure to
 		 * lock the percpu memcg_stock.lock, uncharge memcg directly.
@@ -3232,7 +3232,7 @@ void __memcg_kmem_uncharge_page(struct page *page, int order)
 
 static struct obj_stock_pcp *trylock_stock(void)
 {
-	if (local_trylock(&obj_stock.lock))
+	if (mm_local_trylock_nolock(&obj_stock.lock))
 		return this_cpu_ptr(&obj_stock);
 
 	return NULL;
@@ -3336,14 +3336,64 @@ static bool __consume_obj_stock(struct obj_cgroup *objcg,
 	return false;
 }
 
-static bool consume_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes)
+/*
+ * A failed per-CPU stock trylock normally falls back to charging another
+ * page. No-lock callers can fail that trylock on every allocation, so reuse
+ * the centralized prepaid bytes before charging again. Paired frees return
+ * the bytes here and keep the retained charge bounded instead of adding one
+ * page per allocation.
+ */
+static bool consume_obj_stock_shared(struct obj_cgroup *objcg,
+				     unsigned int nr_bytes)
+{
+	int old = atomic_read(&objcg->nr_charged_bytes);
+
+	do {
+		if (old < 0 || (unsigned int)old < nr_bytes)
+			return false;
+	} while (!atomic_try_cmpxchg(&objcg->nr_charged_bytes, &old,
+				     old - nr_bytes));
+
+	return true;
+}
+
+static unsigned int refill_obj_stock_shared(struct obj_cgroup *objcg,
+					    unsigned int nr_bytes,
+					    bool allow_uncharge)
+{
+	int old = atomic_read(&objcg->nr_charged_bytes);
+	unsigned int new, nr_pages;
+	u64 total;
+
+	do {
+		if (WARN_ON_ONCE(old < 0))
+			return 0;
+
+		total = (unsigned int)old + (u64)nr_bytes;
+		nr_pages = 0;
+		if ((allow_uncharge && total > PAGE_SIZE) || total > U16_MAX) {
+			nr_pages = total >> PAGE_SHIFT;
+			new = total & (PAGE_SIZE - 1);
+		} else {
+			new = total;
+		}
+	} while (!atomic_try_cmpxchg(&objcg->nr_charged_bytes, &old, new));
+
+	return nr_pages;
+}
+
+static bool consume_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes,
+			      gfp_t gfp)
 {
 	struct obj_stock_pcp *stock;
 	bool ret = false;
 
 	stock = trylock_stock();
-	if (!stock)
+	if (!stock) {
+		if (!gfpflags_allow_spinning(gfp))
+			ret = consume_obj_stock_shared(objcg, nr_bytes);
 		return ret;
+	}
 
 	ret = __consume_obj_stock(objcg, stock, nr_bytes);
 	unlock_stock(stock);
@@ -3462,9 +3512,8 @@ static void __refill_obj_stock(struct obj_cgroup *objcg,
 	int i, slot = -1, empty_slot = -1;
 
 	if (!stock) {
-		nr_pages = nr_bytes >> PAGE_SHIFT;
-		nr_bytes = nr_bytes & (PAGE_SIZE - 1);
-		atomic_add(nr_bytes, &objcg->nr_charged_bytes);
+		nr_pages = refill_obj_stock_shared(objcg, nr_bytes,
+						   allow_uncharge);
 		goto out;
 	}
 
@@ -3548,18 +3597,18 @@ int obj_cgroup_charge(struct obj_cgroup *objcg, gfp_t gfp, size_t size)
 	size_t remainder;
 	int ret;
 
-	if (likely(consume_obj_stock(objcg, size)))
+	if (likely(consume_obj_stock(objcg, size, gfp)))
 		return 0;
 
 	/*
-	 * In theory, objcg->nr_charged_bytes can have enough
-	 * pre-charged bytes to satisfy the allocation. However,
+	 * For callers which allow spinning, objcg->nr_charged_bytes can have
+	 * enough pre-charged bytes to satisfy the allocation. However,
 	 * flushing objcg->nr_charged_bytes requires two atomic
 	 * operations, and objcg->nr_charged_bytes can't be big.
 	 * The shared objcg->nr_charged_bytes can also become a
 	 * performance bottleneck if all tasks of the same memcg are
-	 * trying to update it. So it's better to ignore it and try
-	 * grab some new pages. The stock's nr_bytes will be flushed to
+	 * trying to update it. So it's better for those callers to ignore it
+	 * and try to grab some new pages. The stock's nr_bytes will be flushed to
 	 * objcg->nr_charged_bytes later on when objcg changes.
 	 *
 	 * The stock's nr_bytes may contain enough pre-charged bytes
@@ -3570,9 +3619,9 @@ int obj_cgroup_charge(struct obj_cgroup *objcg, gfp_t gfp, size_t size)
 	 * page uncharge right after a page charge, we set the
 	 * allow_uncharge flag to false when calling refill_obj_stock()
 	 * to temporarily allow the pre-charged bytes to exceed the page
-	 * size limit. The maximum reachable value of the pre-charged
-	 * bytes is (sizeof(object) + PAGE_SIZE - 2) if there is no data
-	 * race.
+	 * size limit. No-lock callers already tried the centralized bytes
+	 * above. The maximum reachable value of the pre-charged bytes is
+	 * (sizeof(object) + PAGE_SIZE - 2) if there is no data race.
 	 */
 	ret = __obj_cgroup_charge(objcg, gfp, size, &remainder);
 	if (!ret && remainder)
@@ -3640,6 +3689,7 @@ bool __memcg_slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
 		unsigned long obj_exts;
 		struct slabobj_ext *obj_ext;
 		struct obj_stock_pcp *stock;
+		bool consumed;
 
 		slab = virt_to_slab(p[i]);
 
@@ -3662,7 +3712,13 @@ bool __memcg_slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
 		 * between iterations, with a more complicated undo
 		 */
 		stock = trylock_stock();
-		if (!stock || !__consume_obj_stock(objcg, stock, obj_size)) {
+		if (stock)
+			consumed = __consume_obj_stock(objcg, stock, obj_size);
+		else
+			consumed = !gfpflags_allow_spinning(flags) &&
+				   consume_obj_stock_shared(objcg, obj_size);
+
+		if (!consumed) {
 			size_t remainder;
 
 			unlock_stock(stock);
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 3e21dc90b858..617997ed40ba 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -142,6 +142,15 @@ static DEFINE_MUTEX(pcp_batch_high_lock);
 	pcpu_task_unpin();						\
 })
 
+#define pcp_spin_trylock_nolock(ptr)					\
+({									\
+	struct per_cpu_pages *_ret = NULL;				\
+									\
+	if (!IS_ENABLED(CONFIG_PREEMPT_RT) || preemptible())		\
+		_ret = pcp_spin_trylock(ptr);				\
+	_ret;								\
+})
+
 /*
  * On CONFIG_SMP=n the UP implementation of spin_trylock() never fails and thus
  * is not compatible with our locking scheme. However we do not need pcp for
@@ -154,6 +163,13 @@ static DEFINE_MUTEX(pcp_batch_high_lock);
 
 #define pcp_spin_unlock(ptr)		\
 		BUG_ON(1)
+
+#define pcp_spin_trylock_nolock(ptr)		\
+({						\
+	(void)(ptr);				\
+	NULL;					\
+})
+
 #endif
 
 /*
@@ -1562,7 +1578,8 @@ static void free_one_page(struct zone *zone, struct page *page,
 	unsigned long flags;
 
 	if (unlikely(fpi_flags & FPI_NOLOCK)) {
-		if (!can_spin_trylock() || !spin_trylock_irqsave(&zone->lock, flags)) {
+		if (!can_spin_trylock() ||
+		    !spin_trylock_nolock_irqsave(&zone->lock, flags)) {
 			add_page_to_zone_llist(zone, page, order);
 			return;
 		}
@@ -2544,7 +2561,7 @@ static int rmqueue_bulk(struct zone *zone, unsigned int order,
 	int i;
 
 	if (unlikely(alloc_flags & ALLOC_NOLOCK)) {
-		if (!spin_trylock_irqsave(&zone->lock, flags))
+		if (!spin_trylock_nolock_irqsave(&zone->lock, flags))
 			return 0;
 	} else {
 		spin_lock_irqsave(&zone->lock, flags);
@@ -2986,7 +3003,10 @@ static void __free_frozen_pages(struct page *page, unsigned int order,
 		add_page_to_zone_llist(zone, page, order);
 		return;
 	}
-	pcp = pcp_spin_trylock(zone->per_cpu_pageset);
+	if (unlikely(fpi_flags & FPI_NOLOCK))
+		pcp = pcp_spin_trylock_nolock(zone->per_cpu_pageset);
+	else
+		pcp = pcp_spin_trylock(zone->per_cpu_pageset);
 	if (pcp) {
 		if (!free_frozen_page_commit(zone, pcp, page, migratetype,
 						order, fpi_flags))
@@ -3231,7 +3251,7 @@ struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
 	do {
 		page = NULL;
 		if (unlikely(alloc_flags & ALLOC_NOLOCK)) {
-			if (!spin_trylock_irqsave(&zone->lock, flags))
+			if (!spin_trylock_nolock_irqsave(&zone->lock, flags))
 				return NULL;
 		} else {
 			spin_lock_irqsave(&zone->lock, flags);
@@ -3380,7 +3400,10 @@ static struct page *rmqueue_pcplist(struct zone *preferred_zone,
 	struct page *page;
 
 	/* spin_trylock may fail due to a parallel drain or IRQ reentrancy. */
-	pcp = pcp_spin_trylock(zone->per_cpu_pageset);
+	if (unlikely(alloc_flags & ALLOC_NOLOCK))
+		pcp = pcp_spin_trylock_nolock(zone->per_cpu_pageset);
+	else
+		pcp = pcp_spin_trylock(zone->per_cpu_pageset);
 	if (!pcp)
 		return NULL;
 
diff --git a/mm/slub.c b/mm/slub.c
index 544cff39762c..5281f13f210b 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3149,7 +3149,7 @@ static struct slab_sheaf *barn_get_empty_sheaf(struct node_barn *barn,
 
 	if (likely(allow_spin))
 		spin_lock_irqsave(&barn->lock, flags);
-	else if (!spin_trylock_irqsave(&barn->lock, flags))
+	else if (!spin_trylock_nolock_irqsave(&barn->lock, flags))
 		return NULL;
 
 	if (likely(barn->nr_empty)) {
@@ -3238,7 +3238,7 @@ barn_replace_empty_sheaf(struct node_barn *barn, struct slab_sheaf *empty,
 
 	if (likely(allow_spin))
 		spin_lock_irqsave(&barn->lock, flags);
-	else if (!spin_trylock_irqsave(&barn->lock, flags))
+	else if (!spin_trylock_nolock_irqsave(&barn->lock, flags))
 		return NULL;
 
 	if (likely(barn->nr_full)) {
@@ -3274,7 +3274,7 @@ barn_replace_full_sheaf(struct node_barn *barn, struct slab_sheaf *full,
 
 	if (likely(allow_spin))
 		spin_lock_irqsave(&barn->lock, flags);
-	else if (!spin_trylock_irqsave(&barn->lock, flags))
+	else if (!spin_trylock_nolock_irqsave(&barn->lock, flags))
 		return ERR_PTR(-EBUSY);
 
 	if (likely(barn->nr_empty)) {
@@ -3784,7 +3784,7 @@ static void *alloc_single_from_new_slab(struct kmem_cache *s, struct slab *slab,
 	n = get_node(s, slab_nid(slab));
 	if (allow_spin) {
 		spin_lock_irqsave(&n->list_lock, flags);
-	} else if (!spin_trylock_irqsave(&n->list_lock, flags)) {
+	} else if (!spin_trylock_nolock_irqsave(&n->list_lock, flags)) {
 		/*
 		 * Unlucky, discard newly allocated slab.
 		 * The slab is not fully free, but it's fine as
@@ -3829,7 +3829,7 @@ static bool get_partial_node_bulk(struct kmem_cache *s,
 
 	if (allow_spin)
 		spin_lock_irqsave(&n->list_lock, flags);
-	else if (!spin_trylock_irqsave(&n->list_lock, flags))
+	else if (!spin_trylock_nolock_irqsave(&n->list_lock, flags))
 		return false;
 
 	list_for_each_entry_safe(slab, slab2, &n->partial, slab_list) {
@@ -3902,7 +3902,7 @@ static void *get_from_partial_node(struct kmem_cache *s,
 
 	if (alloc_flags_allow_spinning(ac->alloc_flags))
 		spin_lock_irqsave(&n->list_lock, flags);
-	else if (!spin_trylock_irqsave(&n->list_lock, flags))
+	else if (!spin_trylock_nolock_irqsave(&n->list_lock, flags))
 		return NULL;
 	list_for_each_entry_safe(slab, slab2, &n->partial, slab_list) {
 
@@ -4506,7 +4506,7 @@ static unsigned int alloc_from_new_slab(struct kmem_cache *s, struct slab *slab,
 
 		if (allow_spin) {
 			spin_lock_irqsave(&n->list_lock, flags);
-		} else if (!spin_trylock_irqsave(&n->list_lock, flags)) {
+		} else if (!spin_trylock_nolock_irqsave(&n->list_lock, flags)) {
 			/*
 			 * Unlucky, discard newly allocated slab.
 			 * The slab is not fully free, but it's fine as
@@ -4702,6 +4702,15 @@ bool slab_post_alloc_hook(struct kmem_cache *s, gfp_t flags, size_t size,
 	return memcg_slab_post_alloc_hook(s, flags, size, p, ac);
 }
 
+static __always_inline bool
+cpu_sheaves_trylock(struct kmem_cache *s, bool allow_spin)
+{
+	if (allow_spin)
+		return local_trylock(&s->cpu_sheaves->lock);
+
+	return mm_local_trylock_nolock(&s->cpu_sheaves->lock);
+}
+
 /*
  * Replace the empty main sheaf with a (at least partially) full sheaf.
  *
@@ -4827,6 +4836,7 @@ static __fastpath_inline
 void *alloc_from_pcs(struct kmem_cache *s, gfp_t gfp, unsigned int alloc_flags, int node)
 {
 	struct slub_percpu_sheaves *pcs;
+	bool allow_spin = alloc_flags_allow_spinning(alloc_flags);
 	bool node_requested;
 	void *object;
 
@@ -4841,7 +4851,7 @@ void *alloc_from_pcs(struct kmem_cache *s, gfp_t gfp, unsigned int alloc_flags,
 		return NULL;
 	}
 
-	if (!local_trylock(&s->cpu_sheaves->lock))
+	if (!cpu_sheaves_trylock(s, allow_spin))
 		return NULL;
 
 	pcs = this_cpu_ptr(s->cpu_sheaves);
@@ -5477,7 +5487,7 @@ static void *__kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_f
 		 * But debug caches don't use that and only rely on
 		 * kmem_cache_node->list_lock, so kmalloc_nolock() can attempt
 		 * to allocate from debug caches by
-		 * spin_trylock_irqsave(&n->list_lock, ...)
+		 * spin_trylock_nolock_irqsave(&n->list_lock, ...)
 		 */
 		return NULL;
 
@@ -5980,7 +5990,7 @@ __pcs_replace_full_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 	if (!sheaf_try_flush_main(s))
 		return NULL;
 
-	if (!local_trylock(&s->cpu_sheaves->lock))
+	if (!cpu_sheaves_trylock(s, allow_spin))
 		return NULL;
 
 	pcs = this_cpu_ptr(s->cpu_sheaves);
@@ -6016,7 +6026,7 @@ bool free_to_pcs(struct kmem_cache *s, void *object, bool allow_spin)
 {
 	struct slub_percpu_sheaves *pcs;
 
-	if (!local_trylock(&s->cpu_sheaves->lock))
+	if (!cpu_sheaves_trylock(s, allow_spin))
 		return false;
 
 	pcs = this_cpu_ptr(s->cpu_sheaves);
@@ -6120,7 +6130,7 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj, unsigned int free_flags)
 	if (!IS_ENABLED(CONFIG_PREEMPT_RT))
 		lock_map_acquire_try(&kfree_rcu_sheaf_map);
 
-	if (!local_trylock(&s->cpu_sheaves->lock))
+	if (!cpu_sheaves_trylock(s, allow_spin))
 		goto fail;
 
 	pcs = this_cpu_ptr(s->cpu_sheaves);
@@ -6163,7 +6173,7 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj, unsigned int free_flags)
 		if (!empty)
 			goto fail;
 
-		if (!local_trylock(&s->cpu_sheaves->lock)) {
+		if (!cpu_sheaves_trylock(s, allow_spin)) {
 			__free_empty_sheaf(s, empty, free_flags);
 			goto fail;
 		}
-- 
2.53.0

