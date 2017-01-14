From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 8/8] slab: remove slub sysfs interface files early for empty memcg caches
Date: Sat, 14 Jan 2017 13:48:34 -0500
Message-ID: <20170114184834.8658-9-tj@kernel.org>
References: <20170114184834.8658-1-tj@kernel.org>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=b58WZKhpVuCKIvTedPdY3rv1/qB/Het50ubLSax32FU=;
        b=A/4OgMfSNrM1qLrUCAwo2g0v5Q2v6iyGPp3wUGzZH/SDofsGDrHDHV3+VPYvssWtjw
         V9BMpbe564onog+8bX7p+3xHDriQD6zw3sAV63UtTG5h0YtpVotbj48iVYCRD8DK/q2j
         kua3EglIYQlDDhvacGaL5DzRqv+5KbftEv1FEPFAo8x1HpTnDqWFnazmLnmV/pHs41Hy
         nFEplME8PAnKWBrXvarMuv2CP6ywVZ0vS6og2ASRgfM+upEN8hw61gQAB7g376naM8Nc
         H8oHrWGJLPGhFHYNQOJEvetLmQr2c+YWVLDmHNxeGdPmd6ozFibGpUnmuDPkb9BgJKQJ
         0zRQ==
In-Reply-To: <20170114184834.8658-1-tj@kernel.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vdavydov.dev@gmail.com, cl@linux.com, penberg@kernel.org, rientjes@google.com, iamjoonsoo.kim@lge.com, akpm@linux-foundation.org
Cc: jsvana@fb.com, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, kernel-team@fb.com, Tejun Heo <tj@kernel.org>

With kmem cgroup support enabled, kmem_caches can be created and
destroyed frequently and a great number of near empty kmem_caches can
accumulate if there are a lot of transient cgroups and the system is
not under memory pressure.  When memory reclaim starts under such
conditions, it can lead to consecutive deactivation and destruction of
many kmem_caches, easily hundreds of thousands on moderately large
systems, exposing scalability issues in the current slab management
code.  This is one of the patches to address the issue.

Each cache has a number of sysfs interface files under
/sys/kernel/slab.  On a system with a lot of memory and transient
memcgs, the number of interface files which have to be removed once
memory reclaim kicks in can reach millions.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Jay Vana <jsvana@fb.com>
Acked-by: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 mm/slub.c | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 184f80b..5bffa1f 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3951,8 +3951,20 @@ int __kmem_cache_shrink(struct kmem_cache *s)
 #ifdef CONFIG_MEMCG
 static void kmemcg_cache_deact_after_rcu(struct kmem_cache *s)
 {
-	/* called with all the locks held after a sched RCU grace period */
-	__kmem_cache_shrink(s);
+	/*
+	 * Called with all the locks held after a sched RCU grace period.
+	 * Even if @s becomes empty after shrinking, we can't know that @s
+	 * doesn't have allocations already in-flight and thus can't
+	 * destroy @s until the associated memcg is released.
+	 *
+	 * However, let's remove the sysfs files for empty caches here.
+	 * Each cache has a lot of interface files which aren't
+	 * particularly useful for empty draining caches; otherwise, we can
+	 * easily end up with millions of unnecessary sysfs files on
+	 * systems which have a lot of memory and transient cgroups.
+	 */
+	if (!__kmem_cache_shrink(s))
+		sysfs_slab_remove(s);
 }
 
 void __kmemcg_cache_deactivate(struct kmem_cache *s)
@@ -5651,6 +5663,15 @@ static void sysfs_slab_remove(struct kmem_cache *s)
 		 */
 		return;
 
+	if (!s->kobj.state_in_sysfs)
+		/*
+		 * For a memcg cache, this may be called during
+		 * deactivation and again on shutdown.  Remove only once.
+		 * A cache is never shut down before deactivation is
+		 * complete, so no need to worry about synchronization.
+		 */
+		return;
+
 #ifdef CONFIG_MEMCG
 	kset_unregister(s->memcg_kset);
 #endif
-- 
2.9.3

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
