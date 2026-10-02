Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A1D94BE443;
	Fri,  2 Oct 2026 23:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790982697; cv=none; b=D9lkZP9k7SN/bwPjlrk9LCKCo/gdlH2a7BVEbzxCK61dhS0RWMuyxCMz+TDKanpMBCFrIDOq/TO6TmQs+BAq/WKAxtUb+Ohtm0Lk1wSWPB7yWAnx61YnI0RHm/LUjEU16/iWuAtSLOCXyb0bSnZSYsnOapIbbhIio126x+QQ8uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790982697; c=relaxed/simple;
	bh=z00tVO9g3OOSah3DzLbtuc/3xhCOULMjAScqpSWaGq0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RIk3RFQQY/FUocR5IKGsj7EuaIJg6SRG/rHblmCzvW+bOyKvZw6iZqLCNAYUl9gPsmFlmsExTs5/RBbGNrceSQPs9clr4JBlr6N9t+Z8WFZOfedTV8ixVMdpo0rPpOaOkK3/n9Y/lp3ZUfNYLp2k1/xZOfV7cN6fg28NWmA9JJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AKCiz74Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AKCiz74Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F8CD1F00A07;
	Fri,  2 Oct 2026 23:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790982693;
	bh=XZJMHFQd9VPup6SOQJ7R6J2VWJxgyBT6HgyoAS2ZWmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AKCiz74QrWEPSV2fEOpEsFUmQAXMsJwTg8d5FqSJkSYXcnJUhMOVEo2edysAf8QQO
	 yiGEyVngkOHY4nOOZ5qn1wmM7PMSEE57WhHBq/UQMmvJqJ+94wp8avPlDs+FWOoWhm
	 G70mSm/mIYmYjDB+WDr9hEBPpOY6hbFpmzbk7BJHD8YubigjJhbSDRzaZokSsaeyIe
	 BH+Qt1QKqIACD0ayKZog5UrI2ZJ85qwCDXT8R5bgls2YbvqEA831QYyFpu3dhdbVZt
	 8PcIw7lSoPXabWGsb5XmIk6Ox16Rr0+slbouWc9ER/cd5AVIZWHhcqNdw+ptXYSyhP
	 6DWcwg0LRc6zA==
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
Subject: [PATCH net-next v5 6/7] mm/slab: Let a bucket set handle __GFP_ACCOUNT
Date: Fri,  2 Oct 2026 16:11:26 -0700
Message-Id: <20261002231132.1646573-6-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261002231120.late.500-kees@kernel.org>
References: <20261002231120.late.500-kees@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=19438; i=kees@kernel.org; h=from:subject; bh=z00tVO9g3OOSah3DzLbtuc/3xhCOULMjAScqpSWaGq0=; b=owGbwMvMwCVmps19z/KJym7G02pJDFkHrOQz488GNvaqOHFJfFPnMPV2uXD5RXpW51FPnoT3Z bcn15zuKGVhEONikBVTZAmyc49z8XjbHu4+VxFmDisTyBAGLk4BmIirMMMffp22tXxfP1ZE538I mld3bMX6R4bqc08eSSg790jy+5bpZowM3dzWGp8e9qh2pIoW39yT/NC1YdK7o5Lrs4+/0Jzn6ZL LDgA=
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit

A bucket set holds one row of caches, cloned from KMALLOC_NORMAL, and an
allocation of any other kmalloc type falls back to the general caches.
Extend this to handle __GFP_ACCOUNT, so that a single bucket user can
isolate either GFP_KERNEL or GFP_KERNEL_ACCOUNT allocations, as is
needed for skb data, where AF_UNIX uses:

	sk->sk_allocation = GFP_KERNEL_ACCOUNT;

The coverage is selected at bucket creation time:

	b = kmem_buckets_create_types(name, 0, flags, 0, INT_MAX, NULL,
				      BIT(KMEM_BUCKET_NORMAL) |
				      BIT(KMEM_BUCKET_CGROUP));

