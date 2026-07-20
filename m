Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D69F42CB13;
	Mon, 20 Jul 2026 14:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784557011; cv=none; b=Qu9r1F7A0sPCioOjbYcmV+ks/KWbKYzYAHaW+DdPGzf7Nz2eR/4057rnAjI4KBwbt4sAinPjXCC98/SORq/fUg1b8kElX7o2DWk0TexZO0RHT2+LP/o/8ZVPFzkkYlkk5eGprUFFBTeW3mmdlG1ITviOleDXVCz2/AzO8nJ+Whk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784557011; c=relaxed/simple;
	bh=qRhbsPVpLn1S0jVnMzHPeZNIgXEVXf6DA1Hwaw/x/SE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=glPOY0X2KpCAGF7C3BHx+/ytsD4MV1D0J9/K9IMf+B+U8dRBZKdL1iZxR37CSEFI6vvDnsqIngkq/BQwhStBRgJeTggP6Rf6rHjnde2Cb1gLfxjwm9f0rwNR9UW5mIwr3Ww7Ve3PuZl+AVM22FWF5MXffShHQu36GbgvmHffFLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FeexIb05; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FeexIb05"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CC431F000E9;
	Mon, 20 Jul 2026 14:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784557010;
	bh=6r95VsQz7/bTPUaUrteE7bqXPatxg+Tzf2bzkDOfpus=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=FeexIb05eHtmuOUiBfDtAWxk3PrPlHYamFu45sXhoPfPvLfZHK3B+P/3oLwfibj3F
	 2KM/AArbZ55tU1uwIesTVdWN2BsJV9KT2SqwUU2I3pTlWgAoC3yfkkTt3FnVETIfH6
	 8ETfJb47yFBxAdkpg3KmKOmKFV8jjB0KLX/geS+LghDHRmuPHWUcEJp8ntR8H8Xu5+
	 RxQ6aJZhttrV2b8/IcKp0pHMgDmq+GK/aKseQVharGFoYKdP7ntubaYo0UGSh8QE8d
	 6+M7ZI7lwH/Aq3mupNhevs/wzMenUWn5Xdbs3woHw5ZgEcr4G77yvJbbClkazgqFWL
	 +R692rxxO6N4Q==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Mon, 20 Jul 2026 16:16:21 +0200
Subject: [PATCH v2 07/13] mm/slab: abstract slabobj_ext.ref access
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-b4-objext_split-v2-7-2fa7c6f60dbe@kernel.org>
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

In preparation for changes to the structure, abstract access to the ref
field with a slab_obj_ext_codetag_ref() function. Rename the field to
_ctref to make an unexpected direct access a compile error.

No functional change intended.

Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/slab.h | 10 +++++++++-
 mm/slub.c | 42 +++++++++++++++++++++++++++++-------------
 2 files changed, 38 insertions(+), 14 deletions(-)

diff --git a/mm/slab.h b/mm/slab.h
index 1d1771f97aca..62d6366d7d79 100644
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
index f2ffadde879d..cf999cbe75d1 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2071,23 +2071,25 @@ static inline void mark_obj_codetag_empty(const void *obj)
 	slab_exts = slab_obj_exts(obj_slab);
 	if (slab_exts) {
 		struct slabobj_ext *ext;
+		union codetag_ref *ref;
 
 		get_slab_obj_exts(slab_exts);
 		ext = slab_obj_ext(obj_slab->slab_cache, obj_slab, slab_exts, obj);
+		ref = slab_obj_ext_codetag_ref(obj_slab, ext);
 
 		if (is_kfence_address(obj)) {
 			put_slab_obj_exts(slab_exts);
 			return;
 		}
 
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
@@ -2097,8 +2099,8 @@ static inline bool mark_failed_objexts_alloc(struct slab *slab)
 	return cmpxchg(&slab->obj_exts, 0, OBJEXTS_ALLOC_FAIL) == 0;
 }
 
-static inline void handle_failed_objexts_alloc(unsigned long obj_exts,
-			struct slabobj_ext *vec, unsigned int objects)
+static inline void handle_failed_objexts_alloc(struct slab *slab,
+		unsigned long obj_exts, struct slabobj_ext *vec)
 {
 	if (!mem_alloc_profiling_enabled())
 		return;
@@ -2108,9 +2110,14 @@ static inline void handle_failed_objexts_alloc(unsigned long obj_exts,
 	 * objects with no tag reference. Mark all references in this
 	 * vector as empty to avoid warnings later on.
 	 */
-	if (obj_exts == OBJEXTS_ALLOC_FAIL) {
-		for (unsigned int i = 0; i < objects; i++)
-			set_codetag_empty(&vec[i].ref);
+	if (obj_exts != OBJEXTS_ALLOC_FAIL)
+		return;
+
+	for (unsigned int i = 0; i < slab->objects; i++) {
+		union codetag_ref *ref = slab_obj_ext_codetag_ref(slab, vec);
+
+		set_codetag_empty(ref);
+		vec++;
 	}
 }
 
@@ -2118,8 +2125,8 @@ static inline void handle_failed_objexts_alloc(unsigned long obj_exts,
 
 static inline void mark_obj_codetag_empty(const void *obj) {}
 static inline bool mark_failed_objexts_alloc(struct slab *slab) { return false; }
-static inline void handle_failed_objexts_alloc(unsigned long obj_exts,
-			struct slabobj_ext *vec, unsigned int objects) {}
+static inline void handle_failed_objexts_alloc(struct slab *slab,
+		unsigned long obj_exts, struct slabobj_ext *vec) {}
 
 #endif /* CONFIG_MEM_ALLOC_PROFILING_DEBUG */
 
@@ -2187,7 +2194,7 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
 #endif
 retry:
 	old_exts = READ_ONCE(slab->obj_exts);
-	handle_failed_objexts_alloc(old_exts, vec, slab->objects);
+	handle_failed_objexts_alloc(slab, old_exts, vec);
 
 	if (new_slab) {
 		/*
@@ -2367,9 +2374,15 @@ __alloc_tagging_slab_alloc_hook(struct kmem_cache *s, void *object, gfp_t flags,
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
@@ -2401,10 +2414,13 @@ __alloc_tagging_slab_free_hook(struct kmem_cache *s, struct slab *slab, void **p
 
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

