From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: [PATCH] mm: memcontrol: optimize per-lruvec stats counter memory usage
Date: Sun,  6 Dec 2020 16:56:39 +0800
Message-ID: <20201206085639.12627-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=S6K7q1C4aJV74LX9XzVIffEohV+cRacrmIp1D6GqZ88=;
        b=wbbdNcohGtl2TDgFPwVXnP/R+H6oQayEahb3/U42bl0C7LgjfwxjWQhZocOA7q6nF1
         FmtvtIEcyBL9V+t39mbO4lzaK3D9oTeBvtaHdFlFz5TlDEYOB9DOU0g0r52AFuZaHxwI
         rNZH7gI3CebsuonBrBQOiF4iPffZnK0CGnQx6yEn+aOC1vD6rAOzROGitnJm3cR9VnOl
         gqkZAkaKqh8+KCdEtr403lAWfvLGFsCx7aTVag6VoJpSRcIBDj5fiHqADmh6SBeDTCPy
         342drhgb5CF35xSJJ4tpvkbgw+y4UbM3sqdXlFOrxBuNhZZjGjtPYWqJpBpiUtqLJ9P7
         vLYA==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org, sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org, alexander.h.duyck-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org, laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

The vmstat threshold is 32 (MEMCG_CHARGE_BATCH), so the type of s32
of lruvec_stat_cpu is enough. And introduce struct per_cpu_lruvec_stat
to optimize memory usage.

Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
---
 include/linux/memcontrol.h | 6 +++++-
 mm/memcontrol.c            | 2 +-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index f9a496c4eac7..34cf119976b1 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -92,6 +92,10 @@ struct lruvec_stat {
 	long count[NR_VM_NODE_STAT_ITEMS];
 };
 
+struct per_cpu_lruvec_stat {
+	s32 count[NR_VM_NODE_STAT_ITEMS];
+};
+
 /*
  * Bitmap of shrinker::id corresponding to memcg-aware shrinkers,
  * which have elements charged to this memcg.
@@ -111,7 +115,7 @@ struct mem_cgroup_per_node {
 	struct lruvec_stat __percpu *lruvec_stat_local;
 
 	/* Subtree VM stats (batched updates) */
-	struct lruvec_stat __percpu *lruvec_stat_cpu;
+	struct per_cpu_lruvec_stat __percpu *lruvec_stat_cpu;
 	atomic_long_t		lruvec_stat[NR_VM_NODE_STAT_ITEMS];
 
 	unsigned long		lru_zone_size[MAX_NR_ZONES][NR_LRU_LISTS];
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 49fbcf003bf5..c874ea37b05d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5184,7 +5184,7 @@ static int alloc_mem_cgroup_per_node_info(struct mem_cgroup *memcg, int node)
 		return 1;
 	}
 
-	pn->lruvec_stat_cpu = alloc_percpu_gfp(struct lruvec_stat,
+	pn->lruvec_stat_cpu = alloc_percpu_gfp(struct per_cpu_lruvec_stat,
 					       GFP_KERNEL_ACCOUNT);
 	if (!pn->lruvec_stat_cpu) {
 		free_percpu(pn->lruvec_stat_local);
-- 
2.11.0

