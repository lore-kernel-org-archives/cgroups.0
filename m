From: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: [PATCH 3/9] memcg: accounting for ip6_dst_cache
Date: Tue, 9 Mar 2021 11:04:04 +0300
Message-ID: <6a9a651a-b609-01fb-56c4-01e134c9d534@virtuozzo.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hJ2iE90uFKsfL0YSrlpqtiN1MHH88JEy6xn+wb4EZUw=;
 b=B4dDQJ6GD48Ju+gX+6I19PxEniXVL0kBNwZLBRj9NBBxtcxXCQu+3fWVyt2e6JvCHy+PJlsPhrnPw+bEOnVj3ofn5SFCSyMUowyzGuisPIOW2zxMDBNz6UBsSoGJO8oBOambjr2mLuvSYXS6knvEb/neyFXtsPzQDaYyWEp2fQs=
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Objects can be created from memcg-limited tasks
but its misuse may lead to host OOM.

Signed-off-by: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
---
 net/ipv6/route.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 1536f49..d1d7cdf 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -6526,7 +6526,7 @@ int __init ip6_route_init(void)
 	ret = -ENOMEM;
 	ip6_dst_ops_template.kmem_cachep =
 		kmem_cache_create("ip6_dst_cache", sizeof(struct rt6_info), 0,
-				  SLAB_HWCACHE_ALIGN, NULL);
+				  SLAB_HWCACHE_ALIGN | SLAB_ACCOUNT, NULL);
 	if (!ip6_dst_ops_template.kmem_cachep)
 		goto out;
 
-- 
1.8.3.1

