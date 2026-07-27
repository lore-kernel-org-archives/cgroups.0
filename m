Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44AD940D56A;
	Mon, 27 Jul 2026 12:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785156888; cv=none; b=m7EJGBGnolhLok2esXA3sgWdq5fhRzRvHIndoLL7iTW2citUMumQjSWYUEJghTesAGmAZjF4A9tiVEWe9aIb0FYeaJxMFDgSP0ontU2HN9gm3IWFFJ6E+ZQUGPuvVWFMavfsFMZ9UK6JDP5S0Z6DBA3OGrzScvNUbYTC7dV00j8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785156888; c=relaxed/simple;
	bh=v6fVsIeCzU5YwU3G0Ime3MVsEnI7Vu82K3kzA+MYT7s=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Fr7Ltl8dTN9E0/+QSzTZuxjndw02H+YbCx63fXwkjb0jzq1fWUuTcCV3Wp6On6Oc0yiVUodDoCHYuWde8R8aqjxDUBKaONtfxez0evWHkj/MO5aVjAu3s4PSHOc8IyJw40szksMZxmgq8s6DrSnn81Neg+zflB7WMVlHdvVz2+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UT7XURPD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UT7XURPD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E2331F000E9;
	Mon, 27 Jul 2026 12:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785156887;
	bh=aGp6l8pNN7WNTKPcSeBuJWHpMtYin9pxGaKm+CCO6NI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=UT7XURPD6WCdpFBPaFw97mhbwUjd9PlShAr2/GsEXCn6ZQh3B9XiB9E22vOm4iesl
	 Vbf1p/lY+Co8LPi/Q/RkejFT+I21fLFAAzodxDPTiMH4YuGfNeYg2z3HW0bXySVvKi
	 hzRBlObSeVnYzdDsMnp8kAXqgVFQOgI7pKaUzHLpIZ0qvA/46d2neIIuh4DKsQQlr+
	 p2w+SF+jXNMvy17CPh0CkCWPlAPXdZIL69lsJivvKAxf0YQHMVHLW9hGrWYoiqaZi2
	 yD1NfKPSSWCi9jdgPzVj+l6xXtkM0F07i5WU5brohR54OzTPBMX7WtrzOAGH8K+Jm7
	 fudr5KIAb0C2A==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Mon, 27 Jul 2026 14:54:06 +0200
Subject: [PATCH v3 12/13] mm/slab: stop allocating objcg pointers when
 unnecessary
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260727-b4-objext_split-v3-12-c29ef0f1f257@kernel.org>
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

Start using the slab_needs_objcg() helper to calculate slabobj_ext size.
Caches that we know to never need objcg pointers (currently
KMALLOC_NORMAL caches) will thus stop wasting memory on them when memory
allocation profiling is enabled.

For things to work properly, we need to also add slab_needs_objcg()
checks to mem_cgroup_from_obj_slab() and memcg_slab_free_hook(), because
when obj_exts array exists for a slab only due to mem_alloc profiling,
we would otherwise attempt to access a non-existing objcg pointer in
that slab.

The function __memcg_slab_post_alloc_hook() should not be possible to
call for a slab where slab_needs_objcg() is false, but add a DEBUG_VM
check there to prevent breaking this assumption accidentally.

Reviewed-by: Hao Li <hao.li@linux.dev>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/memcontrol.c |  6 ++++++
 mm/slab.h       | 14 +++++++++++---
 mm/slub.c       |  3 +++
 3 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index cb1e97b4edc1..aace85fb99f9 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2871,6 +2871,9 @@ struct mem_cgroup *mem_cgroup_from_obj_slab(struct slab *slab, void *p)
 	if (!obj_exts)
 		return NULL;
 
+	if (!slab_needs_objcg(slab))
+		return NULL;
+
 	get_slab_obj_exts(obj_exts);
 	obj_ext = slab_obj_ext(slab->slab_cache, slab, obj_exts, p);
 	objcg = slab_obj_ext_objcg(obj_ext);
@@ -3580,6 +3583,9 @@ bool __memcg_slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
 
 		slab = virt_to_slab(p[i]);
 
+		if (IS_ENABLED(CONFIG_DEBUG_VM) && WARN_ON_ONCE(!slab_needs_objcg(slab)))
+			continue;
+
 		if (!slab_obj_exts(slab) &&
 		    alloc_slab_obj_exts(slab, s, flags, slab_alloc_flags)) {
 			continue;
diff --git a/mm/slab.h b/mm/slab.h
index ad2a3ef34ecf..44f9b2569e80 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -615,7 +615,7 @@ static inline size_t cache_obj_ext_size(struct kmem_cache *s)
 {
 	size_t sz = 0;
 
-	if (IS_ENABLED(CONFIG_MEMCG))
+	if (cache_needs_objcg(s))
 		sz += 1;
 
 	if (slab_obj_ext_has_codetag())
@@ -626,7 +626,15 @@ static inline size_t cache_obj_ext_size(struct kmem_cache *s)
 
 static inline size_t slab_obj_ext_size(struct slab *slab)
 {
-	return cache_obj_ext_size(slab->slab_cache);
+	size_t sz = 0;
+
+	if (slab_needs_objcg(slab))
+		sz += 1;
+
+	if (slab_obj_ext_has_codetag())
+		sz += 1;
+
+	return sizeof(struct slabobj_ext) * sz;
 }
 
 #ifdef CONFIG_SLAB_OBJ_EXT
@@ -753,7 +761,7 @@ static inline void slab_obj_ext_set_objcg(struct slabobj_ext *obj_ext,
 static inline union codetag_ref *
 slab_obj_ext_codetag_ref(struct slab *slab, struct slabobj_ext *obj_ext)
 {
-	if (IS_ENABLED(CONFIG_MEMCG))
+	if (slab_needs_objcg(slab))
 		obj_ext += 1;
 
 	return &obj_ext->_ctref;
diff --git a/mm/slub.c b/mm/slub.c
index ccce1faac6de..893a11abcc20 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2510,6 +2510,9 @@ void memcg_slab_free_hook(struct kmem_cache *s, struct slab *slab, void **p,
 	if (likely(!obj_exts))
 		return;
 
+	if (!slab_needs_objcg(slab))
+		return;
+
 	get_slab_obj_exts(obj_exts);
 	__memcg_slab_free_hook(s, slab, p, objects, obj_exts);
 	put_slab_obj_exts(obj_exts);

-- 
2.55.0

