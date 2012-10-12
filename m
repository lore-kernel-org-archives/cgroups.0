From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: [PATCH v4 19/19] Add slab-specific documentation about the kmem controller
Date: Fri, 12 Oct 2012 17:41:13 +0400
Message-ID: <1350049273-17213-20-git-send-email-glommer@parallels.com>
References: <1350049273-17213-1-git-send-email-glommer@parallels.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1350049273-17213-1-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Signed-off-by: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
CC: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
CC: Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>
CC: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
CC: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
CC: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
CC: Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
CC: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 Documentation/cgroups/memory.txt | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/cgroups/memory.txt b/Documentation/cgroups/memory.txt
index dd15be8..95e4809 100644
--- a/Documentation/cgroups/memory.txt
+++ b/Documentation/cgroups/memory.txt
@@ -300,6 +300,13 @@ to trigger slab reclaim when those limits are reached.
 kernel memory, we prevent new processes from being created when the kernel
 memory usage is too high.
 
+* slab pages: pages allocated by the SLAB or SLUB allocator are tracked. A copy
+of each kmem_cache is created everytime the cache is touched by the first time
+from inside the memcg. The creation is done lazily, so some objects can still be
+skipped while the cache is being created. All objects in a slab page should
+belong to the same memcg. This only fails to hold when a task is migrated to a
+different memcg during the page allocation by the cache.
+
 * sockets memory pressure: some sockets protocols have memory pressure
 thresholds. The Memory Controller allows them to be controlled individually
 per cgroup, instead of globally.
-- 
1.7.11.4
