From: Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH] mm: memcontrol: skip propagate percpu vmstat values to current memcg
Date: Tue, 19 Jan 2021 13:27:44 +0800
Message-ID: <20210119052744.96765-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aEEMV7863xltVpOu5dQdeBuAa/L7iHBBzSh9lFg+Kn0=;
        b=mwxZeLnxMtuvQXXMcMBQsTFESo6aiXFL43N5Ft8TdGjcyIu/StwJ3A3lW8hC+9BQfm
         qvqCffOW80GeEY4cGwo2tkrrFTWeUL3471eOzgweQvi1pLYkHqYIw1ICBBoJ77i3jVBZ
         Y9imH6F6215IdJ6eJgOvOjf0v4joL8ol/PWEPUpDHU1EMw5m3P1mXe+gKRjv8jg31GJo
         gW2wp/txsbZbS9BHBsT4bTflX5ir+ZFxBI72wyDTaGq8ZJsyjM55zz2pmiDzcvOaYth2
         0mEjuA23VeUwUlK5j333DwpSRHDhln8Hqjo7pln6+GZxOsvZO+eMuBOG61a0N6FOygNj
         BqcQ==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, akpm@linux-foundation.org
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>

The current memcg will be freed soon, so updating it's vmstat and
vmevent values is pointless. Just skip updating it.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/memcontrol.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index c0a90767e264..597fbe9acf93 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3700,7 +3700,7 @@ static void memcg_flush_percpu_vmstats(struct mem_cgroup *memcg)
 		for (i = 0; i < MEMCG_NR_STAT; i++)
 			stat[i] += per_cpu(memcg->vmstats_percpu->stat[i], cpu);
 
-	for (mi = memcg; mi; mi = parent_mem_cgroup(mi))
+	for (mi = parent_mem_cgroup(memcg); mi; mi = parent_mem_cgroup(mi))
 		for (i = 0; i < MEMCG_NR_STAT; i++)
 			atomic_long_add(stat[i], &mi->vmstats[i]);
 
@@ -3716,7 +3716,8 @@ static void memcg_flush_percpu_vmstats(struct mem_cgroup *memcg)
 				stat[i] += per_cpu(
 					pn->lruvec_stat_cpu->count[i], cpu);
 
-		for (pi = pn; pi; pi = parent_nodeinfo(pi, node))
+		for (pi = parent_nodeinfo(pn, node); pi;
+		     pi = parent_nodeinfo(pi, node))
 			for (i = 0; i < NR_VM_NODE_STAT_ITEMS; i++)
 				atomic_long_add(stat[i], &pi->lruvec_stat[i]);
 	}
@@ -3736,7 +3737,7 @@ static void memcg_flush_percpu_vmevents(struct mem_cgroup *memcg)
 			events[i] += per_cpu(memcg->vmstats_percpu->events[i],
 					     cpu);
 
-	for (mi = memcg; mi; mi = parent_mem_cgroup(mi))
+	for (mi = parent_mem_cgroup(memcg); mi; mi = parent_mem_cgroup(mi))
 		for (i = 0; i < NR_VM_EVENT_ITEMS; i++)
 			atomic_long_add(events[i], &mi->vmevents[i]);
 }
-- 
2.11.0

