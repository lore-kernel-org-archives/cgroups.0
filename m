Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E50D3B27F4;
	Tue,  6 Oct 2026 09:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791278439; cv=none; b=YUMEAcXpOsADHdPe677L0obsmBP9ui3QkUlUpFnI8FiqH9pDk0v2pwKcFPCZvggLvR8mrzty8x2qHQng721ve9F8y0uCMYgt9HoclvnfHzMAuZ9UkDxMtkvCbcyLUx4pAHkbNQ6fXANyRfruLsOI4IZgrle281s0nX5yOKUGU8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791278439; c=relaxed/simple;
	bh=dYx28s+IQ11OCGRHcWcMZU79ypXV2MF4t78CsqcAKhg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LWp2OVEsT4ERe+LN15a4Cqa+Bawkcb945zqdOWQUwr81q9Ig0i1gfRsfJbl5TBdAlgr6h1q8pwD1X3LGS/tTQbfKCTBtsikVBsZJu7l2yuLhZ//0pUf3KMjel8ha7QKB8mgMEqJAy+XKz6tAvpcKUZUSfkfhOBtvAQvfrAjF4wY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IrxZAqAk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IrxZAqAk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A2FE1F008A5;
	Tue,  6 Oct 2026 09:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791278436;
	bh=pwKbDoq6iSAvWzodLVAwDaQk8venNDlb5LaSpx0zjmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IrxZAqAkAnXAWdCx/BtUy1b63fNmD0zRoGFoBOtlw17uoMwWdPVRiHm1FTfe8nYY4
	 vVex+OpWoX120ae5VMv7lJYX/CxgnUYIAhdL67tVbXZGzrG3N9aY/1wIh1HKIoO9WD
	 hu4WEgLxxn1PHBBmiDcCDqiSMczxID/8n4FoakidgUw1Qkkl1U/4Ka8ulJg/A90RS7
	 RUpxYJd1GNj3QN2ahG+1c49TKbexUAh26d2Js+Q7Dfp87LXF4xm1Lhh7kQ+90OehoS
	 vONDkUCgJ9VXJ5CYYv9bPMT1CPqVQfZ6iJBcm57tFZ9loVRYAx0QvczbW07QVlK7+N
	 JKaIi0raaXzXQ==
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
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net-next v6 7/8] mm/slab: Provide kmalloc type fallback for bucket allocations
Date: Tue,  6 Oct 2026 02:20:33 -0700
Message-ID: <20261006092035.166776-7-kees@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261006092030.got.500-kees@kernel.org>
References: <20261006092030.got.500-kees@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6105; i=kees@kernel.org; h=from:subject; bh=dYx28s+IQ11OCGRHcWcMZU79ypXV2MF4t78CsqcAKhg=; b=owGbwMvMwCVmps19z/KJym7G02pJDFlH9iZuu9V5bNsHnpKqlo+9MiFL/ws+v7TyaSXvwtJ4v mr5iAN9HaUsDGJcDLJiiixBdu5xLh5v28Pd5yrCzGFlAhnCwMUpABOZvpvhn8GklrOLprGdZvjH mavMKCd3k3cql7TH/htOjenXJvW8LGH4Kyq7z44ztHwicxLjvzBphwRefr3Pnw+yhhT+WCZYwsT EDwA=
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit

kmem_buckets_create() clones kmalloc_caches[KMALLOC_NORMAL].
kmalloc_slab() figures out the kmalloc type the caller asks for, but
then ignored it whenever a bucket set was in use, returning a normal
cache regardless. That breaks an allocation that needs other pages: a
GFP_DMA allocation would not get memory from ZONE_DMA, and a
__GFP_RECLAIMABLE one would miss the reclaimable caches. None of the
current users do this, so there is no problem, but it makes adding new
users fragile. For example, skb data[1] needs to handle GFP_DMA (rarely).

Send those allocations to the general caches instead, so nothing breaks
and regular allocations remain isolated in the set. Accounted
allocations stay in the set: memcg charges each object on its own, in
any cache, so a bucket cache serves them as well as kmalloc-cg-* does.

Built and tests pass with ARCH=x86_64 defconfig with GCC 16.2.0, with
CONFIG_SLAB_BUCKETS as y and n, and with CONFIG_MEMCG as y, n, and y
with "cgroup.memory=nokmem".

Assisted-by: LLM
Link: https://lore.kernel.org/all/04debe19-bbe8-4b5f-9668-753d1f97832d@redhat.com/ [1]
Signed-off-by: Kees Cook <kees@kernel.org>
---
 mm/slab.h              | 19 +++++++++++--
 lib/tests/slub_kunit.c | 63 ++++++++++++++++++++++++++++++++++++++++++
 mm/slab_common.c       |  5 ++++
 3 files changed, 85 insertions(+), 2 deletions(-)

diff --git a/mm/slab.h b/mm/slab.h
index 8fd6835e4235..af39a4e47c9e 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -421,6 +421,22 @@ static inline unsigned int size_index_elem(unsigned int bytes)
 	return (bytes - 1) / 8;
 }
 
