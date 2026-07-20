Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 249FC42BC41;
	Mon, 20 Jul 2026 14:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784556999; cv=none; b=Eww23q/KjjltUHMvioSVrrLLuFqjRWtGHwRoQDJ1g+PQba0tOvzH61lwcH/E5UR99Ox6vKKQI3E+fpoyLOPiU5fAC7+GBzf+LkIAYE5vFQCQ6tvj06F4LZaEyOF1AN1kDd/8fH6upaDMSddTEa7W+7yhHze+wAX6Di3S9xnxAE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784556999; c=relaxed/simple;
	bh=7lLFWB0Z3ynMsd8fncbOQ0vGhyyoswKScm3rzh7pxL4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ZLD3D/wcuiXAW6MiFoBypAh2NYXmWI5oCi7txAlg1DSGJN3sDHBUzcdjmqVH/UmV5YRCpOWWvK2LMiqm7PM2Qr0uS0G3ZGvM+brXSZfQKDgwQbQPM4Yqnck7AsBZi44YJcfayWQ0JxHbz1Vj1sTjRJo8jXaugiz//SXvOZiouNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BvaFlNqC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BvaFlNqC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 603041F00A3A;
	Mon, 20 Jul 2026 14:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784556998;
	bh=S3cjoXT+ctO1xn/lt8vvk/EJQ8UQyUkXc5d7Z/bIJ8Y=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=BvaFlNqCT3zRcpj5gpCsMysl7f1Z5x6KlIqglS3wL8dE7fDb4vfljJG69QgDI5aMG
	 irsjdWDIFR4nZ5vEOphUnEvvRpnatSwcD3L+tSFQxnLwyibGDXScYKQP9xw505CO+z
	 H0hbacgYBv9pURgI5jYIqD0qCXg5IiLDVdbPZgl3HguYxKGLm94s21tsc+ci5YagvQ
	 4J/mFiiJEZsj4PhXu94EfmM980cNBnzjoVjbDPS4Mt3jztWUM66oaQoOTqrHgVe9/e
	 SiDqHSdH5SqzgWyksDDDO61RgEpDbwIU+Bi9S9P8fZ0Yt/lbMKgsA3tCmHspiFJhGx
	 MDLFUHVSnvi9g==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Mon, 20 Jul 2026 16:16:17 +0200
Subject: [PATCH v2 03/13] mm/slab: remove objs_per_slab()
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260720-b4-objext_split-v2-3-2fa7c6f60dbe@kernel.org>
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

The function has an unused kmem_cache argument and almost nothing uses
it anyway; doing slab->objects is simpler. Remove it with the last two
users. KUNIT_EXPECT_EQ() needs a cast to avoid "error: ‘typeof’ applied
to a bit-field" but we don't need to keep a wrapper just for that.

Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/kfence/kfence_test.c | 2 +-
 mm/slab.h               | 6 ------
 mm/slub.c               | 3 +--
 3 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/mm/kfence/kfence_test.c b/mm/kfence/kfence_test.c
index de2d0f7d62b1..9867c03ef0ae 100644
--- a/mm/kfence/kfence_test.c
+++ b/mm/kfence/kfence_test.c
@@ -295,7 +295,7 @@ static void *test_alloc(struct kunit *test, size_t size, gfp_t gfp, enum allocat
 			 * memcg accounting works correctly.
 			 */
 			KUNIT_EXPECT_EQ(test, obj_to_index(s, slab, alloc), 0U);
-			KUNIT_EXPECT_EQ(test, objs_per_slab(s, slab), 1);
+			KUNIT_EXPECT_EQ(test, ((unsigned int)slab->objects), 1);
 
 			if (policy == ALLOCATE_ANY)
 				return alloc;
diff --git a/mm/slab.h b/mm/slab.h
index f5e336b6b6b0..01535e1e2d3c 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -330,12 +330,6 @@ static inline unsigned int obj_to_index(const struct kmem_cache *cache,
 	return __obj_to_index(cache, slab_address(slab), obj);
 }
 
-static inline int objs_per_slab(const struct kmem_cache *cache,
-				const struct slab *slab)
-{
-	return slab->objects;
-}
-
 /*
  * State of the slab allocator.
  *
diff --git a/mm/slub.c b/mm/slub.c
index 95fa6fbad11a..8c1031989e41 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2133,7 +2133,6 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
 			gfp_t gfp, unsigned int alloc_flags)
 {
 	const bool allow_spin = alloc_flags_allow_spinning(alloc_flags);
-	unsigned int objects = objs_per_slab(s, slab);
 	bool new_slab = alloc_flags & SLAB_ALLOC_NEW_SLAB;
 	unsigned long new_exts;
 	unsigned long old_exts;
@@ -2189,7 +2188,7 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
 #endif
 retry:
 	old_exts = READ_ONCE(slab->obj_exts);
-	handle_failed_objexts_alloc(old_exts, vec, objects);
+	handle_failed_objexts_alloc(old_exts, vec, slab->objects);
 
 	if (new_slab) {
 		/*

-- 
2.55.0

