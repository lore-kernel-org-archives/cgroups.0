From: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: [PATCH v5 05/16] memcg: ipv6/sit: account and don't WARN on
 ip_tunnel_prl structs allocation
Date: Mon, 19 Jul 2021 13:44:50 +0300
Message-ID: <91fd6931-a12d-e2cc-a8db-9861f5545a51@virtuozzo.com>
References: <CALvZod66KF-8xKB1dyY2twizDE=svE8iXT_nqvsrfWg1a92f4A@mail.gmail.com>
 <cover.1626688654.git.vvs@virtuozzo.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:Subject
        :From; bh=AZePevufwLfIw+HZXFzYrAu9HJFcrBqN7a5eGmS+F6o=; b=n4/Mj7/lC/4qow33Krv
        2z1TPxXmwmJ88Vii7JkfW9gl5gpUXQ45ZNdLvmRAzzU+Jo0ICHF4F7wW2Suf0RkZpO2LobZNg1sEq
        T2BObePKwIse3bit2Ii1D8G5NidYaELhOtdnCdRii5kqUfNAzMcnxN/MbAcoNyZkdN3LTOGflMM=;
In-Reply-To: <cover.1626688654.git.vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
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

