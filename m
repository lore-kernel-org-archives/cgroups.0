From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: [PATCH] mm: memcontrol: fix missing wakeup oom task
Date: Fri,  5 Feb 2021 14:23:10 +0800
Message-ID: <20210205062310.74268-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2db/qy51H5/26DTsBdgwD9VocgaNXW9d6RZG/+w8f64=;
        b=M9Wqk2ZmdVe3IJZ3S6Ys4n+UspDDeCho4IySNEw+is5gJAwcgNcFxMseJA/P0ZxD62
         /aVzgbgsHyP9p2D0xAhqk5eRkwfNDbKMfqTEvsFngzza3dcBztkkFGJ2dJVCkrNKyXoh
         W3io9fI4YwXwaLMtuLtl36RjRDtQB3IY0BCR8HbMFL4Cf7poD/qy1+zEYNQm085NPI6F
         aamQrZJBfb/zKeG4hRz9MLRuPnlYEUqhCzvBPVRKEx3RziWNhQdKHpCdzF9DMIT1LoHf
         eFrOpjOKxnktGBYKySKtY4gDq1FGXJ1VsgCa4QouP3dY97Uc4BaVjdAMITrwkcRwv8W3
         ZVUw==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

We call memcg_oom_recover() in the uncharge_batch() to wakeup OOM task
when page uncharged, but for the slab pages, we do not do this when page
uncharged. When we drain per cpu stock, we also should do this.

The memcg_oom_recover() is small, so make it inline. And the parameter
of memcg cannot be NULL, so remove the check.

Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
---
 mm/memcontrol.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 8c035846c7a4..8569f4dbea2a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1925,7 +1925,7 @@ static int memcg_oom_wake_function(wait_queue_entry_t *wait,
 	return autoremove_wake_function(wait, mode, sync, arg);
 }
 
-static void memcg_oom_recover(struct mem_cgroup *memcg)
+static inline void memcg_oom_recover(struct mem_cgroup *memcg)
 {
 	/*
 	 * For the following lockless ->under_oom test, the only required
@@ -1935,7 +1935,7 @@ static void memcg_oom_recover(struct mem_cgroup *memcg)
 	 * achieved by invoking mem_cgroup_mark_under_oom() before
 	 * triggering notification.
 	 */
-	if (memcg && memcg->under_oom)
+	if (memcg->under_oom)
 		__wake_up(&memcg_oom_waitq, TASK_NORMAL, 0, memcg);
 }
 
@@ -2313,6 +2313,7 @@ static void drain_stock(struct memcg_stock_pcp *stock)
 		page_counter_uncharge(&old->memory, stock->nr_pages);
 		if (do_memsw_account())
 			page_counter_uncharge(&old->memsw, stock->nr_pages);
+		memcg_oom_recover(old);
 		stock->nr_pages = 0;
 	}
 
-- 
2.11.0