The prior kmem_buckets_create() function keeps its name and defaults
to only KMEM_BUCKET_NORMAL, leaving existing users as-is.

Only the accounted type is offered. Nothing wants a reclaimable or
no-obj-ext row, and of the twelve places passing GFP_DMA to an skb
allocator, all are rare hardware: b44, b43legacy, prestera, and s390 ctcm.

The choice is made at creation rather than every set getting every type
because the rows, when populated, are not free. Each holds 13 caches, and
a cache is a 1208 byte struct plus an unconditional per-cpu allocation,
a node struct, and an entry in /proc/slabinfo and under /sys/kernel/slab.

The rows are indexed by enum kmem_bucket_type, not enum
kmalloc_cache_type, which counts each KMALLOC_PARTITION copy as a type
of its own. Indexed by kmalloc_cache_type, a set would carry rows it
can never use: on x86_64 with CONFIG_KMALLOC_PARTITION_CACHES=y,
CONFIG_MEMCG=y and CONFIG_ZONE_DMA=y, 20 rows of 112 bytes (2240 bytes)
per set, against the 2 rows (224 bytes) used here.

KMEM_BUCKET_CGROUP collapses to KMEM_BUCKET_NORMAL without CONFIG_MEMCG,
exactly as KMALLOC_CGROUP does, so NR_KMEM_BUCKET_TYPES is 1 there and a
bucket set is the same single row it is today. Where the type is asked for
but the system is not creating caches of it (under "cgroup.memory=nokmem")
the row is aliased to the normal one, as new_kmalloc_cache() does for the
general caches, so those allocations stay isolated rather than falling
back to the general caches.

Built and tests pass (and skip as expected) on ARCH=x86_64 defconfig
with GCC 16.2.0 in all combinations of CONFIG_SLAB_BUCKETS=y/n and
CONFIG_MEMCG=y/n/y+"cgroup.memory=nokmem".

Assisted-by: LLM
Signed-off-by: Kees Cook <kees@kernel.org>
---
 include/linux/slab.h   |  53 +++++++++++++--
 mm/slab.h              |  23 ++++++-
 lib/tests/slub_kunit.c | 101 ++++++++++++++++++++++++++--
 mm/slab_common.c       | 149 ++++++++++++++++++++++++++++++++---------
 4 files changed, 283 insertions(+), 43 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index bdd00235d4b0..ee359dc90333 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -752,6 +752,11 @@ extern kmem_buckets kmalloc_caches[NR_KMALLOC_TYPES];
  */
 enum kmem_bucket_type {
 	KMEM_BUCKET_NORMAL = 0,
+#ifdef CONFIG_MEMCG
+	KMEM_BUCKET_CGROUP,
+#else
+	KMEM_BUCKET_CGROUP = KMEM_BUCKET_NORMAL,
+#endif
 	NR_KMEM_BUCKET_TYPES
 };
 
