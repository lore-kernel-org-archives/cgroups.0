Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DAC438553F;
	Tue,  9 Jun 2026 09:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780996699; cv=none; b=RuCYfRs3S0gTdBGbX15boommdlA7HWJ7Rx3CZyJhTc+HbebodwxyzaMOYJBBBoiwP41Z9PPd8jLFCkyDfRD4GEx07dkBNUQ7nQOYdPkOgQDGnuC9gkid3xCVOmL+K8VfdLCHrW8Ln0xn5N39vo+RNuhtHNNDQGgcdo4m9G8C4YM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780996699; c=relaxed/simple;
	bh=IVEHRfJs06RFdJt5fadVmDHxis0F0C2uMWjdWg15O+4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=kgYQ30wujMagwgxSRrFz2VjQJf1vYEV0zEpB9Kl35Zl9KrLIXXHjxvMt1rDerVQmF19bP/mT8JVNH0Op+kdIcUcCEAT4uFV9gqbCX4m3f2GMPWKZvfDYFFrz8yFbpFGwF0MArDzJRemor0mGeRGa+S/hA/hWVC+OTZGDI8JIHQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i0pCMfID; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i0pCMfID"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4EC41F00898;
	Tue,  9 Jun 2026 09:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780996698;
	bh=vfE2JW2NevESnpLgbLVUdD60WBjBFWnXxCfZNTt4csA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=i0pCMfID9bPgEqXp+BuomAg5WrIvzYhOfvJqY8Ei3gYRGK/Z4sJZTnqnHcTvX2Mwi
	 0i3Jg6HQcgA/GmARey6i1OKtJw4jYxntAugYddhk7I6idIrD+LADXCIiZuEINYHl/s
	 tsm0ts8vxezmbqWW/6yZRrUbmc8+goIoZjbXFgoP1OkjoFi4tp9w4jKbcch8JUt91l
	 2WikOVyJiq2Tz49q+qC1aTfw2Yn4L6vHvyGbPtMwZ8Ea15Gtz8hST67xZymsAbRMR/
	 GxBWiQMeA/EO6CJfjzYSacyiFrXDdxl9iwYPYmZ5eK9Htm5modRwIhzeZk7vccurBb
	 xm8uC+Za6kDWQ==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Tue, 09 Jun 2026 11:17:51 +0200
Subject: [PATCH RFC 06/15] mm/slab: replace struct partial_context with
 slab_alloc_context
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260609-slab_alloc_flags-v1-6-2bf4a4b9b526@kernel.org>
References: <20260609-slab_alloc_flags-v1-0-2bf4a4b9b526@kernel.org>
In-Reply-To: <20260609-slab_alloc_flags-v1-0-2bf4a4b9b526@kernel.org>
To: Harry Yoo <harry@kernel.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Suren Baghdasaryan <surenb@google.com>, Alexei Starovoitov <ast@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
 Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.15.2

Refactor get_from_partial_node(), get_from_any_partial(),
get_from_partial() and ___slab_alloc().

Remove struct partial_context, which used to be more substantial but
shrank as part of the sheaves conversion. Instead pass gfp_flags and
pointer to the new slab_alloc_context, which together is a superset of
partial_context.

This means alloc_flags are now available and we can use them to
determine if spinning is allowed, further reducing false positive "not
allowed" in the slow path due to gfp flags lacking __GFP_RECLAIM.

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/slub.c | 52 ++++++++++++++++++++++++----------------------------
 1 file changed, 24 insertions(+), 28 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index b2a452dd70fa..0bde4f6d9126 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -220,12 +220,6 @@ struct slab_alloc_context {
 	unsigned int alloc_flags;
 };
 
