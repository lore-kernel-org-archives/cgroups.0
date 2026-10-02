Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8A5C44AB60;
	Fri,  2 Oct 2026 23:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790982695; cv=none; b=OvOdhZQimz+LWSLmnwXBXGmNmEcizlvW734pvuu2weApxkekqK8cAe2XaRUxZnfihBp9ENILiR0RcJl1405KoD05j3K7g7jVYfiB4Se3nrT5aNj3L8ZsUUgHGB1tChnYzzBZzuZ1PDwjUONPeZOvr5vaaVhL2TysBUI3oK/nmJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790982695; c=relaxed/simple;
	bh=IvyaYk2+Iu7NIXTrpa0hYRhQGrcYMHvNwlOs/GE8Uyw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OVYAF1DSFEphFd7U5CY4QeCfmZ4ruOQT0HKWR5ECPpViSigEJxNV1VP5ppr6pumNQ+LkSosoj3/heYgOTluJWB8kqN/mXyfdRF2R5/N+7hcX76HfjbFF2GdTgucblrE0hLd8PEnocFEhTgOcHR78KUbJJssL2AhyM6k9oymRpIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XpAS0XK9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XpAS0XK9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 363DD1F00899;
	Fri,  2 Oct 2026 23:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790982693;
	bh=ck6iL+D5JVu4WQzD8eBQ/ax4Rj5EDM29htDBOrwkdSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XpAS0XK9fdAVVra2THzqk4YxwBSgGi3chiGMstxoTGB9pz8nIdeSusKWnNk+umHzX
	 lzIT+lz4iwF/U40t/BTKrKXGb+Bn5QHcUsTnbkbEDg/tuLXhx3sxaAJ1AXPKieyKOz
	 E/tiBX/uPnrL/EfIkOS/Kyw/Wg1sSLJDSY3hk9Ed9pgdkhOYHbsmTMm0MGYyknwuQ3
	 LQIWlLpnc9DTGL80ALGerdob7oDFUNvSTxR0E/cLtEa2mIpsZARP548p/C3MuU8JDa
	 zHxLu63E9sRwg3fv7F8bGn+G+hsen8i7JjRzt1Qyn++v90a60a67xHjmGRLCA+dMWE
	 eET0PH0MJ041g==
From: Kees Cook <kees@kernel.org>
To: Vlastimil Babka <vbabka@kernel.org>
Cc: Kees Cook <kees@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	linux-mm@kvack.org,
	Pedro Falcato <pfalcato@suse.de>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	linux-hardening@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Mina Almasry <almasrymina@google.com>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH net-next v5 3/7] mm/slab: Add kmem_buckets_destroy()
Date: Fri,  2 Oct 2026 16:11:23 -0700
Message-Id: <20261002231132.1646573-3-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261002231120.late.500-kees@kernel.org>
References: <20261002231120.late.500-kees@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4267; i=kees@kernel.org; h=from:subject; bh=IvyaYk2+Iu7NIXTrpa0hYRhQGrcYMHvNwlOs/GE8Uyw=; b=owGbwMvMwCVmps19z/KJym7G02pJDFkHrOTicsW01boNfb6oKrkouiTP+XlfzpotX/3Ghs69n Mf3Gup1lLIwiHExyIopsgTZuce5eLxtD3efqwgzh5UJZAgDF6cATKRyJcNv9sc/FSY3ZBXsXRIW /0d71cKjnSxpXBY2N3ym5ly8aivvzfBX0ubsoxqNqwuPVrpduhf1fxX/67eLnnQxrp1a55Tx4P5 GNgA=
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit

kmem_buckets_create() intentionally had no "destroy" counterpart. Every
caller has lived in core kernel code and creates its set once at boot,
so nothing has needed to take one down. However, KUnit tests may be
built module, so we need it now to support the coming tests.

Some caches have size aliases, so the same pointer is stored at more
then one index, so we have to save it, clear all matching instances, and
then free the saved cache pointer. (This is what the bitmap was tracking
before in the "allocation failed" error path.)

When CONFIG_SLAB_BUCKETS=n the whole body compiles away, matching the
ZERO_SIZE_PTR that kmem_buckets_create() hands back in that configuration.

