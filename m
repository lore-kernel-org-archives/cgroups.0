Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B73B340A94A;
	Mon, 27 Jul 2026 12:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785156868; cv=none; b=nIgS3EG2O6ofmUBpwGwzJAaeQiQEwwcnne6++A2YbWupzWjuGEUsfjGhXJNiPmYhu8XCwm6Wjjm5dIFoc5ePxWyaDd3UwSHG1eQZb3XBUnt/vMbQfS0833Z6yvkmUjs9mD+y6tsY+pZw/WJom7Byt7xwInYNN1gDsatI24geUY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785156868; c=relaxed/simple;
	bh=yFb/cw5ABiC9zEpH4LCA1Hv6Y70d/UTfaPWK53hWsW0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=F/sS4p3QFlrurc1os4Yqcq4YL5QAhK2G+yvOuLyVxNzbMnEZlBTWeRwoy7KWURBgCL22YgvwFBo2/pO0qntWR4dMRXn7UTob2oVxJrqg97oSA2ZmXs3O9T04lH0HmdIZJ1IGj2HC020q2uZKZgOrofo/bK/9glkL67AVrIRRI3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fkmC1z8U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fkmC1z8U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D29401F00A3A;
	Mon, 27 Jul 2026 12:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785156867;
	bh=gW8C7PtNJ+J/PwD5PEcFchCBIkGoW7Qb4a15wmFBizw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=fkmC1z8Uo+Zrb9IsjCAIGPDivm4rLDxbZ3NzWOLqdv2tENqp54VHYp/nhcCyfo2IL
	 +wwzgZ6d8ql4m30hLTOx66HujzWnxtLR1VprKkXmqn5hEX/HCHzfg1RUnrwJfuvRRM
	 PV4kD005UmkY/x5pZgebArEPDnEYYDLPk7+hnaX2BgI32VPen1LiANtg1ZRABEgbb0
	 DgurkN8U7yH/ZHWNIZ39cDQK1N16gsz/A48tTPbsl12Jxj2qsV7hKl3GWZewM4Fg+M
	 Wssdh3euiVVXpUAAs0NOtJSvsrVslXxLzM4LdWh6x7ZLeJkEPsjP2X6nTzzFdZKX4F
	 GzK+MrbR845Fw==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Mon, 27 Jul 2026 14:54:00 +0200
Subject: [PATCH v3 06/13] mm/slab: abstract slabobj_ext.ref access
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260727-b4-objext_split-v3-6-c29ef0f1f257@kernel.org>
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

In preparation for changes to the structure, abstract access to the ref
field with a slab_obj_ext_codetag_ref() function. Rename the field to
_ctref to make an unexpected direct access a compile error.

No functional change intended.

Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Hao Li <hao.li@linux.dev>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/slab.h | 10 +++++++++-
 mm/slub.c | 42 ++++++++++++++++++++++++++++--------------
 2 files changed, 37 insertions(+), 15 deletions(-)

diff --git a/mm/slab.h b/mm/slab.h
index 1e4f61607448..562b62802561 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -558,7 +558,7 @@ struct slabobj_ext {
 	struct obj_cgroup *_objcg;
 #endif
 #ifdef CONFIG_MEM_ALLOC_PROFILING
-	union codetag_ref ref;
+	union codetag_ref _ctref;
 #endif
 } __aligned(8);
 
@@ -675,6 +675,14 @@ static inline void slab_obj_ext_set_objcg(struct slabobj_ext *obj_ext,
 }
 #endif
 
+#ifdef CONFIG_MEM_ALLOC_PROFILING
+static inline union codetag_ref *
+slab_obj_ext_codetag_ref(struct slab *slab, struct slabobj_ext *obj_ext)
+{
+	return &obj_ext->_ctref;
+}
+#endif
+
 int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
 			gfp_t gfp, unsigned int alloc_flags);
 
