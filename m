Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE12A46E017;
	Fri,  2 Oct 2026 23:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790982695; cv=none; b=K+KnRaIVyALWzkIjznFUnBmlgOpPo2lEWVzGmEdm2rKN2n9G4D7MQ70wCZeJPuy2knG5eNvoTLthGMmgw5vkZE8xjCV6PyYd0rZmRE1WzPxrysEATKbop2npqj1MEDjGEXl9FO0bsmOv+c+VZEXqDevjfqI7bbs2PZovBMqy1JM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790982695; c=relaxed/simple;
	bh=mwN3izkgsSVeYNMTH0U8qd2JmvG7SIKwmwQb4PqSgDQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=g8mYmk9Lx4X3uACB9eejQKxYhxkpPvRpjwVGW8i+zt9ob56lTIer2vw0deu8tf1Vy4tY+6gSqfq5weKwCLLx89iNyakXMuhFyLmNftFScRSQMH1x4HXKf1xAHo2OmRSiPRa9GA7FXWpKANKM/bA66fNjiLdyX8W3YLkovEXSqmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C8HlfqQB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C8HlfqQB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CBB11F0089A;
	Fri,  2 Oct 2026 23:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790982693;
	bh=gfTuWlyHlqz+utIgmSPaaa4gJ57ilsCydlAdqgkhENs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C8HlfqQBMN+vyXk2lAz/x5YrRgCb4zdAn3iWILJOyefvIM+9SkCpfQt+N6Hwek3dO
	 cszLjBnasJpcftvB045G47o+52mEJvPpHKbsQ8y4KX0SKLCX/NGmZEDhqLpm0eijtT
	 /7Ty0boA9S+jj35cSb3L/4vjRg6s4C/gn1Px6cpKS06Uid1E4dezejGsOFaNqow2Gz
	 /y1+2cPjFCA2IXKeVcCWr5qni9PLKgCROzqWrhgDd+9XaELgg6CzwubpdHx2nVyz4A
	 kfADa1YAzlTwqVTZbtw3E6vFRnuACkX8fSdUaM2vtn+ABUa+Lp/krmbv2p1c0bXqyz
	 APIsrW9ql4zmQ==
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
Subject: [PATCH net-next v5 4/7] mm/slab: Add tests for the existing kmem_buckets behaviour
Date: Fri,  2 Oct 2026 16:11:24 -0700
Message-Id: <20261002231132.1646573-4-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261002231120.late.500-kees@kernel.org>
References: <20261002231120.late.500-kees@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=10893; i=kees@kernel.org; h=from:subject; bh=mwN3izkgsSVeYNMTH0U8qd2JmvG7SIKwmwQb4PqSgDQ=; b=owGbwMvMwCVmps19z/KJym7G02pJDFkHrORO3Flts/z/veWJR1dxXZ1+K4h1kf4Wh67sKcfOX Lo+QYZ3W0cpC4MYF4OsmCJLkJ17nIvH2/Zw97mKMHNYmUCGMHBxCsBEVJIYGR693rUn9uDiU38u PPqkt37ZR2HuI18zw88XsX5g7H7uenoaw383+1tTT2p05wg+NJ9h5PPSq90k1a3Q4/rSjaE7BFY 13GIFAA==
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit

kmem_buckets has had no test coverage since it was added. Add tests,
including stuff unique to the bucket design:

 - A bucket allocation comes from a cache of the set's own, and that
   cache carries SLAB_NO_MERGE.

 - Each size class is served by the set, including 96 and 192, which are
   not powers of two and are filled in from an aligned index by
   kmem_buckets_create(). Sizes above KMALLOC_MAX_CACHE_SIZE go to the
   page allocator instead, bucket set or not.

 - Each cache is aligned like the kmalloc cache it mirrors, or, when the
   set was created with an alignment, to that one.

 - With CONFIG_SLAB_BUCKETS=n, kmem_buckets_create() still returns a
   non-NULL (zero size alloc pointer), so that callers only have to check
   for failure, and allocations through it come from the general caches.

 - Destroying a set takes its caches down rather than only freeing the
   set, which is what a module creating one on each load depends on.
   A set freed without its caches would leave the names taken, and the
   next load would warn about every one of them.

