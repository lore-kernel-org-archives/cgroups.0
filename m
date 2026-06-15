Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A69593EBF3D;
	Mon, 15 Jun 2026 11:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781524536; cv=none; b=UzuZfFWnCuol1YZIZ0PKVxQkDc3qI0FCJ+5xlwe0RHtU3yZMeaVMU0a5FMEpdBeDS3zlsG0U8b/3tKput9ZgfwEff/Rk+YsfvPdt3PYORUPWCyIZepEoI1pQHMwBG2YRuZu/xtAtYkg8oGyUaORUw0EHMNI6Iqbdt8YyfMUjHxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781524536; c=relaxed/simple;
	bh=MQMTM049WoAzQO9zsjiv0UNv8Zb3KScKhxtghlrOoGQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=PqgjERunRmjR7DIBigVMhGmarMDrJgtlreAGQFxbkf0Qp/eimPvjuY8ruWHIgl/tzBl2PuG7XBEF+O5jLnYNej1+ens3gxNBj3PV+UmemqP5f9jPSZ2gr5lgmGnn071CSFQ1rjVoQuWZ5n7v76ISrNkia2bYQ2blGaTu7E0d3eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YlCJbcSD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YlCJbcSD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E98651F000E9;
	Mon, 15 Jun 2026 11:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781524535;
	bh=TmHeBBNOgV6Vcy7g85BVoEti6aJriI10Deolz6kEodg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=YlCJbcSDFAb9qdWlco/z2waagtuwSG/nVah0iJj1bLnvWa1P8nEtgWBWCA4k6Fe1n
	 j8cF4IPYucE7OErB99YTnsWYsJQ6y7FA/lp4Ok9D0XdwXW5hi9zpaUsTkvnlbOb8G3
	 LlV39x2ACMY8xZCcEm6V2GObSAC6NH/VX6FXKjDeRZ1RVEwhOzrDjYOnsT1MXwtMUZ
	 S1UUNcJHH55Kajn9tZN6SabzvyrGlPgjoQkjTkdXauDOwpXNFoWTQmtLLQnnkFLJfi
	 9OZvmcX6i4ntxQJLql/uDv6fqH99BVX6SnJQivaSZqxvx5HMuo7e91r+lH2AXZAl9d
	 VAtIxMsWZuv5A==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Mon, 15 Jun 2026 13:54:46 +0200
Subject: [PATCH v3 13/15] mm/slab: introduce kmalloc_flags()
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260615-slab_alloc_flags-v3-13-ce1146d140fb@kernel.org>
References: <20260615-slab_alloc_flags-v3-0-ce1146d140fb@kernel.org>
In-Reply-To: <20260615-slab_alloc_flags-v3-0-ce1146d140fb@kernel.org>
To: Harry Yoo <harry@kernel.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Suren Baghdasaryan <surenb@google.com>, Alexei Starovoitov <ast@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
 Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.15.2

With alloc_flags usage in slab, we can replace __GFP_NO_OBJ_EXT with an
alloc flag that prevents kmalloc recursion. For that we need a version
of kmalloc() that takes alloc_flags and use it in places that perform
these potentially recursive kmalloc allocations (of sheaves or obj_ext
arrays).

Add this function, named kmalloc_flags(). Right now it's only useful for
these nested allocations, so it doesn't need to optimize build-time
constant sizes like kmalloc() or kmalloc_buckets.

Since we need it to support both normal and non-spinning
kmalloc_nolock() context through the SLAB_ALLOC_NOLOCK flag, split out
most of the special _kmalloc_nolock_noprof() implementation to
__kmalloc_nolock_noprof() that takes a slab_alloc_context, and make
_kmalloc_nolock_noprof() a simple tail calling wrapper with the proper
context.

kmalloc_flags() can thus determine whether to call
__kmalloc_nolock_noprof() or __do_kmalloc_node(), based on the
given alloc_flags.

Link: https://patch.msgid.link/20260610-slab_alloc_flags-v2-14-7190909db118@kernel.org
Reviewed-by: Hao Li <hao.li@linux.dev>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/slab.h | 13 +++++++++++++
 mm/slub.c | 55 +++++++++++++++++++++++++++++++++++++++++++------------
 2 files changed, 56 insertions(+), 12 deletions(-)

diff --git a/mm/slab.h b/mm/slab.h
index d86203131f58..482b8e0fe797 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -11,6 +11,7 @@
 #include <linux/memcontrol.h>
 #include <linux/kfence.h>
 #include <linux/kasan.h>