+/*
+ * Which set of buckets to use for the given kmalloc_cache_type. A bucket set
+ * mirrors the KMALLOC_NORMAL caches, and also serves accounted allocations:
+ * memcg charges each object on its own, in any cache. Types that need
+ * different pages (DMA, reclaimable) or no obj_exts fall back to the
+ * general caches.
+ */
+static inline kmem_buckets *
+kmalloc_choose_bucket(kmem_buckets *bucket, enum kmalloc_cache_type type)
+{
+	if (bucket && (type <= KMALLOC_PARTITION_END || type == KMALLOC_CGROUP))
+		return bucket;
+
+	return &kmalloc_caches[type];
+}
+
 /*
  * Find the kmem_cache structure that serves a given size of
  * allocation
@@ -438,8 +454,7 @@ kmalloc_slab(size_t size, kmem_buckets *b, gfp_t flags, kmalloc_token_t token,
 	if (alloc_flags & SLAB_ALLOC_NO_OBJ_EXT)
 		type = KMALLOC_NO_OBJ_EXT;
 
-	if (!b)
-		b = &kmalloc_caches[type];
+	b = kmalloc_choose_bucket(b, type);
 	if (size <= 192)
 		index = kmalloc_size_index[size_index_elem(size)];
 	else
diff --git a/lib/tests/slub_kunit.c b/lib/tests/slub_kunit.c
index a2a15a49c5d7..1e6fcbbf8409 100644
--- a/lib/tests/slub_kunit.c
+++ b/lib/tests/slub_kunit.c
@@ -697,6 +697,68 @@ static void test_kmem_buckets_destroy(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, 2, slab_errors);
 }
 
+/*
+ * A bucket set mirrors the normal kmalloc caches, which can serve accounted
+ * allocations too, so those stay in the set. An allocation that needs other
+ * pages (DMA or reclaimable) has to come from the general caches. Check that
+ * it does, rather than being served a cache that does not satisfy what the
+ * flags asked for.
+ */
+static void test_kmem_buckets_type_fallback(struct kunit *test)
+{
+	struct kmem_cache *c;
+	kmem_buckets *b;
+	void *p;
+
+	if (!IS_ENABLED(CONFIG_SLAB_BUCKETS))
+		kunit_skip(test, "needs CONFIG_SLAB_BUCKETS");
+
+	b = kmem_buckets_create("test_buckets", 0, INT_MAX);
+	KUNIT_ASSERT_BUCKETS_CREATED(test, b);
+
+	/* A plain allocation stays isolated in the bucket set. */
+	p = kmem_buckets_alloc(b, 128, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, p);
+	c = cache_of(p);
+	kfree(p);
+	KUNIT_ASSERT_NOT_NULL(test, c);
+
+	KUNIT_EXPECT_TRUE_MSG(test, strstarts(c->name, "test_buckets-"),
+			      "expected a bucket cache, got %s", c->name);
+
+	/* One that needs ZONE_DMA cannot, so it falls back. */
+	if (IS_ENABLED(CONFIG_ZONE_DMA)) {
+		p = kmem_buckets_alloc(b, 128, GFP_KERNEL | GFP_DMA);
+		KUNIT_ASSERT_NOT_NULL(test, p);
+		c = cache_of(p);
+		kfree(p);
+		KUNIT_ASSERT_NOT_NULL(test, c);
+
+		KUNIT_EXPECT_TRUE_MSG(test, strstarts(c->name, "dma-kmalloc-"),
+				      "expected a DMA cache, got %s", c->name);
+	}
+
+	/* Nor can one that is reclaimable. */
+	p = kmem_buckets_alloc(b, 128, GFP_KERNEL | __GFP_RECLAIMABLE);
+	KUNIT_ASSERT_NOT_NULL(test, p);
+	c = cache_of(p);
+	kfree(p);
+	KUNIT_ASSERT_NOT_NULL(test, c);
+
+	KUNIT_EXPECT_TRUE_MSG(test, strstarts(c->name, "kmalloc-rcl-"),
+			      "expected a reclaimable cache, got %s", c->name);
+
+	/* An accounted allocation stays in the set; memcg charges it there. */
+	p = kmem_buckets_alloc(b, 128, GFP_KERNEL | __GFP_ACCOUNT);
+	KUNIT_ASSERT_NOT_NULL(test, p);
+	c = cache_of(p);
+	kfree(p);
+	KUNIT_ASSERT_NOT_NULL(test, c);
+
+	KUNIT_EXPECT_TRUE_MSG(test, strstarts(c->name, "test_buckets-"),
+			      "expected a bucket cache, got %s", c->name);
+}
+
 static struct kunit_case test_cases[] = {
 	KUNIT_CASE(test_clobber_zone),
 
@@ -723,6 +785,7 @@ static struct kunit_case test_cases[] = {
 	KUNIT_CASE(test_kmem_buckets_alignment),
 	KUNIT_CASE(test_kmem_buckets_disabled),
 	KUNIT_CASE(test_kmem_buckets_destroy),
+	KUNIT_CASE(test_kmem_buckets_type_fallback),
 	{}
 };
 
diff --git a/mm/slab_common.c b/mm/slab_common.c
index fb1dd15953a7..6fa02b4ff775 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -420,6 +420,11 @@ static struct kmem_cache *kmem_buckets_cache __ro_after_init;
  * @usersize: How many bytes, starting at @useroffset, may be copied
  *		to/from userspace.
  *
+ * Accounted (__GFP_ACCOUNT) allocations are served by the set like any
+ * other. Allocations that need DMA or reclaimable memory are served by the
+ * general kmalloc caches instead, without the set's isolation or usercopy
+ * region.
+ *
  * Context: Cannot be called within an interrupt, but can be interrupted.
  *
  * Return: a pointer to the cache on success, NULL on failure. When
-- 
2.55.0

