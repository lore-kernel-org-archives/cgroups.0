From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/9] slab: reorganize memcg_cache_params
Date: Sat, 14 Jan 2017 00:54:44 -0500
Message-ID: <20170114055449.11044-5-tj@kernel.org>
References: <20170114055449.11044-1-tj@kernel.org>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=23qhB6RNAsq00jOm6V2t2tFdrny30DJ7LHI8bfdKSrE=;
        b=vRhWUVHY3azjvvHUy5pc2XHRVwH4UqNAJj83I8ETCn3gKsiRfetrCTAgQJojOpPte5
         fwBD5uF9VBwtlQM8hGwujLnCtwd2+ngaSCHL55MR05KkeZ5m2gkapiryShrnP42JPdYJ
         3yShpmYgmNam7zd3PjDRBpa/tdbYBtwYuIAD8qpBb+dbAkLSFKW0hZsNDjo40LKs+tZt
         tbBS7o2soGvmznXbqDmJftbNOfPZ53H2J9jJEBUniQoYk/Sul2wrXcNySIFcc6IHVjt8
         WryGw5pHT/+PTAHuvVKjrKsO+xeBi0XKaTx78L4+Ia9727uB1OCmOFUqNk2DTwv4fUQP
         StUg==
In-Reply-To: <20170114055449.11044-1-tj@kernel.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vdavydov.dev@gmail.com, cl@linux.com, penberg@kernel.org, rientjes@google.com, iamjoonsoo.kim@lge.com, akpm@linux-foundation.org
Cc: jsvana@fb.com, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, kernel-team@fb.com, Tejun Heo <tj@kernel.org>

We're gonna change how memcg caches are iterated.  In preparation,
clean up and reorganize memcg_cache_params.

* The shared ->list is replaced by ->children in root and
  ->children_node in children.

* ->is_root_cache is removed.  Instead ->root_cache is moved out of
  the child union and now used by both root and children.  NULL
  indicates root cache.  Non-NULL a memcg one.

This patch doesn't cause any observable behavior changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 include/linux/slab.h | 33 ++++++++++++++++++++++++---------
 mm/slab.h            |  6 +++---
 mm/slab_common.c     | 21 +++++++++++----------
 3 files changed, 38 insertions(+), 22 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index 084b12b..b310173 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -545,22 +545,37 @@ struct memcg_cache_array {
  * array to be accessed without taking any locks, on relocation we free the old
  * version only after a grace period.
  *
- * Child caches will hold extra metadata needed for its operation. Fields are:
+ * Root and child caches hold different metadata.
  *
- * @memcg: pointer to the memcg this cache belongs to
- * @root_cache: pointer to the global, root cache, this cache was derived from
+ * @root_cache:	Common to root and child caches.  NULL for root, pointer to
+ *		the root cache for children.
  *
- * Both root and child caches of the same kind are linked into a list chained
- * through @list.
+ * The following fields are specific to root caches.
+ *
+ * @memcg_caches: kmemcg ID indexed table of child caches.  This table is
+ *		used to index child cachces during allocation and cleared
+ *		early during shutdown.
+ *
+ * @children:	List of all child caches.  While the child caches are also
+ *		reachable through @memcg_caches, a child cache remains on
+ *		this list until it is actually destroyed.
+ *
+ * The following fields are specifci to child caches.
+ *
+ * @memcg:	Pointer to the memcg this cache belongs to.
+ *
+ * @children_node: List node for @root_cache->children list.
  */
 struct memcg_cache_params {
-	bool is_root_cache;
-	struct list_head list;
+	struct kmem_cache *root_cache;
 	union {
-		struct memcg_cache_array __rcu *memcg_caches;
+		struct {
+			struct memcg_cache_array __rcu *memcg_caches;
+			struct list_head children;
+		};
 		struct {
 			struct mem_cgroup *memcg;
-			struct kmem_cache *root_cache;
+			struct list_head children_node;
 		};
 	};
 };
diff --git a/mm/slab.h b/mm/slab.h
index 3fa2d77..9b3ec3f 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -203,12 +203,12 @@ int __kmem_cache_alloc_bulk(struct kmem_cache *, gfp_t, size_t, void **);
  * slab_mutex.
  */
 #define for_each_memcg_cache(iter, root) \
-	list_for_each_entry(iter, &(root)->memcg_params.list, \
-			    memcg_params.list)
+	list_for_each_entry(iter, &(root)->memcg_params.children, \
+			    memcg_params.children_node)
 
 static inline bool is_root_cache(struct kmem_cache *s)
 {
-	return s->memcg_params.is_root_cache;
+	return !s->memcg_params.root_cache;
 }
 
 static inline bool slab_equal_or_root(struct kmem_cache *s,
diff --git a/mm/slab_common.c b/mm/slab_common.c
index 45aa67c..fdf5b6d 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -135,9 +135,9 @@ int __kmem_cache_alloc_bulk(struct kmem_cache *s, gfp_t flags, size_t nr,
 #if defined(CONFIG_MEMCG) && !defined(CONFIG_SLOB)
 void slab_init_memcg_params(struct kmem_cache *s)
 {
-	s->memcg_params.is_root_cache = true;
-	INIT_LIST_HEAD(&s->memcg_params.list);
+	s->memcg_params.root_cache = NULL;
 	RCU_INIT_POINTER(s->memcg_params.memcg_caches, NULL);
+	INIT_LIST_HEAD(&s->memcg_params.children);
 }
 
 static int init_memcg_params(struct kmem_cache *s,
@@ -145,10 +145,10 @@ static int init_memcg_params(struct kmem_cache *s,
 {
 	struct memcg_cache_array *arr;
 
-	if (memcg) {
-		s->memcg_params.is_root_cache = false;
-		s->memcg_params.memcg = memcg;
+	if (root_cache) {
 		s->memcg_params.root_cache = root_cache;
+		s->memcg_params.memcg = memcg;
+		INIT_LIST_HEAD(&s->memcg_params.children_node);
 		return 0;
 	}
 
@@ -218,7 +218,7 @@ int memcg_update_all_caches(int num_memcgs)
 
 static void unlink_memcg_cache(struct kmem_cache *s)
 {
-	list_del(&s->memcg_params.list);
+	list_del(&s->memcg_params.children_node);
 }
 #else
 static inline int init_memcg_params(struct kmem_cache *s,
@@ -559,7 +559,8 @@ void memcg_create_kmem_cache(struct mem_cgroup *memcg,
 		goto out_unlock;
 	}
 
-	list_add(&s->memcg_params.list, &root_cache->memcg_params.list);
+	list_add(&s->memcg_params.children_node,
+		 &root_cache->memcg_params.children);
 
 	/*
 	 * Since readers won't lock (see cache_from_memcg_idx()), we need a
@@ -650,15 +651,15 @@ static int shutdown_memcg_caches(struct kmem_cache *s)
 	/*
 	 * Shutdown all caches.
 	 */
-	list_for_each_entry_safe(c, c2, &s->memcg_params.list,
-				 memcg_params.list)
+	list_for_each_entry_safe(c, c2, &s->memcg_params.children,
+				 memcg_params.children_node)
 		shutdown_cache(c);
 
 	/*
 	 * A cache being destroyed must be empty. In particular, this means
 	 * that all per memcg caches attached to it must be empty too.
 	 */
-	if (!list_empty(&s->memcg_params.list))
+	if (!list_empty(&s->memcg_params.children))
 		return -EBUSY;
 	return 0;
 }
-- 
2.9.3

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
