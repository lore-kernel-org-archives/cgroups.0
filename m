Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45F2A409624;
	Mon, 27 Jul 2026 12:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785156862; cv=none; b=pAAsuaq0o+yD00fcshbW2wttQWHD7sIxS6AWB69rvXSZfPV+q6hCbMLglAO56y2wXpL5lRmvhdNiQNU9DrjMxTwVqPhrsVVV+EbYjERiW22C/lhmW3ggqaqN/JAmJBa/YRKaIIi2dDZZoSxDN5P/buCKYMJxGwbuhMgNGdJFa5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785156862; c=relaxed/simple;
	bh=fOxQpl440+ZsINupLHUuWOYsylS4d+df/mKOeqRpWmw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=WFJJkVM0tKrSb9UL/nI2SIBge5s0E/+USZp5lL6flMW9LXnPxJWQtyFynIguBh6mCBn4URLweoqQdEdFwc6b77YwCtqj+x+dN0nQYNCzWTS9w6VNtU9vQt3CwFss+jjV546jtMr1mGun/qzckCIOMu+tgJuJ/zBgGCH2+l3rf1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O58oHHzI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O58oHHzI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5834A1F00A3E;
	Mon, 27 Jul 2026 12:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785156861;
	bh=+KVOFL+levc8or+V9XTYywFpS6wBhc+FTSX39UIbiwo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=O58oHHzIt43Rk4hBaYlwOlg3ogflYqy9kUAIyCPTLslbD/hCaUmEZfOJ6XvOvitel
	 IgZi+63qw21pzl+UiTyVMPcTAIEp/oJCN8dRSqEkqy2OB0s9FbdHHHNDacdvX4GiJt
	 4YTSrA1fsxUxU9j6d3rKXuioo0TKXnar/8HFRXeGEQCvVBndgJFypqbMyW04dJfAsN
	 l6r4xlBLMvPwpFSgyQVS3qomkWY9Af7z42Z6kGtS5f5o+W9XJeuW+j+jq2EePhjeKy
	 Sa6n1TYLYrg9xJLwv9g9Z5sg8LLFMTonlyzx//T/3Q+5Ba7+oEolFJ/gmZkndO9pHk
	 kROsvC169HicQ==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Mon, 27 Jul 2026 14:53:58 +0200
Subject: [PATCH v3 04/13] mm/slab: make slab_obj_ext() determine object
 index
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260727-b4-objext_split-v3-4-c29ef0f1f257@kernel.org>
References: <20260727-b4-objext_split-v3-0-c29ef0f1f257@kernel.org>
In-Reply-To: <20260727-b4-objext_split-v3-0-c29ef0f1f257@kernel.org>
To: Harry Yoo <harry@kernel.org>, Suren Baghdasaryan <surenb@google.com>
Cc: Hao Li <hao.li@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.15.2

All callers perform the same obj_to_index() calculation to pass the
index. Simplify by passing object pointer instead and determining the
index by slab_obj_ext().

Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
Reviewed-by: Hao Li <hao.li@linux.dev>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/memcontrol.c | 12 +++---------
 mm/slab.h       | 19 +++++++++++--------
 mm/slub.c       | 22 +++++++---------------
 3 files changed, 21 insertions(+), 32 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6dc4888a90f3..4e427286a88a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2865,15 +2865,13 @@ struct mem_cgroup *mem_cgroup_from_obj_slab(struct slab *slab, void *p)
 	 */
 	unsigned long obj_exts;
 	struct slabobj_ext *obj_ext;
-	unsigned int off;
 
 	obj_exts = slab_obj_exts(slab);
 	if (!obj_exts)
 		return NULL;
 
 	get_slab_obj_exts(obj_exts);
