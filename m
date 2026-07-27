Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05D1540C5A8;
	Mon, 27 Jul 2026 12:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785156885; cv=none; b=NZwnr1CsOde7xcMYSRkeba6LRMHUJg4+1QwigFS9Q6g8NNGIZUhNv0ScbhwsQ849G1n4G+N//otrtAMvYd5Wi5PpMD3EYtRxonahGZSkZgWEiXaRtlBihFrVWVb752ZO6hkj8sMrTlzrBLCWdosnsOUBjlFwDdecuDY9FN2dWt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785156885; c=relaxed/simple;
	bh=pXWCkdAuufpbNk/IY7skmoX2obU2mEeQAWtLRVL0D0I=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=fJVOo9jDlTxwB5cxO4IXgdMpJEOdvaxJqvo0hqLKpNIwau+tXuQJpNxBKjMmWAOCuDoIfTHFANUimvLmpTtqr4sZnLau8AHGN/RhzZ9wt0m5DtJ/ToEnFVFd0E60oGt90LGbyxb2SJT5VSlEOr15RT6Agq2jRjub62O4ECDujkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ys30gj9Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ys30gj9Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 207C21F00A3A;
	Mon, 27 Jul 2026 12:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785156883;
	bh=+4BVCCpRyh+dfWWWvFXt23rJMo2Z9fT7meHI+4y2h98=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Ys30gj9QzznigDITCv950Fj5OGVNRoPfLfjF65UT0E9VqQ3qZtoN/lP+BmUaoAqOk
	 laCjKQwsIafEHIhLIXk0roSQLIMgwWxg4FTZqFQC6eZOHraMABy9eiuBOoQeuzn4+M
	 ve5y8S0vOA+85zYc61MLt7EdCkxMbMXBWarWFpK9iy/ZSTOLH/m6llAPNAxthX4vxv
	 1qgpz/8/6SajJGwRjfTW5wlRryRUrMpuBQ1eE79VJC0UTFJCcjeqQAUb8nRkPxPniz
	 8Jr0ZmfWsjs0YGxzL3S+oNFKl8A2pABCjtWbiz4FXLF2NUNOwW7d90HPZAz5K8IAmB
	 scQaPgmxpJBLA==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Mon, 27 Jul 2026 14:54:05 +0200
Subject: [PATCH v3 11/13] mm/slab: add cache_ and slab_needs_objcg()
 helpers
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260727-b4-objext_split-v3-11-c29ef0f1f257@kernel.org>
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

Slabs of some caches never need the objcg part of struct slabobj_ext.
Introduce helpers to query this for a cache or a slab.

Introduce SLAB_MAY_ACCOUNT flag that is currently only internal and all
caches have it set except:

- KMALLOC_NORMAL caches, as long as KMALLOC_RECLAIM caches are separate
- KMALLOC_NO_OBJ_EXT caches, if they exist

For named caches we currently can't derive SLAB_MAY_ACCOUNT from
SLAB_ACCOUNT because some caches might be created without SLAB_ACCOUNT
and then used both with and without __GFP_ACCOUNT concurrently,
allocating obj_ext arrays on demand. So just add the SLAB_MAY_ACCOUNT
to all kmem caches, unless kmem accounting is disabled.

This can be improved later by finding out all caches used with
__GFP_ACCOUNT, creating them with the SLAB_MAY_ACCOUNT flag explicitly,
and then ignoring __GFP_ACCOUNT for all other caches (possibly with a
warning).

To make the evaluation of slab_needs_objcg() faster in the allocation
and free fast paths, add a obj_exts_needs_objcg flag into slab itself.
This optimization is only available on 64bit architectures where free
bits are available for the flag.

Reviewed-by: Hao Li <hao.li@linux.dev>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 include/linux/slab.h |  3 +++
 mm/kfence/core.c     |  3 +++
 mm/slab.h            | 31 +++++++++++++++++++++++++++++--
 mm/slab_common.c     | 26 +++++++++++++++++++++-----
 mm/slub.c            |  6 +++++-
 5 files changed, 61 insertions(+), 8 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index 32c9f8ed7ae2..e1915026e030 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -45,6 +45,7 @@ enum _slab_flag_bits {
 #endif
 #ifdef CONFIG_MEMCG
 	_SLAB_ACCOUNT,
+	_SLAB_MAY_ACCOUNT,
 #endif
 #ifdef CONFIG_KASAN_GENERIC
 	_SLAB_KASAN,
@@ -204,8 +205,10 @@ enum _slab_flag_bits {
  */
 #ifdef CONFIG_MEMCG
 # define SLAB_ACCOUNT		__SLAB_FLAG_BIT(_SLAB_ACCOUNT)
+# define SLAB_MAY_ACCOUNT	__SLAB_FLAG_BIT(_SLAB_MAY_ACCOUNT)
 #else
 # define SLAB_ACCOUNT		__SLAB_FLAG_UNUSED
+# define SLAB_MAY_ACCOUNT	__SLAB_FLAG_UNUSED
 #endif
 
 #ifdef CONFIG_KASAN_GENERIC
diff --git a/mm/kfence/core.c b/mm/kfence/core.c
index 05b5482c8150..897ecf2594fb 100644
--- a/mm/kfence/core.c
+++ b/mm/kfence/core.c
@@ -640,6 +640,9 @@ static unsigned long kfence_init_pool(void)
 		struct slab *slab = page_slab(page);
 		slab->obj_exts = (unsigned long)&kfence_metadata_init[i / 2 - 1].obj_exts |
 				 MEMCG_DATA_OBJEXTS;
+#ifdef CONFIG_64BIT
+		slab->obj_exts_needs_objcg = 1;
+#endif
 #endif
 	}
 
diff --git a/mm/slab.h b/mm/slab.h
index f86d4ed3f2be..ad2a3ef34ecf 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -81,10 +81,11 @@ struct freelist_counters {
 #ifdef CONFIG_64BIT
 					/*
 					 * Some optimizations use free bits in 'counters' field
-					 * to save memory. If these free bits are not available,
-					 * such optimizations are disabled.
+					 * to save memory or CPU. If these free bits are not
+					 * available, such optimizations are disabled.
 					 */
 					unsigned obj_exts_in_object:1;
+					unsigned obj_exts_needs_objcg:1;
 #endif
 				};
 			};
