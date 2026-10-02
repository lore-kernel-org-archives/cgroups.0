Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06ADD4B7A5D;
	Fri,  2 Oct 2026 23:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790982696; cv=none; b=gu3z/Fipe5X+zFX+MQ5GR8cYI0X2ho8xeLGsFFI5YNn0BEy6MxrQqUAnysTjHj9ZUX+IGQY5bUaMIHye20Fn1c0xjA0Iw6225bZNutQio1/DhOzsFqzxSYMpmp0cl2GxpIdUzH2rRO/bb2dIf2saqlsBFefEzzx88nUxMOXrOBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790982696; c=relaxed/simple;
	bh=tchXc7NwCKm8PR533pBMbCGPjPw8PbVDz6gXpuQlS0o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SBtfFVjUj5qtXjkyNlLoJ6wZKZ5i+oDYlPEtJdQECyLeH5iSWPldbKAc9C7vjTzTZMe6zxY+6guQhWl25DZwbfgQhmBS5ymDllIR8S+6SqKp6bK109RK6zZvNw9TohAlIs7i5BuyAomv67lzZNNnjQqN420zqLZzgzg654L3Mx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LCAmiCEb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LCAmiCEb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66BC21F00A05;
	Fri,  2 Oct 2026 23:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790982693;
	bh=vzksZEAFYFLYmLdPMdRVNGG/Ht2OGYmdABRr9SBKULY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LCAmiCEbErTgs9OGD1kfMoS099cQPavbLCq7WBC0WuSTfXjXuO/B1VTKV1gqR8Znl
	 CJd2xj1IYjvUnwjFAiQWDMVOgKLjH7LBjQgpNrVFwCQpilhMmH83Vza3ebTPyAe36N
	 YxWGCn0wFoc8dB0Bh4mzr6WODWhOOcw6sCJSiI9aAshhxoH657tuKJhsGsGdk82nS3
	 w5ZvDl/s7FWONjQJ47Oyy88qY68NyBRnLybC0tDxCT8zrnviEwofRT+UFLEaO0To2t
	 Dks5QBfd5mVQU7wB8QIBecWmHY7eNeAMZBUpaM1ZStvrjPFBNLOoSyTObGhyuzvyD3
	 4zf5AgMD9kSLw==
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
	"David S. Miller" <davem@davemloft.net>,
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
	netdev@vger.kernel.org
Subject: [PATCH net-next v5 5/7] mm/slab: Provide kmalloc type fallback for bucket allocations
Date: Fri,  2 Oct 2026 16:11:25 -0700
Message-Id: <20261002231132.1646573-5-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261002231120.late.500-kees@kernel.org>
References: <20261002231120.late.500-kees@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6703; i=kees@kernel.org; h=from:subject; bh=tchXc7NwCKm8PR533pBMbCGPjPw8PbVDz6gXpuQlS0o=; b=owGbwMvMwCVmps19z/KJym7G02pJDFkHrORCL077r5G3c+HxeMZyH/XHx5/1T75abb7m8Mwvs jnbPBn1OkpZGMS4GGTFFFmC7NzjXDzetoe7z1WEmcPKBDKEgYtTACYyg4mR4UFTkUvzEkm/Shnz Gt/vFzRrfv45UvJ0Y4GA7wIPOeEprAz/3f9c2TAzeoOztNObU03TWY+eXFH3v63xxF0Z3QUnXzW o8AIA
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit

kmem_buckets_create() clones kmalloc_caches[KMALLOC_NORMAL].
kmalloc_slab() figures out the kmalloc type the caller asks for, but
then ignored it whenever a bucket set was in use, returning a normal
cache regardless. This would be a problem if a caller asked for GFP_DMA,
__GFP_ACCOUNT, etc. None of the current users do this, so there is no
problem, but it makes adding new users fragile. For example, skb data[1]
needs to handle GFP_DMA (rarely) and __GFP_ACCOUNT (often).

Send those allocations to the general caches instead so nothing breaks and
regular allocations remain isolated with the bucket. The kmem_bucket_type
enum contains only a single item here, but will be expanded in the next
patch.

The test checks mem_cgroup_kmem_disabled() before expecting an accounted
cache, so export it for KUnit only, which a modular build of the test
needs to link.

Built and tests pass with ARCH=x86_64 defconfig with GCC 16.2.0, with
CONFIG_SLAB_BUCKETS as y and n.

Assisted-by: LLM
Link: https://lore.kernel.org/all/04debe19-bbe8-4b5f-9668-753d1f97832d@redhat.com/ [1]
Signed-off-by: Kees Cook <kees@kernel.org>
---
 include/linux/slab.h   | 13 ++++++++++
 mm/slab.h              | 23 ++++++++++++++++--
 lib/tests/slub_kunit.c | 54 ++++++++++++++++++++++++++++++++++++++++++
 mm/memcontrol.c        |  2 ++
 4 files changed, 90 insertions(+), 2 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index 4e6e74b3a990..bdd00235d4b0 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -742,6 +742,19 @@ typedef struct kmem_cache * kmem_buckets[KMALLOC_SHIFT_HIGH + 1];
 
 extern kmem_buckets kmalloc_caches[NR_KMALLOC_TYPES];
 
