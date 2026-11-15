Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794755434;
	b=rvhqd8Y36Wh8mbzioXhzFmm9g+lll0M10SsIRmqg/Be6WpKOu1OMtRy+48zNxPYoRmlf
	 uTmmwzlstIPa1dY+PqUpROLr7DQArbBbWlA0UGjQivLe9CZ1yFbDPWBa1Hsc/YBu57igX
	 /DpXk+WnrM0EwSR/6gm7TRkBSa2Y0FmeQSwzFuq8AbOH7m4JvpY+tI9F7zuS8irTsXxqg
	 I9YLN7VBVvHYWUH/7wSoTKtrxoYaLwvrWnda4TPH0+qlLaErAnQ4fRJR05TCXM5beJ6+w
	 q+lXLtOHHU8iELL7ymme7UxTDnOccX7jDpn2VgnDM+ms6HFoHUBJnBhnzJ3WV1XAivw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794755434;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer;
	bh=GhLQyFlJTVqmSyEWQTJRy69VcFNeB6bgSqFN8dNPAm0=;
	b=g9yMgdXiQDyQQFFUmiXPpLrfF6jRZT13ga4UlEEbDzH3csQmblUWujWZou3NSwOSa5Bn
	 pJw2hb/EqHgrwZClpP4XjehZ++7tVc+pZfhqGaDfwSz7fLsnOwep4O87oREdPa6uKrTOF
	 hyKgjtelMVGpBpvzGuACRIPN7WxV/+lrq3u6FJytDIFIQ1gm8dJCOWBX4he2ZQkPYT9sP
	 T5kJZAT9QMicn5m82qSeq87TeOTRbBQBN7HarjIHXc2ynr9650T6+GC7U5ixUCiFgYhAe
	 /a2pIdA0dDtIA1bk1QbrAWf7KLRkOGtijiDQVQXybfXYOvVRogy5gQNk/dDOk4xVGrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hQG9sXiE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7449E606A31A;
	Sun, 15 Nov 2026 15:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hQG9sXiE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16ACB1F000C4;
	Sun, 15 Nov 2026 15:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794755434;
	bh=GhLQyFlJTVqmSyEWQTJRy69VcFNeB6bgSqFN8dNPAm0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=hQG9sXiE+U22az+UEwlgIGfv2rH2zG23/scIb7H+C02Q/5k9hM0vqdMl+YLbEKpqa
	 2h3Em/gXnQ0dMWXjF/cIW9Z4nHOclMc+gVRPpO7yROE7sITl06NgpNM1S0I/DFZ9x3
	 pPkyQPu0OkQsTdv5NJVN1RLgQvJOXsd0YTaooOVyFRZYF0Cs+qgEU/bJCd/TKVZ6sr
	 y3e6wpmlrDYjpclYJqqs1GzcKuGz2AvBp4WcYNBlnlsjGUrEmV78BsPlj3MJZtLoC+
	 nkeHqvZ34HQHANfcrB5zCWk2gqkb+Tvb7MoGY7fFyFtQ/VqwJR7qTe53pSNt0/A6Cp
	 BQ+WOXjMKO3TA==
From: "Harry Yoo (Meta)" <harry@kernel.org>
Date: Sun, 15 Nov 2026 15:09:40 +0000
Subject: [PATCH for-next v3 6/7] mm/slab: refactor free_to_pcs()
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
Message-Id: <20261115-kmalloc-nolock-fixes-v3-6-9034dd4ecaab@kernel.org>
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

Every caller of free_to_pcs() has to call can_free_to_pcs() before it.
Refactor this by adding a slab parameter and calling can_free_to_pcs()
from free_to_pcs(). To do this, move can_free_to_pcs() above
free_to_pcs().

Note that can_free_to_pcs() cannot be folded into free_to_pcs() as
free_to_pcs_bulk() still needs it.

While at it, let free_to_pcs() take free_flags instead of allow_spin.

No functional change intended.

Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>
---
 mm/slub.c | 119 ++++++++++++++++++++++++++++++++------------------------------
 1 file changed, 61 insertions(+), 58 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index aec9fb6e2235..fd3de3bee1de 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -6148,15 +6148,71 @@ __pcs_replace_full_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 	return pcs;
 }
 
+static __always_inline bool can_free_to_pcs(struct slab *slab)
+{
+	int slab_node;
+	int numa_node;
+
+	if (!IS_ENABLED(CONFIG_NUMA))
+		goto check_pfmemalloc;
+
+	slab_node = slab_nid(slab);
+
+#ifdef CONFIG_HAVE_MEMORYLESS_NODES
+	/*
+	 * numa_mem_id() points to the closest node with memory so only allow
+	 * objects from that node to the percpu sheaves
+	 */
+	numa_node = numa_mem_id();
+
+	if (likely(slab_node == numa_node))
+		goto check_pfmemalloc;
+#else
+
+	/*
+	 * numa_mem_id() is only a wrapper to numa_node_id() which is where this
+	 * cpu belongs to, but it might be a memoryless node anyway. We don't
+	 * know what the closest node is.
+	 */
+	numa_node = numa_node_id();
+
+	/* freed object is from this cpu's node, proceed */
+	if (likely(slab_node == numa_node))
+		goto check_pfmemalloc;
+
+	/*
+	 * Freed object isn't from this cpu's node, but that node is memoryless
+	 * or only has ZONE_MOVABLE memory, which slab cannot allocate from.
+	 * Proceed as it's better to cache remote objects than falling back to
+	 * the slowpath for everything. The allocation side can never obtain
+	 * a local object anyway, if none exist. We don't have numa_mem_id() to
+	 * point to the closest node as we would on a proper memoryless node
+	 * setup.
+	 */
+	if (unlikely(!node_state(numa_node, N_NORMAL_MEMORY)))
+		goto check_pfmemalloc;
+#endif
+
+	return false;
+
+check_pfmemalloc:
+	return likely(!slab_test_pfmemalloc(slab));
+}
+
 /*
  * Free an object to the percpu sheaves.
  * The object is expected to have passed slab_free_hook() already.
  */
 static __fastpath_inline
