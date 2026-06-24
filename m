Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF54D3B2D0D;
	Wed, 24 Jun 2026 13:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782306739; cv=none; b=Y3IgJNGGnA00+2y79d+teDf0ItMeaReuvUmnOuh8bz/KPu1I3FcpxrKwHb1hvEGQrlL0CcFruCzBycEr6FaVISNIeGSdOx3L9Ex0kPZrZnkdeqvNMgn+1W7PVxMdys4BMYnPeyrbQIQx1mjsxXp0DX095YlDNR+B0Ec7CnefhUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782306739; c=relaxed/simple;
	bh=ZBbtPkUUD09Gk9z86imvi7y/yl8hTh+j2Zxk+kXEVe8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=R3q+PSXEP+9IQPYOBO1cTiJ0kRNphXGZxjavOdoD3WE4YTvMMx3SxeC7PeqXFbmJGmLvsz7M3txODpax0TSePd412CQ6BRt/wVGG4tvsABMMrnV/IqRQGNomLqbn6FZidKbgWrb4AZUTEdmNVEIbwyEC/V9RMkZP3YBAb96iJSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X8wi8DxC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X8wi8DxC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4CF51F00A3D;
	Wed, 24 Jun 2026 13:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782306737;
	bh=pH+P1A8V8KYcn2HoUYmytNSMd9QH6OkhOZdd7wOXtm4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=X8wi8DxCVvf2fDIieTQiC+2oqznJvQ5h71UPWbCLrs/szy1LUvFqkrAEP3kHkFRZM
	 kBVGfc8bu4d7UukFgsr+RWKod2Pg+VHMheIRWy/oePtVLghKNk2v05qIDXCS3vQWhg
	 uZx8Wfyj2sTCDZN3bwOe+O0XS4LWocVPPLz3u7iVk1cg6jR9sN7zaHPJt/7Ce2e6ME
	 7gHFXLDGnxmPbsKddrT8XNq7s5mnmgaGjEoG85wx+4SLrmBTknDqjxdPV5BoCj19Ti
	 KZfyjRMzOQ046/xXjrpkRTtsaP+q5U03TtatiLgQHIfNWwXuQj1b1QME0ArQHH55P6
	 gE4kalO0HRzcA==
From: "Harry Yoo (Oracle)" <harry@kernel.org>
Date: Wed, 24 Jun 2026 22:11:40 +0900
Subject: [PATCH RFC 3/4] mm/slab: fix a deadlock in
 memcg_alloc_abort_single()
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260624-kmalloc-nolock-fixes-v1-3-fdf4d17351dd@kernel.org>
References: <20260624-kmalloc-nolock-fixes-v1-0-fdf4d17351dd@kernel.org>
In-Reply-To: <20260624-kmalloc-nolock-fixes-v1-0-fdf4d17351dd@kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Hao Li <hao.li@linux.dev>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Alexei Starovoitov <ast@kernel.org>, Pedro Falcato <pfalcato@suse.de>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org
X-Mailer: b4 0.14.3

When kmalloc_nolock() successfully grabs a slab object but memcg aborts
the allocation, the object is freed via __slab_free(). Calling
__slab_free() in unknown context is not allowed and can lead to a
deadlock.

Free the object via defer_free() when spinning is not allowed.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260610-slab_alloc_flags-v2-0-7190909db118%40kernel.org?part=9
Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and kfree_nolock().")
Cc: stable@vger.kernel.org
Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
---
 mm/slub.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 85760c8ff2e2..4a3618e3967e 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2459,7 +2459,8 @@ alloc_tagging_slab_free_hook(struct kmem_cache *s, struct slab *slab, void **p,
 
 #ifdef CONFIG_MEMCG
 
-static void memcg_alloc_abort_single(struct kmem_cache *s, void *object);
+static void memcg_alloc_abort_single(struct kmem_cache *s, void *object,
+				     bool allow_spin);
 
 static __fastpath_inline
 bool memcg_slab_post_alloc_hook(struct kmem_cache *s, gfp_t flags,
@@ -2477,7 +2478,9 @@ bool memcg_slab_post_alloc_hook(struct kmem_cache *s, gfp_t flags,
 		return true;
 
 	if (likely(size == 1)) {
-		memcg_alloc_abort_single(s, *p);
+		bool allow_spin = alloc_flags_allow_spinning(ac->alloc_flags);
+
+		memcg_alloc_abort_single(s, *p, allow_spin);
 		*p = NULL;
 	} else {
 		kmem_cache_free_bulk(s, size, p);
@@ -6436,16 +6439,20 @@ void slab_free(struct kmem_cache *s, struct slab *slab, void *object,
 #ifdef CONFIG_MEMCG
 /* Do not inline the rare memcg charging failed path into the allocation path */
 static noinline
-void memcg_alloc_abort_single(struct kmem_cache *s, void *object)
+void memcg_alloc_abort_single(struct kmem_cache *s, void *object, bool allow_spin)
 {
 	struct slab *slab = virt_to_slab(object);
 	bool init = slab_want_init_on_free(s);
-	bool allow_spin = true;
 
 	alloc_tagging_slab_free_hook(s, slab, &object, 1);
 
-	if (likely(slab_free_hook(s, object, init, false, allow_spin)))
+	if (unlikely(!slab_free_hook(s, object, init, false, allow_spin)))
+		return;
+
+	if (likely(allow_spin))
 		__slab_free(s, slab, object, object, 1, _RET_IP_);
+	else
+		defer_free(s, object);
 }
 #endif
 

-- 
2.53.0

