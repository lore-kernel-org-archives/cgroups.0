Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794755427;
	b=Odc/3vNT6nK5ti9KyoOECVab50HlQUDAaHsJjycVRQUGry4ahruZxpTMctcf/6xcwL4L
	 VbYKvijnCQzyorJ9A+fo8wjhR6eMdx/zJm3NC1SCuYYb9kvkvDFo2LniUzxfcC1hPA9Rf
	 /kmKbcrnE/iCQInMbHJODZhgscIBfePm3QZ3TIong9aQYIvE5Icrd77YZ5HkdyQtXW7hL
	 YPedtNykekcFQgmjwtoGR3qROohH2njxdIqbIKYvdL4DGitX9uxdOEt1irW4nDka7EpNE
	 XP2B1edSj2rXGP7+BOgD+rBeVXrZ5r3gsEhJEX8PJdm8mjxvRJWOnCYZ+xAtJ2xpbrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794755427;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer;
	bh=J2a5kJ1HnqMnnGqSgfzuFucPTLau+/T7+blaKIr3qVE=;
	b=KgKNNj5I2yKRjrU5iV5NrdRix0KbBXSm8o9+QlHRUv7wniplmxolvYGXS97mOqUi37nP
	 zA9oEhwb29EL81tfUKEATSLjo6Lnf5ZP+I2xSCGDbGJCdIx9HmXq8EvpPeSL0KYoSxj+I
	 ujpPNArBdfJcExXTdh9MjYD3xiUcguOZFoXZ7uTicSTOWsusmxVPJpO19LCcp5hjc7awA
	 S+ZyJH18lIOWa5vSmVRysZnfsBFpkeAdRCBfOPwl7n3OXRrdLrG3sEUN7WkX5EKBEroQs
	 CkNr4AGKCYqfW3f1PicxKf9o/on9wEKn90oTGBxdOKMnXskzrjNRY27sWLXBxd78QWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kAUTRrsI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D579606A323;
	Sun, 15 Nov 2026 15:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kAUTRrsI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8099E1F000C5;
	Sun, 15 Nov 2026 15:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794755426;
	bh=J2a5kJ1HnqMnnGqSgfzuFucPTLau+/T7+blaKIr3qVE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=kAUTRrsI5AVKr7aA5OHDZO+Hd92lf/KbZz07Af1lmBv1d0owwSModzgUEhSZ8Jj6c
	 7YZV5bWsVratJSD38MMLTI4GlF2fggwYiXgubkWPXu69/OzBYRKk/KU66yGGL9BOKD
	 Xi/5WJpQMDHj4Gm29zvoLdooGXxu/usbW5pHBJD1xn/a9Fhbar4xXvrlcHPwYjZzp/
	 5lbBoI973ZFbwReQ5BIa9K4Y8bnglwUoLffKskd6J9j7sd+ZRo7i7VhLPXwknVOm5w
	 4tcpJcaq1q3skOsegZbjTj8EANHqExhhtVim6salK6nPgWlBLUPOR/FnVIJazLeNTd
	 pfcJ/AwCHlUCQ==
From: "Harry Yoo (Meta)" <harry@kernel.org>
Date: Sun, 15 Nov 2026 15:09:38 +0000
Subject: [PATCH for-next v3 4/7] mm/slab: fix a deadlock in
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
Message-Id: <20261115-kmalloc-nolock-fixes-v3-4-9034dd4ecaab@kernel.org>
References: <20261115-kmalloc-nolock-fixes-v3-0-9034dd4ecaab@kernel.org>
In-Reply-To: <20261115-kmalloc-nolock-fixes-v3-0-9034dd4ecaab@kernel.org>
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

While at it, try freeing the object to the percpu sheaves first in both
contexts, as kmem_cache_free_bulk() already does for bulk allocations.
This also avoids queueing an irq_work for every failed charge when
spinning is not allowed.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260610-slab_alloc_flags-v2-0-7190909db118%40kernel.org?part=9
Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and kfree_nolock().")
Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>
---
 mm/slab.h |  8 ++++++++
 mm/slub.c | 22 +++++++++++++++++-----
 2 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/mm/slab.h b/mm/slab.h
index 15b0d98ae1d4..fb80a72ad952 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -37,6 +37,14 @@ static inline unsigned int to_alloc_flags(unsigned int free_flags)
 		return SLAB_ALLOC_DEFAULT;
 }
 
+static inline unsigned int to_free_flags(unsigned int alloc_flags)
+{
+	if (alloc_flags & SLAB_ALLOC_NOLOCK)
+		return SLAB_FREE_NOLOCK;
+	else
+		return SLAB_FREE_DEFAULT;
+}
+
 static inline bool alloc_flags_allow_spinning(const unsigned int alloc_flags)
 {
 	return !(alloc_flags & SLAB_ALLOC_NOLOCK);
diff --git a/mm/slub.c b/mm/slub.c
index 7c0adc104988..8252c0b681cc 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2531,7 +2531,8 @@ static inline void slab_obj_ext_has_codetag_init(void)
 
 #ifdef CONFIG_MEMCG
 
-static void memcg_alloc_abort_single(struct kmem_cache *s, void *object);
+static void memcg_alloc_abort_single(struct kmem_cache *s, void *object,
+				     unsigned int alloc_flags);
 
 static __fastpath_inline
 bool memcg_slab_post_alloc_hook(struct kmem_cache *s, gfp_t flags,
@@ -2549,7 +2550,7 @@ bool memcg_slab_post_alloc_hook(struct kmem_cache *s, gfp_t flags,
 		return true;
 
 	if (likely(size == 1)) {
-		memcg_alloc_abort_single(s, *p);
+		memcg_alloc_abort_single(s, *p, ac->alloc_flags);
 		*p = NULL;
 	} else {
 		kmem_cache_free_bulk(s, size, p);
@@ -6647,18 +6648,29 @@ void slab_free(struct kmem_cache *s, struct slab *slab, void *object,
 #ifdef CONFIG_MEMCG
 /* Do not inline the rare memcg charging failed path into the allocation path */
 static noinline
-void memcg_alloc_abort_single(struct kmem_cache *s, void *object)
+void memcg_alloc_abort_single(struct kmem_cache *s, void *object,
+			      unsigned int alloc_flags)
 {
 	struct slab *slab = virt_to_slab(object);
-	unsigned int free_flags = SLAB_FREE_DEFAULT;
+	bool allow_spin = alloc_flags_allow_spinning(alloc_flags);
+	unsigned int free_flags = to_free_flags(alloc_flags);
 
 	if (slab_want_init_on_free(s))
 		free_flags |= SLAB_FREE_INIT;
 
 	alloc_tagging_slab_free_hook(s, slab, &object, 1);
 
-	if (likely(slab_free_hook(s, object, free_flags)))
+	if (unlikely(!slab_free_hook(s, object, free_flags)))
+		return;
+
+	if (likely(can_free_to_pcs(slab)) &&
+	    likely(free_to_pcs(s, object, allow_spin)))
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

