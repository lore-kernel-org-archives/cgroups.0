From: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: [PATCH v5 01/16] memcg: enable accounting for net_device and Tx/Rx
 queues
Date: Mon, 19 Jul 2021 13:44:23 +0300
Message-ID: <a5f14f0c-f2db-5c62-b3dc-8bb152fddd40@virtuozzo.com>
References: <CALvZod66KF-8xKB1dyY2twizDE=svE8iXT_nqvsrfWg1a92f4A@mail.gmail.com>
 <cover.1626688654.git.vvs@virtuozzo.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:Subject
        :From; bh=8P40NsonrJJoThIMYsgSj+KWYiu8Ty9alqCjBkD7j5A=; b=f9Z1kwEDWNzPRNss7dE
        WgQStUzvvT0CjE8M212YgRmDz+3KjPu6OxrWl+TO2NDSb2GLiZodgGlwkLcuj+5U1NXAgmBalYm62
        UUzmwfFluTkElpcL5s0chxLSDibBq28ouLJC/Rtbo8BN+Uu3+IfpAaY+RfQ8wfxUf2nXr4t9FFA=;
In-Reply-To: <cover.1626688654.git.vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Container netadmin can create a lot of fake net devices,
then create a new net namespace and repeat it again and again.
Net device can request the creation of up to 4096 tx and rx queues,
and force kernel to allocate up to several tens of megabytes memory
per net device.

It makes sense to account for them to restrict the host's memory
consumption from inside the memcg-limited container.

Signed-off-by: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
---
 net/core/dev.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index c253c2a..e9aa1e4 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10100,7 +10100,7 @@ static int netif_alloc_rx_queues(struct net_device *dev)
 
 	BUG_ON(count < 1);
 
-	rx = kvzalloc(sz, GFP_KERNEL | __GFP_RETRY_MAYFAIL);
+	rx = kvzalloc(sz, GFP_KERNEL_ACCOUNT | __GFP_RETRY_MAYFAIL);
 	if (!rx)
 		return -ENOMEM;
 
@@ -10167,7 +10167,7 @@ static int netif_alloc_netdev_queues(struct net_device *dev)
 	if (count < 1 || count > 0xffff)
 		return -EINVAL;
 
-	tx = kvzalloc(sz, GFP_KERNEL | __GFP_RETRY_MAYFAIL);
+	tx = kvzalloc(sz, GFP_KERNEL_ACCOUNT | __GFP_RETRY_MAYFAIL);
 	if (!tx)
 		return -ENOMEM;
 
@@ -10807,7 +10807,7 @@ struct net_device *alloc_netdev_mqs(int sizeof_priv, const char *name,
 	/* ensure 32-byte alignment of whole construct */
 	alloc_size += NETDEV_ALIGN - 1;
 
-	p = kvzalloc(alloc_size, GFP_KERNEL | __GFP_RETRY_MAYFAIL);
+	p = kvzalloc(alloc_size, GFP_KERNEL_ACCOUNT | __GFP_RETRY_MAYFAIL);
 	if (!p)
 		return NULL;
 
-- 
1.8.3.1

