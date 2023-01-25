From: Leonardo Bras <leobras-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 1/5] mm/memcontrol: Align percpu memcg_stock to cache
Date: Wed, 25 Jan 2023 04:34:58 -0300
Message-ID: <20230125073502.743446-2-leobras@redhat.com>
References: <20230125073502.743446-1-leobras@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674632152;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KVG76aWPU3FY34u+v28shR/7Qg472WeM1BX+arjDbFU=;
        b=PFCf9y1aILug4RuXuZ5VVuMIlfN+xTWii3VtkSter+AZ+IHrFtNKfLED+yybJr95iAOI+n
        GrMhDxUrRoVZrqgcv6kRf4+yLSNAuNniz2DLvBNJK5PUmo0ujYb0RsYMu2s35Qglrzitxu
        f2TRjQhFlfP6AoDIqpOz1lehtmC8YKo=
In-Reply-To: <20230125073502.743446-1-leobras-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Leonardo Bras <leobras-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

When a struct smaller than a cacheline has an instance that is not aligned
to cache block size, it could happen that data can be spread across two
cachelines.

For memcg_stock this could mean the need to fetch and get cache-exclusivity
in 2 cachelines instead of 1 when we bounce the cacheline between local
cpu functions and drain_all_stock(), which does remote read/write.

This could also mean some false-sharing costs being paid due to the
cacheline being shared between 2 unrelated structures.

Avoid this issue by getting memcg_stock cacheline-aligned.

Signed-off-by: Leonardo Bras <leobras-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 mm/memcontrol.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ab457f0394ab6..f8e86b88b3c7a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2188,7 +2188,8 @@ struct memcg_stock_pcp {
 	unsigned long flags;
 #define FLUSHING_CACHED_CHARGE	0
 };
-static DEFINE_PER_CPU(struct memcg_stock_pcp, memcg_stock) = {
+
+static DEFINE_PER_CPU_SHARED_ALIGNED(struct memcg_stock_pcp, memcg_stock) = {
 	.stock_lock = INIT_LOCAL_LOCK(stock_lock),
 };
 static DEFINE_MUTEX(percpu_charge_mutex);
-- 
2.39.1

