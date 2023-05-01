From: Suren Baghdasaryan <surenb@google.com>
Subject: [PATCH 39/40] codetag: debug: introduce OBJEXTS_ALLOC_FAIL to mark
 failed slab_ext allocations
Date: Mon,  1 May 2023 09:54:49 -0700
Message-ID: <20230501165450.15352-40-surenb@google.com>
References: <20230501165450.15352-1-surenb@google.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682960197; x=1685552197;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6mzPQystPbLbDwPdw2fPo41K7qknlkieEKK3sweddW8=;
        b=48U8jHG63mdA66+jSc2MsTTE/SQi8BR+RKY6JNGvzt9XyZfx935vfOLln6IV1D1nZA
         TDOiQ/WUR049cZ5YJ1Q2SXSzODz7LrWrQUYaviS+GqGgkaK3yK5eLgyzf9e3cLjtYX0E
         QEA8ptoQ0G50fmCmay29a1/AGKziq1anSqyI04k35PIYMGlvV6wz4iKeKGJ75o0JVkmO
         ON7F5nilmKInR+kNfyJ2/HvMFyxBUo4zG20TTbLKq7fKcUY3NShJQ1fHpbVtH1cQdhj8
         PGEM3ZzK108E7+nu3T246tg/tKyPHMfi0CFtYYsesaQA8cqlaVTRPDBW+c2GnGCMueBG
         1wCA==
In-Reply-To: <20230501165450.15352-1-surenb@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: akpm@linux-foundation.org
Cc: kent.overstreet@linux.dev, mhocko@suse.com, vbabka@suse.cz, hannes@cmpxchg.org, roman.gushchin@linux.dev, mgorman@suse.de, dave@stgolabs.net, willy@infradead.org, liam.howlett@oracle.com, corbet@lwn.net, void@manifault.com, peterz@infradead.org, juri.lelli@redhat.com, ldufour@linux.ibm.com, catalin.marinas@arm.com, will@kernel.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org, peterx@redhat.com, david@redhat.com, axboe@kernel.dk, mcgrof@kernel.org, masahiroy@kernel.org, nathan@kernel.org, dennis@kernel.org, tj@kernel.org, muchun.song@linux.dev, rppt@kernel.org, paulmck@kernel.org, pasha.tatashin@soleen.com, yosryahmed@google.com, yuzhao@google.com, dhowells@redhat.com, hughd@google.com, andreyknvl@gmail.com, keescook@chromium.org

If slabobj_ext vector allocation for a slab object fails and later on it
succeeds for another object in the same slab, the slabobj_ext for the
original object will be NULL and will be flagged in case when
CONFIG_MEM_ALLOC_PROFILING_DEBUG is enabled.
Mark failed slabobj_ext vector allocations using a new objext_flags flag
stored in the lower bits of slab->obj_exts. When new allocation succeeds
it marks all tag references in the same slabobj_ext vector as empty to
avoid warnings implemented by CONFIG_MEM_ALLOC_PROFILING_DEBUG checks.

Signed-off-by: Suren Baghdasaryan <surenb@google.com>
---
 include/linux/memcontrol.h |  4 +++-
 mm/slab_common.c           | 27 +++++++++++++++++++++++++--
 2 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index c7f21b15b540..3eb8975c1462 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -356,8 +356,10 @@ enum page_memcg_data_flags {
 #endif /* CONFIG_MEMCG */
 
 enum objext_flags {
+	/* slabobj_ext vector failed to allocate */
+	OBJEXTS_ALLOC_FAIL = __FIRST_OBJEXT_FLAG,
 	/* the next bit after the last actual flag */
-	__NR_OBJEXTS_FLAGS  = __FIRST_OBJEXT_FLAG,
+	__NR_OBJEXTS_FLAGS  = (__FIRST_OBJEXT_FLAG << 1),
 };
 
 #define OBJEXTS_FLAGS_MASK (__NR_OBJEXTS_FLAGS - 1)
diff --git a/mm/slab_common.c b/mm/slab_common.c
index 89265f825c43..5b7e096b70a5 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -217,21 +217,44 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
 {
 	unsigned int objects = objs_per_slab(s, slab);
 	unsigned long obj_exts;
-	void *vec;
+	struct slabobj_ext *vec;
 
 	gfp &= ~OBJCGS_CLEAR_MASK;
 	/* Prevent recursive extension vector allocation */
 	gfp |= __GFP_NO_OBJ_EXT;
 	vec = kcalloc_node(objects, sizeof(struct slabobj_ext), gfp,
 			   slab_nid(slab));
-	if (!vec)
+	if (!vec) {
+#ifdef CONFIG_MEM_ALLOC_PROFILING_DEBUG
+		if (new_slab) {
+			/* Mark vectors which failed to allocate */
+			slab->obj_exts = OBJEXTS_ALLOC_FAIL;
+#ifdef CONFIG_MEMCG
+			slab->obj_exts |= MEMCG_DATA_OBJEXTS;
+#endif
+		}
+#endif
 		return -ENOMEM;
+	}
 
 	obj_exts = (unsigned long)vec;
 #ifdef CONFIG_MEMCG
 	obj_exts |= MEMCG_DATA_OBJEXTS;
 #endif
 	if (new_slab) {
+#ifdef CONFIG_MEM_ALLOC_PROFILING_DEBUG
+		/*
+		 * If vector previously failed to allocate then we have live
+		 * objects with no tag reference. Mark all references in this
+		 * vector as empty to avoid warnings later on.
+		 */
+		if (slab->obj_exts & OBJEXTS_ALLOC_FAIL) {
+			unsigned int i;
+
+			for (i = 0; i < objects; i++)
+				set_codetag_empty(&vec[i].ref);
+		}
+#endif
 		/*
 		 * If the slab is brand new and nobody can yet access its
 		 * obj_exts, no synchronization is required and obj_exts can
-- 
2.40.1.495.gc816e09b53d-goog

