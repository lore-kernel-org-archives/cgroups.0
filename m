From: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: [PATCH v2 1/8] memcg: accounting for fib6_nodes cache
Date: Mon, 15 Mar 2021 15:23:00 +0300
Message-ID: <85b5f428-294b-af57-f496-5be5fddeeeea@virtuozzo.com>
References: <YEnWUrYOArju66ym@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o/tFSq0j5W0x7QzUgqbepV02dkIN9FGfWCz1gtWrMQ4=;
 b=Cp73d2C/16nCAKExXC2PI0+JMvZlKd5QbAn7cLPimZEOB7NjebHI5OpZkOsDjW/eUESsiCYCaly5lNaGZZwnDKDu6caRn79OHa/SUu5U6X9vwCM+AgN195TDi54f6rfRjHNWH1zjodU9toEs8/Ajvbm/wR1eWn/xT0gY231DbFw=
In-Reply-To: <YEnWUrYOArju66ym-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Hideaki YOSHIFUJI <yoshfuji-VfPWfsRibaP+Ru+s062T9g@public.gmane.org>, David Ahern <dsahern-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

An untrusted netadmin inside a memcg-limited container can create a
huge number of routing entries. Currently, allocated kernel objects
are not accounted to proper memcg, so this can lead to global memory
shortage on the host and cause lot of OOM kiils.

One such object is the 'struct fib6_node' mostly allocated in
net/ipv6/route.c::__ip6_ins_rt() inside the lock_bh()/unlock_bh() section:

 write_lock_bh(&table->tb6_lock);
 err = fib6_add(&table->tb6_root, rt, info, mxc);
 write_unlock_bh(&table->tb6_lock);

It this case is not enough to simply add SLAB_ACCOUNT to corresponding
kmem cache. The proper memory cgroup still cannot be found due to the
incorrect 'in_interrupt()' check used in memcg_kmem_bypass().
To be sure that caller is not executed in process contxt
'!in_task()' check should be used instead
---
 mm/memcontrol.c    | 2 +-
 net/ipv6/ip6_fib.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 845eec0..568f2cb 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1076,7 +1076,7 @@ static __always_inline bool memcg_kmem_bypass(void)
 		return false;
 
 	/* Memcg to charge can't be determined. */
-	if (in_interrupt() || !current->mm || (current->flags & PF_KTHREAD))
+	if (!in_task() || !current->mm || (current->flags & PF_KTHREAD))
 		return true;
 
 	return false;
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

