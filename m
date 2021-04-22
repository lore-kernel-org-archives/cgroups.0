From: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: [PATCH v3 05/16] memcg: ipv6/sit: account and don't WARN on
 ip_tunnel_prl structs allocation
Date: Thu, 22 Apr 2021 13:36:40 +0300
Message-ID: <2053653d-a975-59bf-0f16-7d4fddf923fa@virtuozzo.com>
References: <dddf6b29-debd-dcb5-62d0-74909d610edb@virtuozzo.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:Subject
        :From; bh=g4kPPij7yw/SNe+T6KcFKxDI8sjPhlS263iU2VL1Y74=; b=BZPkBqyT53/99DufxDE
        TYVeyViV37StggjdRlsUiG9OLi+M31kDNcoAjueC6/k4YUIWCGifONDyEs/WliCfKFoo+TwZYbenR
        sXTpSh4bAG0mUJHl5QXJmVP6tufbJOnDzm/g/jnRzYiYzqsnJbV4+1d0GqEX7O3XuvkaXPW7GN4=
In-Reply-To: <dddf6b29-debd-dcb5-62d0-74909d610edb-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hideaki YOSHIFUJI <yoshfuji-VfPWfsRibaP+Ru+s062T9g@public.gmane.org>, David Ahern <dsahern-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

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
index 9fdccf0..2ba147c 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -320,7 +320,7 @@ static int ipip6_tunnel_get_prl(struct net_device *dev, struct ifreq *ifr)
 	 * we try harder to allocate.
 	 */
 	kp = (cmax <= 1 || capable(CAP_NET_ADMIN)) ?
-		kcalloc(cmax, sizeof(*kp), GFP_KERNEL | __GFP_NOWARN) :
+		kcalloc(cmax, sizeof(*kp), GFP_KERNEL_ACCOUNT | __GFP_NOWARN) :
 		NULL;
 
 	rcu_read_lock();
@@ -333,7 +333,8 @@ static int ipip6_tunnel_get_prl(struct net_device *dev, struct ifreq *ifr)
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

