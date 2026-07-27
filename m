Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0AF740A929;
	Mon, 27 Jul 2026 12:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785156865; cv=none; b=LC3pZ2XaZ53PdtarqUVgC9mtqpF2EHdKK14QQcj82sslH5iMFMkKUgL33NyBeiWg6wRP+YnLJhhf8j2WyDmqQL9zWT6h1mnKu+2dOEq6sCgTPX1dEhGuIjdHUFcONzC/H79P7mkX6oWEBrt5dsmXEwjwdJZFxA95Qp93+XSDrWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785156865; c=relaxed/simple;
	bh=z2yDE/wsmJaLC1/fXDBaHmQfLX7MDuQvV5ukBNMG5+c=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=m0mOwcTtnB0AyBts8Ryw8dTzFE1YOiWT5kcFLiqf2wB2VYLc6gvj4hCbQnhKX8lOYDekwxX5L5xRcFaKVul1hlsAbxXJaWY1hsfwayKe/Sm7WOGQLazdrVK28wfDrcxJnzXvB1Ft9BG81ld4cuNv4h+vC5VBrRK0uyEAqBM2+UY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QxBgK8Gb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QxBgK8Gb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 956881F000E9;
	Mon, 27 Jul 2026 12:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785156864;
	bh=QmX0mWqwjE6mQk0qp4/I2+NqibALg+g/HqN4lQN0w1I=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=QxBgK8GbUqZaVHVCV2DKsVNjj6JgnYwiAjt9RXZmSCubIqyBaW2eqWuJxmn1fL7ds
	 F67aSuh9uiwgDkis2QyTubCP/TWTC2MPzqYmUYtim0acfnb3pp4cPMdnK0ZL7W9YTQ
	 atouz1vrmm7y09ACKqd90S7JysK2Vpy9ASMAR0buEp94/RC+QQHYWDHtHftVzUXE4w
	 IlQIB34XMt7kGFa4dg0gLzREwezRW0JHgFprNyLZbTxQyTDl2oP/CgOoasQ/b3yAgd
	 rePiHPGiX5JSJTuO5gfF+hqMYuLj++Y1K8vb2+DZmy/c4WnSGW4BJzkCotNNwuBkVG
	 uqIDNWYHPBVIw==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Mon, 27 Jul 2026 14:53:59 +0200
Subject: [PATCH v3 05/13] mm/slab: abstract slabobj_ext.objcg access
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260727-b4-objext_split-v3-5-c29ef0f1f257@kernel.org>
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

In preparation for changes to the structure, abstract getting and
setting the objcg field with slab_obj_ext_objcg() and
slab_obj_ext_set_objcg().
Rename the field to _objcg to make an unexpected direct access a compile
error.

No functional change intended.

Reviewed-by: Hao Li <hao.li@linux.dev>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/kfence/core.c |  2 +-
 mm/memcontrol.c  | 14 ++++++++------
 mm/slab.h        | 15 ++++++++++++++-
 mm/slub.c        |  2 +-
 4 files changed, 24 insertions(+), 9 deletions(-)

diff --git a/mm/kfence/core.c b/mm/kfence/core.c
index 6577bd76954e..05b5482c8150 100644
--- a/mm/kfence/core.c
+++ b/mm/kfence/core.c
@@ -1249,7 +1249,7 @@ void __kfence_free(void *addr)
 	struct kfence_metadata *meta = addr_to_metadata((unsigned long)addr);
 
 #ifdef CONFIG_MEMCG
-	KFENCE_WARN_ON(meta->obj_exts.objcg);
+	KFENCE_WARN_ON(slab_obj_ext_objcg(&meta->obj_exts));
 #endif
 	/*
 	 * If the objects of the cache are SLAB_TYPESAFE_BY_RCU, defer freeing
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 4e427286a88a..cb1e97b4edc1 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2865,6 +2865,7 @@ struct mem_cgroup *mem_cgroup_from_obj_slab(struct slab *slab, void *p)
 	 */
 	unsigned long obj_exts;
 	struct slabobj_ext *obj_ext;
+	struct obj_cgroup *objcg;
 
 	obj_exts = slab_obj_exts(slab);
 	if (!obj_exts)
@@ -2872,9 +2873,8 @@ struct mem_cgroup *mem_cgroup_from_obj_slab(struct slab *slab, void *p)
 
 	get_slab_obj_exts(obj_exts);
 	obj_ext = slab_obj_ext(slab->slab_cache, slab, obj_exts, p);
-	if (obj_ext->objcg) {
-		struct obj_cgroup *objcg = obj_ext->objcg;
-
+	objcg = slab_obj_ext_objcg(obj_ext);
+	if (objcg) {
 		put_slab_obj_exts(obj_exts);
 		return obj_cgroup_memcg(objcg);
 	}
@@ -3614,8 +3614,10 @@ bool __memcg_slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
 		obj_exts = slab_obj_exts(slab);
 		get_slab_obj_exts(obj_exts);
 		obj_ext = slab_obj_ext(s, slab, obj_exts, p[i]);
+
 		obj_cgroup_get(objcg);
-		obj_ext->objcg = objcg;
+		slab_obj_ext_set_objcg(obj_ext, objcg);
+
 		put_slab_obj_exts(obj_exts);
 	}
 
@@ -3633,11 +3635,11 @@ void __memcg_slab_free_hook(struct kmem_cache *s, struct slab *slab,
 		struct obj_stock_pcp *stock;
 
 		obj_ext = slab_obj_ext(s, slab, obj_exts, p[i]);
-		objcg = obj_ext->objcg;
+		objcg = slab_obj_ext_objcg(obj_ext);
 		if (!objcg)
 			continue;
 
-		obj_ext->objcg = NULL;
+		slab_obj_ext_set_objcg(obj_ext, NULL);
 
 		stock = trylock_stock();
 		__refill_obj_stock(objcg, stock, obj_size, true);
diff --git a/mm/slab.h b/mm/slab.h
index 451b50b7f237..1e4f61607448 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -555,7 +555,7 @@ static inline bool need_kmalloc_no_objext(void)
  */
 struct slabobj_ext {
 #ifdef CONFIG_MEMCG
-	struct obj_cgroup *objcg;
+	struct obj_cgroup *_objcg;
 #endif
 #ifdef CONFIG_MEM_ALLOC_PROFILING
 	union codetag_ref ref;
@@ -662,6 +662,19 @@ slab_obj_ext(struct kmem_cache *s, struct slab *slab, unsigned long obj_exts,
 	return kasan_reset_tag(obj_ext);
 }
 
+#ifdef CONFIG_MEMCG
+static inline struct obj_cgroup *slab_obj_ext_objcg(struct slabobj_ext *obj_ext)
+{
+	return obj_ext->_objcg;
+}
+
+static inline void slab_obj_ext_set_objcg(struct slabobj_ext *obj_ext,
+					  struct obj_cgroup *objcg)
+{
+	obj_ext->_objcg = objcg;
+}
+#endif
+
 int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
 			gfp_t gfp, unsigned int alloc_flags);
 
diff --git a/mm/slub.c b/mm/slub.c
index a74f1866c958..2bf38fb1a3f0 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2526,7 +2526,7 @@ bool memcg_slab_post_charge(void *p, gfp_t flags)
 	if (obj_exts) {
 		get_slab_obj_exts(obj_exts);
 		obj_ext = slab_obj_ext(s, slab, obj_exts, p);
-		if (unlikely(obj_ext->objcg)) {
+		if (unlikely(slab_obj_ext_objcg(obj_ext))) {
 			put_slab_obj_exts(obj_exts);
 			return true;
 		}

-- 
2.55.0