-bool free_to_pcs(struct kmem_cache *s, void *object, bool allow_spin)
+bool free_to_pcs(struct kmem_cache *s, struct slab *slab, void *object,
+		 unsigned int free_flags)
 {
+	bool allow_spin = free_flags_allow_spinning(free_flags);
 	struct slub_percpu_sheaves *pcs;
 
+	if (unlikely(!can_free_to_pcs(slab)))
+		return false;
+
 	if (!local_trylock(&s->cpu_sheaves->lock))
 		return false;
 
@@ -6355,57 +6411,6 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj, unsigned int free_flags)
 	return false;
 }
 
-static __always_inline bool can_free_to_pcs(struct slab *slab)
-{
-	int slab_node;
-	int numa_node;
-
-	if (!IS_ENABLED(CONFIG_NUMA))
-		goto check_pfmemalloc;
-
-	slab_node = slab_nid(slab);
-
-#ifdef CONFIG_HAVE_MEMORYLESS_NODES
-	/*
-	 * numa_mem_id() points to the closest node with memory so only allow
-	 * objects from that node to the percpu sheaves
-	 */
-	numa_node = numa_mem_id();
-
-	if (likely(slab_node == numa_node))
-		goto check_pfmemalloc;
-#else
-
-	/*
-	 * numa_mem_id() is only a wrapper to numa_node_id() which is where this
-	 * cpu belongs to, but it might be a memoryless node anyway. We don't
-	 * know what the closest node is.
-	 */
-	numa_node = numa_node_id();
-
-	/* freed object is from this cpu's node, proceed */
-	if (likely(slab_node == numa_node))
-		goto check_pfmemalloc;
-
-	/*
-	 * Freed object isn't from this cpu's node, but that node is memoryless
-	 * or only has ZONE_MOVABLE memory, which slab cannot allocate from.
-	 * Proceed as it's better to cache remote objects than falling back to
-	 * the slowpath for everything. The allocation side can never obtain
-	 * a local object anyway, if none exist. We don't have numa_mem_id() to
-	 * point to the closest node as we would on a proper memoryless node
-	 * setup.
-	 */
-	if (unlikely(!node_state(numa_node, N_NORMAL_MEMORY)))
-		goto check_pfmemalloc;
-#endif
-
-	return false;
-
-check_pfmemalloc:
-	return likely(!slab_test_pfmemalloc(slab));
-}
-
 /*
  * Try to free as many objects (already processed by free hooks) as possible to
  * a single per-cpu sheaf.
@@ -6642,7 +6647,7 @@ void slab_free(struct kmem_cache *s, struct slab *slab, void *object,
 	if (unlikely(!slab_free_hook(s, object, free_flags)))
 		return;
 
-	if (likely(can_free_to_pcs(slab)) && likely(free_to_pcs(s, object, true)))
+	if (likely(free_to_pcs(s, slab, object, free_flags)))
 		return;
 
 	__slab_free(s, slab, object, object, 1, addr);
@@ -6656,7 +6661,6 @@ void memcg_alloc_abort_single(struct kmem_cache *s, void *object,
 			      unsigned int alloc_flags)
 {
 	struct slab *slab = virt_to_slab(object);
-	bool allow_spin = alloc_flags_allow_spinning(alloc_flags);
 	unsigned int free_flags = to_free_flags(alloc_flags);
 
 	if (slab_want_init_on_free(s))
@@ -6667,11 +6671,10 @@ void memcg_alloc_abort_single(struct kmem_cache *s, void *object,
 	if (unlikely(!slab_free_hook(s, object, free_flags)))
 		return;
 
-	if (likely(can_free_to_pcs(slab)) &&
-	    likely(free_to_pcs(s, object, allow_spin)))
+	if (likely(free_to_pcs(s, slab, object, free_flags)))
 		return;
 
-	if (likely(allow_spin))
+	if (likely(free_flags_allow_spinning(free_flags)))
 		__slab_free(s, slab, object, object, 1, _RET_IP_);
 	else
 		defer_free(s, object);
@@ -6991,7 +6994,7 @@ void kfree_nolock(const void *object)
 	if (unlikely(!slab_free_hook(s, x, free_flags)))
 		return;
 
-	if (likely(can_free_to_pcs(slab)) && likely(free_to_pcs(s, x, false)))
+	if (likely(free_to_pcs(s, slab, x, free_flags)))
 		return;
 
 	/*

-- 
2.54.0

