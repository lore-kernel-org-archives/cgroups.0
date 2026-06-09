Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E4413F4831;
	Tue,  9 Jun 2026 09:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780996703; cv=none; b=cS1qWjqPVtEc0ZfgrC85U6wupjmvgJOLvI7BJqobzg3CCGb1xF8JyatHa0WIOzVsdK8NzcTlrZpp/1WWowfAoRyqH4Q8HZHV62v9/CAyCuY2iiaojNEk9fioNuCMHYZ5+LKIPA4fg7pmEI/RKjC26PV6TQTgGnxXB7y/EAhsToo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780996703; c=relaxed/simple;
	bh=sjEEzLRuaqLLAW55S/ondGJWXtmb85RaReSQIT51yGc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=GWeq6LbyC9OI2uQroAwGOS69Cfep4jrSxa5swvC9eBfnOpQPxK3kPFK6VaWtbEt9He5DFckH6vczY2p5rVwOS1AUBa9gcVUb0TiTK/ISdAVeIsD3iuEbclYX18m+gYyEgnG7AgguSGE2Mno5JKfuM4WnET9ESdRXIcxBH2KMt2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UtZ6gzxN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UtZ6gzxN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1DAE1F00899;
	Tue,  9 Jun 2026 09:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780996702;
	bh=lUdhGEsiIkmEk98q3M/PwP2pTSml7IktU/L4N6zTfjk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=UtZ6gzxNRqJnwAm06gvctWhYRD1xV7p2uYuLW7IkT76bgUGxQilzhLe4h3POLT3Rl
	 Fli0goPoJ6XbQS+O5oCeQfJ2cbwUPao6Zwqtf+P8nkcgt3cTTd624a1s0d+g+IVCPd
	 ZV6sDEdiH4Hf9pRMTAiPubWpczu7irXpSc0IYDV0v3CuiqqhVdy8Xw4yRIyXh+SB1N
	 N8NJgQTKSPWxWf5J9DFruOAPnOi3MpleCxvmh9/O/zXFevg1klFbMT0NQ8G9k7exJb
	 gkY0drGG8uu275WdSpHbUjFN7uGnWgkl2HKp+8MejZtPbku79OJZogCD86MRsJD8dk
	 ZZSeyyeLJAWLg==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Tue, 09 Jun 2026 11:17:52 +0200
Subject: [PATCH RFC 07/15] mm/slab: pass alloc_flags to new slab allocation
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260609-slab_alloc_flags-v1-7-2bf4a4b9b526@kernel.org>
References: <20260609-slab_alloc_flags-v1-0-2bf4a4b9b526@kernel.org>
In-Reply-To: <20260609-slab_alloc_flags-v1-0-2bf4a4b9b526@kernel.org>
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

Add the alloc_flags parameter to allocate_slab() and new_slab()
so it can be used to determine if spinning is allowed, independently
from gfp flags.

refill_objects() passes SLAB_ALLOC_DEFAULT because it can only be
reached from contexts that allow spinning.

Also change how trynode_flags are constructed in ___slab_alloc() to
achieve the same "do not upgrade to GFP_NOWAIT" by using masking instead
of a branch. It will now also not upgrade in cases where gfp is weaker
than GFP_NOWAIT (i.e. lacks __GFP_KSWAPD_RECLAIM) but doesn't come from
kmalloc_nolock() - which is more correct anyway.

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/slub.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 0bde4f6d9126..20df6b131f63 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3378,9 +3378,10 @@ static __always_inline void unaccount_slab(struct slab *slab, int order,
 }
 
 /* Allocate and initialize a slab without building its freelist. */
-static struct slab *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
+static struct slab *allocate_slab(struct kmem_cache *s, gfp_t flags,
+				  unsigned int alloc_flags, int node)
 {
-	bool allow_spin = gfpflags_allow_spinning(flags);
+	bool allow_spin = alloc_flags_allow_spinning(alloc_flags);
 	struct slab *slab;
 	struct kmem_cache_order_objects oo = s->oo;
 	gfp_t alloc_gfp;
@@ -3438,15 +3439,17 @@ static struct slab *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
 	return slab;
 }
 
-static struct slab *new_slab(struct kmem_cache *s, gfp_t flags, int node)
+static struct slab *new_slab(struct kmem_cache *s, gfp_t flags,
+			     unsigned int alloc_flags, int node)
 {
 	if (unlikely(flags & GFP_SLAB_BUG_MASK))
 		flags = kmalloc_fix_flags(flags);
 
 	WARN_ON_ONCE(s->ctor && (flags & __GFP_ZERO));
 
-	return allocate_slab(s,
-		flags & (GFP_RECLAIM_MASK | GFP_CONSTRAINT_MASK), node);
+	flags &= GFP_RECLAIM_MASK | GFP_CONSTRAINT_MASK;
+
+	return allocate_slab(s, flags, alloc_flags, node);
 }
 
 static void __free_slab(struct kmem_cache *s, struct slab *slab, bool allow_spin)
@@ -4467,25 +4470,22 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 	 * 1) try to get a partial slab from target node only by having
 	 *    __GFP_THISNODE in pc.flags for get_from_partial()
 	 * 2) if 1) failed, try to allocate a new slab from target node with
-	 *    GPF_NOWAIT | __GFP_THISNODE opportunistically
+	 *    (at most) GPF_NOWAIT | __GFP_THISNODE opportunistically
 	 * 3) if 2) failed, retry with original gfpflags which will allow
 	 *    get_from_partial() try partial lists of other nodes before
 	 *    potentially allocating new page from other nodes
 	 */
 	if (unlikely(node != NUMA_NO_NODE && !(gfpflags & __GFP_THISNODE)
 		     && try_thisnode)) {
-		if (unlikely(!allow_spin))
-			/* Do not upgrade gfp to NOWAIT from more restrictive mode */
-			trynode_flags = gfpflags | __GFP_THISNODE;
-		else
-			trynode_flags = GFP_NOWAIT | __GFP_THISNODE;
+		trynode_flags &= GFP_NOWAIT;
+		trynode_flags |= __GFP_NOWARN | __GFP_THISNODE;
 	}
 
 	object = get_from_partial(s, node, trynode_flags, ac);
 	if (object)
 		goto success;
 
-	slab = new_slab(s, trynode_flags, node);
+	slab = new_slab(s, trynode_flags, ac->alloc_flags, node);
 
 	if (unlikely(!slab)) {
 		if (node != NUMA_NO_NODE && !(gfpflags & __GFP_THISNODE)
@@ -7215,7 +7215,7 @@ refill_objects(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int min,
 
 new_slab:
 
-	slab = new_slab(s, gfp, local_node);
+	slab = new_slab(s, gfp, SLAB_ALLOC_DEFAULT, local_node);
 	if (!slab)
 		goto out;
 
@@ -7563,7 +7563,7 @@ static void early_kmem_cache_node_alloc(int node)
 
 	BUG_ON(kmem_cache_node->size < sizeof(struct kmem_cache_node));
 
-	slab = new_slab(kmem_cache_node, GFP_NOWAIT, node);
+	slab = new_slab(kmem_cache_node, GFP_NOWAIT, SLAB_ALLOC_DEFAULT, node);
 
 	BUG_ON(!slab);
 	if (slab_nid(slab) != node) {

-- 
2.54.0