@@ -903,10 +908,50 @@ void *kmem_cache_alloc_lru_noprof(struct kmem_cache *s, struct list_lru *lru,
 bool kmem_cache_charge(void *objp, gfp_t gfpflags);
 void kmem_cache_free(struct kmem_cache *s, void *objp);
 
-kmem_buckets *kmem_buckets_create(const char *name, unsigned int align,
-				  slab_flags_t flags,
-				  unsigned int useroffset, unsigned int usersize,
-				  void (*ctor)(void *));
+kmem_buckets *kmem_buckets_create_types(const char *name, unsigned int align,
+					slab_flags_t flags,
+					unsigned int useroffset, unsigned int usersize,
+					void (*ctor)(void *),
+					unsigned int type_mask);
+
+/**
+ * kmem_buckets_create - Create a set of caches that handle dynamic sized
+ *			 allocations via kmem_buckets_alloc()
+ * @name: A prefix string which is used in /proc/slabinfo to identify this
+ *	  cache. The individual caches with have their sizes as the suffix.
+ * @align: The required alignment for the objects, or 0 to give each cache
+ *	   the alignment of the kmalloc cache of the same size, as a caller
+ *	   moving from kmalloc() may depend on.
+ * @flags: SLAB flags (see kmem_cache_create() for details).
+ * @useroffset: Starting offset within an allocation that may be copied
+ *		to/from userspace.
+ * @usersize: How many bytes, starting at @useroffset, may be copied
+ *		to/from userspace.
+ * @ctor: A constructor for the objects, run when new allocations are made.
+ *
+ * Covers KMEM_BUCKET_NORMAL only. Allocations needing another kmalloc type
+ * are served by the general caches, keeping the type they asked for and
+ * losing only the isolation. Use kmem_buckets_create_types() to cover more.
+ *
+ * Context: Cannot be called within an interrupt, but can be interrupted.
+ *
+ * Return: a pointer to the cache on success, NULL on failure. When
+ * CONFIG_SLAB_BUCKETS is not enabled, ZERO_SIZE_PTR is returned, and
+ * subsequent calls to kmem_buckets_alloc() will fall back to kmalloc().
+ * (i.e. callers only need to check for NULL on failure.)
+ */
+static inline kmem_buckets *kmem_buckets_create(const char *name,
+						unsigned int align,
+						slab_flags_t flags,
+						unsigned int useroffset,
+						unsigned int usersize,
+						void (*ctor)(void *))
+{
+	return kmem_buckets_create_types(name, align, flags, useroffset,
+					 usersize, ctor,
+					 BIT(KMEM_BUCKET_NORMAL));
+}
+
 void kmem_buckets_destroy(kmem_buckets *bucket);
 
 /*
diff --git a/mm/slab.h b/mm/slab.h
index 7f1bfee83b92..2af44e09edda 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -435,10 +435,31 @@ kmalloc_choose_bucket(kmem_buckets *bucket, enum kmalloc_cache_type type)
 
 	if (type <= KMALLOC_PARTITION_END)
 		btype = KMEM_BUCKET_NORMAL;
+	else if (IS_ENABLED(CONFIG_MEMCG) && type == KMALLOC_CGROUP)
+		btype = KMEM_BUCKET_CGROUP;
 	else
 		return &kmalloc_caches[type];	/* No set holds a row for it. */
 
-	return &bucket[btype];
+	/*
+	 * Either this row was created, and holds a cache everywhere the
+	 * general caches hold one, or it was never created and holds nothing.
+	 * Test with the KMALLOC_SHIFT_LOW which exists in every configuration.
+	 */
+	if (likely(bucket[btype][KMALLOC_SHIFT_LOW]))
+		return &bucket[btype];
+
+	/*
+	 * A row this set _could_ have held, but was not created with: the type
+	 * mask passed to kmem_buckets_create_types() did not cover what its
+	 * callers actually tried to allocate. Report the mismatch but still
+	 * fall back to the general caches.
+	 *
+	 * At present, only __GFP_ACCOUNT can be missing.
+	 */
+	WARN_ONCE(1,
+		  "kmem_buckets: __GFP_ACCOUNT needs BIT(KMEM_BUCKET_CGROUP) in create mask\n");
+
+	return &kmalloc_caches[type];
 }
 
 /*
diff --git a/lib/tests/slub_kunit.c b/lib/tests/slub_kunit.c
index 9768de01e6f9..bc5e52f20179 100644
--- a/lib/tests/slub_kunit.c
+++ b/lib/tests/slub_kunit.c
@@ -760,15 +760,104 @@ static void test_kmem_buckets_type_fallback(struct kunit *test)
 				      "expected a DMA cache, got %s", c->name);
 	}
 
-	/* Nor can one that has to be accounted. */
+	/*
+	 * An accounted allocation would fall back too, but a bucket set can
+	 * hold that type, so reaching the fallback means the create mask was
+	 * wrong and kmalloc_slab() warns. Not exercised here for that reason;
+	 * test_kmem_buckets_type_covered() checks the type that is asked for.
+	 */
+}
+
+/*
+ * A bucket set created for a kmalloc type keeps those allocations isolated
+ * too, rather than sending them to the general caches. Where nothing creates
+ * accounted caches at all, the row aliases the normal one, so this also
+ * covers tearing down a set whose rows share their caches.
+ */
+static void test_kmem_buckets_type_covered(struct kunit *test)
+{
+	struct kmem_cache *c, *normal_cache;
+	kmem_buckets *b;
+	void *p;
+
+	if (!IS_ENABLED(CONFIG_SLAB_BUCKETS))
+		kunit_skip(test, "needs CONFIG_SLAB_BUCKETS");
+
+	b = kmem_buckets_create_types("covered_buckets", 0, 0, 0, INT_MAX, NULL,
+				      BIT(KMEM_BUCKET_NORMAL) |
+				      BIT(KMEM_BUCKET_CGROUP));
+	KUNIT_ASSERT_BUCKETS_CREATED(test, b);
+
+	p = kmem_buckets_alloc(b, 128, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, p);
+	normal_cache = cache_of(p);
+	kfree(p);
+	KUNIT_ASSERT_NOT_NULL(test, normal_cache);
+
+	KUNIT_EXPECT_TRUE_MSG(test, strstarts(normal_cache->name, "covered_buckets-128"),
+			      "expected the normal bucket cache, got %s",
+			      normal_cache->name);
+
+	/* Accounted, and still in the bucket set rather than kmalloc-cg-*. */
+	p = kmem_buckets_alloc(b, 128, GFP_KERNEL | __GFP_ACCOUNT);
+	KUNIT_ASSERT_NOT_NULL(test, p);
+	c = cache_of(p);
+	kfree(p);
+	KUNIT_ASSERT_NOT_NULL(test, c);
+
 	if (IS_ENABLED(CONFIG_MEMCG) && !mem_cgroup_kmem_disabled()) {
-		p = kmem_buckets_alloc(b, 128, GFP_KERNEL | __GFP_ACCOUNT);
+		KUNIT_EXPECT_TRUE_MSG(test, strstarts(c->name, "covered_buckets-cg-"),
+				      "expected the accounted bucket cache, got %s",
+				      c->name);
+		KUNIT_EXPECT_TRUE(test, c->flags & SLAB_ACCOUNT);
+	} else {
+		/*
+		 * Nothing is creating accounted caches, so the row aliases
+		 * the normal one and the allocation lands there -- isolated
+		 * still, just not separately accounted.
+		 */
+		KUNIT_EXPECT_PTR_EQ(test, c, normal_cache);
+	}
+}
+
+/*
+ * The alignment a set is created with reaches every row it holds, not just
+ * the normal one. 256 is stronger than kmalloc's alignment for 128 byte
+ * objects, so a row built without it would show here.
+ */
+static void test_kmem_buckets_type_covered_alignment(struct kunit *test)
+{
+	static const gfp_t gfps[] = { GFP_KERNEL, GFP_KERNEL | __GFP_ACCOUNT };
+	const unsigned int align = 256;
+	struct kmem_cache *c;
+	kmem_buckets *b;
+	void *p;
+	int i;
+
+	if (!IS_ENABLED(CONFIG_SLAB_BUCKETS))
+		kunit_skip(test, "needs CONFIG_SLAB_BUCKETS");
+
+	b = kmem_buckets_create_types("covered_aligned", align, 0, 0, INT_MAX,
+				      NULL, BIT(KMEM_BUCKET_NORMAL) |
+				      BIT(KMEM_BUCKET_CGROUP));
+	KUNIT_ASSERT_BUCKETS_CREATED(test, b);
+
+	for (i = 0; i < ARRAY_SIZE(gfps); i++) {
+		p = kmem_buckets_alloc(b, 128, gfps[i]);
 		KUNIT_ASSERT_NOT_NULL(test, p);
-		c = virt_to_slab(p)->slab_cache;
+		c = cache_of(p);
+		KUNIT_EXPECT_TRUE_MSG(test, IS_ALIGNED((unsigned long)p, align),
+				      "gfp %pGg: object %p is not %u byte aligned",
+				      &gfps[i], p, align);
 		kfree(p);
 
-		KUNIT_EXPECT_TRUE_MSG(test, strstarts(c->name, "kmalloc-cg-"),
-				      "expected an accounted cache, got %s", c->name);
+		KUNIT_ASSERT_NOT_NULL(test, c);
+		KUNIT_EXPECT_TRUE_MSG(test, strstarts(c->name, "covered_aligned-"),
+				      "gfp %pGg: expected a bucket cache, got %s",
+				      &gfps[i], c->name);
+		KUNIT_EXPECT_EQ_MSG(test, c->align, align,
+				    "gfp %pGg: %s aligned to %u, not %u",
+				    &gfps[i], c->name, c->align, align);
 	}
 }
 