Link: https://lore.kernel.org/all/20240809073309.2134488-1-kees@kernel.org/
Assisted-by: LLM
Signed-off-by: Kees Cook <kees@kernel.org>
---
 include/linux/slab.h |  1 +
 mm/slab_common.c     | 49 +++++++++++++++++++++++++++++++++++++-------
 2 files changed, 43 insertions(+), 7 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index 94709e4e14f3..4e6e74b3a990 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -894,6 +894,7 @@ kmem_buckets *kmem_buckets_create(const char *name, unsigned int align,
 				  slab_flags_t flags,
 				  unsigned int useroffset, unsigned int usersize,
 				  void (*ctor)(void *));
+void kmem_buckets_destroy(kmem_buckets *bucket);
 
 /*
  * Bulk allocation and freeing operations. These are accelerated in an
diff --git a/mm/slab_common.c b/mm/slab_common.c
index 301f3d4f4ca2..d66e5e56a0f1 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -438,12 +438,9 @@ kmem_buckets *kmem_buckets_create(const char *name, unsigned int align,
 				  unsigned int usersize,
 				  void (*ctor)(void *))
 {
-	unsigned long mask = 0;
 	unsigned int idx;
 	kmem_buckets *b;
 
-	BUILD_BUG_ON(ARRAY_SIZE(kmalloc_caches[KMALLOC_NORMAL]) > BITS_PER_LONG);
-
 	/*
 	 * When the separate buckets API is not built in, just return
 	 * a non-NULL value for the kmem_buckets pointer, which will be
@@ -497,7 +494,6 @@ kmem_buckets *kmem_buckets_create(const char *name, unsigned int align,
 			kfree(cache_name);
 			if (WARN_ON(!(*b)[aligned_idx]))
 				goto fail;
-			set_bit(aligned_idx, &mask);
 		}
 		if (idx != aligned_idx)
 			(*b)[idx] = (*b)[aligned_idx];
@@ -506,14 +502,53 @@ kmem_buckets *kmem_buckets_create(const char *name, unsigned int align,
 	return b;
 
 fail:
-	for_each_set_bit(idx, &mask, ARRAY_SIZE(kmalloc_caches[KMALLOC_NORMAL]))
-		kmem_cache_destroy((*b)[idx]);
-	kmem_cache_free(kmem_buckets_cache, b);
+	kmem_buckets_destroy(b);
 
 	return NULL;
 }
 EXPORT_SYMBOL(kmem_buckets_create);
 
+/**
+ * kmem_buckets_destroy - Destroy a set of caches made by kmem_buckets_create()
+ * @bucket: The set to destroy, which may be NULL.
+ *
+ * Destroys each cache in @bucket and then frees @bucket itself. As for
+ * kmem_cache_destroy(), every object allocated from @bucket must have been
+ * freed beforehand, and @bucket must not be used afterwards.
+ *
+ * Context: Process context. May sleep, as kmem_cache_destroy() takes the
+ *	    slab mutex and can wait on RCU callbacks for each cache.
+ */
+void kmem_buckets_destroy(kmem_buckets *bucket)
+{
+	unsigned int idx, i;
+
+	if (!IS_ENABLED(CONFIG_SLAB_BUCKETS) || ZERO_OR_NULL_PTR(bucket))
+		return;
+
+	for (idx = 0; idx < ARRAY_SIZE(kmalloc_caches[KMALLOC_NORMAL]); idx++) {
+		struct kmem_cache *cache = (*bucket)[idx];
+
+		if (!cache)
+			continue;
+
+		/*
+		 * Sizes below arch_slab_minalign() share one cache, which
+		 * kmem_buckets_create() then stores at each of their indices.
+		 * Drop every reference to it before destroying it, so that no
+		 * later pass reads a pointer to a cache that is already gone.
+		 */
+		for (i = idx; i < ARRAY_SIZE(kmalloc_caches[KMALLOC_NORMAL]); i++)
+			if ((*bucket)[i] == cache)
+				(*bucket)[i] = NULL;
+
+		kmem_cache_destroy(cache);
+	}
+
+	kmem_cache_free(kmem_buckets_cache, bucket);
+}
+EXPORT_SYMBOL(kmem_buckets_destroy);
+
 /*
  * For a given kmem_cache, kmem_cache_destroy() should only be called
  * once or there will be a use-after-free problem. The actual deletion
-- 
2.34.1