The tests skip rather than compile out, which is useful for testing
the CONFIG_SLAB_BUCKETS=n behaviors.

Built and tests passing (with expected skips) on ARCH=x86_64 defconfig
with GCC 16.2.0, with CONFIG_SLAB_BUCKETS as y and n.

Assisted-by: LLM
Signed-off-by: Kees Cook <kees@kernel.org>
---
 lib/tests/slub_kunit.c | 252 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 252 insertions(+)

diff --git a/lib/tests/slub_kunit.c b/lib/tests/slub_kunit.c
index e3b63f0338d5..3c923a3af825 100644
--- a/lib/tests/slub_kunit.c
+++ b/lib/tests/slub_kunit.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <kunit/test.h>
 #include <kunit/test-bug.h>
+#include <kunit/resource.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
 #include <linux/module.h>
@@ -474,6 +475,251 @@ static int test_init(struct kunit *test)
 	return 0;
 }
 
+/* Destroy buckets on test exit so a failed KUNIT_ASSERT_*() doesn't leak. */
+KUNIT_DEFINE_ACTION_WRAPPER(destroy_buckets, kmem_buckets_destroy, kmem_buckets *);
+
+#define KUNIT_ASSERT_BUCKETS_CREATED(test, b)					\
+	do {									\
+		KUNIT_ASSERT_NOT_NULL(test, b);					\
+		KUNIT_ASSERT_EQ(test, 0,					\
+				kunit_add_action_or_reset(test,			\
+							  destroy_buckets, b)); \
+	} while (0)
+
+/*
+ * The cache an allocation came from, or NULL if it came from no cache at
+ * all, e.g. a size too big for any of them is served by the page allocator.
+ */
+static struct kmem_cache *cache_of(void *p)
+{
+	struct slab *slab = virt_to_slab(p);
+
+	return slab ? slab->slab_cache : NULL;
+}
+
+/*
+ * A bucket set exists to keep its allocations out of the caches everything
+ * else uses, so check the two things that make that true: they come from a
+ * cache of the set's own, and that cache is never merged into another.
+ */
+static void test_kmem_buckets_isolation(struct kunit *test)
+{
+	struct kmem_cache *bucket_cache, *general_cache;
+	kmem_buckets *b;
+	void *p, *q;
+
+	if (!IS_ENABLED(CONFIG_SLAB_BUCKETS))
+		kunit_skip(test, "needs CONFIG_SLAB_BUCKETS");
+
+	b = kmem_buckets_create("isolated_buckets", 0, 0, 0, INT_MAX, NULL);
+	KUNIT_ASSERT_BUCKETS_CREATED(test, b);
+
+	/*
+	 * Free each allocation before asserting on the next one: the cache
+	 * outlives its objects, so nothing below needs them, and an assertion
+	 * that leaves one behind would make the deferred teardown report a
+	 * cache that is still in use.
+	 */
+	p = kmem_buckets_alloc(b, 128, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, p);
+	bucket_cache = cache_of(p);
+	kfree(p);
+	KUNIT_ASSERT_NOT_NULL(test, bucket_cache);
+
+	KUNIT_EXPECT_TRUE_MSG(test, strstarts(bucket_cache->name, "isolated_buckets-"),
+			      "expected a bucket cache, got %s", bucket_cache->name);
+
+	/*
+	 * Cache merging is on by default, and a bucket cache merged into a
+	 * same-sized general one would quietly undo the whole separation.
+	 */
+	KUNIT_EXPECT_TRUE(test, bucket_cache->flags & SLAB_NO_MERGE);
+
+	q = kmalloc(128, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, q);
+	general_cache = cache_of(q);
+	kfree(q);
+	KUNIT_ASSERT_NOT_NULL(test, general_cache);
+
+	KUNIT_EXPECT_PTR_NE(test, bucket_cache, general_cache);
+}
+
+/*
+ * Every size class gets its own cache in the set, including the ones that
+ * are not powers of two and are filled in from an aligned index. Sizes past
+ * the largest cache are served by the page allocator, bucket set or not.
+ */
+static void test_kmem_buckets_sizes(struct kunit *test)
+{
+	static const size_t sizes[] = { 8, 96, 192, 1024, 4096 };
+	struct kmem_cache *c;
+	kmem_buckets *b;
+	void *p;
+	int i;
+
+	if (!IS_ENABLED(CONFIG_SLAB_BUCKETS))
+		kunit_skip(test, "needs CONFIG_SLAB_BUCKETS");
+
+	b = kmem_buckets_create("sized_buckets", 0, 0, 0, INT_MAX, NULL);
+	KUNIT_ASSERT_BUCKETS_CREATED(test, b);
+
+	for (i = 0; i < ARRAY_SIZE(sizes); i++) {
+		p = kmem_buckets_alloc(b, sizes[i], GFP_KERNEL);
+		KUNIT_ASSERT_NOT_NULL(test, p);
+		c = cache_of(p);
+		kfree(p);
+		KUNIT_ASSERT_NOT_NULL(test, c);
+
+		KUNIT_EXPECT_TRUE_MSG(test, strstarts(c->name, "sized_buckets-"),
+				      "size %zu: expected a bucket cache, got %s",
+				      sizes[i], c->name);
+		KUNIT_EXPECT_GE(test, c->object_size, sizes[i]);
+	}
+
+	/* Too big for any cache: a folio from the page allocator, not a slab. */
+	p = kmem_buckets_alloc(b, KMALLOC_MAX_CACHE_SIZE + 1, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, p);
+	c = cache_of(p);
+	kfree(p);
+
+	KUNIT_EXPECT_NULL(test, c);
+}
+
+/*
+ * A bucket cache stands in for a kmalloc cache, so it has to be aligned like
+ * one. The DMA layer decides whether a buffer needs bouncing from its size,
+ * on the grounds that a kmalloc cache of that size is already aligned for
+ * the device, so a weaker alignment here is not something a caller can see
+ * coming. Without slab debugging the size implies the alignment and this
+ * holds either way; with it, only the cache's own alignment does.
+ */
+static void test_kmem_buckets_alignment(struct kunit *test)
+{
+	static const size_t sizes[] = { 128, 512, 2048 };
+	struct kmem_cache *bucket_cache, *general_cache;
+	kmem_buckets *b;
+	void *p;
+	int i;
+
+	if (!IS_ENABLED(CONFIG_SLAB_BUCKETS))
+		kunit_skip(test, "needs CONFIG_SLAB_BUCKETS");
+
+	b = kmem_buckets_create("aligned_buckets", 0, 0, 0, INT_MAX, NULL);
+	KUNIT_ASSERT_BUCKETS_CREATED(test, b);
+
+	for (i = 0; i < ARRAY_SIZE(sizes); i++) {
+		p = kmem_buckets_alloc(b, sizes[i], GFP_KERNEL);
+		KUNIT_ASSERT_NOT_NULL(test, p);
+		bucket_cache = cache_of(p);
+		KUNIT_EXPECT_TRUE_MSG(test,
+				      IS_ALIGNED((unsigned long)p, ARCH_DMA_MINALIGN),
+				      "size %zu: object %p is not %d byte aligned",
+				      sizes[i], p, (int)ARCH_DMA_MINALIGN);
+		kfree(p);
+
+		p = kmalloc(sizes[i], GFP_KERNEL);
+		KUNIT_ASSERT_NOT_NULL(test, p);
+		general_cache = cache_of(p);
+		kfree(p);
+
+		KUNIT_ASSERT_NOT_NULL(test, bucket_cache);
+		KUNIT_ASSERT_NOT_NULL(test, general_cache);
+		KUNIT_EXPECT_EQ_MSG(test, bucket_cache->align, general_cache->align,
+				    "size %zu: bucket cache aligned to %u, %s to %u",
+				    sizes[i], bucket_cache->align,
+				    general_cache->name, general_cache->align);
+	}
+}
+
+/*
+ * A set created with an alignment gives every one of its caches that
+ * alignment in place of the kmalloc caches' own. 256 is stronger than
+ * kmalloc's alignment for the 64 and 128 byte caches and weaker than it
+ * for the 512 and 2048 byte ones, so this checks the override both ways.
+ */
+static void test_kmem_buckets_explicit_alignment(struct kunit *test)
+{
+	static const size_t sizes[] = { 64, 128, 512, 2048 };
+	const unsigned int align = 256;
+	struct kmem_cache *c;
+	kmem_buckets *b;
+	void *p;
+	int i;
+
+	if (!IS_ENABLED(CONFIG_SLAB_BUCKETS))
+		kunit_skip(test, "needs CONFIG_SLAB_BUCKETS");
+
+	b = kmem_buckets_create("explicit_buckets", align, 0, 0, INT_MAX, NULL);
+	KUNIT_ASSERT_BUCKETS_CREATED(test, b);
+
+	for (i = 0; i < ARRAY_SIZE(sizes); i++) {
+		p = kmem_buckets_alloc(b, sizes[i], GFP_KERNEL);
+		KUNIT_ASSERT_NOT_NULL(test, p);
+		c = cache_of(p);
+		KUNIT_EXPECT_TRUE_MSG(test, IS_ALIGNED((unsigned long)p, align),
+				      "size %zu: object %p is not %u byte aligned",
+				      sizes[i], p, align);
+		kfree(p);
+
+		KUNIT_ASSERT_NOT_NULL(test, c);
+		KUNIT_EXPECT_EQ_MSG(test, c->align, align,
+				    "size %zu: bucket cache aligned to %u, not %u",
+				    sizes[i], c->align, align);
+	}
+}
+
+/*
+ * With the feature compiled out, kmem_buckets_create() still returns
+ * something non-NULL so that callers only have to check for failure, and
+ * allocations through it work (i.e. come from the general caches).
+ */
+static void test_kmem_buckets_disabled(struct kunit *test)
+{
+	kmem_buckets *b;
+	struct kmem_cache *c;
+	void *p;
+
+	if (IS_ENABLED(CONFIG_SLAB_BUCKETS))
+		kunit_skip(test, "only meaningful without CONFIG_SLAB_BUCKETS");
+
+	b = kmem_buckets_create("disabled_buckets", 0, 0, 0, INT_MAX, NULL);
+	KUNIT_ASSERT_BUCKETS_CREATED(test, b);
+
+	p = kmem_buckets_alloc(b, 128, GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, p);
+	c = cache_of(p);
+	kfree(p);
+	KUNIT_ASSERT_NOT_NULL(test, c);
+
+	KUNIT_EXPECT_TRUE_MSG(test, !strstarts(c->name, "disabled_buckets-"),
+			      "expected a general cache, got %s", c->name);
+}
+
+/* Destroying a set has to take its caches down, not just free the set. */
+static void test_kmem_buckets_destroy(struct kunit *test)
+{
+	kmem_buckets *b;
+	void *p;
+
+	if (!IS_ENABLED(CONFIG_SLAB_BUCKETS))
+		kunit_skip(test, "needs CONFIG_SLAB_BUCKETS");
+
+	b = kmem_buckets_create("destroyed_buckets", 0, 0, 0, INT_MAX, NULL);
+	KUNIT_ASSERT_NOT_NULL(test, b);
+
+	/*
+	 * Deliberately leaked, as test_leak_destroy() leaks its own: the
+	 * teardown below has to find it. kmem_cache_destroy() unlists the
+	 * cache either way, so the name is still released.
+	 */
+	p = kmem_buckets_alloc(b, 128, GFP_KERNEL);
+	KUNIT_EXPECT_NOT_NULL(test, p);
+
+	kmem_buckets_destroy(b);
+
+	KUNIT_EXPECT_EQ(test, 2, slab_errors);
+}
+
 static struct kunit_case test_cases[] = {
 	KUNIT_CASE(test_clobber_zone),
 
@@ -495,6 +741,12 @@ static struct kunit_case test_cases[] = {
 #if defined(CONFIG_KPROBES) && defined(CONFIG_SMP)
 	KUNIT_CASE_SLOW(test_kmalloc_nolock_and_friends_kprobe),
 #endif
+	KUNIT_CASE(test_kmem_buckets_isolation),
+	KUNIT_CASE(test_kmem_buckets_sizes),
+	KUNIT_CASE(test_kmem_buckets_alignment),
+	KUNIT_CASE(test_kmem_buckets_explicit_alignment),
+	KUNIT_CASE(test_kmem_buckets_disabled),
+	KUNIT_CASE(test_kmem_buckets_destroy),
 	{}
 };
 
-- 
2.34.1

