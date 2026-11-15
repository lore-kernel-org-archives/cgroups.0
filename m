Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794755423;
	b=49DJ5FkIsBCt5j5xFibL3WI35irLAOcTUuF3ri72P96W31/Dzbx1qa52osEPm0xGa5Oo
	 v7sEUK350cRBG/V31wRoxyhlTn/b9RtNDRrBD92H3vuWfaRsxPlzpD2uuTwJeHbUeMc0x
	 9lzMi8z2H+4HjfJY/A1H/gyUFrvu5TkFKSmcylcc9TyFUwFJ2MpUE1WPEx3oBNwMX2FLm
	 XaZLmFKDGDejwAstr2e4baf253GhkcfQhTJUuBp59wyN2/5klB4llsyXLj52IOnsyuP+5
	 xYTz54J/hMNpwbCeGA0SAYQHvto8ykVZy3ZK28zqGL4kyzJQcdtSLr+kKcJLkfupgww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794755423;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer;
	bh=WO5dYOrdka6DIWC9KKEpVyr89KsTYkuKSnLMWU6DnVo=;
	b=N6vU5qJ7RHqdwrJ0fd3VdEPEgHTUBRXsI2w0HaPMcC2jdOWi1+326zXylTanyFUluKTj
	 JfJWYtHY6lF4EcdkWtvdXBGEetemJlQOwspJlCVZ8rsCprGuPJMpzJkGGAPABPOJjaEMN
	 2pYooa5mzOnvaOnipoVPB9haS6IOIQLl9P+I28GysgxGhE2dosXJ5xbHyjSj6M0/zFa7Q
	 S+r2ifsVLb7rySyJNdydaK/8Enh3BuggBHW8kHkGZW4ipJ2aUq1cr/ILh0t7zgyhn5ZPG
	 d94uRYenAVCQYeWzuRMMaPfevp+KS2utwoBugm+K5pgr8zD3EU47lt+1dNWNVpm20sw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="Pz3Mq/WN";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D094606A31F;
	Sun, 15 Nov 2026 15:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Pz3Mq/WN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9C461F000C4;
	Sun, 15 Nov 2026 15:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794755423;
	bh=WO5dYOrdka6DIWC9KKEpVyr89KsTYkuKSnLMWU6DnVo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Pz3Mq/WN7xLi7ysp9JmjujQrSrHmU9huH6HMZ5HpsrPJ46v6WQMa2uOL6QdV5ECHC
	 CyHCqZXeRonR7n0k9jENAdyzQR18b57mFG8BjnVdVy27oiE+Lku0Zkldd1JPlY+JBS
	 GsdAL9XB8VSsq+0s0pSQ9f2K+ZekR40FkTktiJ2FF4fy3hnddyyKhWzhW/r1RccfZe
	 YG0WeT8EN3mhazdTKNVUV8hvD/KWfeLOYRNUmzxly8Tqc3VbdABmXQ3MJIW4009Rl4
	 6YeYROCh9sLyOTo9JFJGf2LNZIYjnFsElRm3s6kMDYfzz9Qmq0abkdAL/gkzFsI6Dg
	 YeE2duYy552xQ==
From: "Harry Yoo (Meta)" <harry@kernel.org>
Date: Sun, 15 Nov 2026 15:09:37 +0000
Subject: [PATCH for-next v3 3/7] mm/slab: handle SLAB_FREE_NOLOCK in
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
Message-Id: <20261115-kmalloc-nolock-fixes-v3-3-9034dd4ecaab@kernel.org>
References: <20261115-kmalloc-nolock-fixes-v3-0-9034dd4ecaab@kernel.org>
In-Reply-To: <20261115-kmalloc-nolock-fixes-v3-0-9034dd4ecaab@kernel.org>
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

Instead of open coding slab_free_hook(), let it handle
SLAB_FREE_NOLOCK. This is required to correctly handle allocation
failures due to memcg charging.

kfree_nolock() now respects init_on_free which has been ignored.
Besides that, no functional change intended.

Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and kfree_nolock().")
Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>
---
 mm/slub.c | 76 +++++++++++++++++++++++++++++++--------------------------------
 1 file changed, 37 insertions(+), 39 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 761dc2affea2..7c0adc104988 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2684,11 +2684,14 @@ struct rcu_delayed_free {
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
@@ -2698,28 +2701,39 @@ bool slab_free_hook(struct kmem_cache *s, void *x, unsigned int free_flags)
 {
 	bool init = free_flags & SLAB_FREE_INIT;
 	bool after_rcu_delay = free_flags & SLAB_FREE_AFTER_RCU_DELAY;
+	bool allow_spin = free_flags_allow_spinning(free_flags);
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
@@ -2728,6 +2742,7 @@ bool slab_free_hook(struct kmem_cache *s, void *x, unsigned int free_flags)
 	if (still_accessible) {
 		struct rcu_delayed_free *delayed_free;
 
+		VM_WARN_ON_ONCE(!allow_spin);
 		delayed_free = kmalloc_obj(*delayed_free, GFP_NOWAIT);
 		if (delayed_free) {
 			/*
@@ -2775,8 +2790,11 @@ bool slab_free_hook(struct kmem_cache *s, void *x, unsigned int free_flags)
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
@@ -6935,6 +6953,7 @@ void kfree_nolock(const void *object)
 	struct slab *slab;
 	struct kmem_cache *s;
 	void *x = (void *)object;
+	unsigned int free_flags = SLAB_FREE_NOLOCK;
 
 	if (unlikely(ZERO_OR_NULL_PTR(object)))
 		return;
@@ -6949,33 +6968,12 @@ void kfree_nolock(const void *object)
 
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
+	if (slab_want_init_on_free(s))
+		free_flags |= SLAB_FREE_INIT;
+
+	if (unlikely(!slab_free_hook(s, x, free_flags)))
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

