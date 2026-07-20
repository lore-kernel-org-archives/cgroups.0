Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74B4842A17B;
	Mon, 20 Jul 2026 14:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784557008; cv=none; b=pfrskSaKJP4BMhWN9j4u73Uu+xMNYcmRQhmh/qOVcIRRPnwPqrJH9OzQM3KTuHvOcDjAaEyeDoDZjAuQgYtaSnUoZ0iHBTsZrq+5MMqzpeV9aI32x8AK+htubPc9QXflGQg4Ca9NIkhvFaZqNBRLX+U76MK0vkIAo2VdfrTZADU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784557008; c=relaxed/simple;
	bh=mcQgvQ3H084hVOKFHe4mvrHFvcTIirhGDX/vYCPlAwk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Z9nrDfzXovZhytBqsEvIzEq9OmruWqahVowH7G6pJsqWlEr8Kl8PNJO+fE+wv0mPc943GCX9uF4Ca3tHylpG+XnsuMzeCVTNr3FRP/zasSSlNSGxzcQ0J44mKo/BpW+uxsIw83YAHrFPv29s6eppldGqJYjDGoKjhuqYujeHRgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O6IlCXMd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O6IlCXMd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D66F1F00A3A;
	Mon, 20 Jul 2026 14:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784557007;
	bh=D3U54YmCRY/GBvsj3bANv9/dOilD8BR4I8e1Q/zY4xQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=O6IlCXMdef44TD7zJDcvT/iuRPSZckHKHRWd2siui/LxQAjoo18KmQMbMT4tgXl1Q
	 1X5kY0W9M7JYIxRhNTGXKCEnC5UX2HkNMjlBvC6arD+edzA/ECMxxPXTLp8X49UX1X
	 9rG1xY2R069IV3CexOp8B1LPpZtquCZu49DQdp5FI72jor3t6olgYxL3klKFc+7Ivn
	 sJgOjcCx8hnR7a4ZBe+GPek4JDGE2hScWhpZKI6dU+iwzwoyU0aCcaxJf2q5uYwF62
	 cJ4jGLvHqKi94GnJMWMn19jujSokl6DzGH4mCi+hjXVb9Wyxydr1tXjstWaMdzyhJt
	 BbwufI9yG6TWA==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Mon, 20 Jul 2026 16:16:20 +0200
Subject: [PATCH v2 06/13] mm/slab: abstract slabobj_ext.objcg access
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-b4-objext_split-v2-6-2fa7c6f60dbe@kernel.org>
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

In preparation for changes to the structure, abstract getting and
setting the objcg field with slab_obj_ext_objcg() and
slab_obj_ext_set_objcg().
Rename the field to _objcg to make an unexpected direct access a compile
error.

No functional change intended.

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
index 64cec02b5016..1d1771f97aca 100644
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
index aa99d7eb6a4d..f2ffadde879d 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2529,7 +2529,7 @@ bool memcg_slab_post_charge(void *p, gfp_t flags)
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