-	off = obj_to_index(slab->slab_cache, slab, p);
-	obj_ext = slab_obj_ext(slab, obj_exts, off);
+	obj_ext = slab_obj_ext(slab->slab_cache, slab, obj_exts, p);
 	if (obj_ext->objcg) {
 		struct obj_cgroup *objcg = obj_ext->objcg;
 
@@ -3541,7 +3539,6 @@ bool __memcg_slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
 	size_t obj_size = obj_full_size(s);
 	struct obj_cgroup *objcg;
 	struct slab *slab;
-	unsigned long off;
 	size_t i;
 
 	/*
@@ -3616,8 +3613,7 @@ bool __memcg_slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
 
 		obj_exts = slab_obj_exts(slab);
 		get_slab_obj_exts(obj_exts);
-		off = obj_to_index(s, slab, p[i]);
-		obj_ext = slab_obj_ext(slab, obj_exts, off);
+		obj_ext = slab_obj_ext(s, slab, obj_exts, p[i]);
 		obj_cgroup_get(objcg);
 		obj_ext->objcg = objcg;
 		put_slab_obj_exts(obj_exts);
@@ -3635,10 +3631,8 @@ void __memcg_slab_free_hook(struct kmem_cache *s, struct slab *slab,
 		struct obj_cgroup *objcg;
 		struct slabobj_ext *obj_ext;
 		struct obj_stock_pcp *stock;
-		unsigned int off;
 
-		off = obj_to_index(s, slab, p[i]);
-		obj_ext = slab_obj_ext(slab, obj_exts, off);
+		obj_ext = slab_obj_ext(s, slab, obj_exts, p[i]);
 		objcg = obj_ext->objcg;
 		if (!objcg)
 			continue;
diff --git a/mm/slab.h b/mm/slab.h
index 7bd361447c54..451b50b7f237 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -579,7 +579,7 @@ struct slabobj_ext {
  * obj_exts = slab_obj_exts(slab);
  * if (obj_exts) {
  *         get_slab_obj_exts(obj_exts);
- *         obj_ext = slab_obj_ext(slab, obj_exts, obj_to_index(s, slab, obj));
+ *         obj_ext = slab_obj_ext(s, slab, obj_exts, obj);
  *         // do something with obj_ext
  *         put_slab_obj_exts(obj_exts);
  * }
@@ -639,21 +639,24 @@ static inline unsigned int slab_get_stride(struct slab *slab)
 /*
  * slab_obj_ext - get the pointer to the slab object extension metadata
  * associated with an object in a slab.
+ * @s: cache that the slab belongs to
  * @slab: a pointer to the slab struct
  * @obj_exts: a pointer to the object extension vector
- * @index: an index of the object
+ * @obj: a pointer to the object
  *
  * Returns a pointer to the object extension associated with the object.
  * Must be called within a section covered by get/put_slab_obj_exts().
  */
-static inline struct slabobj_ext *slab_obj_ext(struct slab *slab,
-					       unsigned long obj_exts,
-					       unsigned int index)
+static inline struct slabobj_ext *
+slab_obj_ext(struct kmem_cache *s, struct slab *slab, unsigned long obj_exts,
+	     const void *obj)
 {
 	struct slabobj_ext *obj_ext;
+	unsigned int index;
 
 	VM_WARN_ON_ONCE(obj_exts != slab_obj_exts(slab));
 
+	index = obj_to_index(s, slab, obj);
 	obj_ext = (struct slabobj_ext *)(obj_exts +
 					 slab_get_stride(slab) * index);
 	return kasan_reset_tag(obj_ext);
@@ -669,9 +672,9 @@ static inline unsigned long slab_obj_exts(struct slab *slab)
 	return 0;
 }
 
-static inline struct slabobj_ext *slab_obj_ext(struct slab *slab,
-					       unsigned long obj_exts,
-					       unsigned int index)
+static inline struct slabobj_ext *
+slab_obj_ext(struct kmem_cache *s, struct slab *slab, unsigned long obj_exts,
+	     const void *obj)
 {
 	return NULL;
 }
diff --git a/mm/slub.c b/mm/slub.c
index b94482830637..a74f1866c958 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2073,11 +2073,10 @@ static inline void mark_obj_codetag_empty(const void *obj)
 	obj_slab = virt_to_slab(obj);
 	slab_exts = slab_obj_exts(obj_slab);
 	if (slab_exts) {
+		struct slabobj_ext *ext;
+
 		get_slab_obj_exts(slab_exts);
-		unsigned int offs = obj_to_index(obj_slab->slab_cache,
-						 obj_slab, obj);
-		struct slabobj_ext *ext = slab_obj_ext(obj_slab,
-						       slab_exts, offs);
+		ext = slab_obj_ext(obj_slab->slab_cache, obj_slab, slab_exts, obj);
 
 		if (unlikely(is_codetag_empty(&ext->ref))) {
 			put_slab_obj_exts(slab_exts);
@@ -2365,10 +2364,8 @@ __alloc_tagging_slab_alloc_hook(struct kmem_cache *s, void *object, gfp_t flags,
 	 * check should be added before alloc_tag_add().
 	 */
 	if (obj_exts) {
-		unsigned int obj_idx = obj_to_index(s, slab, object);
-
 		get_slab_obj_exts(obj_exts);
-		obj_ext = slab_obj_ext(slab, obj_exts, obj_idx);
+		obj_ext = slab_obj_ext(s, slab, obj_exts, object);
 		alloc_tag_add(&obj_ext->ref, current->alloc_tag, s->size);
 		put_slab_obj_exts(obj_exts);
 	} else {
@@ -2389,7 +2386,6 @@ static noinline void
 __alloc_tagging_slab_free_hook(struct kmem_cache *s, struct slab *slab, void **p,
 			       int objects)
 {
-	int i;
 	unsigned long obj_exts;
 
 	/* slab->obj_exts might not be NULL if it was created for MEMCG accounting. */
@@ -2401,13 +2397,11 @@ __alloc_tagging_slab_free_hook(struct kmem_cache *s, struct slab *slab, void **p
 		return;
 
 	get_slab_obj_exts(obj_exts);
-	for (i = 0; i < objects; i++) {
-		unsigned int off = obj_to_index(s, slab, p[i]);
-
+	for (int i = 0; i < objects; i++) {
 		if (is_kfence_address(p[i]))
 			continue;
 
-		alloc_tag_sub(&slab_obj_ext(slab, obj_exts, off)->ref, s->size);
+		alloc_tag_sub(&slab_obj_ext(s, slab, obj_exts, p[i])->ref, s->size);
 	}
 	put_slab_obj_exts(obj_exts);
 }
@@ -2492,7 +2486,6 @@ bool memcg_slab_post_charge(void *p, gfp_t flags)
 	struct kmem_cache *s;
 	struct page *page;
 	struct slab *slab;
-	unsigned long off;
 
 	page = virt_to_page(p);
 	if (PageLargeKmalloc(page)) {
@@ -2532,8 +2525,7 @@ bool memcg_slab_post_charge(void *p, gfp_t flags)
 	obj_exts = slab_obj_exts(slab);
 	if (obj_exts) {
 		get_slab_obj_exts(obj_exts);
-		off = obj_to_index(s, slab, p);
-		obj_ext = slab_obj_ext(slab, obj_exts, off);
+		obj_ext = slab_obj_ext(s, slab, obj_exts, p);
 		if (unlikely(obj_ext->objcg)) {
 			put_slab_obj_exts(obj_exts);
 			return true;

-- 
2.55.0

