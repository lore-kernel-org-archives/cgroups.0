From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 1/4] mm, slab: Revert "extend slab/shrink to shrink all memcg caches"
Date: Mon, 27 Apr 2020 19:56:18 -0400
Message-ID: <20200427235621.7823-2-longman@redhat.com>
References: <20200427235621.7823-1-longman@redhat.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588031808;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=bG+oOpvHV7fdGOI3xpfAnUa5ETjwSHs1N5A5bl4B/qU=;
        b=iPQT2XYOUvCYah1j4sxKrOqGrk/zzBzpSoZW/9npQ6+TCMUxxoacZlCbCAmgG925prVWpM
        Z4eAojg8WqVpu2eJ1G7u1v0tFjulnOyQtiK7qAE6xtvX5rQViBN+qFN1dapukajFXL/4T7
        GebTd5b/uUZ0PYeCX7riCW1kCCrDFKA=
In-Reply-To: <20200427235621.7823-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Qian Cai <cai-J5quhbR+WMc@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

When the slub shrink sysfs file is written into, the function call
sequence is as follows:

  kernfs_fop_write
    => slab_attr_store
      => shrink_store
        => kmem_cache_shrink_all

It turns out that doing a memcg cache scan in kmem_cache_shrink_all()
is redundant as the same memcg cache scan is being done in
slab_attr_store(). So revert the commit 04f768a39d55 ("mm, slab: extend
slab/shrink to shrink all memcg caches") except the documentation change
which is still valid.

Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 mm/slab.h        |  1 -
 mm/slab_common.c | 37 -------------------------------------
 mm/slub.c        |  2 +-
 3 files changed, 1 insertion(+), 39 deletions(-)

diff --git a/mm/slab.h b/mm/slab.h
index 207c83ef6e06..0937cb2ae8aa 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -237,7 +237,6 @@ int __kmem_cache_shrink(struct kmem_cache *);
 void __kmemcg_cache_deactivate(struct kmem_cache *s);
 void __kmemcg_cache_deactivate_after_rcu(struct kmem_cache *s);
 void slab_kmem_cache_release(struct kmem_cache *);
-void kmem_cache_shrink_all(struct kmem_cache *s);
 
 struct seq_file;
 struct file;
diff --git a/mm/slab_common.c b/mm/slab_common.c
index 23c7500eea7d..2e367ab8c15c 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -995,43 +995,6 @@ int kmem_cache_shrink(struct kmem_cache *cachep)
 }
 EXPORT_SYMBOL(kmem_cache_shrink);
 
-/**
- * kmem_cache_shrink_all - shrink a cache and all memcg caches for root cache
- * @s: The cache pointer
- */
-void kmem_cache_shrink_all(struct kmem_cache *s)
-{
-	struct kmem_cache *c;
-
-	if (!IS_ENABLED(CONFIG_MEMCG_KMEM) || !is_root_cache(s)) {
-		kmem_cache_shrink(s);
-		return;
-	}
-
-	get_online_cpus();
-	get_online_mems();
-	kasan_cache_shrink(s);
-	__kmem_cache_shrink(s);
-
-	/*
-	 * We have to take the slab_mutex to protect from the memcg list
-	 * modification.
-	 */
-	mutex_lock(&slab_mutex);
-	for_each_memcg_cache(c, s) {
-		/*
-		 * Don't need to shrink deactivated memcg caches.
-		 */
-		if (s->flags & SLAB_DEACTIVATED)
-			continue;
-		kasan_cache_shrink(c);
-		__kmem_cache_shrink(c);
-	}
-	mutex_unlock(&slab_mutex);
-	put_online_mems();
-	put_online_cpus();
-}
-
 bool slab_is_available(void)
 {
 	return slab_state >= UP;
diff --git a/mm/slub.c b/mm/slub.c
index 9bf44955c4f1..183ccc364ccf 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5343,7 +5343,7 @@ static ssize_t shrink_store(struct kmem_cache *s,
 			const char *buf, size_t length)
 {
 	if (buf[0] == '1')
-		kmem_cache_shrink_all(s);
+		kmem_cache_shrink(s);
 	else
 		return -EINVAL;
 	return length;
-- 
2.18.1

