From: Shakeel Butt <shakeelb@google.com>
Subject: [PATCH] slub: Don't panic for memcg kmem cache creation failure
Date: Wed, 19 Jun 2019 16:25:14 -0700
Message-ID: <20190619232514.58994-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=2Xe5CNu50mksX/zEQQqGlLiWQgOuxvE/hS5GIpxigKA=;
        b=g1it1EteZ/NGeK69zsjfHOTg9qZMabcBis5hFjOrlB2l+EFid2XH43a/H1Q98WQaN4
         EuaSsBaTPlqXmMYUHUth9G/bMVvlH6pFOoOKmzO5ypBeVy38P7a0Es8xFNAKHTRaabbw
         8raai+S+rVgHmvNm9WwaNFbh3CDbHzBDR0yc8D2i20C+AGY93ETkj7ecEaSTfenjJLSd
         fcu2WQVp0NMDR3iKV/rnrn6v8WivwS78j6PGG20RxN0RiXWs5GoTqxJGDi9W1+QRi9g4
         d0z67gIh/nncaGZD0tfYFyUqwU/UD9ePElOit5dKhGB4YOjiUpRTPlAbsW+SCWdDRbSB
         Q3KA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>, Christoph Lameter <cl@linux.com>, Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Shakeel Butt <shakeelb@google.com>, Dave Hansen <dave.hansen@intel.com>

Currently for CONFIG_SLUB, if a memcg kmem cache creation is failed and
the corresponding root kmem cache has SLAB_PANIC flag, the kernel will
be crashed. This is unnecessary as the kernel can handle the creation
failures of memcg kmem caches. Additionally CONFIG_SLAB does not
implement this behavior. So, to keep the behavior consistent between
SLAB and SLUB, removing the panic for memcg kmem cache creation
failures. The root kmem cache creation failure for SLAB_PANIC correctly
panics for both SLAB and SLUB.

Reported-by: Dave Hansen <dave.hansen@intel.com>
Signed-off-by: Shakeel Butt <shakeelb@google.com>
---
 mm/slub.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 6a5174b51cd6..84c6508e360d 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3640,10 +3640,6 @@ static int kmem_cache_open(struct kmem_cache *s, slab_flags_t flags)
 
 	free_kmem_cache_nodes(s);
 error:
-	if (flags & SLAB_PANIC)
-		panic("Cannot create slab %s size=%u realsize=%u order=%u offset=%u flags=%lx\n",
-		      s->name, s->size, s->size,
-		      oo_order(s->oo), s->offset, (unsigned long)flags);
 	return -EINVAL;
 }
 
-- 
2.22.0.410.gd8fdbe21b5-goog

