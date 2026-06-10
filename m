Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AF29449ED7;
	Wed, 10 Jun 2026 15:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781106044; cv=none; b=NLzMPFjRqkIOrUNLE/wolRKw7x6MHUeQ1NYHpOqMrgIYAEXm0kfSLh+IqgMhYDY+4E2XHGgIjrD8g7KcdZ/y4ObEp1C8xyvpxNiUh6hB4GBnEMubGu0g33Mpfy9Z2pCow94R54ftWJO8AmHBqQF8so6KMWjP7An/tiJ3Se8Pn7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781106044; c=relaxed/simple;
	bh=8602drIWvaMzE1J7gRFwq87zIHWzXIetqQvqoPq1HB4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=qSV80L5GiJ0SWwaB0nI/5p4bcj2MuPg0mJLgn+HD332wTvDtnZFDoej391fOi4nxqLr7QmZ/mRntTIzjmsQLn9k5S2q7PTtcCiGKv3kWrD881AI9aXIO36Qo6oUHUJwjZ5dqZlMipdIo7i2+799MEajHmztX+by3LH/eLlNM/VA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UaFWjH3U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UaFWjH3U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67B281F00898;
	Wed, 10 Jun 2026 15:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781106043;
	bh=Z++mZQokUZ73KMQBNMzzxOT6j7m/HHKA2PQwEqwlqcs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=UaFWjH3USM6+6T78Sjt/86W5bncAKXl2WivN7Bst2gu6MiEIipnORJuiZFcoMwV32
	 xupyRppQ++6a/7mKK+ctOLW5TePbzH3Yhw2E+7p4WhromGLsj9GNbMMLgRYi6l8/EN
	 ghoK46HcRrwqjfqY+ZGfOJDMbVPniXXl9hxUycYLI1AQyF9WNrUtthXOq224WXXReg
	 i/0NoPpfo7Qa9c3nnyqprZmjds3O4z7fn1inJhaSt31jFA+F8Vt4Wq3cbZZtNGFC6X
	 TmL/+f7gRnrwWNcxtIb4i4ZNqDxx/jkfHxfqjjMFRbq8YCQyI7QkHCTWfzaHOaepxt
	 2H3HaPXzgcwhg==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Wed, 10 Jun 2026 17:40:05 +0200
Subject: [PATCH v2 03/16] mm/slab: stop inlining __slab_alloc_node()
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260610-slab_alloc_flags-v2-3-7190909db118@kernel.org>
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

With sheaves, this is no longer part of the allocation fastpath.  For
the same reason, also mark the call to it from slab_alloc_node() as
unlikely().

Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/slub.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 8e5264d3ddbf..7b48c0d38404 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4519,8 +4519,8 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 	return object;
 }
 
-static __always_inline void *__slab_alloc_node(struct kmem_cache *s,
-		gfp_t gfpflags, int node, unsigned long addr, size_t orig_size)
+static void *__slab_alloc_node(struct kmem_cache *s, gfp_t gfpflags, int node,
+			       unsigned long addr, size_t orig_size)
 {
 	void *object;
 
@@ -4923,7 +4923,7 @@ static __fastpath_inline void *slab_alloc_node(struct kmem_cache *s, struct list
 
 	object = alloc_from_pcs(s, gfpflags, node);
 
-	if (!object)
+	if (unlikely(!object))
 		object = __slab_alloc_node(s, gfpflags, node, addr, orig_size);
 
 	maybe_wipe_obj_freeptr(s, object);

-- 
2.54.0

