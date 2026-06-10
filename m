Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 208EA42B74B;
	Wed, 10 Jun 2026 15:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781106072; cv=none; b=Nk5JpibMhZKEkIWRdJYGj56sEJsRszVrHrvC+Po0HN6QIXz9wJy7cUorYx50UXg/7zRNeWGPR99tmOHDkZFg8SrW0c7SPjP9OWtabdMXpIbSYoX9CaR47RzznZ4TIwVykgT8Jqe9+8l31rZLQJnETj38RpKPWENi+CXGymppc28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781106072; c=relaxed/simple;
	bh=wgWHXObYF6mJTeBz5pIZrb/5ufYHgi8gu347cbOyPUA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=cSxIOq/Ll9LBzIY88Rmkw4a9INW7d5/TS+7CGNwXy2ERrxtENqiozcnxmrL2sUGBvuLZjd6MFfEc3WjO2yqLWB1sUMMaLkUfIdpYmZoKQW2l7ig67F9G5XwW65eGMVHnCysyFm8QMQzPzqEyysVI/TvC66XfEtk+n74kY3eMcdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cw/B8aoH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cw/B8aoH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B53D1F00898;
	Wed, 10 Jun 2026 15:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781106070;
	bh=Mexx5lD21ZUkTPtQWUL+ov3B4ZXu0cDITz5foBNYJFU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Cw/B8aoHhqstcutNmiUGTHn+ICFdYtdKlcju3TXdMB7hIcJcS2GsTTpsUB0+Z+Bbq
	 2xX82XGTZNZqF1sjDhTDvd7Hf08jgo9fr6ZSTnDaYwExWExnjwMP8siFAmPh8f5X4j
	 JnPgag3rXpzNeI21Yz2pJSB3u7FnSV5u+DNjRxL0+julH1Rkh+pJZdHbwvbVqocYxd
	 KtK9WQmHSaz+jGclY8IneafQwttMX3zcjPlP8HRbCFQpGKXDeUNVOnqVqike7o4dAp
	 f0FJx5oAvUTUrwQRC9xqgXaDRI9VvQ4yNyBdAzOi3Co/SslxdWKv3zhzVh/IkNMS+t
	 b6VSc2o64zSJA==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Wed, 10 Jun 2026 17:40:09 +0200
Subject: [PATCH v2 07/16] mm/slab: replace struct partial_context with
 slab_alloc_context
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260610-slab_alloc_flags-v2-7-7190909db118@kernel.org>
References: <20260610-slab_alloc_flags-v2-0-7190909db118@kernel.org>
In-Reply-To: <20260610-slab_alloc_flags-v2-0-7190909db118@kernel.org>
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
index ef745b37d063..98b79e5e7679 100644
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