-/* Structure holding parameters for get_from_partial() call chain */
-struct partial_context {
-	gfp_t flags;
-	unsigned int orig_size;
-};
-
 /* Structure holding parameters for get_partial_node_bulk() */
 struct partial_bulk_context {
 	gfp_t flags;
@@ -3826,7 +3820,8 @@ static bool get_partial_node_bulk(struct kmem_cache *s,
  */
 static void *get_from_partial_node(struct kmem_cache *s,
 				   struct kmem_cache_node *n,
-				   struct partial_context *pc)
+				   gfp_t gfp_flags,
+				   struct slab_alloc_context *ac)
 {
 	struct slab *slab, *slab2;
 	unsigned long flags;
@@ -3841,7 +3836,7 @@ static void *get_from_partial_node(struct kmem_cache *s,
 	if (!n || !n->nr_partial)
 		return NULL;
 
-	if (gfpflags_allow_spinning(pc->flags))
+	if (alloc_flags_allow_spinning(ac->alloc_flags))
 		spin_lock_irqsave(&n->list_lock, flags);
 	else if (!spin_trylock_irqsave(&n->list_lock, flags))
 		return NULL;
@@ -3849,12 +3844,12 @@ static void *get_from_partial_node(struct kmem_cache *s,
 
 		struct freelist_counters old, new;
 
-		if (!pfmemalloc_match(slab, pc->flags))
+		if (!pfmemalloc_match(slab, gfp_flags))
 			continue;
 
 		if (IS_ENABLED(CONFIG_SLUB_TINY) || kmem_cache_debug(s)) {
 			object = alloc_single_from_partial(s, n, slab,
-							pc->orig_size);
+							ac->orig_size);
 			if (object)
 				break;
 			continue;
@@ -3888,15 +3883,16 @@ static void *get_from_partial_node(struct kmem_cache *s,
 /*
  * Get an object from somewhere. Search in increasing NUMA distances.
  */
-static void *get_from_any_partial(struct kmem_cache *s, struct partial_context *pc)
+static void *get_from_any_partial(struct kmem_cache *s, gfp_t gfp_flags,
+				  struct slab_alloc_context *ac)
 {
 #ifdef CONFIG_NUMA
 	struct zonelist *zonelist;
 	struct zoneref *z;
 	struct zone *zone;
-	enum zone_type highest_zoneidx = gfp_zone(pc->flags);
+	enum zone_type highest_zoneidx = gfp_zone(gfp_flags);
 	unsigned int cpuset_mems_cookie;
-	bool allow_spin = gfpflags_allow_spinning(pc->flags);
+	bool allow_spin = alloc_flags_allow_spinning(ac->alloc_flags);
 
 	/*
 	 * The defrag ratio allows a configuration of the tradeoffs between
@@ -3930,16 +3926,17 @@ static void *get_from_any_partial(struct kmem_cache *s, struct partial_context *
 		if (allow_spin)
 			cpuset_mems_cookie = read_mems_allowed_begin();
 
-		zonelist = node_zonelist(mempolicy_slab_node(), pc->flags);
+		zonelist = node_zonelist(mempolicy_slab_node(), gfp_flags);
 		for_each_zone_zonelist(zone, z, zonelist, highest_zoneidx) {
 			struct kmem_cache_node *n;
 
 			n = get_node(s, zone_to_nid(zone));
 
-			if (n && cpuset_zone_allowed(zone, pc->flags) &&
+			if (n && cpuset_zone_allowed(zone, gfp_flags) &&
 					n->nr_partial > s->min_partial) {
 
-				void *object = get_from_partial_node(s, n, pc);
+				void *object = get_from_partial_node(s, n,
+								gfp_flags, ac);
 
 				if (object) {
 					/*
@@ -3961,8 +3958,8 @@ static void *get_from_any_partial(struct kmem_cache *s, struct partial_context *
 /*
  * Get an object from a partial slab
  */
-static void *get_from_partial(struct kmem_cache *s, int node,
-			      struct partial_context *pc)
+static void *get_from_partial(struct kmem_cache *s, int node, gfp_t flags,
+			      struct slab_alloc_context *ac)
 {
 	int searchnode = node;
 	void *object;
@@ -3970,11 +3967,11 @@ static void *get_from_partial(struct kmem_cache *s, int node,
 	if (node == NUMA_NO_NODE)
 		searchnode = numa_mem_id();
 
-	object = get_from_partial_node(s, get_node(s, searchnode), pc);
-	if (object || (node != NUMA_NO_NODE && (pc->flags & __GFP_THISNODE)))
+	object = get_from_partial_node(s, get_node(s, searchnode), flags, ac);
+	if (object || (node != NUMA_NO_NODE && (flags & __GFP_THISNODE)))
 		return object;
 
-	return get_from_any_partial(s, pc);
+	return get_from_any_partial(s, flags, ac);
 }
 
 static bool has_pcs_used(int cpu, struct kmem_cache *s)
@@ -4454,16 +4451,16 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 			   struct slab_alloc_context *ac)
 {
 	bool allow_spin = alloc_flags_allow_spinning(ac->alloc_flags);
+	gfp_t trynode_flags;
 	void *object;
 	struct slab *slab;
-	struct partial_context pc;
 	bool try_thisnode = true;
 
 	stat(s, ALLOC_SLOWPATH);
 
 new_objects:
 
-	pc.flags = gfpflags;
+	trynode_flags = gfpflags;
 	/*
 	 * When a preferred node is indicated but no __GFP_THISNODE
 	 *
@@ -4479,17 +4476,16 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 		     && try_thisnode)) {
 		if (unlikely(!allow_spin))
 			/* Do not upgrade gfp to NOWAIT from more restrictive mode */
-			pc.flags = gfpflags | __GFP_THISNODE;
+			trynode_flags = gfpflags | __GFP_THISNODE;
 		else
-			pc.flags = GFP_NOWAIT | __GFP_THISNODE;
+			trynode_flags = GFP_NOWAIT | __GFP_THISNODE;
 	}
 
-	pc.orig_size = ac->orig_size;
-	object = get_from_partial(s, node, &pc);
+	object = get_from_partial(s, node, trynode_flags, ac);
 	if (object)
 		goto success;
 
-	slab = new_slab(s, pc.flags, node);
+	slab = new_slab(s, trynode_flags, node);
 
 	if (unlikely(!slab)) {
 		if (node != NUMA_NO_NODE && !(gfpflags & __GFP_THISNODE)

-- 
2.54.0

