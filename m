Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794755419;
	b=GvmPsVzUEG/hyGXvXuJBSXFEvrvNrrlAi/5sBWy5CJ96hbzT053ROeownAzX2uvoHaNg
	 Eoccgj6QS0NU1YicAoyRS8qH+hUEAyaNksmx452c0P4x8hLmI11fK3l6fHovp58T3z+hQ
	 YlLqaN/fpLvV3ef5b1EAkU3e32UfSUsdwzDQ84ZXARLEP6LqI6jM+z1RLOG6s81xrc/9u
	 FxZeCSbA9M/6uIK3BPOxWKWNbaB41Crvc1nI98RwRUSx0VVeLv396rbBxGdU84juD2PLs
	 z/gktUXtZOYMfJR1CrEJD381t9ziiv3F0Rk8yUJAoTW5+lkce4HVOefufM9cCi2xnEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794755419;
	h=Received:DKIM-Signature:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer;
	bh=LEpvJjswIVVnFhWoxB5UG1ML2CnsBWwLFbFU6DcBCqQ=;
	b=C/FHj4jRbxwl+w4bSaWI+lTyh0P4zb8vlRHddK+qBhq72q+zCGf9beuoTS1SpBvouVXM
	 HaqNvZgmy4PRMNuaVeIXwUnJYvZ8h6P3K2Eux0MXyuUoWvI2I1Dp2OHpFYtQ0ZWpWoN4F
	 XlM+X7Fe9uYCG57mZEFCLUpQzO+UgQvSc/UCGZvLzreSVqaveDOmIKuospHPXNi9xEyjU
	 IqG3tI6XzZGASz96R8r052mdtxaNbj8QezOP2AsE8ByhPTN88kZ3+35Q0qsb1qsBQSwlI
	 LNcbEvCsdThJ5cFE0MJ91qJgZ1NBWMrXvkh/VBrW9E6kxzTSHFG0L8YzL3vSYGba9hA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oISKXA5E;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BB36606A31A;
	Sun, 15 Nov 2026 15:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oISKXA5E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3D4C1F000C4;
	Sun, 15 Nov 2026 15:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794755419;
	bh=LEpvJjswIVVnFhWoxB5UG1ML2CnsBWwLFbFU6DcBCqQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=oISKXA5E2zGjU7JwWeZoNC5HOL9bMy/MNsoDXDI0q4Qa7509anBWcQy2sRuTOcKiz
	 QNKBCfG+ZHJEp/EjpaUQVdn8kaXnGax69xIJoVw9ZsPtmLypIJ4oLkhHh/paop12XR
	 h+Fmp5QJQS8Jybk0yaEVVcmXg3105bAOqyKoc93lczQaSBqUYqHJJPDHWI1d7WJzgG
	 0PQjEj8wZr5xfMBGKqoH14iLkiK/O5B5exn6l9gWC2dRfS+lBuqH5luUUaTVnxiBxe
	 4MGN2bq8r2BkNr27QIAtQrcpe87N6m43xl0o3P0+sxAullm34CtsWo2/tOaCDin4c0
	 pJ0AwTWrdR1/w==
From: "Harry Yoo (Meta)" <harry@kernel.org>
Date: Sun, 15 Nov 2026 15:09:36 +0000
Subject: [PATCH for-next v3 2/7] mm/slab: pass free_flags to
 slab_free_hook()
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
Message-Id: <20261115-kmalloc-nolock-fixes-v3-2-9034dd4ecaab@kernel.org>
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
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev
X-Mailer: b4 0.16.0

slab_free_hook() takes two bools, init and after_rcu_delay, and a later
patch needs to tell it whether spinning is allowed.

Instead of adding a third bool, make it take free_flags. Add
SLAB_FREE_INIT and SLAB_FREE_AFTER_RCU_DELAY, and convert the callers.

No functional change intended.

