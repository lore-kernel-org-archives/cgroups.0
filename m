From: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: [PATCH] percpu: improve percpu_alloc_percpu event trace
Date: Fri, 6 May 2022 07:46:08 +0300
Message-ID: <8d627f02-183f-c4e7-7c15-77b2b438536b@openvz.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openvz-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :content-language:content-transfer-encoding;
        bh=ebHe35Gmk78WMJgIfckhHfMIdVOvsLMOAu74q+t4BFo=;
        b=KYIakOzZUhch4ffbH6b7quOPssgj49bX0KU5QOiFBnElxbHq2FdwP3vT+3h5CcxPwX
         IrixwIa75q2T+acquFnGzfIdts4a13ILh1TU87vipuJT/zbgQcpdDqgCFu0tnC5cpz6U
         Y9+dMdFiT+jzafaqB6FpGOzcc4Z3a7vhJ2VOl8ItlzGx194twpwlWA7dyR24EkXKFnPB
         zFT7GXJaHWZNWdZv7dpJ8UsvZjA67mhWtFEbSSN8OH20bsRBiduvCnEfZEAj+wGvDOo3
         cOv1n4hJHPM42jtT8AG9DivNuYUg5sH8DJ2TZVNjmADImTQVCElvyU9y7swBwazZ+gPH
         Cgfw==
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Dennis Zhou <dennis-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

Added bytes_alloc and gfp_flags fields to the output of the
percpu_alloc_percpu ftrace event. This is required to track
memcg-accounted percpu allocations.

Signed-off-by: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
---
 include/trace/events/percpu.h | 17 ++++++++++++-----
 mm/percpu-internal.h          |  8 ++++----
 mm/percpu.c                   |  3 ++-
 3 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/include/trace/events/percpu.h b/include/trace/events/percpu.h
index df112a64f6c9..a6d640d2cb8b 100644
--- a/include/trace/events/percpu.h
+++ b/include/trace/events/percpu.h
@@ -6,13 +6,16 @@
 #define _TRACE_PERCPU_H
 
 #include <linux/tracepoint.h>
+#include <trace/events/mmflags.h>
 
 TRACE_EVENT(percpu_alloc_percpu,
 
 	TP_PROTO(bool reserved, bool is_atomic, size_t size,
-		 size_t align, void *base_addr, int off, void __percpu *ptr),
+		 size_t align, void *base_addr, int off,
+		 void __percpu *ptr, size_t bytes_alloc, gfp_t gfp_flags),
 
-	TP_ARGS(reserved, is_atomic, size, align, base_addr, off, ptr),
+	TP_ARGS(reserved, is_atomic, size, align, base_addr, off, ptr,
+		bytes_alloc, gfp_flags),
 
 	TP_STRUCT__entry(
 		__field(	bool,			reserved	)
@@ -22,8 +25,9 @@ TRACE_EVENT(percpu_alloc_percpu,
 		__field(	void *,			base_addr	)
 		__field(	int,			off		)
 		__field(	void __percpu *,	ptr		)
+		__field(	size_t,			bytes_alloc	)
+		__field(	gfp_t,			gfp_flags	)
 	),
-
 	TP_fast_assign(
 		__entry->reserved	= reserved;
 		__entry->is_atomic	= is_atomic;
@@ -32,12 +36,15 @@ TRACE_EVENT(percpu_alloc_percpu,
 		__entry->base_addr	= base_addr;
 		__entry->off		= off;
 		__entry->ptr		= ptr;
+		__entry->bytes_alloc	= bytes_alloc;
+		__entry->gfp_flags	= gfp_flags;
 	),
 
-	TP_printk("reserved=%d is_atomic=%d size=%zu align=%zu base_addr=%p off=%d ptr=%p",
+	TP_printk("reserved=%d is_atomic=%d size=%zu align=%zu base_addr=%p off=%d ptr=%p bytes_alloc=%zu gfp_flags=%s",
 		  __entry->reserved, __entry->is_atomic,
 		  __entry->size, __entry->align,
-		  __entry->base_addr, __entry->off, __entry->ptr)
+		  __entry->base_addr, __entry->off, __entry->ptr,
+		  __entry->bytes_alloc, show_gfp_flags(__entry->gfp_flags))
 );
 
 TRACE_EVENT(percpu_free_percpu,
diff --git a/mm/percpu-internal.h b/mm/percpu-internal.h
index 411d1593ef23..70b1ea23f4d2 100644
--- a/mm/percpu-internal.h
+++ b/mm/percpu-internal.h
@@ -113,7 +113,6 @@ static inline int pcpu_chunk_map_bits(struct pcpu_chunk *chunk)
 	return pcpu_nr_pages_to_map_bits(chunk->nr_pages);
 }
 
-#ifdef CONFIG_MEMCG_KMEM
 /**
  * pcpu_obj_full_size - helper to calculate size of each accounted object
  * @size: size of area to allocate in bytes
@@ -123,13 +122,14 @@ static inline int pcpu_chunk_map_bits(struct pcpu_chunk *chunk)
  */
 static inline size_t pcpu_obj_full_size(size_t size)
 {
-	size_t extra_size;
+	size_t extra_size = 0;
 
-	extra_size = size / PCPU_MIN_ALLOC_SIZE * sizeof(struct obj_cgroup *);
+#ifdef CONFIG_MEMCG_KMEM
+	extra_size += size / PCPU_MIN_ALLOC_SIZE * sizeof(struct obj_cgroup *);
+#endif
 
 	return size * num_possible_cpus() + extra_size;
 }
-#endif /* CONFIG_MEMCG_KMEM */
 
 #ifdef CONFIG_PERCPU_STATS
 
diff --git a/mm/percpu.c b/mm/percpu.c
index ea28db283044..cbeb380c359d 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1885,7 +1885,8 @@ static void __percpu *pcpu_alloc(size_t size, size_t align, bool reserved,
 	kmemleak_alloc_percpu(ptr, size, gfp);
 
 	trace_percpu_alloc_percpu(reserved, is_atomic, size, align,
-			chunk->base_addr, off, ptr);
+			chunk->base_addr, off, ptr,
+			pcpu_obj_full_size(size), gfp);
 
 	pcpu_memcg_post_alloc_hook(objcg, chunk, off, size);
 
-- 
2.31.1