+#include <linux/slab.h>
 
 /*
  * Internal slab definitions
@@ -26,6 +27,18 @@ static inline bool alloc_flags_allow_spinning(const unsigned int alloc_flags)
 	return !(alloc_flags & SLAB_ALLOC_NOLOCK);
 }
 
+void *__kmalloc_flags_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t flags,
+				  unsigned int alloc_flags, int node)
+				  __assume_kmalloc_alignment __alloc_size(1);
+
+static __always_inline __alloc_size(1) void *_kmalloc_flags_noprof(size_t size,
+		gfp_t flags, unsigned int alloc_flags, int node, kmalloc_token_t token)
+{
+	return __kmalloc_flags_noprof(PASS_TOKEN_PARAMS(size, token), flags, alloc_flags, node);
+}
+#define kmalloc_flags_noprof(...)	_kmalloc_flags_noprof(__VA_ARGS__, __kmalloc_token(__VA_ARGS__))
+#define kmalloc_flags(...)		alloc_hooks(kmalloc_flags_noprof(__VA_ARGS__))
+
 #ifdef CONFIG_64BIT
 # ifdef system_has_cmpxchg128
 # define system_has_freelist_aba()	system_has_cmpxchg128()
diff --git a/mm/slub.c b/mm/slub.c
index 8769083bec81..383d39a22561 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5385,19 +5385,14 @@ void *__kmalloc_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t flags)
 }
 EXPORT_SYMBOL(__kmalloc_noprof);
 
-void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, int node)
+static void *__kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags,
+				     int node, const struct slab_alloc_context *ac)
 {
-	size_t orig_size = size;
-	unsigned int alloc_flags = SLAB_ALLOC_NOLOCK;
 	struct kmem_cache *s;
 	bool can_retry = true;
 	void *ret;
-	const struct slab_alloc_context ac = {
-		.caller_addr = _RET_IP_,
-		.orig_size = orig_size,
-		.alloc_flags = alloc_flags,
-	};
 
+	VM_WARN_ON_ONCE(alloc_flags_allow_spinning(ac->alloc_flags));
 	VM_WARN_ON_ONCE(gfp_flags & ~(__GFP_ACCOUNT | __GFP_ZERO |
 			__GFP_NO_OBJ_EXT | __GFP_NOWARN | __GFP_NOMEMALLOC));
 
@@ -5434,7 +5429,7 @@ void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, in
 		 */
 		return NULL;
 
-	ret = alloc_from_pcs(s, gfp_flags, alloc_flags, node);
+	ret = alloc_from_pcs(s, gfp_flags, ac->alloc_flags, node);
 	if (ret)
 		goto success;
 
@@ -5444,7 +5439,7 @@ void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, in
 	 * kfence_alloc. Hence call __slab_alloc_node() (at most twice)
 	 * and slab_post_alloc_hook() directly.
 	 */
-	ret = __slab_alloc_node(s, gfp_flags, node, &ac);
+	ret = __slab_alloc_node(s, gfp_flags, node, ac);
 
 	/*
 	 * It's possible we failed due to trylock as we preempted someone with
@@ -5467,11 +5462,23 @@ void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, in
 
 success:
 	maybe_wipe_obj_freeptr(s, ret);
-	slab_post_alloc_hook(s, gfp_flags, 1, &ret, &ac);
+	slab_post_alloc_hook(s, gfp_flags, 1, &ret, ac);
 
-	ret = kasan_kmalloc(s, ret, orig_size, gfp_flags);
+	ret = kasan_kmalloc(s, ret, ac->orig_size, gfp_flags);
 	return ret;
 }
+
+void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, int node)
+{
+	const struct slab_alloc_context ac = {
+		.caller_addr = _RET_IP_,
+		.orig_size = size,
+		.alloc_flags = SLAB_ALLOC_NOLOCK,
+	};
+
+	return __kmalloc_nolock_noprof(PASS_TOKEN_PARAMS(size, token),
+				       gfp_flags, node, &ac);
+}
 EXPORT_SYMBOL_GPL(_kmalloc_nolock_noprof);
 
 void *__kmalloc_node_track_caller_noprof(DECL_KMALLOC_PARAMS(size, b, token), gfp_t flags,
@@ -5525,6 +5532,30 @@ void *__kmalloc_cache_node_noprof(struct kmem_cache *s, gfp_t gfpflags,
 }
 EXPORT_SYMBOL(__kmalloc_cache_node_noprof);
 
+/*
+ * The only version of kmalloc_node() that takes alloc_flags and thus can
+ * determine on its own whether to handle the allocation via kmalloc_nolock() or
+ * normally
+ */
+void *__kmalloc_flags_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t flags,
+			     unsigned int alloc_flags, int node)
+{
+	const struct slab_alloc_context ac = {
+		.caller_addr = _RET_IP_,
+		.orig_size = size,
+		.alloc_flags = alloc_flags,
+	};
+
+	if (alloc_flags_allow_spinning(alloc_flags)) {
+		return __do_kmalloc_node(NULL, flags, node,
+				PASS_TOKEN_PARAM(token), &ac);
+	} else {
+		return __kmalloc_nolock_noprof(PASS_TOKEN_PARAMS(size, token),
+					       flags, node, &ac);
+	}
+}
+
+
 static noinline void free_to_partial_list(
 	struct kmem_cache *s, struct slab *slab,
 	void *head, void *tail, int bulk_cnt,

-- 
2.54.0

