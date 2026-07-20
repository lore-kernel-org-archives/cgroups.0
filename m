Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C95EF42E8CF;
	Mon, 20 Jul 2026 14:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784557020; cv=none; b=ED27wg8aDACmPKscMKz15C8UpwrSe+aqxIaeAO6zjFcyU8Bm5Frd8l1gvDie/2NMrt7r6mbKJf5Y7TxrrWGFi9JwfzJO09dApKZ8b/K0lM6pbNqbr3kiYe5NHs/YOYIEQS5qkkZ01Tu0hT8iuvK+OmGloSHSDGoxA5MUyvRmZfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784557020; c=relaxed/simple;
	bh=Rl7X5Rc2qzs8VSmnN6mZfUDi4ETsgSO0pJ6+SeGk3qc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=i8PxDLZuVnW2wfqPx0hYi1aSJltDnEKHSQodJ20lxz8/HVoDoR/7H54pqFW0251jrCctDFm/IwG/PL5xlGGZ/Yjh6TEARwnXd/4d0s537DYrxspohcz/FbXtpn62JyUl+vAVWKJ8hTYRDQeb50sg5jNANx2NpIPQ0zJkSkDPIy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E/pkkBJT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E/pkkBJT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB6FF1F00A3A;
	Mon, 20 Jul 2026 14:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784557019;
	bh=p2cb0SC7Ft0dMHSHileX02Rth4klsLBw5vrXUr6czBQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=E/pkkBJTKEu06X2E0MtqbAqYG9hOrori+/Hbw0Q15iKK2xoCJuysaSbUjQnTjr4v/
	 /sTpoSxqfoJHBP5gshywigUIIVPwl0y6AldIvzDUc1t7LW+t+/Wy2DKN3jL5k9+BZq
	 iXnq+W94dP+4WXVmojEjornHrVlpBFywNqv2qk4gyo3snXvWHHi8OKPz5ov+g+vpgf
	 lvtTEVgxdkGSoANsjGKvL28F1b71Tgmpzi6j2LGN7mDAHeEV0OiaP+PajPeWFhHk/q
	 cQx4wexLQr5akB2uGT+LQagSMZfrbAFm7fJ3e+x4BVBeRZAcBvwIR4MvSxyMZX+joL
	 4LFq343++leMw==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Mon, 20 Jul 2026 16:16:24 +0200
Subject: [PATCH v2 10/13] mm/slab: introduce slab_obj_ext_has_codetag()
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-b4-objext_split-v2-10-2fa7c6f60dbe@kernel.org>
References: <20260720-b4-objext_split-v2-0-2fa7c6f60dbe@kernel.org>
In-Reply-To: <20260720-b4-objext_split-v2-0-2fa7c6f60dbe@kernel.org>
To: Harry Yoo <harry@kernel.org>, Suren Baghdasaryan <surenb@google.com>
Cc: Hao Li <hao.li@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.15.2

mem_alloc_profiling_enabled() allows evaluating (with a static key) if
memory profiling is currently enabled. mem_profiling_support is a
variable where false means it's not possible to enable it anymore,
because the system was booted with "never" or it was later shut down.
This is possible to query by mem_alloc_profiling_permanently_disabled().

To make slabobj_ext array size handling dynamic, we need a snapshot of
mem_alloc_profiling_permanently_disabled() early in boot, so that's not
affected by a later shutdown. We also need it to be static key based for
performance. Neither mem_alloc_profiling_enabled() nor
mem_alloc_profiling_permanently_disabled() satisfy this.

Therefore introduce slab_obj_ext_has_codetag() with an underlying static
key for that use case. Its state is made to reflect the result of
mem_alloc_profiling_permanently_disabled() during kmem_cache_init(),
which does happen after setup_early_mem_profiling().

Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/slab.h | 16 ++++++++++++++++
 mm/slub.c | 30 ++++++++++++++++++++++++++++++
 2 files changed, 46 insertions(+)

diff --git a/mm/slab.h b/mm/slab.h
index f8446167e175..983cb1119a76 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -568,6 +568,22 @@ struct slabobj_ext {
 	};
 } __aligned(8);
 
+#ifdef CONFIG_MEM_ALLOC_PROFILING
+DECLARE_STATIC_KEY_MAYBE(CONFIG_MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT,
+			 slab_obj_ext_has_codetag_key);
+
+static inline bool slab_obj_ext_has_codetag(void)
+{
+	return static_branch_maybe(CONFIG_MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT,
+				   &slab_obj_ext_has_codetag_key);
+}
+#else
+static inline bool slab_obj_ext_has_codetag(void)
+{
+	return false;
+}
+#endif
+
 static inline size_t cache_obj_ext_size(struct kmem_cache *s)
 {
 	size_t sz = 0;
diff --git a/mm/slub.c b/mm/slub.c
index 287cbf3eddcc..d78d3e50c877 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -213,6 +213,11 @@ DEFINE_STATIC_KEY_FALSE(slub_debug_enabled);
 static DEFINE_STATIC_KEY_FALSE(strict_numa);
 #endif
 
+#ifdef CONFIG_MEM_ALLOC_PROFILING
+DEFINE_STATIC_KEY_MAYBE(CONFIG_MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT,
+			slab_obj_ext_has_codetag_key);
+#endif
+
 /* Structure holding extra parameters for slab allocations */
 struct slab_alloc_context {
 	unsigned long caller_addr;
@@ -2425,6 +2430,25 @@ alloc_tagging_slab_free_hook(struct kmem_cache *s, struct slab *slab, void **p,
 		__alloc_tagging_slab_free_hook(s, slab, p, objects);
 }
 
+/*
+ * Make sure the static key used by slab_obj_ext_has_codetag() reflects the
+ * value of !mem_alloc_profiling_permanently_disabled()
+ *
+ * Any later mem alloc profiling shutdown won't be reflected in the static key
+ * because obj_exts with codetags might already exist.
+ */
+static void __init slab_obj_ext_has_codetag_init(void)
+{
+	bool need_codetag = !mem_alloc_profiling_permanently_disabled();
+
+	if (need_codetag != static_key_enabled(&slab_obj_ext_has_codetag_key)) {
+		if (need_codetag)
+			static_branch_enable(&slab_obj_ext_has_codetag_key);
+		else
+			static_branch_disable(&slab_obj_ext_has_codetag_key);
+	}
+}
+
 #else /* CONFIG_MEM_ALLOC_PROFILING */
 
 static inline void
@@ -2439,6 +2463,10 @@ alloc_tagging_slab_free_hook(struct kmem_cache *s, struct slab *slab, void **p,
 {
 }
 
+static inline void slab_obj_ext_has_codetag_init(void)
+{
+}
+
 #endif /* CONFIG_MEM_ALLOC_PROFILING */
 
 
@@ -8551,6 +8579,8 @@ void __init kmem_cache_init(void)
 		boot_kmem_cache_node;
 	int node;
 
+	slab_obj_ext_has_codetag_init();
+
 	if (debug_guardpage_minorder())
 		slub_max_order = 0;
 

-- 
2.55.0

