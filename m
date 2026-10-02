Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FAB73EFD07;
	Fri,  2 Oct 2026 23:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790982696; cv=none; b=mIImi9tzTLSOCkZ7RrmX3wRQl0A6Dp76azB5BZvF6R5FPA7lFK0NvvuXyJ5U8qCpS85rQ9Wp1rpEZdW6xIX71unD1xfHWeSnnJsIISFNFOo0re2QrpY87qWelqT6L2nylhjRbsYex6nCOx3H7DlwBnhjU9n5NkSu48U/brAhY/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790982696; c=relaxed/simple;
	bh=UDNZ1R5lvYoftAp5JNIjU2HGyMYGenKFgfjUmFWVrbA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=q/WPes7MXpfQAjqJ15sz44MOR40xC2g9g8O5X2/2P5/xlAT2JsyidA59jEaNW7rNl8KjvbkUV3VoyFu9u6og8lD758xBfSxarb3MmR1wS+eeUZc37Wdk75E1QVdgw83jXTAygRxmr5iFd//qqrli6MxByIiiW76x8DJCAwk0NAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DlWNCeR1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DlWNCeR1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E92C1F00898;
	Fri,  2 Oct 2026 23:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790982693;
	bh=FVmFNn+LnsECzPXFNIQCEYvxLeFFB0nlNjTo56p1F20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DlWNCeR1pZP6qS8+aZv/bUHT4aMWWhYtAu6VXgeS0MIwCr4xt/fwPyBN1dlPg7kYs
	 5xePJ28WoBfDQYLnHFFDETH7TEjTZhXbEhO25jZacOfS291Xhy9GOlKZDnUanG9wwW
	 0o5xgmsaox2A4jCUTzQH0gR/s0UMv8sx6S1vu6Hhttd68TjLGq+5yrfB0Rqaz+Ihkx
	 PqGYPVN/ez6ID7Ev5ykCUpIBtJMiZYV8WSTP7kKt9ECkKzdQOCUjwjSr0JoKW8SVAW
	 z5h0nxFHPIIzogOQlfzW67HZyH6L5uH+VwwKpNQAqf5TlVAfiI/p7kPQMiN/XP0Emo
	 oS3/tX6u/L2Sw==
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
Subject: [PATCH net-next v5 2/7] mm/slab: Let kmem_buckets_create() take an alignment
Date: Fri,  2 Oct 2026 16:11:22 -0700
Message-Id: <20261002231132.1646573-2-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261002231120.late.500-kees@kernel.org>
References: <20261002231120.late.500-kees@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4893; i=kees@kernel.org; h=from:subject; bh=UDNZ1R5lvYoftAp5JNIjU2HGyMYGenKFgfjUmFWVrbA=; b=owGbwMvMwCVmps19z/KJym7G02pJDFkHrGSF83k8dFacOFYmaH6629ZsR4noymiGBzt1ZVc3v XtuIpzaUcrCIMbFICumyBJk5x7n4vG2Pdx9riLMHFYmkCEMXJwCMJF5aQz/TEIuau9nPn726uXw rf3M7e9FFHbxHbQ7Nlt+pvUa26zLsxj+17rZyx+wOtfw5XmrpijTk/VCE0rNE5/ay5v4CkxmEk9 gBgA=
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit

A bucket set is created with kmem_cache_create_usercopy(..., align = 0),
so calculate_alignment() falls back to arch_slab_minalign(), typically 8
bytes. The general kmalloc caches it stands in for are created through
create_boot_cache(), which starts from ARCH_KMALLOC_MINALIGN and raises
it to the largest power-of-two divisor of the size:

	if (flags & SLAB_KMALLOC)
		align = max(align, 1U << (ffs(size) - 1));

This is only a problem when slab metadata is enabled with
CONFIG_KASAN=y, CONFIG_SLUB_DEBUG_ON=y, or "slab_debug=...", because
metadata changes the stride size off a power of two, for example:

	size 128:  bucket align=8 size=224  | kmalloc align=128  size=384
	size 512:  bucket align=8 size=608  | kmalloc align=512  size=1536
	size 2048: bucket align=8 size=2144 | kmalloc align=2048 size=6144

So bucket allocations will fail the IS_ALIGNED(p, ARCH_DMA_MINALIGN)
check, potentially creating problems for non-coherent DMA situation.

