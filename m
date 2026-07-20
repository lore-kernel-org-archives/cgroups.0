Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9A3A42E8DF;
	Mon, 20 Jul 2026 14:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784557018; cv=none; b=CAPOJGXEXJR5K6egRfwVkRhO2Mt7HXD3q+lEpKa9h96QUaqD/BByvS1PZ5+Q9ONxqBIjJli/axVqvtuXqzfDFFJqejOCKJ29EuSdZPg1ClBVMPtLZdKqqb7T7ms8gPJSCK80MMTgJ489nJm2sfulG/dvmavk1k+zc1pyrVyBQ+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784557018; c=relaxed/simple;
	bh=JSD3i3wxXmRaw3kP4Fra0mQWky7FxbV5dW+q+FeGfGU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=G86f/9s2uyrZQCdYWZdgeH8tQWSYMiX/IPX2xx8Q0abKTmwBW07XinvpOXy1A7dF2gfcweQNG82sFQlR9tACv1+QKIQFWx0RZ15i0rH+cb6PZI1Viz3CeK0Tgmqg3UANABxQcybUjEQM2cdW4cxYcKmoUsYmLfa5ojHghFGQk3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a+9vjh6s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a+9vjh6s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC1B01F000E9;
	Mon, 20 Jul 2026 14:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784557016;
	bh=bjoSP6iddXq5PqiuJFnR36EEih/xwOGHSb79nndRhpk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=a+9vjh6s3qu0BOkJaj3suWW2z1csNZFV0BtPZnhUHEIoGJBS5KSiGcwnk1Iks8gjB
	 m2TT14Rmb2TkuX4tC/0hR2o6oKdj+ECei+hB7/v0JUFfK1a1Bjif5cRzPKzpArgJnB
	 F/Eu9SyTDosipKO0glkdRQVWnKQVr2ph8jvPAHP2snGsgqAljhAESwJZm3oLK5zMjg
	 1lkq4VUhebyhhtNHmqRVKC50zawjTgscX15PrKG877KXQdPKJeIGLdfM+lr4FvoQZI
	 7hmvIQUmidozfjtyzthbhwlvNw/QHs4E8wumY8mGcwpUuEKUmDCUDc8iBPPFocVtJA
	 uVTPgzFqJtSaQ==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Mon, 20 Jul 2026 16:16:23 +0200
Subject: [PATCH v2 09/13] mm/slab: change struct slabobj_ext to a union
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-b4-objext_split-v2-9-2fa7c6f60dbe@kernel.org>
References: <20260720-b4-objext_split-v2-0-2fa7c6f60dbe@kernel.org>
In-Reply-To: <20260720-b4-objext_split-v2-0-2fa7c6f60dbe@kernel.org>
To: Harry Yoo <harry@kernel.org>, Suren Baghdasaryan <surenb@google.com>
Cc: Hao Li <hao.li@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.15.2

Currently, struct slabobj_ext can hold both objcg pointer and
codetag_ref (when both are compile-enabled) and there is an array of as
many slabobj_ext instances as there are objects in a slab.

This makes the layout fixed so even if codetag_ref is unused (because
memory allocation profiling is disabled), the space for them is
allocated and wasted. Similarly, some caches (currently kmalloc_normal)
do not ever need objcg pointers, leading to wasted memory with memory
allocation profiling enabled.

To make this more flexible, change the layout so that struct slabobj_ext
becomes a union of objcg pointer and codetag_ref (to ensure uniform
size; in practice both are the same size anyway). The slabobj_ext array
then can have twice as many elements as before. For cache locality
purposes, the effective memory layout is unchanged, so objcg and codetag
ref for a given object are still adjacent.

cache_obj_ext_size() returns the effective size of (0-2) struct
slabobj_ext's for a cache, slab_obj_ext_size() for a slab. Currently
both return a constant value derived from the config options, but will
be made dynamic later. Replace all sizeof(slabobj_ext) usage with these.

