From: Suren Baghdasaryan <surenb@google.com>
Subject: [PATCH 37/40] codetag: debug: skip objext checking when it's for
 objext itself
Date: Mon,  1 May 2023 09:54:47 -0700
Message-ID: <20230501165450.15352-38-surenb@google.com>
References: <20230501165450.15352-1-surenb@google.com>
Mime-Version: 1.0
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682960192; x=1685552192;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nH88FGoAACjgZmQtkl43JvHLPN3RafkQwEsrc5bfN4s=;
        b=lLa+vy9YS9JYxnsS/wzOxOEwwt8wSy5Uuy+3HdA356nRicp9ut8/ucfpMAH5tzjtpk
         TZcWKstbLNfc+ExqK3JufnNMMSOfGAmXHFXOkaH7uvY2JNRcUhOQ+mziqCIge56WJNZ/
         gi3cQ2XcWFl2PGrQeodns68az+EoIqlViDNY/5PRPUy6or731mNfftlLkYP0wViktDEH
         g0WRqa3axpcg1emeJdFyEEwnjL1yqR7Zf3pRutm7Z9+tW9GBqkt749c0MDSZR/CpVzak
         uesUCRPASh4BPez2LMwWVpOzpXLQw5JYdzG+OUSaei3lVr1p9uTTjV6lehd+V/Xsz/IX
         /oSA==
In-Reply-To: <20230501165450.15352-1-surenb@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: akpm@linux-foundation.org
Cc: kent.overstreet@linux.dev, mhocko@suse.com, vbabka@suse.cz, hannes@cmpxchg.org, roman.gushchin@linux.dev, mgorman@suse.de, dave@stgolabs.net, willy@infradead.org, liam.howlett@oracle.com, corbet@lwn.net, void@manifault.com, peterz@infradead.org, juri.lelli@redhat.com, ldufour@linux.ibm.com, catalin.marinas@arm.com, will@kernel.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org, peterx@redhat.com, david@redhat.com, axboe@kernel.dk, mcgrof@kernel.org, masahiroy@kernel.org, nathan@kernel.org, dennis@kernel.org, tj@kernel.org, muchun.song@linux.dev, rppt@kernel.org, paulmck@kernel.org, pasha.tatashin@soleen.com, yosryahmed@google.com, yuzhao@google.com, dhowells@redhat.com, hughd@google.com, andreyknvl@gmail.com, keescook@chromium.org

objext objects are created with __GFP_NO_OBJ_EXT flag and therefore have
no corresponding objext themselves (otherwise we would get an infinite
recursion). When freeing these objects their codetag will be empty and
when CONFIG_MEM_ALLOC_PROFILING_DEBUG is enabled this will lead to false
warnings. Introduce CODETAG_EMPTY special codetag value to mark
allocations which intentionally lack codetag to avoid these warnings.
Set objext codetags to CODETAG_EMPTY before freeing to indicate that
the codetag is expected to be empty.

Signed-off-by: Suren Baghdasaryan <surenb@google.com>
---
 include/linux/alloc_tag.h | 28 ++++++++++++++++++++++++++++
 mm/slab.h                 | 33 +++++++++++++++++++++++++++++++++
 mm/slab_common.c          |  1 +
 3 files changed, 62 insertions(+)

diff --git a/include/linux/alloc_tag.h b/include/linux/alloc_tag.h
index 190ab793f7e5..2c3f4f3a8c93 100644
--- a/include/linux/alloc_tag.h
+++ b/include/linux/alloc_tag.h
@@ -51,6 +51,28 @@ static inline bool mem_alloc_profiling_enabled(void)
 	return static_branch_likely(&mem_alloc_profiling_key);
 }
 