Suggested-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Link: https://lore.kernel.org/f31885cd-57c2-428d-9760-a76a0137f989@kernel.org
Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>
---
 mm/slab.h |  6 ++++--
 mm/slub.c | 47 ++++++++++++++++++++++++++++++++++-------------
 2 files changed, 38 insertions(+), 15 deletions(-)

diff --git a/mm/slab.h b/mm/slab.h
index e94ac63d10dc..15b0d98ae1d4 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -24,8 +24,10 @@
 #define SLAB_ALLOC_NO_RECURSE	0x04 /* prevent kmalloc() recursion */
 #define SLAB_ALLOC_NO_OBJ_EXT	0x08 /* prevent obj_exts array allocation */
 
-#define SLAB_FREE_DEFAULT	0x00 /* no flags */
-#define SLAB_FREE_NOLOCK	0x01 /* spinning not allowed */
+#define SLAB_FREE_DEFAULT		0x00 /* no flags */
+#define SLAB_FREE_NOLOCK		0x01 /* spinning not allowed */
+#define SLAB_FREE_INIT			0x02 /* zero the object on free */
+#define SLAB_FREE_AFTER_RCU_DELAY	0x04 /* RCU grace period has elapsed */
 
 static inline unsigned int to_alloc_flags(unsigned int free_flags)
 {
diff --git a/mm/slub.c b/mm/slub.c
index 86259c32cf59..761dc2affea2 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2694,9 +2694,10 @@ struct rcu_delayed_free {
  * - __kcsan_check_access()
  */
 static __always_inline
-bool slab_free_hook(struct kmem_cache *s, void *x, bool init,
-		    bool after_rcu_delay)
+bool slab_free_hook(struct kmem_cache *s, void *x, unsigned int free_flags)
 {
+	bool init = free_flags & SLAB_FREE_INIT;
+	bool after_rcu_delay = free_flags & SLAB_FREE_AFTER_RCU_DELAY;
 	/* Are the object contents still accessible? */
 	bool still_accessible = (s->flags & SLAB_TYPESAFE_BY_RCU) && !after_rcu_delay;
 
@@ -2786,10 +2787,10 @@ bool slab_free_freelist_hook(struct kmem_cache *s, void **head, void **tail,
 	void *object;
 	void *next = *head;
 	void *old_tail = *tail;
-	bool init;
+	unsigned int free_flags = SLAB_FREE_DEFAULT;
 
 	if (is_kfence_address(next)) {
-		slab_free_hook(s, next, false, false);
+		slab_free_hook(s, next, free_flags);
 		return false;
 	}
 
@@ -2797,14 +2798,15 @@ bool slab_free_freelist_hook(struct kmem_cache *s, void **head, void **tail,
 	*head = NULL;
 	*tail = NULL;
 
-	init = slab_want_init_on_free(s);
+	if (slab_want_init_on_free(s))
+		free_flags |= SLAB_FREE_INIT;
 
 	do {
 		object = next;
 		next = get_freepointer(s, object);
 
 		/* If object's reuse doesn't have to be delayed */
-		if (likely(slab_free_hook(s, object, init, false))) {
+		if (likely(slab_free_hook(s, object, free_flags))) {
 			/* Move object to the new freelist */
 			set_freepointer(s, object, *head);
 			*head = object;
@@ -3025,18 +3027,21 @@ static void sheaf_flush_unused(struct kmem_cache *s, struct slab_sheaf *sheaf)
 static bool __rcu_free_sheaf_prepare(struct kmem_cache *s,
 				     struct slab_sheaf *sheaf)
 {
-	bool init = slab_want_init_on_free(s);
+	unsigned int free_flags = SLAB_FREE_AFTER_RCU_DELAY;
 	void **p = &sheaf->objects[0];
 	unsigned int i = 0;
 	bool pfmemalloc = false;
 
+	if (slab_want_init_on_free(s))
+		free_flags |= SLAB_FREE_INIT;
+
 	while (i < sheaf->size) {
 		struct slab *slab = virt_to_slab(p[i]);
 
 		memcg_slab_free_hook(s, slab, p + i, 1);
 		alloc_tagging_slab_free_hook(s, slab, p + i, 1);
 
-		if (unlikely(!slab_free_hook(s, p[i], init, true))) {
+		if (unlikely(!slab_free_hook(s, p[i], free_flags))) {
 			p[i] = p[--sheaf->size];
 			continue;
 		}
@@ -6458,10 +6463,13 @@ static unsigned int __free_to_pcs_batch(struct kmem_cache *s, size_t size, void
  */
 static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
 {
-	bool init = slab_want_init_on_free(s);
+	unsigned int free_flags = SLAB_FREE_DEFAULT;
 	void **remote_objects = p;
 	unsigned int remote_nr = 0;
 
+	if (slab_want_init_on_free(s))
+		free_flags |= SLAB_FREE_INIT;
+
 	/*
 	 * Process the free hooks and separate out remote objects by
 	 * partitioning the 'p' array in place:
@@ -6476,7 +6484,7 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
 		memcg_slab_free_hook(s, slab, p + i, 1);
 		alloc_tagging_slab_free_hook(s, slab, p + i, 1);
 
-		if (unlikely(!slab_free_hook(s, p[i], init, false))) {
+		if (unlikely(!slab_free_hook(s, p[i], free_flags))) {
 			p[i] = p[--size];
 			continue;
 		}
@@ -6600,10 +6608,15 @@ static __fastpath_inline
 void slab_free(struct kmem_cache *s, struct slab *slab, void *object,
 	       unsigned long addr)
 {
+	unsigned int free_flags = SLAB_FREE_DEFAULT;
+
+	if (slab_want_init_on_free(s))
+		free_flags |= SLAB_FREE_INIT;
+
 	memcg_slab_free_hook(s, slab, &object, 1);
 	alloc_tagging_slab_free_hook(s, slab, &object, 1);
 
-	if (unlikely(!slab_free_hook(s, object, slab_want_init_on_free(s), false)))
+	if (unlikely(!slab_free_hook(s, object, free_flags)))
 		return;
 
 	if (likely(can_free_to_pcs(slab)) && likely(free_to_pcs(s, object, true)))
@@ -6619,10 +6632,14 @@ static noinline
 void memcg_alloc_abort_single(struct kmem_cache *s, void *object)
 {
 	struct slab *slab = virt_to_slab(object);
+	unsigned int free_flags = SLAB_FREE_DEFAULT;
+
+	if (slab_want_init_on_free(s))
+		free_flags |= SLAB_FREE_INIT;
 
 	alloc_tagging_slab_free_hook(s, slab, &object, 1);
 
-	if (likely(slab_free_hook(s, object, slab_want_init_on_free(s), false)))
+	if (likely(slab_free_hook(s, object, free_flags)))
 		__slab_free(s, slab, object, object, 1, _RET_IP_);
 }
 #endif
@@ -6651,6 +6668,7 @@ static void slab_free_after_rcu_debug(struct rcu_head *rcu_head)
 	void *object = delayed_free->object;
 	struct slab *slab = virt_to_slab(object);
 	struct kmem_cache *s;
+	unsigned int free_flags = SLAB_FREE_AFTER_RCU_DELAY;
 
 	kfree(delayed_free);
 
@@ -6664,8 +6682,11 @@ static void slab_free_after_rcu_debug(struct rcu_head *rcu_head)
 	if (WARN_ON(!(s->flags & SLAB_TYPESAFE_BY_RCU)))
 		return;
 
+	if (slab_want_init_on_free(s))
+		free_flags |= SLAB_FREE_INIT;
+
 	/* resume freeing */
-	if (slab_free_hook(s, object, slab_want_init_on_free(s), true)) {
+	if (slab_free_hook(s, object, free_flags)) {
 		__slab_free(s, slab, object, object, 1, _THIS_IP_);
 		stat(s, FREE_SLOWPATH);
 	}

-- 
2.54.0

