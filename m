Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF58F3EF64F;
	Tue,  9 Jun 2026 09:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780996683; cv=none; b=tPaWnym25alIedjeeyWweHuUMgoBlM+nMI7dmOzJPpJ9HnangkfpM3QO7PAQf/AFLW7v6B8yvi9m3Z0MCHHiQjcUAlfoN/ZMY3Ob8EPOtcTAIjXDT2XCOlCSsORaXNQALYClE4dTo1iJ0obtPcm6GYT6J57F5snTW7p0aYNIdAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780996683; c=relaxed/simple;
	bh=gFcZBhFzW5NkF8kcnntqDsKywGM6S+YvsfB6MNovero=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=FQt9+J7tSLnxwxFWnwODQRKiwWnVBN9SMyCJNUo3BEz8RaEc6vUIPzYqw1ZymVgPW/yz0OjZNqblDNNVN3FGyMZpSr1Ens3g9hBF1/prnnMt8jrJIYkd4mclCPEakOecOgo5fMdlee+JKSvfBUf5WdfZK+5UquAfFSNdbtB/CFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EwWzpVtx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EwWzpVtx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 186051F0089A;
	Tue,  9 Jun 2026 09:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780996682;
	bh=bvHD+M5eqRU8vVzuDK3OdPD9YFSs1FhVN9CwKgx6w+4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=EwWzpVtx8lJmQmJHm7yEhQSONZqQWXPzp9YlWF8zTHmBmWejy22deW0f5F1bJX69y
	 H3psOwlagOJkgHekG275fpHqMAMD9rF4PQwsQF+clC6fBuwuIUKUnmrVft4tEsRePK
	 R0ITq1mDTxnmsTeg5lirWpQd/MAM5cpuvyfmdBsZObis0fN6BZkCZg6xoJZ+PucWpK
	 MzBk7CAqFXU/ynrTHIFGSgiG3v9YDsKl7kQeWb5WcJH6IKN8t9xxHaWA1slsyrqIhn
	 s/Fqtf2Ng2+59Iq0gsSekyju0UdwBprhZdEQGDIwmjCyFmQps+ZWqrCKHyOmcr2SrI
	 YWNTTrY5UMp0g==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Tue, 09 Jun 2026 11:17:47 +0200
Subject: [PATCH RFC 02/15] mm/slab: stop inlining __slab_alloc_node()
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260609-slab_alloc_flags-v1-2-2bf4a4b9b526@kernel.org>
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

With sheaves, this is no longer part of the allocation fastpath.  For
the same reason, also mark the call to it from slab_alloc_node() as
unlikely().

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/slub.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index f787dc422d1b..af85f338db4f 100644
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
 
@@ -4907,7 +4907,7 @@ static __fastpath_inline void *slab_alloc_node(struct kmem_cache *s, struct list
 
 	object = alloc_from_pcs(s, gfpflags, node);
 
-	if (!object)
+	if (unlikely(!object))
 		object = __slab_alloc_node(s, gfpflags, node, addr, orig_size);
 
 	maybe_wipe_obj_freeptr(s, object);

-- 
2.54.0

