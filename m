From: Abel Wu <wuyun.abel@bytedance.com>
Subject: [PATCH net-next 2/2] net-memcg: Remove redundant tcpmem_pressure
Date: Sun, 25 Jun 2023 22:28:11 +0800
Message-ID: <20230625142820.47185-2-wuyun.abel@bytedance.com>
References: <20230625142820.47185-1-wuyun.abel@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1687703376; x=1690295376;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VJ3Ti/D8S3EnbGsOdGwNu9kTjaPf3p14ktWAeREbOBA=;
        b=R76JOrQ1dPo/73QodWvkhogr6Xt3xbQEkJkqTXvgiKUM710so38qio0hXQtzJsCbye
         O64gRUD8e4b7zMBLCa8BCFkjiCVBuoelt8Lz44yLSCENsHauLJ5VAqcybrk7HI43XjZJ
         xw1A0f0eaZzKR/Ar36Kqyfhr3MjK8BgRBvHCT8PoFVrsUtlG8ClolFEc1xl4ajF7FpQ4
         jG1bDDFxEkF4PmsG5MN5jtqcIgZemQAg42B1hTpu7CQnS5UpXJ+RqiyD5oKIhLIk3DKX
         7lQZBR+vpTUq2cMa25g5g10YhFZV5+0w3BEdk2HvIp0mOd/DI175m+zpOf8KM/i3awwh
         RfiQ==
In-Reply-To: <20230625142820.47185-1-wuyun.abel@bytedance.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, David Ahern <dsahern@kernel.org>, Yosry Ahmed <yosryahmed@google.com>, Yu Zhao <yuzhao@google.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Kuniyuki Iwashima <kuniyu@amazon.com>, Martin KaFai Lau <martin.lau@kernel.org>, Alexander Mikhalitsyn <alexander@mihalicyn.com>, Breno Leitao <leitao@debian.org>, David Howells <dhowells@redhat.com>, Jason Xing <kernelx>
Cc: Abel Wu <wuyun.abel@bytedance.com>, Michal Hocko <mhocko@suse.com>, open list <linux-kernel@vger.kernel.org>, "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>, "open list:CONTROL GROUP - MEMORY RESOURCE
        CONTROLLER MEMCG" <cgroups@vger.kernel.org>, "open list:CONTROL GROUP - MEMORY RESOURCE
        CONTROLLER MEMCG" <linux-mm@kvack.org>

As {socket,tcpmem}_pressure are only used in default/legacy mode
respectively, use socket_pressure instead of tcpmem_pressure in all
kinds of cgroup hierarchies.

Signed-off-by: Abel Wu <wuyun.abel@bytedance.com>
---
 include/linux/memcontrol.h | 3 +--
 mm/memcontrol.c            | 4 ++--
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 9b1b536b4ec9..05e9fb5fa08d 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -288,7 +288,6 @@ struct mem_cgroup {
 
 	/* Legacy tcp memory accounting */
 	bool			tcpmem_active;
-	int			tcpmem_pressure;
 
 #ifdef CONFIG_MEMCG_KMEM
 	int kmemcg_id;
@@ -1744,7 +1743,7 @@ void mem_cgroup_sk_free(struct sock *sk);
 static inline bool mem_cgroup_under_socket_pressure(struct mem_cgroup *memcg)
 {
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
-		return !!memcg->tcpmem_pressure;
+		return !!memcg->socket_pressure;
 	do {
 		if (time_before(jiffies, READ_ONCE(memcg->socket_pressure)))
 			return true;
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 4b27e245a055..76c4e5c6e558 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -7337,10 +7337,10 @@ bool mem_cgroup_charge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages,
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

