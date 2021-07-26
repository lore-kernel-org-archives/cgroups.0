From: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: [PATCH v6 05/16] memcg: ipv6/sit: account and don't WARN on
 ip_tunnel_prl structs allocation
Date: Mon, 26 Jul 2021 22:00:31 +0300
Message-ID: <52f7bed9-a0a1-24ff-2305-ef3224fa4c67@virtuozzo.com>
References: <9bf9d9bd-03b1-2adb-17b4-5d59a86a9394@virtuozzo.com>
 <cover.1627321321.git.vvs@virtuozzo.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:Subject
        :From; bh=AZePevufwLfIw+HZXFzYrAu9HJFcrBqN7a5eGmS+F6o=; b=OCYnI1D+kIDAM3W3PkD
        UygoUhUyuAeVsJ+M3NO3XVRFyjGx+ilOH9LQeObbypVFBER+S7/iCrRqQXjbn1ITehS0p5L+cZhhn
        qp58uUnx8BMfOzhw6DfHe2XmQbjVbv09PzygHK/S93ZiJMv1TjcB0dus+NukMXTAr8X8iUjea48=;
In-Reply-To: <cover.1627321321.git.vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hideaki YOSHIFUJI <yoshfuji-VfPWfsRibaP+Ru+s062T9g@public.gmane.org>, David Ahern <dsahern-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Author: Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>

The size of the ip_tunnel_prl structs allocation is controllable from
user-space, thus it's better to avoid spam in dmesg if allocation failed.
Also add __GFP_ACCOUNT as this is a good candidate for per-memcg
accounting. Allocation is temporary and limited by 4GB.

Signed-off-by: Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Signed-off-by: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
---
 net/ipv6/sit.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index df5bea8..33adc12 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -321,7 +321,7 @@ static int ipip6_tunnel_get_prl(struct net_device *dev, struct ifreq *ifr)
 	 * we try harder to allocate.
 	 */
 	kp = (cmax <= 1 || capable(CAP_NET_ADMIN)) ?
-		kcalloc(cmax, sizeof(*kp), GFP_KERNEL | __GFP_NOWARN) :
+		kcalloc(cmax, sizeof(*kp), GFP_KERNEL_ACCOUNT | __GFP_NOWARN) :
 		NULL;
 
 	rcu_read_lock();
@@ -334,7 +334,8 @@ static int ipip6_tunnel_get_prl(struct net_device *dev, struct ifreq *ifr)
 		 * For root users, retry allocating enough memory for
 		 * the answer.
 		 */
-		kp = kcalloc(ca, sizeof(*kp), GFP_ATOMIC);
+		kp = kcalloc(ca, sizeof(*kp), GFP_ATOMIC | __GFP_ACCOUNT |
+					      __GFP_NOWARN);
 		if (!kp) {
 			ret = -ENOMEM;
 			goto out;
-- 
1.8.3.1