+#ifdef CONFIG_MEM_ALLOC_PROFILING_DEBUG
+
+#define CODETAG_EMPTY	(void *)1
+
+static inline bool is_codetag_empty(union codetag_ref *ref)
+{
+	return ref->ct == CODETAG_EMPTY;
+}
+
+static inline void set_codetag_empty(union codetag_ref *ref)
+{
+	if (ref)
+		ref->ct = CODETAG_EMPTY;
+}
+
+#else /* CONFIG_MEM_ALLOC_PROFILING_DEBUG */
+
+static inline bool is_codetag_empty(union codetag_ref *ref) { return false; }
+static inline void set_codetag_empty(union codetag_ref *ref) {}
+
+#endif /* CONFIG_MEM_ALLOC_PROFILING_DEBUG */
+
 static inline void __alloc_tag_sub(union codetag_ref *ref, size_t bytes,
 				   bool may_allocate)
 {
@@ -65,6 +87,11 @@ static inline void __alloc_tag_sub(union codetag_ref *ref, size_t bytes,
 	if (!ref || !ref->ct)
 		return;
 
+	if (is_codetag_empty(ref)) {
+		ref->ct = NULL;
+		return;
+	}
+
 	if (is_codetag_ctx_ref(ref))
 		alloc_tag_free_ctx(ref->ctx, &tag);
 	else
@@ -112,6 +139,7 @@ static inline void alloc_tag_add(union codetag_ref *ref, struct alloc_tag *tag,
 #else
 
 #define DEFINE_ALLOC_TAG(_alloc_tag, _old)
+static inline void set_codetag_empty(union codetag_ref *ref) {}
 static inline void alloc_tag_sub(union codetag_ref *ref, size_t bytes) {}
 static inline void alloc_tag_sub_noalloc(union codetag_ref *ref, size_t bytes) {}
 static inline void alloc_tag_add(union codetag_ref *ref, struct alloc_tag *tag,
diff --git a/mm/slab.h b/mm/slab.h
index f9442d3a10b2..50d86008a86a 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -416,6 +416,31 @@ static inline struct slabobj_ext *slab_obj_exts(struct slab *slab)
 int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
 			gfp_t gfp, bool new_slab);
 
+
+#ifdef CONFIG_MEM_ALLOC_PROFILING_DEBUG
+
+static inline void mark_objexts_empty(struct slabobj_ext *obj_exts)
+{
+	struct slabobj_ext *slab_exts;
+	struct slab *obj_exts_slab;
+
+	obj_exts_slab = virt_to_slab(obj_exts);
+	slab_exts = slab_obj_exts(obj_exts_slab);
+	if (slab_exts) {
+		unsigned int offs = obj_to_index(obj_exts_slab->slab_cache,
+						 obj_exts_slab, obj_exts);
+		/* codetag should be NULL */
+		WARN_ON(slab_exts[offs].ref.ct);
+		set_codetag_empty(&slab_exts[offs].ref);
+	}
+}
+
+#else /* CONFIG_MEM_ALLOC_PROFILING_DEBUG */
+
+static inline void mark_objexts_empty(struct slabobj_ext *obj_exts) {}
+
+#endif /* CONFIG_MEM_ALLOC_PROFILING_DEBUG */
+
 static inline bool need_slab_obj_ext(void)
 {
 #ifdef CONFIG_MEM_ALLOC_PROFILING
@@ -437,6 +462,14 @@ static inline void free_slab_obj_exts(struct slab *slab)
 	if (!obj_exts)
 		return;
 
+	/*
+	 * obj_exts was created with __GFP_NO_OBJ_EXT flag, therefore its
+	 * corresponding extension will be NULL. alloc_tag_sub() will throw a
+	 * warning if slab has extensions but the extension of an object is
+	 * NULL, therefore replace NULL with CODETAG_EMPTY to indicate that
+	 * the extension for obj_exts is expected to be NULL.
+	 */
+	mark_objexts_empty(obj_exts);
 	kfree(obj_exts);
 	slab->obj_exts = 0;
 }
diff --git a/mm/slab_common.c b/mm/slab_common.c
index a05333bbb7f1..89265f825c43 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -244,6 +244,7 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
 		 * assign slabobj_exts in parallel. In this case the existing
 		 * objcg vector should be reused.
 		 */
+		mark_objexts_empty(vec);
 		kfree(vec);
 		return 0;
 	}
-- 
2.40.1.495.gc816e09b53d-goog

