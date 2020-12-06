From: Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v2 09/12] mm: memcontrol: convert vmstat slab counters to bytes
Date: Sun,  6 Dec 2020 16:29:45 +0800
Message-ID: <20201206082948.11812-3-songmuchun@bytedance.com>
References: <20201206082948.11812-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jxjzCofAcULr7bnQMbpOvZCW6tNXMo722rzO5X3X+g0=;
        b=wNv4qDSehcayO/ihogNTwYkGmNfh5RiiwJJPy5Ul8/X5rRuoAcaO9IWiT/zhh7c3zE
         DkQdTnRVChsF0HNvUG0ZpVzWqoGDxZHC6UdxNFd1esXfxLRYG5JPaZt/ehJmxRKGxRcy
         j2K7ImVTdAGGUwQzHwmDDriZDLsK3oJ2kzyams7iLzW6JmsFMSnV6U0Q5tVhmTk88NLQ
         P1mxFKPCxWivQAZSOj3l5kb7OdCK33TsD2BMo7RzFcUXbMtYUb38SlvmlQtvx8PkvIV3
         EV0/A75iolf7+KiwyhLHgs4vUFCGQa7dSkHBYsNwoQvuzRX5BJsEWtgU5PNGExnjgrB6
         0zag==
In-Reply-To: <20201206082948.11812-1-songmuchun@bytedance.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: gregkh@linuxfoundation.org, rafael@kernel.org, adobriyan@gmail.com, akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, hughd@google.com, will@kernel.org, guro@fb.com, rppt@kernel.org, tglx@linutronix.de, esyr@redhat.com, peterx@redhat.com, krisman@collabora.com, surenb@google.com, avagin@openvz.org, elver@google.com, rdunlap@infradead.org, iamjoonsoo.kim@lge.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>

the global and per-node counters are stored in pages, however memcg
and lruvec counters are stored in bytes. This scheme looks weird.
So convert all vmstat slab counters to bytes.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 include/linux/vmstat.h | 17 ++++++++++-------
 mm/vmstat.c            | 21 ++++++++++-----------
 2 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
index 322dcbfcc933..fd1a3d5d4926 100644
--- a/include/linux/vmstat.h
+++ b/include/linux/vmstat.h
@@ -197,18 +197,26 @@ static inline
 unsigned long global_node_page_state_pages(enum node_stat_item item)
 {
 	long x = atomic_long_read(&vm_node_stat[item]);
+
 #ifdef CONFIG_SMP
 	if (x < 0)
 		x = 0;
 #endif
+	if (vmstat_item_in_bytes(item))
+		x >>= PAGE_SHIFT;
 	return x;
 }
 
 static inline unsigned long global_node_page_state(enum node_stat_item item)
 {
-	VM_WARN_ON_ONCE(vmstat_item_in_bytes(item));
+	long x = atomic_long_read(&vm_node_stat[item]);
 
-	return global_node_page_state_pages(item);
+	VM_WARN_ON_ONCE(vmstat_item_in_bytes(item));
+#ifdef CONFIG_SMP
+	if (x < 0)
+		x = 0;
+#endif
+	return x;
 }
 
 static inline unsigned long zone_page_state(struct zone *zone,
@@ -312,11 +320,6 @@ static inline void __mod_zone_page_state(struct zone *zone,
 static inline void __mod_node_page_state(struct pglist_data *pgdat,
 			enum node_stat_item item, int delta)
 {
-	if (vmstat_item_in_bytes(item)) {
-		VM_WARN_ON_ONCE(delta & (PAGE_SIZE - 1));
-		delta >>= PAGE_SHIFT;
-	}
-
 	node_page_state_add(delta, pgdat, item);
 }
 
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 8d77ee426e22..7fb0c7cb9516 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -345,11 +345,6 @@ void __mod_node_page_state(struct pglist_data *pgdat, enum node_stat_item item,
 	long x;
 	long t;
 
-	if (vmstat_item_in_bytes(item)) {
-		VM_WARN_ON_ONCE(delta & (PAGE_SIZE - 1));
-		delta >>= PAGE_SHIFT;
-	}
-
 	x = delta + __this_cpu_read(*p);
 
 	t = __this_cpu_read(pcp->stat_threshold);
@@ -554,11 +549,6 @@ static inline void mod_node_state(struct pglist_data *pgdat,
 	s8 __percpu *p = pcp->vm_node_stat_diff + item;
 	long o, n, t, z;
 
-	if (vmstat_item_in_bytes(item)) {
-		VM_WARN_ON_ONCE(delta & (PAGE_SIZE - 1));
-		delta >>= PAGE_SHIFT;
-	}
-
 	do {
 		z = 0;  /* overflow to node counters */
 
@@ -1012,19 +1002,28 @@ unsigned long node_page_state_pages(struct pglist_data *pgdat,
 				    enum node_stat_item item)
 {
 	long x = atomic_long_read(&pgdat->vm_stat[item]);
+
 #ifdef CONFIG_SMP
 	if (x < 0)
 		x = 0;
 #endif
+	if (vmstat_item_in_bytes(item))
+		x >>= PAGE_SHIFT;
 	return x;
 }
 
 unsigned long node_page_state(struct pglist_data *pgdat,
 			      enum node_stat_item item)
 {
+	long x = atomic_long_read(&pgdat->vm_stat[item]);
+
 	VM_WARN_ON_ONCE(vmstat_item_in_bytes(item));
 
-	return node_page_state_pages(pgdat, item);
+#ifdef CONFIG_SMP
+	if (x < 0)
+		x = 0;
+#endif
+	return x;
 }
 #endif
 
-- 
2.11.0

