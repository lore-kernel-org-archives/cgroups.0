Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793717293;
	b=kiM8fk2rre1QDrJkWnf7t7VwWEaPiBM3cas2uSMJE+VPvFJ/N8CoAt5qvj97c1AiLb0v
	 FpUrUSETB63fDvVB1uqL+ufjKpjgK46Zya/gRWUyk7x5gm/bRTb6uTordIad3weoZ3hVc
	 g4YjGsiOyGKgf9k9qhIa5Y7sUjIbLt90MmPUKIzhW1qDFSaFfYJr1Hb/aeLw42X2ntYW5
	 I3hMobGEGMnmMOdJwOryD/WdKrjIs7BiGXjbdeB9AOozVaXNQowZ7RsL9MnaiGTzW1Trp
	 yWbhlTx9r0F/mSM/9RD7omEuQiLDuTG/KvRVtohMqO55+VCEehLva+TvGzmiNwBWF8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793717293;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer;
	bh=gt49kfhRLv3BikedQenPzFqlRz9INL4lEazsjHYysos=;
	b=Vv1iWaiQs/k5yQA6tbQQyTjU1muiHlVwxR+f0jeDYvINqmzLfiCa1Eg2QIWTiV8kriqv
	 +kE0UfnZ90QbxqELwZsQ3hf6tP7vrMlwKeJ9f/Lw9iYNYkZUTUpyz6EXGttmvTlv9i6r/
	 gxIkm5X5dy2X4znwDlMb/mGsDBpVjXMRkCthoxQDLwkMAHI8Dl0AHo7blBSPzeS8CNICX
	 /kxPr90bmS47nUq/pNmRjJS2+nRb351Sy7d8EBifbKfBgWLLvVZr7WvEQ4fJjnLh3D7pp
	 uE3IefD+yaIEWkW9PdSMGZuR6n7VeMNiMAmkOKG659/kAYf9cvVWxQ3XXjTJCWh9MxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="UV/SzD8b";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 351E860A261C;
	Tue,  3 Nov 2026 14:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UV/SzD8b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2C331F00A1E;
	Tue,  3 Nov 2026 14:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793717293;
	bh=gt49kfhRLv3BikedQenPzFqlRz9INL4lEazsjHYysos=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=UV/SzD8b1lCSXwwMKrcBE9IpVGv7kQTGdpYQqYduYHGWazOxgVATqO/kxaAdh8MDP
	 qIcAPuk6iyLpbahuEnMajrKRuNfaxfiaZ8197/LLrguzEESjD5T7WmUq6KIMnrDYwT
	 hacivFso6yJwasxOf792PVq+/bU2bD1Cd+bihB0zPceciV3O11DWGjMFPtKo13kawQ
	 UGmT5u2AwnD/LzGPewxPkq1yM5mGqV9mBPLpK2NIckBlD5lowLS5slKWJyVG67BQVn
	 eUqOsj3XEaeayQhnXnjEUmEcuDtkDmw8mpmMRdRGHAfmJ2XVYQnVMNb8s8vmd2gtel
	 RGWDcp8OrevyA==
From: "Harry Yoo (Meta)" <harry@kernel.org>
Date: Tue, 03 Nov 2026 14:47:51 +0000
Subject: [PATCH for-next-fixes v2 2/5] mm/slab: handle allow_spin in
 slab_free_hook() instead of open coding
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261103-kmalloc-nolock-fixes-v2-2-19167cfe4779@kernel.org>
References: <20261103-kmalloc-nolock-fixes-v2-0-19167cfe4779@kernel.org>
In-Reply-To: <20261103-kmalloc-nolock-fixes-v2-0-19167cfe4779@kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, Harry Yoo <harry@kernel.org>, 
 Alexei Starovoitov <ast@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: kernel-team@meta.com, cgroups@vger.kernel.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev
X-Mailer: b4 0.16.0

kfree_nolock() deliberately skips slab free hooks that should not be
called in unknown context. However, there is one more place that
needs the same thing: memcg_alloc_abort_single().