@@ -800,6 +889,8 @@ static struct kunit_case test_cases[] = {
 	KUNIT_CASE(test_kmem_buckets_disabled),
 	KUNIT_CASE(test_kmem_buckets_destroy),
 	KUNIT_CASE(test_kmem_buckets_type_fallback),
+	KUNIT_CASE(test_kmem_buckets_type_covered),
+	KUNIT_CASE(test_kmem_buckets_type_covered_alignment),
 	{}
 };
 
diff --git a/mm/slab_common.c b/mm/slab_common.c
index d66e5e56a0f1..c045e2d41ee5 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -410,9 +410,15 @@ EXPORT_SYMBOL(__kmem_cache_create_args);
 
 static struct kmem_cache *kmem_buckets_cache __ro_after_init;
 
+static int kmem_buckets_create_row(kmem_buckets *b,
+				   enum kmalloc_cache_type type,
+				   const char *name, unsigned int align,
+				   slab_flags_t flags, unsigned int useroffset,
+				   unsigned int usersize, void (*ctor)(void *));
+
 /**
- * kmem_buckets_create - Create a set of caches that handle dynamic sized
- *			 allocations via kmem_buckets_alloc()
+ * kmem_buckets_create_types - Create a set of caches that handle dynamic sized
+ *			       allocations via kmem_buckets_alloc()
  * @name: A prefix string which is used in /proc/slabinfo to identify this
  *	  cache. The individual caches with have their sizes as the suffix.
  * @align: The required alignment for the objects, or 0 to give each cache
@@ -424,6 +430,11 @@ static struct kmem_cache *kmem_buckets_cache __ro_after_init;
  * @usersize: How many bytes, starting at @useroffset, may be copied
  *		to/from userspace.
  * @ctor: A constructor for the objects, run when new allocations are made.
+ * @type_mask: Which kmalloc types to hold caches for, as a mask of
+ *	       BIT(KMEM_BUCKET_*). KMEM_BUCKET_NORMAL is always included.
+ *	       Allocations of a type that is not covered are served by the
+ *	       general caches instead, so a caller need not know in advance
+ *	       which types its own callers will ask for.
  *
  * Context: Cannot be called within an interrupt, but can be interrupted.
  *
@@ -432,13 +443,14 @@ static struct kmem_cache *kmem_buckets_cache __ro_after_init;
  * subsequent calls to kmem_buckets_alloc() will fall back to kmalloc().
  * (i.e. callers only need to check for NULL on failure.)
  */