@@ -584,6 +585,32 @@ static inline bool slab_obj_ext_has_codetag(void)
 }
 #endif
 
+#ifdef CONFIG_MEMCG
+static inline bool cache_needs_objcg(struct kmem_cache *cache)
+{
+	return (cache->flags & SLAB_MAY_ACCOUNT);
+}
+
+static inline bool slab_needs_objcg(struct slab *slab)
+{
+#ifdef CONFIG_64BIT
+	return slab->obj_exts_needs_objcg;
+#else
+	return cache_needs_objcg(slab->slab_cache);
+#endif
+}
+#else
+static inline bool cache_needs_objcg(struct kmem_cache *cache)
+{
+	return false;
+}
+
+static inline bool slab_needs_objcg(struct slab *slab)
+{
+	return false;
+}
+#endif
+
 static inline size_t cache_obj_ext_size(struct kmem_cache *s)
 {
 	size_t sz = 0;
diff --git a/mm/slab_common.c b/mm/slab_common.c
index 03ecac12cd86..1e1d3feec353 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -52,7 +52,7 @@ struct kmem_cache *kmem_cache;
 		SLAB_OBJ_EXT_IN_OBJ)
 
 #define SLAB_MERGE_SAME (SLAB_RECLAIM_ACCOUNT | SLAB_CACHE_DMA | \
-			 SLAB_CACHE_DMA32 | SLAB_ACCOUNT)
+			 SLAB_CACHE_DMA32 | SLAB_ACCOUNT | SLAB_MAY_ACCOUNT)
 
 /*
  * Merge control. If this is set then no merging of slab caches will occur.
@@ -359,6 +359,13 @@ struct kmem_cache *__kmem_cache_create_args(const char *name,
 		goto out_unlock;
 	}
 
+	/*
+	 * For now we assume any cache can be used with __GFP_ACCOUNT and thus
+	 * may need to store objcg pointers for objects
+	 */
+	if (!mem_cgroup_kmem_disabled())
+		flags |= SLAB_MAY_ACCOUNT;
+
 	/* Fail closed on bad usersize of useroffset values. */
 	if (!IS_ENABLED(CONFIG_HARDENED_USERCOPY) ||
 	    WARN_ON(!args->usersize && args->useroffset) ||
@@ -984,11 +991,20 @@ new_kmalloc_cache(int idx, enum kmalloc_cache_type type)
 #endif
 
 	/*
-	 * If CONFIG_MEMCG is enabled, disable cache merging for
-	 * KMALLOC_NORMAL caches.
+	 * If memcg_kmem is enabled and this is a KMALLOC_NORMAL cache and not
+	 * aliased with any other type, make sure it's never merged with any other
+	 * cache.
+	 *
+	 * In other cases the kmalloc cache may end up being used for a
+	 * __GFP_ACCOUNT allocation so mark it as such. The exception is a
+	 * KMALLOC_NO_OBJ_EXT cache.
 	 */
-	if (IS_ENABLED(CONFIG_MEMCG) && (type == KMALLOC_NORMAL))
-		flags |= SLAB_NO_MERGE;
+	if (!mem_cgroup_kmem_disabled()) {
+		if (type == KMALLOC_NORMAL && KMALLOC_RECLAIM != KMALLOC_NORMAL)
+			flags |= SLAB_NO_MERGE;
+		else if (!(flags & SLAB_NO_OBJ_EXT))
+			flags |= SLAB_MAY_ACCOUNT;
+	}
 
 	if (minalign > ARCH_KMALLOC_MINALIGN) {
 		aligned_size = ALIGN(aligned_size, minalign);
diff --git a/mm/slub.c b/mm/slub.c
index 6050fc08d8ee..ccce1faac6de 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2555,7 +2555,7 @@ bool memcg_slab_post_charge(void *p, gfp_t flags)
 	 * of slab_obj_exts being allocated from the same slab and thus the slab
 	 * becoming effectively unfreeable.
 	 */
-	if (is_kmalloc_normal(s))
+	if (!cache_needs_objcg(s))
 		return true;
 
 	/* Ignore already charged objects. */
@@ -3433,6 +3433,10 @@ static struct slab *allocate_slab(struct kmem_cache *s, gfp_t flags,
 
 	slab->objects = oo_objects(oo);
 
+#ifdef CONFIG_64BIT
+	if (cache_needs_objcg(s))
+		slab->obj_exts_needs_objcg = 1;
+#endif
 	slab->slab_cache = s;
 
 	kasan_poison_slab(slab);

-- 
2.55.0