diff --git a/mm/slub.c b/mm/slub.c
index 2bf38fb1a3f0..7812a7c097c9 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2074,18 +2074,20 @@ static inline void mark_obj_codetag_empty(const void *obj)
 	slab_exts = slab_obj_exts(obj_slab);
 	if (slab_exts) {
 		struct slabobj_ext *ext;
+		union codetag_ref *ref;
 
 		get_slab_obj_exts(slab_exts);
 		ext = slab_obj_ext(obj_slab->slab_cache, obj_slab, slab_exts, obj);
+		ref = slab_obj_ext_codetag_ref(obj_slab, ext);
 
-		if (unlikely(is_codetag_empty(&ext->ref))) {
+		if (unlikely(is_codetag_empty(ref))) {
 			put_slab_obj_exts(slab_exts);
 			return;
 		}
 
 		/* codetag should be NULL here */
-		WARN_ON(ext->ref.ct);
-		set_codetag_empty(&ext->ref);
+		WARN_ON(ref->ct);
+		set_codetag_empty(ref);
 		put_slab_obj_exts(slab_exts);
 	}
 }
@@ -2095,19 +2097,22 @@ static inline bool mark_failed_objexts_alloc(struct slab *slab)
 	return cmpxchg(&slab->obj_exts, 0, OBJEXTS_ALLOC_FAIL) == 0;
 }
 
-static inline void handle_failed_objexts_alloc(unsigned long obj_exts,
-			struct slabobj_ext *vec, unsigned int objects)
+static inline void handle_failed_objexts_alloc(struct slab *slab,
+		unsigned long obj_exts, struct slabobj_ext *vec)
 {
 	/*
 	 * If vector previously failed to allocate then we have live
 	 * objects with no tag reference. Mark all references in this
 	 * vector as empty to avoid warnings later on.
 	 */
-	if (obj_exts == OBJEXTS_ALLOC_FAIL) {
-		unsigned int i;
+	if (obj_exts != OBJEXTS_ALLOC_FAIL)
+		return;
+
+	for (unsigned int i = 0; i < slab->objects; i++) {
+		union codetag_ref *ref = slab_obj_ext_codetag_ref(slab, vec);
 
-		for (i = 0; i < objects; i++)
-			set_codetag_empty(&vec[i].ref);
+		set_codetag_empty(ref);
+		vec++;
 	}
 }
 
@@ -2115,8 +2120,8 @@ static inline void handle_failed_objexts_alloc(unsigned long obj_exts,
 
 static inline void mark_obj_codetag_empty(const void *obj) {}
 static inline bool mark_failed_objexts_alloc(struct slab *slab) { return false; }
-static inline void handle_failed_objexts_alloc(unsigned long obj_exts,
-			struct slabobj_ext *vec, unsigned int objects) {}
+static inline void handle_failed_objexts_alloc(struct slab *slab,
+		unsigned long obj_exts, struct slabobj_ext *vec) {}
 
 #endif /* CONFIG_MEM_ALLOC_PROFILING_DEBUG */
 
@@ -2184,7 +2189,7 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
 #endif
 retry:
 	old_exts = READ_ONCE(slab->obj_exts);
-	handle_failed_objexts_alloc(old_exts, vec, slab->objects);
+	handle_failed_objexts_alloc(slab, old_exts, vec);
 
 	if (new_slab) {
 		/*
@@ -2364,9 +2369,15 @@ __alloc_tagging_slab_alloc_hook(struct kmem_cache *s, void *object, gfp_t flags,
 	 * check should be added before alloc_tag_add().
 	 */
 	if (obj_exts) {
+		union codetag_ref *ref;
+
 		get_slab_obj_exts(obj_exts);
+
 		obj_ext = slab_obj_ext(s, slab, obj_exts, object);
-		alloc_tag_add(&obj_ext->ref, current->alloc_tag, s->size);
+		ref = slab_obj_ext_codetag_ref(slab, obj_ext);
+
+		alloc_tag_add(ref, current->alloc_tag, s->size);
+
 		put_slab_obj_exts(obj_exts);
 	} else {
 		alloc_tag_set_inaccurate(current->alloc_tag);
@@ -2398,10 +2409,13 @@ __alloc_tagging_slab_free_hook(struct kmem_cache *s, struct slab *slab, void **p
 
 	get_slab_obj_exts(obj_exts);
 	for (int i = 0; i < objects; i++) {
+		struct slabobj_ext *ext;
+
 		if (is_kfence_address(p[i]))
 			continue;
 
-		alloc_tag_sub(&slab_obj_ext(s, slab, obj_exts, p[i])->ref, s->size);
+		ext = slab_obj_ext(s, slab, obj_exts, p[i]);
+		alloc_tag_sub(slab_obj_ext_codetag_ref(slab, ext), s->size);
 	}
 	put_slab_obj_exts(obj_exts);
 }

-- 
2.55.0

