From: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: [PATCH v6 03/16] memcg: enable accounting for inet_bin_bucket cache
Date: Mon, 26 Jul 2021 22:00:17 +0300
Message-ID: <e8910e6f-1efe-b613-9456-ead37f955d61@virtuozzo.com>
References: <9bf9d9bd-03b1-2adb-17b4-5d59a86a9394@virtuozzo.com>
 <cover.1627321321.git.vvs@virtuozzo.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:Subject
        :From; bh=5useEdTraDabNukS5dPf+83pq0fTm+yVCCArjRQXtkc=; b=Sbnj8zxzpBhlwPQQuU3
        edyljQohLh5vMnf8nGH5g8S0DeHRK9y3Lc8+caKyDpbFRBGFWdmYwGVPnmagG8KYtMNsqmUi4nuAu
        ubm5oeKhkkBgj7Fh82YASnPGvPHC0DhA0NrcJnOp/U+IoOuTCwyZ+ahu71P9ASjLL/QEaUpblE0=;
In-Reply-To: <cover.1627321321.git.vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hideaki YOSHIFUJI <yoshfuji-VfPWfsRibaP+Ru+s062T9g@public.gmane.org>, David Ahern <dsahern-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

net namespace can create up to 64K tcp and dccp ports and force kernel
to allocate up to several megabytes of memory per netns
for inet_bind_bucket objects.

It makes sense to account for them to restrict the host's memory
consumption from inside the memcg-limited container.

Signed-off-by: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
---
 net/dccp/proto.c | 2 +-
 net/ipv4/tcp.c   | 4 +++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/dccp/proto.c b/net/dccp/proto.c
index 7eb0fb2..abb5c59 100644
--- a/net/dccp/proto.c
+++ b/net/dccp/proto.c
@@ -1126,7 +1126,7 @@ static int __init dccp_init(void)
 	dccp_hashinfo.bind_bucket_cachep =
 		kmem_cache_create("dccp_bind_bucket",
 				  sizeof(struct inet_bind_bucket), 0,
-				  SLAB_HWCACHE_ALIGN, NULL);
+				  SLAB_HWCACHE_ALIGN | SLAB_ACCOUNT, NULL);
 	if (!dccp_hashinfo.bind_bucket_cachep)
 		goto out_free_hashinfo2;
 
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index d5ab5f2..5c0605e 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4509,7 +4509,9 @@ void __init tcp_init(void)
 	tcp_hashinfo.bind_bucket_cachep =
 		kmem_cache_create("tcp_bind_bucket",
 				  sizeof(struct inet_bind_bucket), 0,
-				  SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL);
+				  SLAB_HWCACHE_ALIGN | SLAB_PANIC |
+				  SLAB_ACCOUNT,
+				  NULL);
 
 	/* Size and allocate the main established and bind bucket
 	 * hash tables.
-- 
1.8.3.1

