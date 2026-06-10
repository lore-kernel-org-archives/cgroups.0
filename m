Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83D9843D4EF;
	Wed, 10 Jun 2026 15:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781106110; cv=none; b=N+Cj4IBSHOpwY9RvozAmBvDbSVtCvdVVevfdGqKYaNBb59t8XambCun9Kar1xpH4Yl3ji15ZIl1l9HLGmcBqNgTZEshrASqz7gDoPhXqCTBMldVzSHOPaJ7sYHwljIm4jemCj2Vaut6tPzbuwaqTgNR4klZ0F0xx5QVPLDuRQn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781106110; c=relaxed/simple;
	bh=/4WmPX44Q4AFm8S99K3lkmPJVJCVaZFE72dvTQFFoto=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=aU7z8CGbvFcYrKvbAArT+L1jdVKyTNkzHfUYpo5YbaKuCUkk766GdgpRHIcUA5tpX0vWAr+pSzNu/xK281LRUtHQD9BcKf9KQmjKTwYLGpfW1FjscSqgkNKm3MycMHVxSHw9Nli3tGxCOwo2SynK6BgLtWNLklJJxbA26KszmFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Su1gbBTv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Su1gbBTv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65E8B1F00893;
	Wed, 10 Jun 2026 15:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781106108;
	bh=Z4p7lBTo620lw4Cx9cPSuEFRwzQZKtUkN/W+8V4LMiY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Su1gbBTvmRn8OWDOvh3qn3pI4cAxHZ45px1Swujt8aZRyDQ2J7bmOwZiD1kaqqChI
	 HetPcwR6LmZcW4IC8PlXBx/UmddVjTIcdIO3FOs6AnS58JKxtaPhIbT8wb8accI83E
	 g3t5AfHsFGIIRPOYjEHT7BPV7OtTDbuAdMQEiStz5Jixcbxo4J3KK2+gvgEWDBCmF9
	 jccFfMTKAgQnaLM37K620iiUYGXcScDJS/t6B9eG+EKRovUFFlWbdVryacWBLk9mm9
	 HOk6gy3RMYea3PCFfmfHKRA/snC0KQNkbfiwHpIfsxc1d5g3cME27KqU1tmsG9tWvk
	 kD/LblYVS9Dow==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Wed, 10 Jun 2026 17:40:14 +0200
Subject: [PATCH v2 12/16] mm/slab: pass slab_alloc_context to
 __do_kmalloc_node()
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260610-slab_alloc_flags-v2-12-7190909db118@kernel.org>
References: <20260610-slab_alloc_flags-v2-0-7190909db118@kernel.org>
In-Reply-To: <20260610-slab_alloc_flags-v2-0-7190909db118@kernel.org>
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

