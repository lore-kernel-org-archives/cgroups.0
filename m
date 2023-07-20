From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [RFC PATCH 2/8] mm: vmscan: add lruvec_for_each_list() helper
Date: Thu, 20 Jul 2023 07:08:19 +0000
Message-ID: <20230720070825.992023-3-yosryahmed@google.com>
References: <20230720070825.992023-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689836912; x=1692428912;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=GTtTsHYHZoypkh/ZbOFrb+97cNaIZGVMYPTBvEUZ8QA=;
        b=1DoBmPRpqoKxp5AI1ATOavPZeo0Whgkd5Tc59Swf0g3JyV+Sf4czsw5vt5hRV/iIWU
         m0gxZI0ZpwmKuzcQe6n8ABa+pR3RNfGEwG4M79yda3Vq21aVBJ/g7QPw4WwY0KIttAPP
         qZs11I8hXcrNiTzcuVsx+5sSznkYJ5ijPhs+K2QY4AKhJ+1OPsJskvfvc2riuWl1X0pr
         fjY+rxKO1ypRGpwy/gVhyEiUbivpXGQsHDrV1rAgXPICZpfqdKSn1Khg2rXXV4x7hO0B
         V/yFis6Q3bBvFsNeipAISnXIhdf4e5y1csYuoWKJL9e1bvfMGj/AyzmZSyj99NVp9/vT
         61xw==
In-Reply-To: <20230720070825.992023-1-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Luis Chamberlain <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Iurii Zaikin <yzaikin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "T.J. Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

This helper is used to provide a callback to be called for each lruvec
list. This abstracts different lruvec implementations (MGLRU vs. classic
LRUs). The helper is used by a following commit to iterate all folios in
all LRUs lists for memcg recharging.

Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 include/linux/swap.h |  8 ++++++++
 mm/vmscan.c          | 28 ++++++++++++++++++++++++++++
 2 files changed, 36 insertions(+)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 456546443f1f..c0621deceb03 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -406,6 +406,14 @@ extern void lru_cache_add_inactive_or_unevictable(struct page *page,
 						struct vm_area_struct *vma);
 
 /* linux/mm/vmscan.c */
+typedef bool (*lruvec_list_fn_t)(struct lruvec *lruvec,
+				 struct list_head *list,
+				 enum lru_list lru,
+				 void *arg);
+extern void lruvec_for_each_list(struct lruvec *lruvec,
+				 lruvec_list_fn_t fn,
+				 void *arg);
+
 extern unsigned long zone_reclaimable_pages(struct zone *zone);
 extern unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
 					gfp_t gfp_mask, nodemask_t *mask);
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 1080209a568b..e7956000a3b6 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -6254,6 +6254,34 @@ static void lru_gen_shrink_node(struct pglist_data *pgdat, struct scan_control *
 
 #endif /* CONFIG_LRU_GEN */
 
+/*
+ * lruvec_for_each_list - make a callback for every folio list in the lruvec
+ * @lruvec: the lruvec to iterate lists in
+ * @fn: the callback to make for each list, iteration stops if it returns true
+ * @arg: argument to pass to @fn
+ */
+void lruvec_for_each_list(struct lruvec *lruvec, lruvec_list_fn_t fn, void *arg)
+{
+	enum lru_list lru;
+
+#ifdef CONFIG_LRU_GEN
+	if (lru_gen_enabled()) {
+		int gen, type, zone;
+
+		for_each_gen_type_zone(gen, type, zone) {
+			lru = type * LRU_INACTIVE_FILE;
+			if (fn(lruvec, &lruvec->lrugen.folios[gen][type][zone],
+			       lru, arg))
+				break;
+		}
+	} else
+#endif
+		for_each_evictable_lru(lru) {
+			if (fn(lruvec, &lruvec->lists[lru], lru, arg))
+				break;
+		}
+}
+
 static void shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 {
 	unsigned long nr[NR_LRU_LISTS];
-- 
2.41.0.255.g8b1d071c50-goog

