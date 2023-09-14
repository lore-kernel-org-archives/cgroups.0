From: Huan Yang <link-DGpbCiVdSXo@public.gmane.org>
Subject: [PATCH 1/3] mm: multi-gen LRU: fold lru_gen run cmd
Date: Thu, 14 Sep 2023 18:47:43 +0800
Message-ID: <20230914104754.55-2-link@vivo.com>
References: <20230914104754.55-1-link@vivo.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0C8N66XH3EPgkxilo68Mh0apGkR0cAE3HBoIonCw0Yc=;
 b=bzTL9qkPZQ+omu8iK7UQBPZb9vgNx+01XztxjXtNl3nSG2nPhlqV52IiIkLsg8VOrBm1WyJCPHjZRSRfXHgJJuT+g9MTwlY7XuGw+UN7ZHVCcEQ+8SZFNS4fekPYbIj4Pq1T1bvGntYhUpziO5EmFnFDEOAxlOxzkLWlnRewOFyHb2PH7aMY4XrkqJPnDi9o5S16InDTTEb2oFR3a5+p6BYF2IPxSspxmC09RJNBfGI1QrfFeIbyGL5ojCJDbawVWNrFhGOO2EFDOByP0cKHis8m35dn2olXVN5bD8zy3KaGodFiTRo1dy0ZdGV3DJxu4LSKzuXaU4t0y6AZeYhNZg==
In-Reply-To: <20230914104754.55-1-link-DGpbCiVdSXo@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mike Rapoport <rppt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Jan Alexander Steffens (heftig)" <heftig-fd97jBR+K/6hPH1hqNUYSQ@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Huan Yang <link-DGpbCiVdSXo@public.gmane.org>, Brian Geffon <bgeffon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Gaosheng Cui <cuigaosheng1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Peter Xu <peterx-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Axel Rasmussen <axelrasmussen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "T.J. Alumbaugh" <talumbau-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Kefeng Wang <wangkefeng.wang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm@kvac
Cc: kernel-DGpbCiVdSXo@public.gmane.org

This patch move LRU_GEN define helper into mm_inline which will
used in per memcg lru gen node.

let run aging/eviction into func, per memcg also will run this.

Signed-off-by: Huan Yang <link-DGpbCiVdSXo@public.gmane.org>
---
 include/linux/mm_inline.h |  9 ++++++++
 mm/vmscan.c               | 45 +++++++++++++++++++++------------------
 2 files changed, 33 insertions(+), 21 deletions(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index 8148b30a9df1..b953b305c8a2 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -101,6 +101,15 @@ static __always_inline enum lru_list folio_lru_list(struct folio *folio)
 
 #ifdef CONFIG_LRU_GEN
 
+#define DEFINE_MAX_SEQ(lruvec)						\
+	unsigned long max_seq = READ_ONCE((lruvec)->lrugen.max_seq)
+
+#define DEFINE_MIN_SEQ(lruvec)						\
+	unsigned long min_seq[ANON_AND_FILE] = {			\
+		READ_ONCE((lruvec)->lrugen.min_seq[LRU_GEN_ANON]),	\
+		READ_ONCE((lruvec)->lrugen.min_seq[LRU_GEN_FILE]),	\
+	}
+
 #ifdef CONFIG_LRU_GEN_ENABLED
 static inline bool lru_gen_enabled(void)
 {
diff --git a/mm/vmscan.c b/mm/vmscan.c
index ea57a43ebd6b..f59977964e81 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3285,15 +3285,6 @@ static bool should_clear_pmd_young(void)
 
 #define LRU_REFS_FLAGS	(BIT(PG_referenced) | BIT(PG_workingset))
 
-#define DEFINE_MAX_SEQ(lruvec)						\
-	unsigned long max_seq = READ_ONCE((lruvec)->lrugen.max_seq)
-
-#define DEFINE_MIN_SEQ(lruvec)						\
-	unsigned long min_seq[ANON_AND_FILE] = {			\
-		READ_ONCE((lruvec)->lrugen.min_seq[LRU_GEN_ANON]),	\
-		READ_ONCE((lruvec)->lrugen.min_seq[LRU_GEN_FILE]),	\
-	}
-
 #define for_each_gen_type_zone(gen, type, zone)				\
 	for ((gen) = 0; (gen) < MAX_NR_GENS; (gen)++)			\
 		for ((type) = 0; (type) < ANON_AND_FILE; (type)++)	\
@@ -6058,6 +6049,29 @@ static int run_eviction(struct lruvec *lruvec, unsigned long seq, struct scan_co
 	return -EINTR;
 }
 
+static int __process_one_cmd(char cmd, struct lruvec *lruvec, unsigned long seq,
+			     struct scan_control *sc, int swappiness,
+			     unsigned long opt)
+{
+	int err;
+
+	if (swappiness < 0)
+		swappiness = get_swappiness(lruvec, sc);
+	else if (swappiness > 200)
+		return -EINVAL;
+
+	switch (cmd) {
+	case '+':
+		err = run_aging(lruvec, seq, sc, swappiness, opt);
+		break;
+	case '-':
+		err = run_eviction(lruvec, seq, sc, swappiness, opt);
+		break;
+	}
+
+	return err;
+}
+
 static int run_cmd(char cmd, int memcg_id, int nid, unsigned long seq,
 		   struct scan_control *sc, int swappiness, unsigned long opt)
 {
@@ -6086,19 +6100,8 @@ static int run_cmd(char cmd, int memcg_id, int nid, unsigned long seq,
 
 	lruvec = get_lruvec(memcg, nid);
 
-	if (swappiness < 0)
-		swappiness = get_swappiness(lruvec, sc);
-	else if (swappiness > 200)
-		goto done;
+	err = __process_one_cmd(cmd, lruvec, seq, sc, swappiness, opt);
 
-	switch (cmd) {
-	case '+':
-		err = run_aging(lruvec, seq, sc, swappiness, opt);
-		break;
-	case '-':
-		err = run_eviction(lruvec, seq, sc, swappiness, opt);
-		break;
-	}
 done:
 	mem_cgroup_put(memcg);
 
-- 
2.34.1