Instead of open coding slab_free_hook(), let it handle the allow_spin
parameter. This is required to correctly handle allocation failures due
to memcg charging.

There are two functional changes from this.

First, memcg_alloc_abort_single() -> slab_free_hook() path no longer
calls free hooks that acquire spinlocks if !allow_spin.

Second, kfree_nolock() now follows init_on_free which has been ignored.

Besides that, no functional change intended.

Closes: https://lore.kernel.org/asiSUpAYYU8Od4HM@gmail.com
Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and kfree_nolock().")
Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>
---
 mm/slub.c | 104 +++++++++++++++++++++++++++++++++-----------------------------
 1 file changed, 56 insertions(+), 48 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 45e077c7526c..36e7bb93418a 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2686,41 +2686,54 @@ struct rcu_delayed_free {
  * - memcg_slab_post_alloc_hook()
  * - alloc_tagging_slab_alloc_hook()
  *
+ * slab_free_hook() assumes that memcg_slab_free_hook() and
+ * alloc_tagging_slab_free_hook() are already invoked.
+ *
  * Free hooks that must handle missing corresponding alloc hooks:
  * - kmemleak_free_recursive()
  * - kfence_free()
  *
- * Free hooks that have no alloc hook counterpart, and thus safe to call:
+ * Free hooks that have no alloc hook counterpart:
  * - debug_check_no_locks_freed()
  * - debug_check_no_obj_freed()
  * - __kcsan_check_access()
  */
 static __always_inline
 bool slab_free_hook(struct kmem_cache *s, void *x, bool init,
-		    bool after_rcu_delay)
+		    bool after_rcu_delay, bool allow_spin)
 {
 	/* Are the object contents still accessible? */
 	bool still_accessible = (s->flags & SLAB_TYPESAFE_BY_RCU) && !after_rcu_delay;
 
-	kmemleak_free_recursive(x, s->flags);
 	kmsan_slab_free(s, x);
 
-	debug_check_no_locks_freed(x, s->object_size);
+	/* Hooks that acquire locks or kmalloc_nolock() skips alloc hook counterpart */
+	if (likely(allow_spin)) {
+		kmemleak_free_recursive(x, s->flags);
+		debug_check_no_locks_freed(x, s->object_size);
 
-	if (!(s->flags & SLAB_DEBUG_OBJECTS))
-		debug_check_no_obj_freed(x, s->object_size);
+		if (!(s->flags & SLAB_DEBUG_OBJECTS))
+			debug_check_no_obj_freed(x, s->object_size);
 
-	/* Use KCSAN to help debug racy use-after-free. */
-	if (!still_accessible)
-		__kcsan_check_access(x, s->object_size,
-				     KCSAN_ACCESS_WRITE | KCSAN_ACCESS_ASSERT);
+		/* Use KCSAN to help debug racy use-after-free. */
+		if (!still_accessible)
+			__kcsan_check_access(x, s->object_size,
+					     KCSAN_ACCESS_WRITE | KCSAN_ACCESS_ASSERT);
 
-	if (kfence_free(x))
-		return false;
+		if (kfence_free(x))
+			return false;
+	}
 
 	/*
 	 * Give KASAN a chance to notice an invalid free operation before we
 	 * modify the object.
+	 *
+	 * If KASAN finds a bug it will do kasan_report_invalid_free() which
+	 * will call raw_spin_lock_irqsave() which is technically unsafe from
+	 * NMI, but take chance and report kernel bug. The sequence of
+	 * kasan_report_invalid_free() -> raw_spin_lock_irqsave() -> NMI
+	 * -> kfree_nolock() -> kasan_report_invalid_free() on the same CPU
+	 *  is double buggy and deserves to deadlock.
 	 */
 	if (kasan_slab_pre_free(s, x))
 		return false;
@@ -2729,6 +2742,7 @@ bool slab_free_hook(struct kmem_cache *s, void *x, bool init,
 	if (still_accessible) {
 		struct rcu_delayed_free *delayed_free;
 
+		VM_WARN_ON_ONCE(!allow_spin);
 		delayed_free = kmalloc_obj(*delayed_free, GFP_NOWAIT);
 		if (delayed_free) {
 			/*
@@ -2776,8 +2790,11 @@ bool slab_free_hook(struct kmem_cache *s, void *x, bool init,
 		set_orig_size(s, x, orig_size);
 
 	}
-	/* KASAN might put x into memory quarantine, delaying its reuse. */
-	return !kasan_slab_free(s, x, init, still_accessible, false);
+	/*
+	 * KASAN might put x into memory quarantine, delaying its reuse.
+	 * Skip quarantine when spinning is not allowed as it uses a spinlock.
+	 */
+	return !kasan_slab_free(s, x, init, still_accessible, !allow_spin);
 }
 
 static __fastpath_inline
@@ -2789,9 +2806,10 @@ bool slab_free_freelist_hook(struct kmem_cache *s, void **head, void **tail,
 	void *next = *head;
 	void *old_tail = *tail;
 	bool init;
+	bool allow_spin = true;
 
 	if (is_kfence_address(next)) {
-		slab_free_hook(s, next, false, false);
+		slab_free_hook(s, next, false, false, allow_spin);
 		return false;
 	}
 
@@ -2806,7 +2824,7 @@ bool slab_free_freelist_hook(struct kmem_cache *s, void **head, void **tail,
 		next = get_freepointer(s, object);
 
 		/* If object's reuse doesn't have to be delayed */
-		if (likely(slab_free_hook(s, object, init, false))) {
+		if (likely(slab_free_hook(s, object, init, false, allow_spin))) {
 			/* Move object to the new freelist */
 			set_freepointer(s, object, *head);
 			*head = object;
@@ -3031,6 +3049,7 @@ static bool __rcu_free_sheaf_prepare(struct kmem_cache *s,
 	void **p = &sheaf->objects[0];
 	unsigned int i = 0;
 	bool pfmemalloc = false;
+	bool allow_spin = true;
 
 	while (i < sheaf->size) {
 		struct slab *slab = virt_to_slab(p[i]);
@@ -3038,7 +3057,7 @@ static bool __rcu_free_sheaf_prepare(struct kmem_cache *s,
 		memcg_slab_free_hook(s, slab, p + i, 1);
 		alloc_tagging_slab_free_hook(s, slab, p + i, 1);
 
-		if (unlikely(!slab_free_hook(s, p[i], init, true))) {
+		if (unlikely(!slab_free_hook(s, p[i], init, true, allow_spin))) {
 			p[i] = p[--sheaf->size];
 			continue;
 		}
@@ -6479,6 +6498,7 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
 	bool init = slab_want_init_on_free(s);
 	void **remote_objects = p;
 	unsigned int remote_nr = 0;
+	bool allow_spin = true;
 
 	/*
 	 * Process the free hooks and separate out remote objects by
@@ -6494,7 +6514,7 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
 		memcg_slab_free_hook(s, slab, p + i, 1);
 		alloc_tagging_slab_free_hook(s, slab, p + i, 1);
 
-		if (unlikely(!slab_free_hook(s, p[i], init, false))) {
+		if (unlikely(!slab_free_hook(s, p[i], init, false, allow_spin))) {
 			p[i] = p[--size];
 			continue;
 		}
@@ -6624,13 +6644,17 @@ static __fastpath_inline
 void slab_free(struct kmem_cache *s, struct slab *slab, void *object,
 	       unsigned long addr)
 {
+	bool allow_spin = true;
+	bool init = slab_want_init_on_free(s);
+
 	memcg_slab_free_hook(s, slab, &object, 1);
 	alloc_tagging_slab_free_hook(s, slab, &object, 1);
 
-	if (unlikely(!slab_free_hook(s, object, slab_want_init_on_free(s), false)))
+	if (unlikely(!slab_free_hook(s, object, init, false, allow_spin)))
 		return;
 
-	if (likely(can_free_to_pcs(slab)) && likely(free_to_pcs(s, object, true)))
+	if (likely(can_free_to_pcs(slab)) &&
+			likely(free_to_pcs(s, object, allow_spin)))
 		return;
 
 	__slab_free(s, slab, object, object, 1, addr);
@@ -6643,10 +6667,12 @@ static noinline
 void memcg_alloc_abort_single(struct kmem_cache *s, void *object)
 {
 	struct slab *slab = virt_to_slab(object);
+	bool init = slab_want_init_on_free(s);
+	bool allow_spin = true;
 
 	alloc_tagging_slab_free_hook(s, slab, &object, 1);
 
-	if (likely(slab_free_hook(s, object, slab_want_init_on_free(s), false)))
+	if (likely(slab_free_hook(s, object, init, false, allow_spin)))
 		__slab_free(s, slab, object, object, 1, _RET_IP_);
 }
 #endif
@@ -6675,6 +6701,8 @@ static void slab_free_after_rcu_debug(struct rcu_head *rcu_head)
 	void *object = delayed_free->object;
 	struct slab *slab = virt_to_slab(object);
 	struct kmem_cache *s;
+	bool allow_spin = true;
+	bool init;
 
 	kfree(delayed_free);
 
@@ -6688,8 +6716,9 @@ static void slab_free_after_rcu_debug(struct rcu_head *rcu_head)
 	if (WARN_ON(!(s->flags & SLAB_TYPESAFE_BY_RCU)))
 		return;
 
+	init = slab_want_init_on_free(s);
 	/* resume freeing */
-	if (slab_free_hook(s, object, slab_want_init_on_free(s), true)) {
+	if (slab_free_hook(s, object, init, true, allow_spin)) {
 		__slab_free(s, slab, object, object, 1, _THIS_IP_);
 		stat(s, FREE_SLOWPATH);
 	}
@@ -6938,6 +6967,8 @@ void kfree_nolock(const void *object)
 	struct slab *slab;
 	struct kmem_cache *s;
 	void *x = (void *)object;
+	bool allow_spin = false;
+	bool init;
 
 	if (unlikely(ZERO_OR_NULL_PTR(object)))
 		return;
@@ -6952,33 +6983,10 @@ void kfree_nolock(const void *object)
 
 	memcg_slab_free_hook(s, slab, &x, 1);
 	alloc_tagging_slab_free_hook(s, slab, &x, 1);
-	/*
-	 * Unlike slab_free() do NOT call the following:
-	 * kmemleak_free_recursive(x, s->flags);
-	 * debug_check_no_locks_freed(x, s->object_size);
-	 * debug_check_no_obj_freed(x, s->object_size);
-	 * __kcsan_check_access(x, s->object_size, ..);
-	 * kfence_free(x);
-	 * since they take spinlocks or not safe from any context.
-	 */
-	kmsan_slab_free(s, x);
-	/*
-	 * If KASAN finds a kernel bug it will do kasan_report_invalid_free()
-	 * which will call raw_spin_lock_irqsave() which is technically
-	 * unsafe from NMI, but take chance and report kernel bug.
-	 * The sequence of
-	 * kasan_report_invalid_free() -> raw_spin_lock_irqsave() -> NMI
-	 *  -> kfree_nolock() -> kasan_report_invalid_free() on the same CPU
-	 * is double buggy and deserves to deadlock.
-	 */
-	if (kasan_slab_pre_free(s, x))
+
+	init = slab_want_init_on_free(s);
+	if (unlikely(!slab_free_hook(s, x, init, false, allow_spin)))
 		return;
-	/*
-	 * memcg, kasan_slab_pre_free are done for 'x'.
-	 * The only thing left is kasan_poison without quarantine,
-	 * since kasan quarantine takes locks and not supported from NMI.
-	 */
-	kasan_slab_free(s, x, false, false, /* skip quarantine */true);
 
 	if (likely(can_free_to_pcs(slab)) && likely(free_to_pcs(s, x, false)))
 		return;

-- 
2.54.0

