From: Abel Wu <wuyun.abel-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: [PATCH RESEND net-next 2/2] net-memcg: Remove redundant tcpmem_pressure
Date: Tue, 11 Jul 2023 20:41:44 +0800
Message-ID: <20230711124157.97169-2-wuyun.abel@bytedance.com>
References: <20230711124157.97169-1-wuyun.abel@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1689079359; x=1691671359;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WF8p9HwwgSPuKR34SMZuqSQ7aAssq/odh5sAxqcKAUo=;
        b=PfObz486Wz+B8XCRMJmNpdOHd0bdAenCGoIFIrS0nn6pqgOGHIHHLLi/E7y4xelPQs
         oV1L5cDtGQ4gFHo4+itEHIwzUsNI9UXysv8UU/Pza3CLcUbZHUcxkt1As11YdvxnX8RF
         H17ZVvTu4nrEDSvdfN39NUxyIGNfeoTwnjdkSADFNYnqT8BI11t6wbWjHwH7o/9kadrH
         e5S5yw3IMsz3lksjyY+6iOF1Q4m7p0LVb07p4UTqbAdR2d9VI1K3CWAVsuHGT4SgzzBo
         xLZVs2ZfUmoYmSJPyCtnkjpSavzGDmGYFi8eCIFGc6qahboTah/quQSujY0SX5PCPa3e
         hfRg==
In-Reply-To: <20230711124157.97169-1-wuyun.abel-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, David Ahern <dsahern-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Abel Wu <wuyun.abel-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Kefeng Wang <wangkefeng.wang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Kuniyuki Iwashima <kuniyu-vV1OtcyAfmbQT0dZR+AlfA@public.gmane.org>, Martin KaFai Lau <martin.lau-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Alexander Mikhalitsyn <al>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:NETWORKING [GENERAL]" <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:CONTROL GROUP - MEMORY RESOURCE
        CONTROLLER MEMCG" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:CONTROL GROUP - MEMORY RESOURCE
        CONTROLLER MEMCG" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

As {socket,tcpmem}_pressure are only used in default/legacy mode
respectively, use socket_pressure instead of tcpmem_pressure in all
kinds of cgroup hierarchies.

Signed-off-by: Abel Wu <wuyun.abel-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
---
 include/linux/memcontrol.h | 3 +--
 mm/memcontrol.c            | 4 ++--
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 5860c7f316b9..341d397186ff 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -288,7 +288,6 @@ struct mem_cgroup {
 
 	/* Legacy tcp memory accounting */
 	bool			tcpmem_active;
-	int			tcpmem_pressure;
 
 #ifdef CONFIG_MEMCG_KMEM
 	int kmemcg_id;
@@ -1728,7 +1727,7 @@ void mem_cgroup_sk_free(struct sock *sk);
 static inline bool mem_cgroup_under_socket_pressure(struct mem_cgroup *memcg)
 {
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
-		return !!memcg->tcpmem_pressure;
+		return !!memcg->socket_pressure;
 	do {
 		if (time_before(jiffies, READ_ONCE(memcg->socket_pressure)))
 			return true;
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e8ca4bdcb03c..e9e26dbd65b5 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -7292,10 +7292,10 @@ bool mem_cgroup_charge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages,
 		struct page_counter *fail;
 
 		if (page_counter_try_charge(&memcg->tcpmem, nr_pages, &fail)) {
-			memcg->tcpmem_pressure = 0;
+			memcg->socket_pressure = 0;
 			return true;
 		}
-		memcg->tcpmem_pressure = 1;
+		memcg->socket_pressure = 1;
 		if (gfp_mask & __GFP_NOFAIL) {
 			page_counter_charge(&memcg->tcpmem, nr_pages);
 			return true;
-- 
2.37.3

