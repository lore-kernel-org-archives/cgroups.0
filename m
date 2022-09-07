From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/3] memcg: rearrange code
Date: Wed,  7 Sep 2022 04:35:36 +0000
Message-ID: <20220907043537.3457014-3-shakeelb@google.com>
References: <20220907043537.3457014-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=7xWB4XnyIc05hqp29+Ov/me4j17Vvs2h2ECTnGXauQA=;
        b=SDmUz9LkUVm/33cr2fKGG4SmxGsrw9fW609UlO1Lh2n9kJAvfCfnCBYoBieiLK1YI4
         MPXnoJKs7HxJOBMeo211kZrqk641hONA1Abc3kl7lVLPSE2aHCTST/ZAGe/af7Ia1j+Y
         HSkzyUCEB5QeLvw41TwrGd/TwUv4YIM4WP861pR3jQm7dOBwu7Q0zlxU3M2K1wwpBOpB
         CpJIkspZw9r5LITpRw9Xg679OMVQjNafq6M/iV99mdZ3p+Qr3ZpmS2S+7O4Mi0TM+q+w
         DxfU/ss15LI61VWwYkkQPDsa/qz7JkfaqkZ89EbLkvsgKRetTJhSaS1Vm/9WvgNffImX
         t82A==
In-Reply-To: <20220907043537.3457014-1-shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

This is a preparatory patch for easing the review of the follow up patch
which will reduce the memory overhead of memory cgroups.

Signed-off-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 mm/memcontrol.c | 46 +++++++++++++++++++++++-----------------------
 1 file changed, 23 insertions(+), 23 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index b195d4ca2a72..d0ccc16ed416 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -669,6 +669,29 @@ static void flush_memcg_stats_dwork(struct work_struct *w)
 	queue_delayed_work(system_unbound_wq, &stats_flush_dwork, FLUSH_TIME);
 }
 
+/* Subset of vm_event_item to report for memcg event stats */
+static const unsigned int memcg_vm_event_stat[] = {
+	PGSCAN_KSWAPD,
+	PGSCAN_DIRECT,
+	PGSTEAL_KSWAPD,
+	PGSTEAL_DIRECT,
+	PGFAULT,
+	PGMAJFAULT,
+	PGREFILL,
+	PGACTIVATE,
+	PGDEACTIVATE,
+	PGLAZYFREE,
+	PGLAZYFREED,
+#if defined(CONFIG_MEMCG_KMEM) && defined(CONFIG_ZSWAP)
+	ZSWPIN,
+	ZSWPOUT,
+#endif
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	THP_FAULT_ALLOC,
+	THP_COLLAPSE_ALLOC,
+#endif
+};
+
 struct memcg_vmstats_percpu {
 	/* Local (CPU and cgroup) page state & events */
 	long			state[MEMCG_NR_STAT];
@@ -1501,29 +1524,6 @@ static inline unsigned long memcg_page_state_output(struct mem_cgroup *memcg,
 	return memcg_page_state(memcg, item) * memcg_page_state_unit(item);
 }
 
-/* Subset of vm_event_item to report for memcg event stats */
-static const unsigned int memcg_vm_event_stat[] = {
-	PGSCAN_KSWAPD,
-	PGSCAN_DIRECT,
-	PGSTEAL_KSWAPD,
-	PGSTEAL_DIRECT,
-	PGFAULT,
-	PGMAJFAULT,
-	PGREFILL,
-	PGACTIVATE,
-	PGDEACTIVATE,
-	PGLAZYFREE,
-	PGLAZYFREED,
-#if defined(CONFIG_MEMCG_KMEM) && defined(CONFIG_ZSWAP)
-	ZSWPIN,
-	ZSWPOUT,
-#endif
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	THP_FAULT_ALLOC,
-	THP_COLLAPSE_ALLOC,
-#endif
-};
-
 static void memory_stat_format(struct mem_cgroup *memcg, char *buf, int bufsize)
 {
 	struct seq_buf s;
-- 
2.37.2.789.g6183377224-goog

