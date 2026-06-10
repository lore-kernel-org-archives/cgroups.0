Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AF73427A14;
	Wed, 10 Jun 2026 15:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781106095; cv=none; b=K0wS11lmwk0Fg5Gnvw3xuxatXPD7CB/S91ZknTXT3+VAxcorofRej+O4l4Wude33vmJovx38+NsIhU93HVUN6QIwa3gldV2vLsf6iuyQHPnlThpSQAPpd9fy7jeNQ9kOnzM62ydUOANUjmfMVEglaTGAMVJGFTd8P7Qh4Ko6uSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781106095; c=relaxed/simple;
	bh=FpTc3BlOVZml+Y2SBp4Vmh49Dgy4xcBdlNWT6x7ub/E=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=sV9TGdfOkfiBU1wg/TVAHzqT4ntOAoPBCW5jAZnT+y2TdKf7ZpuR6h6bV5yucGzGfrr6FkOnL/eR50ZP4tptV3b2XQNwJ1zhZzV1p/WQQLEcQeD78TZjfHHkWmjqXXQEfdF5RYhMZPuMoFKvVqRM5lAZtma12IbGYCT4tHMWp/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AIjmLxGH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AIjmLxGH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D05BC1F00893;
	Wed, 10 Jun 2026 15:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781106093;
	bh=sg/Tskmnml7waI3JEH90Cm0YBKXCVybYdgxFLhHLMdE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=AIjmLxGH0i43NviLgImZ9HF9DC+gewVXMKj5az49sPzA7nurY+pjxASikLvwWteEb
	 7CboNyVZDQSrmEfFKVNHs3dTVYo0FTl2vVhPSfY8b6f3cj7Dmkf3Q1/HNOaUovJnvQ
	 l4kVLvgp9zoVzfIpPPtHO2EjRLdSQ3kVztiTby7C/n47XbFH9MoRdvYthyVM6NMO5E
	 dJnw6PgiD+96KkRMuKz+doEtMr5E9+8xbwuG3Jkf3Nb9J6MzlWNmLaHQmz15MLnNOn
	 ajI9j3RbtyenMzwjwSxoqe3CaHb5a786nXCAhFbcdhUZFCvLWhSgs9YBcLcZm1nu7P
	 CP1Q8bcA3wPwA==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Wed, 10 Jun 2026 17:40:12 +0200
Subject: [PATCH v2 10/16] mm/slab: replace slab_alloc_node() parameters
 with slab_alloc_context
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260610-slab_alloc_flags-v2-10-7190909db118@kernel.org>
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

The function takes all the parameters that exist as fields in
slab_alloc_context, except alloc_flags. Replace them with a single
pointer.

This moves slab_alloc_context initialization to a number of callers,
which is more verbose, but arguably also more clear than a long list of
parameters, and most do not use the 'lru' field.

