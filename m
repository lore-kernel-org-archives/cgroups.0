Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C91D540A934;
	Mon, 27 Jul 2026 12:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785156892; cv=none; b=spr+lWUnzo/KQGrpImGeiHOBTIjO0rRYFAwwrhplY6kMcT2WAFhHlwe8IhmDb/7dXfvsFbEMbn97pO58St2XwJC4Ygl07dSEAbKBkUVyZ4h4QJnj4M4mcQrcthzwg/TYWbY9rPtrauptj6AYgA3ZEGa0BT3iSf3lRFYiZrRCLtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785156892; c=relaxed/simple;
	bh=lrHPuPOzk7DD+8v334REUR262DnadfyimU+SGntP9VI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ckgYJ8/D4AUPxLQOLOTeTNp0IJ8g2lPmN2/VtAz6bqGE8vJm/2wE76JE8WjVLfwTDmLLP2DLO3uPrRM+m2ykc3NT8ismfSTaBT6+Z4d4IU4cn/mmBdvFpR6FKfzaKfz3QytfOSQEpE7q6Fv/S2AisnRSMIl6yuxykrhSwgc53mA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GlOc/Hti; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GlOc/Hti"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C6121F00A3D;
	Mon, 27 Jul 2026 12:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785156890;
	bh=Y993pIXua00WBWAIL/1Z7lFYMSFYvoH9IeLbXJAbVr8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=GlOc/Hti45wALWjtn6Haho+Objyxbrbt7jQkQI52f6WDWE6mQNDdVTCUx5xmIUySB
	 IW9jvpBKPbL0IutvEOSTvfsIVLqUZjVPKPsPpYsqDse4sWKwjGAGgCAv+IRf/98wO6
	 zZaFHX6HIs/YfteHIuMALmr0a+gc3U9q3q/4HKE5ir/6uXQ1rZ2+7CSOwq2tFvzNHU
	 xX9glvhA3CwgJ86x7y7y4hZdK1qGqh4MLaxWsKoWJ6ddhsOW3tNuwBvWcCkoGLL62Z
	 IX3czJRwF/un2vwPqYI8nw8sla4BzQHPFwqUytbZRDxwPhfRruQYiX/eIf8+qcgkau
	 dwkPBfdDKgL6A==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Mon, 27 Jul 2026 14:54:07 +0200
Subject: [PATCH v3 13/13] mm/slab, kfence, memcg: completely remove obj_ext
 for kfence objects
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260727-b4-objext_split-v3-13-c29ef0f1f257@kernel.org>
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

We have already disabled memory allocation profiling for objects
allocated for KFENCE to avoid complexity. KFENCE allocations are rare
and there can be only CONFIG_KFENCE_NUM_OBJECTS (default to 255)
outstanding ones at any time, so they are among noise in the profiling
stats.

For the same reasons, we can stop memcg_kmem accounting of kfence
objects as their memory usage will be negligible wrt any practical
memcg limits.

This allows us simplifying the code and getting rid of
is_kfence_address() checks in various places, including slab_obj_ext()'s
usage of obj_to_index(). Instead we rely on the fact that slab_obj_exts()
will now always return 0 for a kfence object's fake slab, which makes
those places unreachable.

All we need to do to keep this assumption valid is not to allocate
obj_exts for kfence objects, so the checks need to guard
alloc_slab_obj_exts() where necessary.

Suggested-by: Harry Yoo <harry@kernel.org>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/kfence/core.c   | 15 ---------------
 mm/kfence/kfence.h |  3 ---
 mm/memcontrol.c    | 12 +++++++-----
 mm/slab.h          |  6 +++++-
 mm/slub.c          | 31 ++++++++++++++++---------------
 5 files changed, 28 insertions(+), 39 deletions(-)

diff --git a/mm/kfence/core.c b/mm/kfence/core.c
index 897ecf2594fb..90925c646c4c 100644
--- a/mm/kfence/core.c
+++ b/mm/kfence/core.c
@@ -636,14 +636,6 @@ static unsigned long kfence_init_pool(void)
 
 		page = pfn_to_page(start_pfn + i);
 		__SetPageSlab(page);
-#ifdef CONFIG_MEMCG
-		struct slab *slab = page_slab(page);
-		slab->obj_exts = (unsigned long)&kfence_metadata_init[i / 2 - 1].obj_exts |
-				 MEMCG_DATA_OBJEXTS;
-#ifdef CONFIG_64BIT
-		slab->obj_exts_needs_objcg = 1;
-#endif
-#endif
 	}
 
 	/*
@@ -707,10 +699,6 @@ static unsigned long kfence_init_pool(void)
 			continue;
 
 		page = pfn_to_page(start_pfn + i);
-#ifdef CONFIG_MEMCG
-		struct slab *slab = page_slab(page);
-		slab->obj_exts = 0;
-#endif
 		__ClearPageSlab(page);
 	}
 
@@ -1251,9 +1239,6 @@ void __kfence_free(void *addr)
 {
 	struct kfence_metadata *meta = addr_to_metadata((unsigned long)addr);
 
-#ifdef CONFIG_MEMCG
-	KFENCE_WARN_ON(slab_obj_ext_objcg(&meta->obj_exts));
-#endif
 	/*
 	 * If the objects of the cache are SLAB_TYPESAFE_BY_RCU, defer freeing
 	 * the object, as the object page may be recycled for other-typed
diff --git a/mm/kfence/kfence.h b/mm/kfence/kfence.h
index 1f618f9b0d12..e6b4bf349ff7 100644
--- a/mm/kfence/kfence.h
+++ b/mm/kfence/kfence.h
@@ -102,9 +102,6 @@ struct kfence_metadata {
 	struct kfence_track free_track __guarded_by(&lock);
 	/* For updating alloc_covered on frees. */
 	u32 alloc_stack_hash __guarded_by(&lock);