As a preparatory step, make __do_kmalloc_node() take a pointer to
slab_alloc_context. This replaces the 'caller' parameter and includes
alloc_flags which we'll make use of.

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/slub.c | 47 ++++++++++++++++++++++++++++++++---------------
 1 file changed, 32 insertions(+), 15 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index ef457e07db83..6845e15c148a 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5338,19 +5338,14 @@ EXPORT_SYMBOL(__kmalloc_large_node_noprof);
 
 static __always_inline
 void *__do_kmalloc_node(size_t size, kmem_buckets *b, gfp_t flags, int node,
-			unsigned long caller, kmalloc_token_t token)
+			kmalloc_token_t token, struct slab_alloc_context *ac)
 {
 	struct kmem_cache *s;
 	void *ret;
-	struct slab_alloc_context ac = {
-		.caller_addr = caller,
-		.orig_size = size,
-		.alloc_flags = SLAB_ALLOC_DEFAULT,
-	};
 
 	if (unlikely(size > KMALLOC_MAX_CACHE_SIZE)) {
 		ret = __kmalloc_large_node_noprof(size, flags, node);
-		trace_kmalloc(caller, ret, size,
+		trace_kmalloc(ac->caller_addr, ret, size,
 			      PAGE_SIZE << get_order(size), flags, node);
 		return ret;
 	}
@@ -5360,22 +5355,34 @@ void *__do_kmalloc_node(size_t size, kmem_buckets *b, gfp_t flags, int node,
 
 	s = kmalloc_slab(size, b, flags, token);
 
-	ret = slab_alloc_node(s, flags, node, &ac);
+	ret = slab_alloc_node(s, flags, node, ac);
 	ret = kasan_kmalloc(s, ret, size, flags);
-	trace_kmalloc(caller, ret, size, s->size, flags, node);
+	trace_kmalloc(ac->caller_addr, ret, size, s->size, flags, node);
 	return ret;
 }
 void *__kmalloc_node_noprof(DECL_KMALLOC_PARAMS(size, b, token), gfp_t flags, int node)
 {
+	struct slab_alloc_context ac = {
+		.caller_addr = _RET_IP_,
+		.orig_size = size,
+		.alloc_flags = SLAB_ALLOC_DEFAULT,
+	};
+
 	return __do_kmalloc_node(size, PASS_BUCKET_PARAM(b), flags, node,
-				 _RET_IP_, PASS_TOKEN_PARAM(token));
+				 PASS_TOKEN_PARAM(token), &ac);
 }
 EXPORT_SYMBOL(__kmalloc_node_noprof);
 
 void *__kmalloc_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t flags)
 {
-	return __do_kmalloc_node(size, NULL, flags,  NUMA_NO_NODE, _RET_IP_,
-				 PASS_TOKEN_PARAM(token));
+	struct slab_alloc_context ac = {
+		.caller_addr = _RET_IP_,
+		.orig_size = size,
+		.alloc_flags = SLAB_ALLOC_DEFAULT,
+	};
+
+	return __do_kmalloc_node(size, NULL, flags,  NUMA_NO_NODE,
+				 PASS_TOKEN_PARAM(token), &ac);
 }
 EXPORT_SYMBOL(__kmalloc_noprof);
 
@@ -5471,9 +5478,14 @@ EXPORT_SYMBOL_GPL(_kmalloc_nolock_noprof);
 void *__kmalloc_node_track_caller_noprof(DECL_KMALLOC_PARAMS(size, b, token), gfp_t flags,
 					 int node, unsigned long caller)
 {
-	return __do_kmalloc_node(size, PASS_BUCKET_PARAM(b), flags, node,
-				 caller, PASS_TOKEN_PARAM(token));
+	struct slab_alloc_context ac = {
+		.caller_addr = caller,
+		.orig_size = size,
+		.alloc_flags = SLAB_ALLOC_DEFAULT,
+	};
 
+	return __do_kmalloc_node(size, PASS_BUCKET_PARAM(b), flags, node,
+				 PASS_TOKEN_PARAM(token), &ac);
 }
 EXPORT_SYMBOL(__kmalloc_node_track_caller_noprof);
 
@@ -6874,6 +6886,11 @@ void *__kvmalloc_node_noprof(DECL_KMALLOC_PARAMS(size, b, token), unsigned long
 {
 	bool allow_block;
 	void *ret;
+	struct slab_alloc_context ac = {
+		.caller_addr = _RET_IP_,
+		.orig_size = size,
+		.alloc_flags = SLAB_ALLOC_DEFAULT,
+	};
 
 	/*
 	 * It doesn't really make sense to fallback to vmalloc for sub page
@@ -6881,7 +6898,7 @@ void *__kvmalloc_node_noprof(DECL_KMALLOC_PARAMS(size, b, token), unsigned long
 	 */
 	ret = __do_kmalloc_node(size, PASS_BUCKET_PARAM(b),
 				kmalloc_gfp_adjust(flags, size),
-				node, _RET_IP_, PASS_TOKEN_PARAM(token));
+				node, PASS_TOKEN_PARAM(token), &ac);
 	if (ret || size <= PAGE_SIZE)
 		return ret;
 

-- 
2.54.0

