Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793717301;
	b=PrBterFyBHgK2IRZ+hwBHyfa5rYvoa4OnbfiEZywqtwle1PHEXjQ146UKRLADCXGiSW8
	 g06lLw8UY5fzAi0cc4b2CFrmumDvJTErFSROg2JGy65iGnAxpUGJSGoLYeyxfk27UlUCn
	 FXiG93vwUbTiCPqMK4ZqajEVylt3NUikejN7Kr6spPtpBQxSfTVvp/a9yY9F8cDf5f0T6
	 IZk9kVeHXi9huIcCnoelCsfgRaCqfDALOuX/zNasK2IcG1eGpBuQaXa6hKRmmCpKYeHrD
	 CnXlOS4X0jm4EJuaaRIIuwi3se13nx8SkGMRe1ljGsEz2lWhSSKHsAG0PLWjlnmxiYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793717301;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer;
	bh=gD+JfyFsFqSMM5CGTKNOp21IwpvoIZuhMHjwjkhQ9Y4=;
	b=CTfS7iKYSM73fH4YJR2YLp/qNj2BhypAg0rOHP+WY2prj6vhJS2y4CXKWENYM05yUiqv
	 AkWRAFurZpHMXsoCP9RI+zErSKKKP4lr8K9yAu6nbBpunRMVMU4J88jw3D7xgITVuxFk/
	 bZRGNOQw6vye6ToaZAHviOz4nl9crcAVnJ9Ck7canxpUyyS4nCnvGsuaf8l/EHhSCX/dQ
	 zUrFHBkmBogxmfhRKmehmO8zuQe1MPZWKRfgYFF8NVlN3AvzygO97zDDLzphsld5j2Dwv
	 KIZBsc6t1+gFqw8pyBQZEIaHuvzFWnpy9hXiZI4Bs+PCxQmJ5bXYdmHqVvtrLRuwYTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O77gfe8k;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B06266071C35;
	Tue,  3 Nov 2026 14:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O77gfe8k
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0324C1F00A02;
	Tue,  3 Nov 2026 14:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793717300;
	bh=gD+JfyFsFqSMM5CGTKNOp21IwpvoIZuhMHjwjkhQ9Y4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=O77gfe8kp25hNoBGGIpC6DtRiBGmJPBhWTL/hDCA5+40SPpjiLXP+1QdEzJtXYuk8
	 PGqiTX3BM5EwlBxY4d77MPivJkSwbOK9K8gWZKUCbRLj268RO5hcZWX2HEN/rpCv8m
	 IQZe8dH2k2nvGSXI6U7HnXrlw3KVT5+4UuwqNblGOLfjAktu2xrAejReS/e+4O76ml
	 uLIr3xHA+hTy6w/ig2jAXuCk0KXSr1iSqFdXByf+ozWqigWRvLaIggx4fsyICZvUXv
	 /Rpc9v4Kn8Kw3JD2ei8tFnzdFKhVulxHaMnj5Z23rw21Ynd4QIva2GCVTVPgiY2LVG
	 jaEOxNCbwa13Q==
From: "Harry Yoo (Meta)" <harry@kernel.org>
Date: Tue, 03 Nov 2026 14:47:53 +0000
Subject: [PATCH for-next-fixes v2 4/5] mm/slab: fix a deadlock in
 memcg_alloc_abort_single()
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261103-kmalloc-nolock-fixes-v2-4-19167cfe4779@kernel.org>
References: <20261103-kmalloc-nolock-fixes-v2-0-19167cfe4779@kernel.org>
In-Reply-To: <20261103-kmalloc-nolock-fixes-v2-0-19167cfe4779@kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, Harry Yoo <harry@kernel.org>, 
 Alexei Starovoitov <ast@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: kernel-team@meta.com, cgroups@vger.kernel.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev, 
 Sashiko <sashiko-bot@kernel.org>
X-Mailer: b4 0.16.0

When kmalloc_nolock() successfully grabs a slab object but memcg aborts
the allocation, the object is freed via __slab_free(). Calling
__slab_free() in unknown context is not allowed and can lead to a
deadlock.

Free the object via defer_free() when spinning is not allowed.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260610-slab_alloc_flags-v2-0-7190909db118%40kernel.org?part=9
Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and kfree_nolock().")
Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/slub.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 48415f24e115..6dfa8ca3c937 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2533,7 +2533,8 @@ static inline void slab_obj_ext_has_codetag_init(void)
 
 #ifdef CONFIG_MEMCG
 
-static void memcg_alloc_abort_single(struct kmem_cache *s, void *object);
+static void memcg_alloc_abort_single(struct kmem_cache *s, void *object,
+				     bool allow_spin);
 
 static __fastpath_inline
 bool memcg_slab_post_alloc_hook(struct kmem_cache *s, gfp_t flags,
@@ -2551,7 +2552,9 @@ bool memcg_slab_post_alloc_hook(struct kmem_cache *s, gfp_t flags,
 		return true;
 
 	if (likely(size == 1)) {
-		memcg_alloc_abort_single(s, *p);
+		bool allow_spin = alloc_flags_allow_spinning(ac->alloc_flags);
+
+		memcg_alloc_abort_single(s, *p, allow_spin);
 		*p = NULL;
 	} else {
 		kmem_cache_free_bulk(s, size, p);
@@ -6663,16 +6666,20 @@ void slab_free(struct kmem_cache *s, struct slab *slab, void *object,
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
2.54.0