This will also allow kmalloc_nolock() to call slab_alloc_node() and
reduce the special open-coding it currently has.

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/slub.c | 75 ++++++++++++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 53 insertions(+), 22 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index e634137b67fa..0b9974bfcb24 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4921,30 +4921,23 @@ unsigned int alloc_from_pcs_bulk(struct kmem_cache *s, gfp_t gfp, size_t size,
  *
  * Otherwise we can simply pick the next object from the lockless free list.
  */
-static __fastpath_inline void *slab_alloc_node(struct kmem_cache *s, struct list_lru *lru,
-		gfp_t gfpflags, int node, unsigned long addr, size_t orig_size)
+static __fastpath_inline void *slab_alloc_node(struct kmem_cache *s,
+		gfp_t gfpflags, int node, struct slab_alloc_context *ac)
 {
-	const unsigned int alloc_flags = SLAB_ALLOC_DEFAULT;
 	void *object;
-	struct slab_alloc_context ac = {
-		.caller_addr = addr,
-		.orig_size = orig_size,
-		.alloc_flags = alloc_flags,
-		.lru = lru,
-	};
 
 	s = slab_pre_alloc_hook(s, gfpflags);
 	if (unlikely(!s))
 		return NULL;
 
-	object = kfence_alloc(s, orig_size, gfpflags);
+	object = kfence_alloc(s, ac->orig_size, gfpflags);
 	if (unlikely(object))
 		goto out;
 
-	object = alloc_from_pcs(s, gfpflags, alloc_flags, node);
+	object = alloc_from_pcs(s, gfpflags, ac->alloc_flags, node);
 
 	if (!object)
-		object = __slab_alloc_node(s, gfpflags, node, &ac);
+		object = __slab_alloc_node(s, gfpflags, node, ac);
 
 	maybe_wipe_obj_freeptr(s, object);
 
@@ -4953,15 +4946,21 @@ static __fastpath_inline void *slab_alloc_node(struct kmem_cache *s, struct list
 	 * In case this fails due to memcg_slab_post_alloc_hook(),
 	 * object is set to NULL
 	 */
-	slab_post_alloc_hook(s, gfpflags, 1, &object, &ac);
+	slab_post_alloc_hook(s, gfpflags, 1, &object, ac);
 
 	return object;
 }
 
 void *kmem_cache_alloc_noprof(struct kmem_cache *s, gfp_t gfpflags)
 {
-	void *ret = slab_alloc_node(s, NULL, gfpflags, NUMA_NO_NODE, _RET_IP_,
-				    s->object_size);
+	void *ret;
+	struct slab_alloc_context ac = {
+		.caller_addr = _RET_IP_,
+		.orig_size = s->object_size,
+		.alloc_flags = SLAB_ALLOC_DEFAULT,
+	};
+
+	ret = slab_alloc_node(s, gfpflags, NUMA_NO_NODE, &ac);
 
 	trace_kmem_cache_alloc(_RET_IP_, ret, s, gfpflags, NUMA_NO_NODE);
 
@@ -4972,8 +4971,15 @@ EXPORT_SYMBOL(kmem_cache_alloc_noprof);
 void *kmem_cache_alloc_lru_noprof(struct kmem_cache *s, struct list_lru *lru,
 			   gfp_t gfpflags)
 {
-	void *ret = slab_alloc_node(s, lru, gfpflags, NUMA_NO_NODE, _RET_IP_,
-				    s->object_size);
+	void *ret;
+	struct slab_alloc_context ac = {
+		.caller_addr = _RET_IP_,
+		.orig_size = s->object_size,
+		.alloc_flags = SLAB_ALLOC_DEFAULT,
+		.lru = lru,
+	};
+
+	ret = slab_alloc_node(s, gfpflags, NUMA_NO_NODE, &ac);
 
 	trace_kmem_cache_alloc(_RET_IP_, ret, s, gfpflags, NUMA_NO_NODE);
 
@@ -5005,7 +5011,14 @@ EXPORT_SYMBOL(kmem_cache_charge);
  */
 void *kmem_cache_alloc_node_noprof(struct kmem_cache *s, gfp_t gfpflags, int node)
 {
-	void *ret = slab_alloc_node(s, NULL, gfpflags, node, _RET_IP_, s->object_size);
+	void *ret;
+	struct slab_alloc_context ac = {
+		.caller_addr = _RET_IP_,
+		.orig_size = s->object_size,
+		.alloc_flags = SLAB_ALLOC_DEFAULT,
+	};
+
+	ret = slab_alloc_node(s, gfpflags, node, &ac);
 
 	trace_kmem_cache_alloc(_RET_IP_, ret, s, gfpflags, node);
 
@@ -5335,6 +5348,11 @@ void *__do_kmalloc_node(size_t size, kmem_buckets *b, gfp_t flags, int node,
 {
 	struct kmem_cache *s;
 	void *ret;
+	struct slab_alloc_context ac = {
+		.caller_addr = caller,
+		.orig_size = size,
+		.alloc_flags = SLAB_ALLOC_DEFAULT,
+	};
 
 	if (unlikely(size > KMALLOC_MAX_CACHE_SIZE)) {
 		ret = __kmalloc_large_node_noprof(size, flags, node);
@@ -5348,7 +5366,7 @@ void *__do_kmalloc_node(size_t size, kmem_buckets *b, gfp_t flags, int node,
 
 	s = kmalloc_slab(size, b, flags, token);
 
-	ret = slab_alloc_node(s, NULL, flags, node, caller, size);
+	ret = slab_alloc_node(s, flags, node, &ac);
 	ret = kasan_kmalloc(s, ret, size, flags);
 	trace_kmalloc(caller, ret, size, s->size, flags, node);
 	return ret;
@@ -5467,8 +5485,14 @@ EXPORT_SYMBOL(__kmalloc_node_track_caller_noprof);
 
 void *__kmalloc_cache_noprof(struct kmem_cache *s, gfp_t gfpflags, size_t size)
 {
-	void *ret = slab_alloc_node(s, NULL, gfpflags, NUMA_NO_NODE,
-					    _RET_IP_, size);
+	void *ret;
+	struct slab_alloc_context ac = {
+		.caller_addr = _RET_IP_,
+		.orig_size = size,
+		.alloc_flags = SLAB_ALLOC_DEFAULT,
+	};
+
+	ret = slab_alloc_node(s, gfpflags, NUMA_NO_NODE, &ac);
 
 	trace_kmalloc(_RET_IP_, ret, size, s->size, gfpflags, NUMA_NO_NODE);
 
@@ -5480,7 +5504,14 @@ EXPORT_SYMBOL(__kmalloc_cache_noprof);
 void *__kmalloc_cache_node_noprof(struct kmem_cache *s, gfp_t gfpflags,
 				  int node, size_t size)
 {
-	void *ret = slab_alloc_node(s, NULL, gfpflags, node, _RET_IP_, size);
+	void *ret;
+	struct slab_alloc_context ac = {
+		.caller_addr = _RET_IP_,
+		.orig_size = size,
+		.alloc_flags = SLAB_ALLOC_DEFAULT,
+	};
+
+	ret = slab_alloc_node(s, gfpflags, node, &ac);
 
 	trace_kmalloc(_RET_IP_, ret, size, s->size, gfpflags, node);
 

-- 
2.54.0

