Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC1553F39E5;
	Tue,  9 Jun 2026 09:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780996695; cv=none; b=rfO2zeBF9m6xTZa4r7Ja47/hJpfYzuxr6DABuezj9Flk9yFBMagE5PnruBGaL/mU+nNattXJfV5ZKJejqkRL2x9NM2alkrikZR7JkWStehIIu/uLTDZmSrkOn2eGOr9aHLf/MlllEZ91BPhdBonS1H/ukWwK+yIjHvcGiJw2hmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780996695; c=relaxed/simple;
	bh=5FTOVjtxsumh5OVZ7SKtRSg3YXCwAY3OMkOa/2FT/bQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=fQSEQzphAi203lYAl9rcI1/XeWC/7lF6ieIZasFU+YUPl4vdMWbjts5XSwfqvZMpa1no3Tp3HpE2tnJ4E2hLWtQKx06WD23551lobfLbCT3yTgwAT051kU4ktyP5kjMFXJHUAHhOjP/zYWtwFa/sBB8eyCUbYr4GMUe7oFDYG8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fuQh7gWD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fuQh7gWD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D762D1F00893;
	Tue,  9 Jun 2026 09:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780996694;
	bh=UaSnETjCVjKQXWJX1aoWsst86Gp93Bm51zl46Fnvd9Q=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=fuQh7gWDayJSvLXaB+wnx5dQuD5ZWO3KkG541FD7WN8TTBLqUfkzaQdPnG8Z972n8
	 FEEn1P++JxpaAG/u7Q51YwJ4k4indiGn8LAAOeiLW5b81km8G/bc48kOSuUaqUJucB
	 WeJ4ZxSEzWNPDBKbVhwmmzqeawSPoZnDGZSbyI+aQ58Ol4HtjK9EIXCTNuxTkljNjv
	 TBcqmly6vqldZyJX7J0CV24jhy3TUQvrOPyHgLSq/ZTu7faTh9UtfMAQK4yc2F/zO3
	 Tut+uyQ13I4Izx7CJe5Q3VuqQBSY3mq37X6VXKzwCbOxlevwCcEOPgvbIhc4GYZ529
	 crHcT/FegA1KQ==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Tue, 09 Jun 2026 11:17:50 +0200
Subject: [PATCH RFC 05/15] mm/slab: add alloc_flags to slab_alloc_context
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260609-slab_alloc_flags-v1-5-2bf4a4b9b526@kernel.org>
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

Add alloc_flags as a new field to the slab_alloc_context helper struct,
so we can pass it to more functions in the slab implementation without
adding another function parameter.

Start checking them via alloc_flags_allow_spinning() in
alloc_single_from_new_slab() (where we can drop the allow_spin
parameter) and ___slab_alloc(). This further reduces false-positive
spinning-not-allowed from allocations that are not kmalloc_nolock() but
lack __GFP_RECLAIM flags.

_kmalloc_nolock_noprof() initializes ac.alloc_flags using its flags that
are SLAB_ALLOC_TRYLOCK. slab_alloc_node() and __kmem_cache_alloc_bulk()
are not reachable from kmalloc_nolock() and all their callers expect
spinning to be allowed, so they can use SLAB_ALLOC_DEFAULT. This is
temporary as the scope of slab_alloc_context will further move to the
callers, making the alloc_flags usage more obvious.

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/slub.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 278d8cbcc7ee..b2a452dd70fa 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -217,6 +217,7 @@ static DEFINE_STATIC_KEY_FALSE(strict_numa);
 struct slab_alloc_context {
 	unsigned long caller_addr;
 	unsigned long orig_size;
+	unsigned int alloc_flags;
 };
 
 /* Structure holding parameters for get_from_partial() call chain */
@@ -3693,9 +3694,9 @@ static inline void init_slab_obj_iter(struct kmem_cache *s, struct slab *slab,
  * and put the slab to the partial (or full) list.
  */
 static void *alloc_single_from_new_slab(struct kmem_cache *s, struct slab *slab,
-					struct slab_alloc_context *ac,
-					bool allow_spin)
+					struct slab_alloc_context *ac)
 {
+	bool allow_spin = alloc_flags_allow_spinning(ac->alloc_flags);
 	struct kmem_cache_node *n;
 	struct slab_obj_iter iter;
 	bool needs_add_partial;
@@ -4452,7 +4453,7 @@ static unsigned int alloc_from_new_slab(struct kmem_cache *s, struct slab *slab,
 static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 			   struct slab_alloc_context *ac)
 {
-	bool allow_spin = gfpflags_allow_spinning(gfpflags);
+	bool allow_spin = alloc_flags_allow_spinning(ac->alloc_flags);
 	void *object;
 	struct slab *slab;
 	struct partial_context pc;
@@ -4503,7 +4504,7 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 	stat(s, ALLOC_SLAB);
 
 	if (IS_ENABLED(CONFIG_SLUB_TINY) || kmem_cache_debug(s)) {
-		object = alloc_single_from_new_slab(s, slab, ac, allow_spin);
+		object = alloc_single_from_new_slab(s, slab, ac);
 
 		if (likely(object))
 			goto success;
@@ -4903,6 +4904,7 @@ unsigned int alloc_from_pcs_bulk(struct kmem_cache *s, gfp_t gfp, size_t size,
 static __fastpath_inline void *slab_alloc_node(struct kmem_cache *s, struct list_lru *lru,
 		gfp_t gfpflags, int node, unsigned long addr, size_t orig_size)
 {
+	const unsigned int alloc_flags = SLAB_ALLOC_DEFAULT;
 	void *object;
 
 	s = slab_pre_alloc_hook(s, gfpflags);
@@ -4913,12 +4915,13 @@ static __fastpath_inline void *slab_alloc_node(struct kmem_cache *s, struct list
 	if (unlikely(object))
 		goto out;
 
-	object = alloc_from_pcs(s, gfpflags, SLAB_ALLOC_DEFAULT, node);
+	object = alloc_from_pcs(s, gfpflags, alloc_flags, node);
 
 	if (unlikely(!object)) {
 		struct slab_alloc_context ac = {
 			.caller_addr = addr,
 			.orig_size = orig_size,
+			.alloc_flags = alloc_flags,
 		};
 		object = __slab_alloc_node(s, gfpflags, node, &ac);
 	}
@@ -5390,6 +5393,7 @@ void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, in
 	struct slab_alloc_context ac = {
 		.caller_addr = _RET_IP_,
 		.orig_size = orig_size,
+		.alloc_flags = alloc_flags,
 	};
 
 	/*
@@ -7240,6 +7244,7 @@ static bool __kmem_cache_alloc_bulk(struct kmem_cache *s, gfp_t flags,
 		struct slab_alloc_context ac = {
 			.caller_addr = _RET_IP_,
 			.orig_size = s->object_size,
+			.alloc_flags = SLAB_ALLOC_DEFAULT,
 		};
 		for (i = 0; i < size; i++) {
 

-- 
2.54.0