+/*
+ * The kmalloc types a bucket set can hold a copy of. This is deliberately not
+ * enum kmalloc_cache_type: the KMALLOC_PARTITION copies are all "normal" to a
+ * bucket set, which already separates what they were there to separate, so
+ * indexing by those would mean up to KMALLOC_PARTITION_CACHES_NR unusable
+ * rows per set. Allocations of any type not listed here are served by the
+ * general caches.
+ */
+enum kmem_bucket_type {
+	KMEM_BUCKET_NORMAL = 0,
+	NR_KMEM_BUCKET_TYPES
+};
+
 /*
  * Define gfp bits that should not be set for KMALLOC_NORMAL.
  */
diff --git a/mm/slab.h b/mm/slab.h
index 8fd6835e4235..7f1bfee83b92 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -421,6 +421,26 @@ static inline unsigned int size_index_elem(unsigned int bytes)
 	return (bytes - 1) / 8;
 }
 
+/*
+ * Which set of buckets to use for the given kmalloc_cache_type. If not
+ * handled by the kmem_buckets, fall back to general caches.
+ */
+static inline kmem_buckets *
+kmalloc_choose_bucket(kmem_buckets *bucket, enum kmalloc_cache_type type)
+{
+	enum kmem_bucket_type btype;
+
+	if (!bucket)
+		return &kmalloc_caches[type];
+
+	if (type <= KMALLOC_PARTITION_END)
+		btype = KMEM_BUCKET_NORMAL;
+	else
+		return &kmalloc_caches[type];	/* No set holds a row for it. */
+
+	return &bucket[btype];
+}
+
 /*
  * Find the kmem_cache structure that serves a given size of
  * allocation
@@ -438,8 +458,7 @@ kmalloc_slab(size_t size, kmem_buckets *b, gfp_t flags, kmalloc_token_t token,
 	if (alloc_flags & SLAB_ALLOC_NO_OBJ_EXT)
 		type = KMALLOC_NO_OBJ_EXT;
 
-	if (!b)
-		b = &kmalloc_caches[type];
+	b = kmalloc_choose_bucket(b, type);
 	if (size <= 192)
 		index = kmalloc_size_index[size_index_elem(size)];
 	else
diff --git a/lib/tests/slub_kunit.c b/lib/tests/slub_kunit.c
index 3c923a3af825..9768de01e6f9 100644
--- a/lib/tests/slub_kunit.c
+++ b/lib/tests/slub_kunit.c
@@ -720,6 +720,58 @@ static void test_kmem_buckets_destroy(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, 2, slab_errors);
 }
 
+/*
+ * A bucket set holds only the kmalloc types it was created with, so an
+ * allocation that asks for a different one has to come from the general
+ * caches. Check that it does, rather than being served a normal cache that
+ * does not satisfy what the flags asked for.
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
+	b = kmem_buckets_create("test_buckets", 0, 0, 0, INT_MAX, NULL);
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
+	/* Nor can one that has to be accounted. */
+	if (IS_ENABLED(CONFIG_MEMCG) && !mem_cgroup_kmem_disabled()) {
+		p = kmem_buckets_alloc(b, 128, GFP_KERNEL | __GFP_ACCOUNT);
+		KUNIT_ASSERT_NOT_NULL(test, p);
+		c = virt_to_slab(p)->slab_cache;
+		kfree(p);
+
+		KUNIT_EXPECT_TRUE_MSG(test, strstarts(c->name, "kmalloc-cg-"),
+				      "expected an accounted cache, got %s", c->name);
+	}
+}
+
 static struct kunit_case test_cases[] = {
 	KUNIT_CASE(test_clobber_zone),
 
@@ -747,6 +799,7 @@ static struct kunit_case test_cases[] = {
 	KUNIT_CASE(test_kmem_buckets_explicit_alignment),
 	KUNIT_CASE(test_kmem_buckets_disabled),
 	KUNIT_CASE(test_kmem_buckets_destroy),
+	KUNIT_CASE(test_kmem_buckets_type_fallback),
 	{}
 };
 
@@ -757,5 +810,6 @@ static struct kunit_suite test_suite = {
 };
 kunit_test_suite(test_suite);
 
+MODULE_IMPORT_NS("EXPORTED_FOR_KUNIT_TESTING");
 MODULE_DESCRIPTION("Kunit tests for slub allocator");
 MODULE_LICENSE("GPL");
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1271d390b617..5ceeb5a0b614 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -62,6 +62,7 @@
 #include <linux/seq_buf.h>
 #include <linux/sched/isolation.h>
 #include <linux/kmemleak.h>
+#include <kunit/visibility.h>
 #include "internal.h"
 #include "swap.h"
 #include "swap_table.h"
@@ -135,6 +136,7 @@ bool mem_cgroup_kmem_disabled(void)
 {
 	return cgroup_memory_nokmem;
 }
+EXPORT_SYMBOL_IF_KUNIT(mem_cgroup_kmem_disabled);
 
 static void memcg_uncharge(struct mem_cgroup *memcg, unsigned int nr_pages);
 
-- 
2.34.1

