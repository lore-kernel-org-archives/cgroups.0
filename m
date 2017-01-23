From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH v2 02/10] slub: separate out sysfs_slab_release() from
 sysfs_slab_remove()
Date: Mon, 23 Jan 2017 17:54:49 -0500
Message-ID: <20170123225449.GA29940@htj.duckdns.org>
References: <20170117235411.9408-1-tj@kernel.org>
 <20170117235411.9408-3-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=0yVbFaUJ20sO+1idCY57TlRfs+ax7E0zV/z2INNnT6I=;
        b=j4cQS5E0bUI8E+gYYtqHqgxbLsumAlKf/LIvW8FG7Y/zK0tHtm4w+ARGwyfxm02XUN
         30aRwqc3537zXOIK+Q4fTvVEsxLPtZVIGQFTxceNXpAiMFDOtRPSiPS1c+MOu2KgBsZA
         Xuvuueln/ZyBM9lEgz1tqpBCNZIxUnQ8Us9ekGMLyD2ahhLNVU28CQx709cM+48D7K95
         R4ThW4wY5LX1lIWz7Cv3AZVfM8Lnaic4VrTPoCEn+lpbRkCXs6FnRPw5uAb7CmZR6P40
         7DFh0gZzqOWXn0QvCIRAn4nxUbCR1b8d1AA8ED297UHDgxqD4HZMEiPOtugxgjWkBqyZ
         DulQ==
Content-Disposition: inline
In-Reply-To: <20170117235411.9408-3-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org, penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: jsvana-b10kYP2dOMg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

From 3b0cdd93b2d9bdea62ea6681e612bdae7a40d883 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Date: Mon, 23 Jan 2017 17:53:18 -0500

Separate out slub sysfs removal and release, and call the former
earlier from __kmem_cache_shutdown().  There's no reason to defer
sysfs removal through RCU and this will later allow us to remove sysfs
files way earlier during memory cgroup offline instead of release.

v2: Add slab_state >= FULL test to sysfs_slab_release() so that
    kobject_put() is skipped for caches which aren't fully initialized
    as before.  This most likely leaks the kmem_cache on init failure
    as we're skipping the only release path.  Let's fix that up later.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
---
v2 of the patch.  Fixes boot failure reported by the test bot.

Thanks.

 include/linux/slub_def.h |  4 ++--
 mm/slab_common.c         |  2 +-
 mm/slub.c                | 12 ++++++++++--
 3 files changed, 13 insertions(+), 5 deletions(-)

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
index 68b84f9..59ca718 100644
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
@@ -5643,7 +5646,12 @@ void sysfs_slab_remove(struct kmem_cache *s)
 #endif
 	kobject_uevent(&s->kobj, KOBJ_REMOVE);
 	kobject_del(&s->kobj);
-	kobject_put(&s->kobj);
+}
+
+void sysfs_slab_release(struct kmem_cache *s)
+{
+	if (slab_state >= FULL)
+		kobject_put(&s->kobj);
 }
 
 /*
-- 
2.9.3
