From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/2] memcg: unify memcg stat flushing
Date: Wed, 29 Sep 2021 21:47:11 -0700
Message-ID: <20210930044711.2892660-2-shakeelb@google.com>
References: <20210930044711.2892660-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=3wCSVYwLyxFTgw/NEPcqwwI1Bpk2vqRKGXaqYC4gfms=;
        b=DtSDabIIC+wI82CTcYe7egJAGdF/UFE2BKRj3Yae1ZQd2V54f2o78Q4UrdWf6YKqcr
         0wFzisOz2LGitNBfKkvecCzJqQWOrcIwALJwdVcDjpLyGBqXFuE0neUoeoIzr6FbF6Hc
         o/GZeEV5sqXh12jPc516sCjkzUNl/KaC1jmlcnsR9DUHvLoRX28wrFdu2nAtyXi95Hvj
         JXk4dtsivlft9MddRs1ZmyQrGJBxpzcG4/4iyfcnmAPPSQJWjr2je++2ppdKs91qx7mk
         9KqgdC5GaMuCyA5Bb8eMtD1wBT82M0MOUL3kW3ohFKxivrEagmT9gRJhVace95S4FYHx
         tzcw==
In-Reply-To: <20210930044711.2892660-1-shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

The memcg stats can be flushed in multiple context and potentially in
parallel too. For example multiple parallel user space readers for memcg
stats will contend on the rstat locks with each other. There is no need
for that. We just need one flusher and everyone else can benefit. In
addition after aa48e47e3906 ("memcg: infrastructure to flush memcg
stats") the kernel periodically flush the memcg stats from the root, so,
the other flushers will potentially have much less work to do.

Signed-off-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 mm/memcontrol.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 933dde29c67b..688c891448dd 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1425,7 +1425,7 @@ static char *memory_stat_format(struct mem_cgroup *memcg)
 	 *
 	 * Current memory state:
 	 */
-	cgroup_rstat_flush(memcg->css.cgroup);
+	mem_cgroup_flush_stats();
 
 	for (i = 0; i < ARRAY_SIZE(memory_stats); i++) {
 		u64 size;
@@ -3529,8 +3529,7 @@ static unsigned long mem_cgroup_usage(struct mem_cgroup *memcg, bool swap)
 	unsigned long val;
 
 	if (mem_cgroup_is_root(memcg)) {
-		/* mem_cgroup_threshold() calls here from irqsafe context */
-		cgroup_rstat_flush_irqsafe(memcg->css.cgroup);
+		mem_cgroup_flush_stats();
 		val = memcg_page_state(memcg, NR_FILE_PAGES) +
 			memcg_page_state(memcg, NR_ANON_MAPPED);
 		if (swap)
@@ -3911,7 +3910,7 @@ static int memcg_numa_stat_show(struct seq_file *m, void *v)
 	int nid;
 	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
 
-	cgroup_rstat_flush(memcg->css.cgroup);
+	mem_cgroup_flush_stats();
 
 	for (stat = stats; stat < stats + ARRAY_SIZE(stats); stat++) {
 		seq_printf(m, "%s=%lu", stat->name,
@@ -3983,7 +3982,7 @@ static int memcg_stat_show(struct seq_file *m, void *v)
 
 	BUILD_BUG_ON(ARRAY_SIZE(memcg1_stat_names) != ARRAY_SIZE(memcg1_stats));
 
-	cgroup_rstat_flush(memcg->css.cgroup);
+	mem_cgroup_flush_stats();
 
 	for (i = 0; i < ARRAY_SIZE(memcg1_stats); i++) {
 		unsigned long nr;
@@ -4486,7 +4485,7 @@ void mem_cgroup_wb_stats(struct bdi_writeback *wb, unsigned long *pfilepages,
 	struct mem_cgroup *memcg = mem_cgroup_from_css(wb->memcg_css);
 	struct mem_cgroup *parent;
 
-	cgroup_rstat_flush_irqsafe(memcg->css.cgroup);
+	mem_cgroup_flush_stats();
 
 	*pdirty = memcg_page_state(memcg, NR_FILE_DIRTY);
 	*pwriteback = memcg_page_state(memcg, NR_WRITEBACK);
@@ -5354,12 +5353,14 @@ static void mem_cgroup_css_reset(struct cgroup_subsys_state *css)
 
 static void __mem_cgroup_flush_stats(void)
 {
-	if (!spin_trylock(&stats_flush_lock))
+	unsigned long flag;
+
+	if (!spin_trylock_irqsave(&stats_flush_lock, flag))
 		return;
 
 	cgroup_rstat_flush_irqsafe(root_mem_cgroup->css.cgroup);
 	atomic_set(&stats_flush_threshold, 0);
-	spin_unlock(&stats_flush_lock);
+	spin_unlock_irqrestore(&stats_flush_lock, flag);
 }
 
 void mem_cgroup_flush_stats(void)
@@ -6391,7 +6392,7 @@ static int memory_numa_stat_show(struct seq_file *m, void *v)
 	int i;
 	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
 
-	cgroup_rstat_flush(memcg->css.cgroup);
+	mem_cgroup_flush_stats();
 
 	for (i = 0; i < ARRAY_SIZE(memory_stats); i++) {
 		int nid;
-- 
2.33.0.685.g46640cef36-goog

