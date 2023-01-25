From: Leonardo Bras <leobras-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 5/5] mm/memcontrol: Remove flags from memcg_stock_pcp
Date: Wed, 25 Jan 2023 04:35:02 -0300
Message-ID: <20230125073502.743446-6-leobras@redhat.com>
References: <20230125073502.743446-1-leobras@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674632171;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NWp8AY96vdXmiMbopROrFgs2cU/VADiUd7iIJJXBCxY=;
        b=el/47FiS49Sk8mreZ2OWz2iX8VjGh8taqZbHwZv74qFL3bVKOKHuGUe1yFvUTuI0sjc6m5
        llrVLhXki9/43TklZkbLmHtvBtMoQwdOMp6NRXwtztEQzAPcDlrBLP9En/LYAUcaV9QHtN
        FG92PPC+IlBX9V4mlINT0wPRgM/jh1U=
In-Reply-To: <20230125073502.743446-1-leobras-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Leonardo Bras <leobras-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

The flags member of struct memcg_stock_pcp has only one used bit:
FLUSHING_CACHED_CHARGE

Both struct member and flag were created to avoid scheduling multiple
instances of kworkers running drain_local_stock() for a single cpu.

How could this scenario happen before:
- drain_all_stock() gets called, get ownership of percpu_charge_mutex,
  schedules a drain_local_stock() on cpu X, and drops ownership of
  percpu_charge_mutex.
- Another thread calls drain_all_stock(), get ownership of
  percpu_charge_mutex, schedules a drain_local_stock() on cpu X, ...

Since the stock draining is now performed by the thread running
drain_all_stock(), and happens before letting go of the
percpu_charge_mutex, there is no chance of another drain happening
between test_and_set_bit() and clear_bit(), so flags is now useless.

Remove the flags member of memcg_stock_pcp, its usages and the
FLUSHING_CACHED_CHARGE define.

Signed-off-by: Leonardo Bras <leobras-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 mm/memcontrol.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 5b7f7c2e0232f..60712f69595e4 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2183,9 +2183,6 @@ struct memcg_stock_pcp {
 	int nr_slab_reclaimable_b;
 	int nr_slab_unreclaimable_b;
 #endif
-
-	unsigned long flags;
-#define FLUSHING_CACHED_CHARGE	0
 };
 
 static DEFINE_PER_CPU_SHARED_ALIGNED(struct memcg_stock_pcp, memcg_stock) = {
@@ -2281,7 +2278,6 @@ static void drain_stock_from(struct memcg_stock_pcp *stock)
 
 	old = drain_obj_stock(stock);
 	drain_stock(stock);
-	clear_bit(FLUSHING_CACHED_CHARGE, &stock->flags);
 
 	spin_unlock_irqrestore(&stock->stock_lock, flags);
 	if (old)
@@ -2351,8 +2347,7 @@ static void drain_all_stock(struct mem_cgroup *root_memcg)
 			flush = true;
 		rcu_read_unlock();
 
-		if (flush &&
-		    !test_and_set_bit(FLUSHING_CACHED_CHARGE, &stock->flags))
+		if (flush)
 			drain_stock_from(stock);
 	}
 	migrate_enable();
-- 
2.39.1

