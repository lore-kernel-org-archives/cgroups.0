From: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: [PATCH v6 01/16] memcg: enable accounting for net_device and Tx/Rx
 queues
Date: Mon, 26 Jul 2021 21:59:59 +0300
Message-ID: <d6a9a9f6-0221-01ab-991b-baeeca2bae3d@virtuozzo.com>
References: <9bf9d9bd-03b1-2adb-17b4-5d59a86a9394@virtuozzo.com>
 <cover.1627321321.git.vvs@virtuozzo.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:Subject
        :From; bh=8P40NsonrJJoThIMYsgSj+KWYiu8Ty9alqCjBkD7j5A=; b=t/Wbc2X6e4hgS6K/esz
        rDRgLQP+44k4Ks3i8TtCrVRYU0P5ktfE/Yc9vT6+0wqF0ZgziueAylfctEJXEJvxTYDVK6qwyZWGr
        OMPEvv8HrnQmso/PYifm+LD7dFR5AaihJ3yStFxz04OgrrZhdYz3eTA1welGVASrj7qsH60MVsE=;
In-Reply-To: <cover.1627321321.git.vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
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