-#ifdef CONFIG_MEMCG
-	struct slabobj_ext obj_exts;
-#endif
 };
 
 #define KFENCE_METADATA_SIZE PAGE_ALIGN(sizeof(struct kfence_metadata) * \
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index aace85fb99f9..6b51ddf6dfe0 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3583,13 +3583,15 @@ bool __memcg_slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
 
 		slab = virt_to_slab(p[i]);
 
-		if (IS_ENABLED(CONFIG_DEBUG_VM) && WARN_ON_ONCE(!slab_needs_objcg(slab)))
-			continue;
+		if (!slab_obj_exts(slab)) {
+			if (is_kfence_address(p[i]))
+				continue;
+			if (alloc_slab_obj_exts(slab, s, flags, slab_alloc_flags))
+				continue;
+		}
 
-		if (!slab_obj_exts(slab) &&
-		    alloc_slab_obj_exts(slab, s, flags, slab_alloc_flags)) {
+		if (IS_ENABLED(CONFIG_DEBUG_VM) && WARN_ON_ONCE(!slab_needs_objcg(slab)))
 			continue;
-		}
 
 		/*
 		 * if we fail and size is 1, memcg_alloc_abort_single() will
diff --git a/mm/slab.h b/mm/slab.h
index 44f9b2569e80..04600f57b401 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -730,7 +730,11 @@ slab_obj_ext(struct kmem_cache *s, struct slab *slab, unsigned long obj_exts,
 
 	VM_WARN_ON_ONCE(obj_exts != slab_obj_exts(slab));
 
-	index = obj_to_index(s, slab, obj);
+	/*
+	 * KFENCE objects have NULL obj_exts and thus can't reach this
+	 * and we don't need obj_to_index()
+	 */
+	index = __obj_to_index(s, slab_address(slab), obj);
 
 	if (!obj_exts_in_object(slab))
 		stride = slab_obj_ext_size(slab);
diff --git a/mm/slub.c b/mm/slub.c
index 893a11abcc20..94b744e5ac79 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2064,9 +2064,6 @@ static inline void mark_obj_codetag_empty(const void *obj)
 	struct slab *obj_slab;
 	unsigned long slab_exts;
 
-	if (is_kfence_address(obj))
-		return;
-
 	obj_slab = virt_to_slab(obj);
 	slab_exts = slab_obj_exts(obj_slab);
 	if (slab_exts) {
@@ -2329,11 +2326,15 @@ static inline unsigned long
 prepare_slab_obj_exts_hook(struct kmem_cache *s, struct slab *slab,
 			   gfp_t flags, unsigned int alloc_flags, void *p)
 {
-	if (!slab_obj_exts(slab) &&
-	    alloc_slab_obj_exts(slab, s, flags, alloc_flags)) {
-		pr_warn_once("%s, %s: Failed to create slab extension vector!\n",
-			     __func__, s->name);
-		return 0;
+	if (!slab_obj_exts(slab)) {
+		if (is_kfence_address(p))
+			return 0;
+
+		if (alloc_slab_obj_exts(slab, s, flags, alloc_flags)) {
+			pr_warn_once("%s, %s: Failed to create slab extension vector!\n",
+				     __func__, s->name);
+			return 0;
+		}
 	}
 
 	return slab_obj_exts(slab);
@@ -2358,9 +2359,6 @@ __alloc_tagging_slab_alloc_hook(struct kmem_cache *s, void *object, gfp_t flags,
 	if (alloc_flags & SLAB_ALLOC_NO_RECURSE)
 		return;
 
-	if (is_kfence_address(object))
-		return;
-
 	slab = virt_to_slab(object);
 	obj_exts = prepare_slab_obj_exts_hook(s, slab, flags, alloc_flags, object);
 	/*
@@ -2380,7 +2378,13 @@ __alloc_tagging_slab_alloc_hook(struct kmem_cache *s, void *object, gfp_t flags,
 
 		put_slab_obj_exts(obj_exts);
 	} else {
-		alloc_tag_set_inaccurate(current->alloc_tag);
+		/*
+		 * KFENCE allocations are rare and the amount of outstanding
+		 * ones is limited to a small number so it's not worth setting
+		 * tags as inaccurate because of them.
+		 */
+		if (!is_kfence_address(object))
+			alloc_tag_set_inaccurate(current->alloc_tag);
 	}
 }
 
@@ -2411,9 +2415,6 @@ __alloc_tagging_slab_free_hook(struct kmem_cache *s, struct slab *slab, void **p
 	for (int i = 0; i < objects; i++) {
 		struct slabobj_ext *ext;
 
-		if (is_kfence_address(p[i]))
-			continue;
-
 		ext = slab_obj_ext(s, slab, obj_exts, p[i]);
 		alloc_tag_sub(slab_obj_ext_codetag_ref(slab, ext), s->size);
 	}

-- 
2.55.0