-kmem_buckets *kmem_buckets_create(const char *name, unsigned int align,
-				  slab_flags_t flags,
-				  unsigned int useroffset,
-				  unsigned int usersize,
-				  void (*ctor)(void *))
-{
-	unsigned int idx;
+kmem_buckets *kmem_buckets_create_types(const char *name, unsigned int align,
+					slab_flags_t flags,
+					unsigned int useroffset,
+					unsigned int usersize,
+					void (*ctor)(void *),
+					unsigned int type_mask)
+{
+	enum kmem_bucket_type btype;
 	kmem_buckets *b;
 
 	/*
@@ -457,20 +469,87 @@ kmem_buckets *kmem_buckets_create(const char *name, unsigned int align,
 		return NULL;
 
 	flags |= SLAB_NO_MERGE;
+	type_mask |= BIT(KMEM_BUCKET_NORMAL);
+
+	for (btype = 0; btype < NR_KMEM_BUCKET_TYPES; btype++) {
+		enum kmalloc_cache_type src = KMALLOC_NORMAL;
+		slab_flags_t type_flags = 0;
+
+		if (!(type_mask & BIT(btype)))
+			continue;
+
+		/*
+		 * Under CONFIG_MEMCG=n the two types are the same value, so
+		 * the IS_ENABLED() is what keeps the normal row out of here.
+		 */
+		if (IS_ENABLED(CONFIG_MEMCG) && btype == KMEM_BUCKET_CGROUP) {
+			/*
+			 * Aliasing below reads the normal row, so this loop
+			 * must have built it already. That holds only while
+			 * the normal type sorts first.
+			 */
+			BUILD_BUG_ON(KMEM_BUCKET_CGROUP <= KMEM_BUCKET_NORMAL);
+
+			/*
+			 * Nothing anywhere is creating accounted caches, as
+			 * with "cgroup.memory=nokmem". Point this row's
+			 * entries at the normal row's caches, the way
+			 * new_kmalloc_cache() aliases kmalloc_caches[] for
+			 * the same reason. Leaving the row empty instead
+			 * would send every accounted allocation out of the
+			 * set and into the general caches.
+			 */
+			if (mem_cgroup_kmem_disabled()) {
+				memcpy(b[btype], b[KMEM_BUCKET_NORMAL],
+				       sizeof(b[btype]));
+				continue;
+			}
+
+			type_flags = SLAB_ACCOUNT;
+			src = KMALLOC_CGROUP;
+		}
+
+		if (kmem_buckets_create_row(&b[btype], src, name, align,
+					    flags | type_flags, useroffset,
+					    usersize, ctor))
+			goto fail;
+	}
+
+	return b;
+
+fail:
+	kmem_buckets_destroy(b);
+
+	return NULL;
+}
+EXPORT_SYMBOL(kmem_buckets_create_types);
+
+/*
+ * Build one row of @b by mirroring the general caches of @type: a cache per
+ * kmalloc size, each named "@name-" followed by that cache's own suffix, so
+ * a row of KMALLOC_CGROUP ("kmalloc-cg-96") gets "@name-cg-96".
+ */
+static int kmem_buckets_create_row(kmem_buckets *b,
+				   enum kmalloc_cache_type type,
+				   const char *name, unsigned int align,
+				   slab_flags_t flags, unsigned int useroffset,
+				   unsigned int usersize, void (*ctor)(void *))
+{
+	unsigned int idx;
 
 	for (idx = 0; idx < ARRAY_SIZE(kmalloc_caches[KMALLOC_NORMAL]); idx++) {
 		char *short_size, *cache_name;
 		unsigned int cache_useroffset, cache_usersize;
 		unsigned int size, aligned_idx;
 
-		if (!kmalloc_caches[KMALLOC_NORMAL][idx])
+		if (!kmalloc_caches[type][idx])
 			continue;
 
-		size = kmalloc_caches[KMALLOC_NORMAL][idx]->object_size;
+		size = kmalloc_caches[type][idx]->object_size;
 		if (!size)
 			continue;
 
-		short_size = strchr(kmalloc_caches[KMALLOC_NORMAL][idx]->name, '-');
+		short_size = strchr(kmalloc_caches[type][idx]->name, '-');
 		if (WARN_ON(!short_size))
 			goto fail;
 
@@ -488,7 +567,7 @@ kmem_buckets *kmem_buckets_create(const char *name, unsigned int align,
 			if (WARN_ON(!cache_name))
 				goto fail;
 			(*b)[aligned_idx] = kmem_cache_create_usercopy(cache_name, size,
-					align ?: kmalloc_caches[KMALLOC_NORMAL][idx]->align,
+					align ?: kmalloc_caches[type][idx]->align,
 					flags, cache_useroffset,
 					cache_usersize, ctor);
 			kfree(cache_name);
@@ -499,14 +578,11 @@ kmem_buckets *kmem_buckets_create(const char *name, unsigned int align,
 			(*b)[idx] = (*b)[aligned_idx];
 	}
 
-	return b;
+	return 0;
 
 fail:
-	kmem_buckets_destroy(b);
-
-	return NULL;
+	return -ENOMEM;
 }
-EXPORT_SYMBOL(kmem_buckets_create);
 
 /**
  * kmem_buckets_destroy - Destroy a set of caches made by kmem_buckets_create()
@@ -521,28 +597,35 @@ EXPORT_SYMBOL(kmem_buckets_create);
  */
 void kmem_buckets_destroy(kmem_buckets *bucket)
 {
+	enum kmem_bucket_type btype, t;
 	unsigned int idx, i;
 
 	if (!IS_ENABLED(CONFIG_SLAB_BUCKETS) || ZERO_OR_NULL_PTR(bucket))
 		return;
 
-	for (idx = 0; idx < ARRAY_SIZE(kmalloc_caches[KMALLOC_NORMAL]); idx++) {
-		struct kmem_cache *cache = (*bucket)[idx];
+	for (btype = 0; btype < NR_KMEM_BUCKET_TYPES; btype++) {
+		for (idx = 0; idx < ARRAY_SIZE(bucket[btype]); idx++) {
+			struct kmem_cache *cache = bucket[btype][idx];
 
-		if (!cache)
-			continue;
+			if (!cache)
+				continue;
 
-		/*
-		 * Sizes below arch_slab_minalign() share one cache, which
-		 * kmem_buckets_create() then stores at each of their indices.
-		 * Drop every reference to it before destroying it, so that no
-		 * later pass reads a pointer to a cache that is already gone.
-		 */
-		for (i = idx; i < ARRAY_SIZE(kmalloc_caches[KMALLOC_NORMAL]); i++)
-			if ((*bucket)[i] == cache)
-				(*bucket)[i] = NULL;
+			/*
+			 * A cache is reachable from more than one entry: sizes
+			 * below arch_slab_minalign() share one, and a row that
+			 * kmem_buckets_create_types() aliased onto the normal
+			 * one under "cgroup.memory=nokmem" holds all of them a
+			 * second time. Drop every reference before destroying
+			 * it, so that no later pass reads a pointer to a cache
+			 * that is already gone.
+			 */
+			for (t = 0; t < NR_KMEM_BUCKET_TYPES; t++)
+				for (i = 0; i < ARRAY_SIZE(bucket[t]); i++)
+					if (bucket[t][i] == cache)
+						bucket[t][i] = NULL;
 
-		kmem_cache_destroy(cache);
+			kmem_cache_destroy(cache);
+		}
 	}
 
 	kmem_cache_free(kmem_buckets_cache, bucket);
@@ -1092,7 +1175,7 @@ void __init create_kmalloc_caches(void)
 
 	if (IS_ENABLED(CONFIG_SLAB_BUCKETS))
 		kmem_buckets_cache = kmem_cache_create("kmalloc_buckets",
-						       sizeof(kmem_buckets),
+						       sizeof(kmem_buckets) * NR_KMEM_BUCKET_TYPES,
 						       0, SLAB_NO_MERGE, NULL);
 }
 
-- 
2.34.1

