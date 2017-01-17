From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 02/10] slub: separate out sysfs_slab_release() from sysfs_slab_remove()
Date: Tue, 17 Jan 2017 15:54:03 -0800
Message-ID: <20170117235411.9408-3-tj@kernel.org>
References: <20170117235411.9408-1-tj@kernel.org>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=EnIzwd/Gkg6Zjc2wtLBqLLL8X8YwzSYRSZjVhTgtaQ0=;
        b=FYrePSxocZV+Z3JY+iOTXPJZaxi+JUM10T8A0QK70qcFcTTl+ENPI+upnrKbdQR1FZ
         k9Hcp/NQZPLaegalwXd4OeFqRVHGB6F9cnzMnfuDXxI9Wcyz5Kmg3zZYBEdr/Eega4V+
         Z4SZ7cz4+0JWOiLUQM8nrzwhbT+sxHjElmL9TM2E+UFHDNVA1QYWRZZv0XhnMkMuw0hB
         i1HSI3Jnny0AAYUXxFRNlk06Z1ZcpkMczdXqPddBa7SS7SlJGaH8LHcgcaTgRqii5r/p
         Ullb4XoEEtvSz+tpNtMfS4BlBftdsy+5CrYuL0QIg1lTbZhW8IjiMLzxKEpyp7IuqY/b
         OdOA==
In-Reply-To: <20170117235411.9408-1-tj@kernel.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vdavydov.dev@gmail.com, cl@linux.com, penberg@kernel.org, rientjes@google.com, iamjoonsoo.kim@lge.com, akpm@linux-foundation.org
Cc: jsvana@fb.com, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, kernel-team@fb.com, Tejun Heo <tj@kernel.org>

Separate out slub sysfs removal and release, and call the former
earlier from __kmem_cache_shutdown().  There's no reason to defer
sysfs removal through RCU and this will later allow us to remove sysfs
files way earlier during memory cgroup offline instead of release.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 include/linux/slub_def.h | 4 ++--
 mm/slab_common.c         | 2 +-
 mm/slub.c                | 9 ++++++++-
 3 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/include/linux/slub_def.h b/include/linux/slub_def.h
index 75f56c2..07ef550 100644
--- a/include/linux/slub_def.h
+++ b/include/linux/slub_def.h
@@ -113,9 +113,9 @@ struct kmem_cache {
 
 #ifdef CONFIG_SYSFS
 #define SLAB_SUPPORTS_SYSFS
-void sysfs_slab_remove(struct kmem_cache *);
+void sysfs_slab_release(struct kmem_cache *);
 #else
-static inline void sysfs_slab_remove(struct kmem_cache *s)
+static inline void sysfs_slab_release(struct kmem_cache *s)
 {
 }
 #endif
diff --git a/mm/slab_common.c b/mm/slab_common.c
index 46ff746..3bc4bb8 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -480,7 +480,7 @@ static void release_caches(struct list_head *release, bool need_rcu_barrier)
 
 	list_for_each_entry_safe(s, s2, release, list) {
 #ifdef SLAB_SUPPORTS_SYSFS
-		sysfs_slab_remove(s);
+		sysfs_slab_release(s);
 #else
 		slab_kmem_cache_release(s);
 #endif
diff --git a/mm/slub.c b/mm/slub.c
index 68b84f9..2b78c82 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -214,11 +214,13 @@ enum track_item { TRACK_ALLOC, TRACK_FREE };
 static int sysfs_slab_add(struct kmem_cache *);
 static int sysfs_slab_alias(struct kmem_cache *, const char *);
 static void memcg_propagate_slab_attrs(struct kmem_cache *s);
+static void sysfs_slab_remove(struct kmem_cache *s);
 #else
 static inline int sysfs_slab_add(struct kmem_cache *s) { return 0; }
 static inline int sysfs_slab_alias(struct kmem_cache *s, const char *p)
 							{ return 0; }
 static inline void memcg_propagate_slab_attrs(struct kmem_cache *s) { }
+static inline void sysfs_slab_remove(struct kmem_cache *s) { }
 #endif
 
 static inline void stat(const struct kmem_cache *s, enum stat_item si)
@@ -3679,6 +3681,7 @@ int __kmem_cache_shutdown(struct kmem_cache *s)
 		if (n->nr_partial || slabs_node(s, node))
 			return 1;
 	}
+	sysfs_slab_remove(s);
 	return 0;
 }
 
@@ -5629,7 +5632,7 @@ static int sysfs_slab_add(struct kmem_cache *s)
 	goto out;
 }
 
-void sysfs_slab_remove(struct kmem_cache *s)
+static void sysfs_slab_remove(struct kmem_cache *s)
 {
 	if (slab_state < FULL)
 		/*
@@ -5643,6 +5646,10 @@ void sysfs_slab_remove(struct kmem_cache *s)
 #endif
 	kobject_uevent(&s->kobj, KOBJ_REMOVE);
 	kobject_del(&s->kobj);
+}
+
+void sysfs_slab_release(struct kmem_cache *s)
+{
 	kobject_put(&s->kobj);
 }
 
-- 
2.9.3

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