No functional change intended, the layout is still effectively static.

Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/slab.h | 49 +++++++++++++++++++++++++++++++++++++++----------
 mm/slub.c | 19 +++++++++++--------
 2 files changed, 50 insertions(+), 18 deletions(-)

diff --git a/mm/slab.h b/mm/slab.h
index e586798e4f16..f8446167e175 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -550,18 +550,42 @@ static inline bool need_kmalloc_no_objext(void)
 }
 
 /*
- * Extended information for slab objects stored as an array in page->memcg_data
- * if MEMCG_DATA_OBJEXTS is set.
+ * Extended information for slab objects stored as a pointer to an array in
+ * slab->obj_exts (aliasing page->memcg_data) if MEMCG_DATA_OBJEXTS is set.
  */
 struct slabobj_ext {
+	/*
+	 * All elements of the union should be pointer-sized to avoid memory
+	 * waste
+	 */
+	union {
 #ifdef CONFIG_MEMCG
-	struct obj_cgroup *_objcg;
+		struct obj_cgroup *_objcg;
 #endif
 #ifdef CONFIG_MEM_ALLOC_PROFILING
-	union codetag_ref _ctref;
+		union codetag_ref _ctref;
 #endif
+	};
 } __aligned(8);
 
+static inline size_t cache_obj_ext_size(struct kmem_cache *s)
+{
+	size_t sz = 0;
+
+	if (IS_ENABLED(CONFIG_MEMCG))
+		sz += 1;
+
+	if (IS_ENABLED(CONFIG_MEM_ALLOC_PROFILING))
+		sz += 1;
+
+	return sizeof(struct slabobj_ext) * sz;
+}
+
+static inline size_t slab_obj_ext_size(struct slab *slab)
+{
+	return cache_obj_ext_size(slab->slab_cache);
+}
+
 #ifdef CONFIG_SLAB_OBJ_EXT
 
 /*
@@ -651,18 +675,18 @@ slab_obj_ext(struct kmem_cache *s, struct slab *slab, unsigned long obj_exts,
 {
 	struct slabobj_ext *obj_ext;
 	unsigned int index;
+	unsigned int stride;
 
 	VM_WARN_ON_ONCE(obj_exts != slab_obj_exts(slab));
 
 	index = obj_to_index(s, slab, obj);
 
-	if (!obj_exts_in_object(slab)) {
-		obj_ext = ((struct slabobj_ext *)obj_exts) + index;
-	} else {
-		unsigned int stride = s->size;
+	if (!obj_exts_in_object(slab))
+		stride = slab_obj_ext_size(slab);
+	else
+		stride = s->size;
 
-		obj_ext = (struct slabobj_ext *)(obj_exts + index * stride);
-	}
+	obj_ext = (struct slabobj_ext *)(obj_exts + index * stride);
 
 	return kasan_reset_tag(obj_ext);
 }
@@ -670,12 +694,14 @@ slab_obj_ext(struct kmem_cache *s, struct slab *slab, unsigned long obj_exts,
 #ifdef CONFIG_MEMCG
 static inline struct obj_cgroup *slab_obj_ext_objcg(struct slabobj_ext *obj_ext)
 {
+	/* if objcg exists, it comes first, so we don't need to do anything */
 	return obj_ext->_objcg;
 }
 
 static inline void slab_obj_ext_set_objcg(struct slabobj_ext *obj_ext,
 					  struct obj_cgroup *objcg)
 {
+	/* if objcg exists, it comes first, so we don't need to do anything */
 	obj_ext->_objcg = objcg;
 }
 #endif
