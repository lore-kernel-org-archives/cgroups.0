From: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: [PATCH 2/9] memcg: accounting for fib6_nodes cache
Date: Tue, 9 Mar 2021 11:03:56 +0300
Message-ID: <f105248d-bd21-8e6f-bdac-4f2c4792fc4b@virtuozzo.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kv57v9wwkEkRFk3quNioC72lkLY1VHt10WJve0iQRuY=;
 b=SUj6B/84e5vnSMKxM46a+k4e2HS1OaDa7AZBrUPRiMnFuiuDCwCKYkMXItyH5uYi9rK/NO6XGWrZTJDpabXJ2f57QRrA0erJzRTXDFHW5DeF+31LZordwKwnWysSxfA/KWd3ePSIGU9BHqtHU5s1IJ3W8vxTDAIvZ16R4g7amuw=
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Objects can be created from memcg-limited tasks
but its misuse may lead to host OOM.

Signed-off-by: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
---
 net/ipv6/ip6_fib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index ef9d022..fa92ed1 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -2445,7 +2445,7 @@ int __init fib6_init(void)
 
 	fib6_node_kmem = kmem_cache_create("fib6_nodes",
 					   sizeof(struct fib6_node),
-					   0, SLAB_HWCACHE_ALIGN,
+					   0, SLAB_HWCACHE_ALIGN|SLAB_ACCOUNT,
 					   NULL);
 	if (!fib6_node_kmem)
 		goto out;
-- 
1.8.3.1

