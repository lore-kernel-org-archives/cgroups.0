Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17EE03E9C23;
	Mon, 15 Jun 2026 11:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781524513; cv=none; b=rJ98Kju5sfHeqBTNyVD/uKCh0sGm5m5s6uz8DHMyWhuCFYsjkRd8AWoD6mNRFulyghsEd1TP5FUZI48aeuRKN9B4wyC81mnPIALPXHNYgIdx+dQkhcPh1vryd6qJOZFu/lPH7osdsdn1bbfkB7BFtlr+HP6Cb6mS3JtrX3dn8Rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781524513; c=relaxed/simple;
	bh=IBooEieX50omRW0Gm5Luqmfa7FnR2qSW66TG/fUQxTY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=G0iqTL6+kzRiINVnfYP7+t/eAVl5aS6JKSZbPChsN3hzGKEuuLV44jm/HcQic3qf5jpPEE9AqGbs8Bn6SjXhpSBgcabjsz5FXbqu0fpAbH+7wTPB4YG5QQdV0SkizSh67nAm0QZpCGMmToKfS2cwdpUIcmSVRIfe1QslOmZbz/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HdaqbaKd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HdaqbaKd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 816081F00A3D;
	Mon, 15 Jun 2026 11:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781524512;
	bh=clKGU2J3FECfFFvrlPmzCBUH3Fhm/wSfYtcUHaC+zIs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=HdaqbaKdUA2kThvtHmI9K1RSKSZN7JliY3uoWE9tdZ+lHtxjpLN0Xsf1YV/zwEW2a
	 4OoHorFuZYbQuyP8SA0gmcbTiFBxjbKqUkm94brLiIJB+UV3G06OThCxRQ81vjWWcz
	 SH/ZZCuD6p24R4PD2shjgWg+Oxp6ZxzeEZwRm6uh8bcalScp5KZpTGVt9lxpUS05nE
	 o1i4KjoENaC63p9ngR3nyfhcIQ5AXdPxVpEG949JZ2Jk4AzWuIlY4Qqu4HIo9L9lsa
	 DyDSrVMg/+wnLtyMiB6FL/xFJLwCjX28UJHj0FhtNQzKxSHBDCZy39YxjrWRZSPTUQ
	 +a3MoAu9VPjmw==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Mon, 15 Jun 2026 13:54:40 +0200
Subject: [PATCH v3 07/15] mm/slab: pass alloc_flags to new slab allocation
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260615-slab_alloc_flags-v3-7-ce1146d140fb@kernel.org>
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

Add the alloc_flags parameter to allocate_slab() and new_slab()
so it can be used to determine if spinning is allowed, independently
from gfp flags.

refill_objects() passes SLAB_ALLOC_DEFAULT because it can only be
reached from contexts that allow spinning.

Link: https://patch.msgid.link/20260610-slab_alloc_flags-v2-8-7190909db118@kernel.org
Reviewed-by: Hao Li <hao.li@linux.dev>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/slub.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 3a34907b881b..a975a2e727c8 100644
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
@@ -3398,10 +3399,6 @@ static struct slab *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
 	if ((alloc_gfp & __GFP_DIRECT_RECLAIM) && oo_order(oo) > oo_order(s->min))
 		alloc_gfp = (alloc_gfp | __GFP_NOMEMALLOC) & ~__GFP_RECLAIM;
 
-	/*
-	 * __GFP_RECLAIM could be cleared on the first allocation attempt,
-	 * so pass allow_spin flag directly.
-	 */
 	slab = alloc_slab_page(alloc_gfp, node, oo, allow_spin);
 	if (unlikely(!slab)) {
 		oo = s->min;
@@ -3438,15 +3435,17 @@ static struct slab *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
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
@@ -4482,7 +4481,7 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 	if (object)
 		goto success;
 
-	slab = new_slab(s, trynode_flags, node);
+	slab = new_slab(s, trynode_flags, ac->alloc_flags, node);
 
 	if (unlikely(!slab)) {
 		if (node != NUMA_NO_NODE && !(gfpflags & __GFP_THISNODE)
@@ -7230,7 +7229,7 @@ refill_objects(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int min,
 
 new_slab:
 
-	slab = new_slab(s, gfp, local_node);
+	slab = new_slab(s, gfp, SLAB_ALLOC_DEFAULT, local_node);
 	if (!slab)
 		goto out;
 
@@ -7578,7 +7577,7 @@ static void early_kmem_cache_node_alloc(int node)
 
 	BUG_ON(kmem_cache_node->size < sizeof(struct kmem_cache_node));
 
-	slab = new_slab(kmem_cache_node, GFP_NOWAIT, node);
+	slab = new_slab(kmem_cache_node, GFP_NOWAIT, SLAB_ALLOC_DEFAULT, node);
 
 	BUG_ON(!slab);
 	if (slab_nid(slab) != node) {

-- 
2.54.0