@@ -684,6 +710,9 @@ static inline void slab_obj_ext_set_objcg(struct slabobj_ext *obj_ext,
 static inline union codetag_ref *
 slab_obj_ext_codetag_ref(struct slab *slab, struct slabobj_ext *obj_ext)
 {
+	if (IS_ENABLED(CONFIG_MEMCG))
+		obj_ext += 1;
+
 	return &obj_ext->_ctref;
 }
 #endif
diff --git a/mm/slub.c b/mm/slub.c
index f5b3eb44cb8a..287cbf3eddcc 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -803,7 +803,7 @@ static inline bool need_slab_obj_exts(struct kmem_cache *s)
 
 static inline unsigned int obj_exts_size_in_slab(struct slab *slab)
 {
-	return sizeof(struct slabobj_ext) * slab->objects;
+	return slab_obj_ext_size(slab) * slab->objects;
 }
 
 static inline unsigned long obj_exts_offset_in_slab(struct kmem_cache *s,
@@ -1199,7 +1199,7 @@ static void print_trailer(struct kmem_cache *s, struct slab *slab, u8 *p)
 	off += kasan_metadata_size(s, false);
 
 	if (obj_exts_in_object(slab))
-		off += sizeof(struct slabobj_ext);
+		off += slab_obj_ext_size(slab);
 
 	if (off != size_from_object(s))
 		/* Beginning of the filler is the free pointer */
@@ -1404,7 +1404,7 @@ static int check_pad_bytes(struct kmem_cache *s, struct slab *slab, u8 *p)
 	off += kasan_metadata_size(s, false);
 
 	if (obj_exts_in_object(slab))
-		off += sizeof(struct slabobj_ext);
+		off += slab_obj_ext_size(slab);
 
 	if (size_from_object(s) == off)
 		return 1;
@@ -2094,6 +2094,8 @@ static inline bool mark_failed_objexts_alloc(struct slab *slab)
 static inline void handle_failed_objexts_alloc(struct slab *slab,
 		unsigned long obj_exts, struct slabobj_ext *vec)
 {
+	unsigned int stride;
+
 	if (!mem_alloc_profiling_enabled())
 		return;
 
@@ -2105,11 +2107,13 @@ static inline void handle_failed_objexts_alloc(struct slab *slab,
 	if (obj_exts != OBJEXTS_ALLOC_FAIL)
 		return;
 
+	stride = slab_obj_ext_size(slab) / sizeof(*vec);
+
 	for (unsigned int i = 0; i < slab->objects; i++) {
 		union codetag_ref *ref = slab_obj_ext_codetag_ref(slab, vec);
 
 		set_codetag_empty(ref);
-		vec++;
+		vec += stride;
 	}
 }
 
@@ -2135,7 +2139,7 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
 	unsigned long new_exts;
 	unsigned long old_exts;
 	struct slabobj_ext *vec;
-	size_t sz = sizeof(struct slabobj_ext) * slab->objects;
+	size_t sz = slab_obj_ext_size(slab) * slab->objects;
 
 	gfp &= ~OBJCGS_CLEAR_MASK;
 	/*
@@ -2278,8 +2282,7 @@ static void alloc_slab_obj_exts_early(struct kmem_cache *s, struct slab *slab)
 
 		get_slab_obj_exts(obj_exts);
 		for_each_object(addr, s, slab_address(slab), slab->objects)
-			memset(kasan_reset_tag(addr) + offset, 0,
-			       sizeof(struct slabobj_ext));
+			memset(kasan_reset_tag(addr) + offset, 0, slab_obj_ext_size(slab));
 		put_slab_obj_exts(obj_exts);
 
 #ifdef CONFIG_MEMCG
@@ -7938,7 +7941,7 @@ static int calculate_sizes(struct kmem_cache_args *args, struct kmem_cache *s)
 	aligned_size = ALIGN(size, s->align);
 #if defined(CONFIG_SLAB_OBJ_EXT) && defined(CONFIG_64BIT)
 	if (slab_args_unmergeable(args, s->flags) &&
-			(aligned_size - size >= sizeof(struct slabobj_ext)))
+			(aligned_size - size >= cache_obj_ext_size(s)))
 		s->flags |= SLAB_OBJ_EXT_IN_OBJ;
 #endif
 	size = aligned_size;

-- 
2.55.0

