Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BED3140A941;
	Mon, 27 Jul 2026 12:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785156878; cv=none; b=WiB537ygY6Ar0WBDO11SGQSaX69myxwhnBcFDYksNFc5sL4ADceyI1rn3MTf86w82xFOkzJH4nxgU4DcPx1R58ztEIXGVbzHW2VBQ8Vlk1trKo9nFPN3ZzCmTcLFFI9FnIJvpfgpJ+L59jHv7ScdkZAD/1etcSfKEw5JhjQUA9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785156878; c=relaxed/simple;
	bh=rQwr2yaH2uuQLtKU5DaqUy9nnJ9f5dc5MK7EgTA5t64=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=JTIHOWMYKsZThCdoS8NUtQLzKMKK/kkK9dRBjRJtYe+ioQa/PBolehffo4YC5Bp2JmO50xPF/2jpY9pHePZiLjQA0vZwW1sxOaaxDrdgedqt4AcBegUD1nqpK8cBMG15HYqgAau8GCjOPXhSZAmB8a4ciQoq8SlEaf30n9lNWF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PM7EE0wP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PM7EE0wP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98E021F00A3D;
	Mon, 27 Jul 2026 12:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785156877;
	bh=MMR10wzWOC3iWDE6DrvrWcfSrkQzPUkWCEv11fQdpQY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=PM7EE0wP1nRdstfCP22TIZ3AP/RdJYjnz8S9dhp3/nIeUmgmQ7135ZWmfDKq7BYUa
	 6Csn5N/TjSOe6cc/Px6PmatZc3+G6h8ez+r7PfrkZsXTRheOi0wRALbeyMCYR+dLq0
	 r2s02WqAkJRNYi7+hY7Ahf9B864+ewdhAKs1o/dcJ4XvGYoUTGCLQcsUzkJO8+Fmz8
	 J1euZnp/iBku9SqYOSxKkvgS8tmKlYCHPY5Mf3+FgUt7rR8Dw7mevSavJu/4gsAvcp
	 PvMryzt6yLHhvVRORiCyXjmgSHrgrTtAaQRQN3FBK8/wdqaBBPB9+pJIeJV/siu+yH
	 OsK5q5jk9ONjw==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Mon, 27 Jul 2026 14:54:03 +0200
Subject: [PATCH v3 09/13] mm/slab: introduce slab_obj_ext_has_codetag()
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260727-b4-objext_split-v3-9-c29ef0f1f257@kernel.org>
References: <20260727-b4-objext_split-v3-0-c29ef0f1f257@kernel.org>
In-Reply-To: <20260727-b4-objext_split-v3-0-c29ef0f1f257@kernel.org>
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
index 3f8144b9b9d8..8f352d9f4d91 100644
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
index 9079aaab3235..67958f2b3bab 100644
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
@@ -2420,6 +2425,25 @@ alloc_tagging_slab_free_hook(struct kmem_cache *s, struct slab *slab, void **p,
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
@@ -2434,6 +2458,10 @@ alloc_tagging_slab_free_hook(struct kmem_cache *s, struct slab *slab, void **p,
 {
 }
 
+static inline void slab_obj_ext_has_codetag_init(void)
+{
+}
+
 #endif /* CONFIG_MEM_ALLOC_PROFILING */
 
 
@@ -8546,6 +8574,8 @@ void __init kmem_cache_init(void)
 		boot_kmem_cache_node;
 	int node;
 
+	slab_obj_ext_has_codetag_init();
+
 	if (debug_guardpage_minorder())
 		slub_max_order = 0;
 

-- 
2.55.0