As discussed in review, add an alignment argument to
kmem_buckets_create(), where kmem_cache_create() has it. A caller that
needs a particular alignment passes it. With 0, each cache takes the
alignment of the kmalloc cache being mirrored, which is where the size
and the name suffix already come from, so a caller moving from kmalloc()
keeps the alignment it had. Both existing callers pass 0.

Fixes: b32801d1255be ("mm/slab: Introduce kmem_buckets_create() and family")
Assisted-by: LLM
Signed-off-by: Kees Cook <kees@kernel.org>
---
 include/linux/slab.h | 3 ++-
 ipc/msgutil.c        | 2 +-
 mm/slab_common.c     | 9 +++++++--
 mm/util.c            | 2 +-
 4 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index cda126def67a..94709e4e14f3 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -890,7 +890,8 @@ void *kmem_cache_alloc_lru_noprof(struct kmem_cache *s, struct list_lru *lru,
 bool kmem_cache_charge(void *objp, gfp_t gfpflags);
 void kmem_cache_free(struct kmem_cache *s, void *objp);
 
-kmem_buckets *kmem_buckets_create(const char *name, slab_flags_t flags,
+kmem_buckets *kmem_buckets_create(const char *name, unsigned int align,
+				  slab_flags_t flags,
 				  unsigned int useroffset, unsigned int usersize,
 				  void (*ctor)(void *));
 
diff --git a/ipc/msgutil.c b/ipc/msgutil.c
index e28f0cecb2ec..b49b8f65a582 100644
--- a/ipc/msgutil.c
+++ b/ipc/msgutil.c
@@ -43,7 +43,7 @@ static kmem_buckets *msg_buckets __ro_after_init;
 
 static int __init init_msg_buckets(void)
 {
-	msg_buckets = kmem_buckets_create("msg_msg", SLAB_ACCOUNT,
+	msg_buckets = kmem_buckets_create("msg_msg", 0, SLAB_ACCOUNT,
 					  sizeof(struct msg_msg),
 					  DATALEN_MSG, NULL);
 
diff --git a/mm/slab_common.c b/mm/slab_common.c
index 270408ce5a9d..301f3d4f4ca2 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -415,6 +415,9 @@ static struct kmem_cache *kmem_buckets_cache __ro_after_init;
  *			 allocations via kmem_buckets_alloc()
  * @name: A prefix string which is used in /proc/slabinfo to identify this
  *	  cache. The individual caches with have their sizes as the suffix.
+ * @align: The required alignment for the objects, or 0 to give each cache
+ *	   the alignment of the kmalloc cache of the same size, as a caller
+ *	   moving from kmalloc() may depend on.
  * @flags: SLAB flags (see kmem_cache_create() for details).
  * @useroffset: Starting offset within an allocation that may be copied
  *		to/from userspace.
@@ -429,7 +432,8 @@ static struct kmem_cache *kmem_buckets_cache __ro_after_init;
  * subsequent calls to kmem_buckets_alloc() will fall back to kmalloc().
  * (i.e. callers only need to check for NULL on failure.)
  */
-kmem_buckets *kmem_buckets_create(const char *name, slab_flags_t flags,
+kmem_buckets *kmem_buckets_create(const char *name, unsigned int align,
+				  slab_flags_t flags,
 				  unsigned int useroffset,
 				  unsigned int usersize,
 				  void (*ctor)(void *))
@@ -487,7 +491,8 @@ kmem_buckets *kmem_buckets_create(const char *name, slab_flags_t flags,
 			if (WARN_ON(!cache_name))
 				goto fail;
 			(*b)[aligned_idx] = kmem_cache_create_usercopy(cache_name, size,
-					0, flags, cache_useroffset,
+					align ?: kmalloc_caches[KMALLOC_NORMAL][idx]->align,
+					flags, cache_useroffset,
 					cache_usersize, ctor);
 			kfree(cache_name);
 			if (WARN_ON(!(*b)[aligned_idx]))
diff --git a/mm/util.c b/mm/util.c
index bf0513d1d3d0..3f04d77ef4b8 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -199,7 +199,7 @@ static kmem_buckets *user_buckets __ro_after_init;
 
 static int __init init_user_buckets(void)
 {
-	user_buckets = kmem_buckets_create("memdup_user", 0, 0, INT_MAX, NULL);
+	user_buckets = kmem_buckets_create("memdup_user", 0, 0, 0, INT_MAX, NULL);
 
 	return 0;
 }
-- 
2.34.1

