Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31EB243B6DE;
	Wed, 15 Jul 2026 10:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784110277; cv=none; b=UX0kcrW7143bFA0XXE4KX2toySpFHzqZaN+NWVO/WIBSp+qv9oSK7ddPdu7hwZxa5iGCv5sIKJl+sFEQYd8bHsguPR51e5pKsudBgrdtLHl86wcpHLmzFxBBWXTaYrxmVZ5BaNW9U+mIqEE4aqKR2j8dmHsU9jlHuXFSXvscCec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784110277; c=relaxed/simple;
	bh=SHdGz4rDHOERE3YmVNFGmxnZB4g49fyajAUjwjCyN0c=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=no2QftbJgjPdF2vocXf/66d8R3pd1mI9D6gURyHAeoRtageRD5BNSMDhTZDNkUlXAZjI/xkEAD6JwtAp88stkjQOq2ZqYt1CtlBumEi828yvw3tmcHIbZJjuuPx0VD42xZ3QA2vmL3F2qytsl850qE3wa7laEk8hBrBCuqt96oM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PUdIwloJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PUdIwloJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F1EF1F000E9;
	Wed, 15 Jul 2026 10:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784110275;
	bh=qejNc6/2sAIyKponA71R3jYamk33F9xwBlnyqE8jUxY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=PUdIwloJ/5Zc31NRZkkCTFSmel7KjvBoFgWtriTOnSrrRfLys/6sgIRFf3ShnyBZ4
	 HCmzT2Xt0+qG6gMgV3UNz0W9rPZdL5AyBUZyrtIuN6RdQf6xyAjTExn0ObXscDqFMv
	 xfwOViyvNmPxmsIkiF2sn7CEJnphg1GNpZTfleCJ3h7X5nJmOQYHwdwAusQisq+wib
	 d+6Fb86TM14tkAP4NvFSOVhQl/4Z8XpwNOz4HqpKNuFXNwMu8KeLXuMK/YcYnjV4uX
	 ZP0jZVD5/75bTxcVdUjFzBrTpRftxKWLFDf/EjBmsNfz6Tty5R1gDYc7ijVysCdxF+
	 Sl052/U2RSG+A==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Wed, 15 Jul 2026 12:10:49 +0200
Subject: [PATCH RFC 09/12] mm/slab: introduce slab_obj_ext_has_codetag()
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260715-b4-objext_split-v1-9-9a49c4ccf4c3@kernel.org>
References: <20260715-b4-objext_split-v1-0-9a49c4ccf4c3@kernel.org>
In-Reply-To: <20260715-b4-objext_split-v1-0-9a49c4ccf4c3@kernel.org>
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

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/slab.h | 16 ++++++++++++++++
 mm/slub.c | 31 +++++++++++++++++++++++++++++++
 2 files changed, 47 insertions(+)

diff --git a/mm/slab.h b/mm/slab.h
index 359ab8caf61e..dcca86799fc9 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -564,6 +564,22 @@ struct slabobj_ext {
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
 static inline size_t static_obj_ext_size(void)
 {
 	size_t sz = 0;
diff --git a/mm/slub.c b/mm/slub.c
index dd15af8abd62..4200e7105b30 100644
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
@@ -2415,6 +2420,26 @@ alloc_tagging_slab_free_hook(struct kmem_cache *s, struct slab *slab, void **p,
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
+	bool key_enabled = IS_ENABLED(CONFIG_MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT);
+	bool need_codetag = !mem_alloc_profiling_permanently_disabled();
+
+	if (key_enabled != need_codetag) {
+		if (need_codetag)
+			static_branch_enable(&slab_obj_ext_has_codetag_key);
+		else
+			static_branch_disable(&slab_obj_ext_has_codetag_key);
+	}
+}
+
 #else /* CONFIG_MEM_ALLOC_PROFILING */
 
 static inline void
@@ -2429,6 +2454,10 @@ alloc_tagging_slab_free_hook(struct kmem_cache *s, struct slab *slab, void **p,
 {
 }
 
+static inline void slab_obj_ext_has_codetag_init(void)
+{
+}
+
 #endif /* CONFIG_MEM_ALLOC_PROFILING */
 
 
@@ -8541,6 +8570,8 @@ void __init kmem_cache_init(void)
 		boot_kmem_cache_node;
 	int node;
 
+	slab_obj_ext_has_codetag_init();
+
 	if (debug_guardpage_minorder())
 		slub_max_order = 0;
 

-- 
2.55.0

