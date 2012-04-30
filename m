From: Anton Vorontsov <anton.vorontsov-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 3/3] slab: Get rid of mem_cgroup_put_kmem_cache()
Date: Mon, 30 Apr 2012 03:02:02 -0700
Message-ID: <20120430100202.GC28569@lizard>
References: <20120430095918.GA13824@lizard>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120430095918.GA13824@lizard>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linaro-kernel-cunTk1MwBs8s++Sfvej+rw@public.gmane.org, patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org

The function is no longer used, so can be safely removed.

Signed-off-by: Anton Vorontsov <anton.vorontsov-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 include/linux/slab_def.h |   11 -----------
 1 file changed, 11 deletions(-)

diff --git a/include/linux/slab_def.h b/include/linux/slab_def.h
index 2d371ae..72ea626 100644
--- a/include/linux/slab_def.h
+++ b/include/linux/slab_def.h
@@ -232,12 +232,6 @@ kmem_cache_get_ref(struct kmem_cache *cachep)
 }
 
 static inline void
-mem_cgroup_put_kmem_cache(struct kmem_cache *cachep)
-{
-	rcu_read_unlock();
-}
-
-static inline void
 mem_cgroup_kmem_cache_prepare_sleep(struct kmem_cache *cachep)
 {
 	/*
@@ -266,11 +260,6 @@ kmem_cache_drop_ref(struct kmem_cache *cachep)
 }
 
 static inline void
-mem_cgroup_put_kmem_cache(struct kmem_cache *cachep)
-{
-}
-
-static inline void
 mem_cgroup_kmem_cache_prepare_sleep(struct kmem_cache *cachep)
 {
 }
-- 
1.7.9.2
