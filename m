From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH-next v5 3/4] mm/memcg: Improve refill_obj_stock() performance
Date: Tue, 20 Apr 2021 15:29:06 -0400
Message-ID: <20210420192907.30880-4-longman@redhat.com>
References: <20210420192907.30880-1-longman@redhat.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618947032;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=V8tpjiZVe9/HPR7EqqmVPxX4+H+yOIDgVesSOM9WmtY=;
        b=ExXlP/QgRAFDof4pxNIZXaI6bL/bMGwkwhoxdmnolVTNEt9k/UGMQVrncxhLDKe2WMZrdu
        eLQUjZch3/078FPjwvwXkBAJRTWiL0XIYaypI+qeoLa45GBlDiYGVqdV2omcfjwdg2UlOc
        yvgjE0B4G+ggrLiEtRm+AopeECRl6HE=
In-Reply-To: <20210420192907.30880-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Masayoshi Mizuma <msys.mizuma-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Xing Zhengjun <zhengjun.xing-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

There are two issues with the current refill_obj_stock() code. First of
all, when nr_bytes reaches over PAGE_SIZE, it calls drain_obj_stock() to
atomically flush out remaining bytes to obj_cgroup, clear cached_objcg
and do a obj_cgroup_put(). It is likely that the same obj_cgroup will
be used again which leads to another call to drain_obj_stock() and
obj_cgroup_get() as well as atomically retrieve the available byte from
obj_cgroup. That is costly. Instead, we should just uncharge the excess
pages, reduce the stock bytes and be done with it. The drain_obj_stock()
function should only be called when obj_cgroup changes.

Secondly, when charging an object of size not less than a page in
obj_cgroup_charge(), it is possible that the remaining bytes to be
refilled to the stock will overflow a page and cause refill_obj_stock()
to uncharge 1 page. To avoid the additional uncharge in this case,
a new overfill flag is added to refill_obj_stock() which will be set
when called from obj_cgroup_charge().

A multithreaded kmalloc+kfree microbenchmark on a 2-socket 48-core
96-thread x86-64 system with 96 testing threads were run.  Before this
patch, the total number of kilo kmalloc+kfree operations done for a 4k
large object by all the testing threads per second were 4,304 kops/s
(cgroup v1) and 8,478 kops/s (cgroup v2). After applying this patch, the
number were 4,731 (cgroup v1) and 418,142 (cgroup v2) respectively. This
represents a performance improvement of 1.10X (cgroup v1) and 49.3X
(cgroup v2).

Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 mm/memcontrol.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 292b4783b1a7..2f87d0b05092 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3153,10 +3153,12 @@ static bool obj_stock_flush_required(struct memcg_stock_pcp *stock,
 	return false;
 }
 
-static void refill_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes)
+static void refill_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes,
+			     bool overfill)
 {
 	struct memcg_stock_pcp *stock;
 	unsigned long flags;
+	unsigned int nr_pages = 0;
 
 	local_irq_save(flags);
 
@@ -3165,14 +3167,20 @@ static void refill_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes)
 		drain_obj_stock(stock);
 		obj_cgroup_get(objcg);
 		stock->cached_objcg = objcg;
-		stock->nr_bytes = atomic_xchg(&objcg->nr_charged_bytes, 0);
+		stock->nr_bytes = atomic_read(&objcg->nr_charged_bytes)
+				? atomic_xchg(&objcg->nr_charged_bytes, 0) : 0;
 	}
 	stock->nr_bytes += nr_bytes;
 
-	if (stock->nr_bytes > PAGE_SIZE)
-		drain_obj_stock(stock);
+	if (!overfill && (stock->nr_bytes > PAGE_SIZE)) {
+		nr_pages = stock->nr_bytes >> PAGE_SHIFT;
+		stock->nr_bytes &= (PAGE_SIZE - 1);
+	}
 
 	local_irq_restore(flags);
+
+	if (nr_pages)
+		obj_cgroup_uncharge_pages(objcg, nr_pages);
 }
 
 int obj_cgroup_charge(struct obj_cgroup *objcg, gfp_t gfp, size_t size)
@@ -3201,14 +3209,14 @@ int obj_cgroup_charge(struct obj_cgroup *objcg, gfp_t gfp, size_t size)
 
 	ret = obj_cgroup_charge_pages(objcg, gfp, nr_pages);
 	if (!ret && nr_bytes)
-		refill_obj_stock(objcg, PAGE_SIZE - nr_bytes);
+		refill_obj_stock(objcg, PAGE_SIZE - nr_bytes, true);
 
 	return ret;
 }
 
 void obj_cgroup_uncharge(struct obj_cgroup *objcg, size_t size)
 {
-	refill_obj_stock(objcg, size);
+	refill_obj_stock(objcg, size, false);
 }
 
 #endif /* CONFIG_MEMCG_KMEM */
-- 
2.18.1

