From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: [PATCH v2] slub: correctly bootstrap boot caches
Date: Fri, 22 Feb 2013 20:20:00 +0400
Message-ID: <1361550000-14173-1-git-send-email-glommer@parallels.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

After we create a boot cache, we may allocate from it until it is bootstraped.
This will move the page from the partial list to the cpu slab list. If this
happens, the loop:

	list_for_each_entry(p, &n->partial, lru)

that we use to scan for all partial pages will yield nothing, and the pages
will keep pointing to the boot cpu cache, which is of course, invalid. To do
that, we should flush the cache to make sure that the cpu slab is back to the
partial list.

Signed-off-by: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Reported-by:  Steffen Michalke <StMichalke-S0/GAf8tV78@public.gmane.org>
Tested-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

 mm/slub.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)
---
 mm/slub.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/slub.c b/mm/slub.c
index ba2ca53..31a494c 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3617,6 +3617,12 @@ static struct kmem_cache * __init bootstrap(struct kmem_cache *static_cache)
 
 	memcpy(s, static_cache, kmem_cache->object_size);
 
+	/*
+	 * This runs very early, and only the boot processor is supposed to be
+	 * up.  Even if it weren't true, IRQs are not up so we couldn't fire
+	 * IPIs around.
+	 */
+	__flush_cpu_slab(s, smp_processor_id());
 	for_each_node_state(node, N_NORMAL_MEMORY) {
 		struct kmem_cache_node *n = get_node(s, node);
 		struct page *p;
-- 
1.8.1.2
