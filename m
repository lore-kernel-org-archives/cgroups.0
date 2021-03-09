From: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: [PATCH 5/9] memcg: accounting for ip_fib caches
Date: Tue, 9 Mar 2021 11:04:22 +0300
Message-ID: <6f182357-0a06-7f27-8684-22198725ac5d@virtuozzo.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jOmah3Ttr9Ux8KuZu/qKnk0qr3VbDotJHjS20FoIgVc=;
 b=RQSuWtKu7YNKRzV4JUL3gFPUTNYuL+FCxfgShJ08jNC3cze6gXt9sznoQnve4759qYUFlj8UQ+ce5Q2Eksio7FGqzP0fK2SYc6u6BnJkiFzETOxTb1zNq4w0dsaARVD1KayMbFK/SIj275w+QxOObiQiysFbxzWTaG12JXcrNM8=
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Objects can be created from memcg-limited tasks
but its misuse may lead to host OOM.

Signed-off-by: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
---
 net/ipv4/fib_trie.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index 25cf387..8060524 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -2380,11 +2380,11 @@ void __init fib_trie_init(void)
 {
 	fn_alias_kmem = kmem_cache_create("ip_fib_alias",
 					  sizeof(struct fib_alias),
-					  0, SLAB_PANIC, NULL);
+					  0, SLAB_PANIC | SLAB_ACCOUNT, NULL);
 
 	trie_leaf_kmem = kmem_cache_create("ip_fib_trie",
 					   LEAF_SIZE,
-					   0, SLAB_PANIC, NULL);
+					   0, SLAB_PANIC | SLAB_ACCOUNT, NULL);
 }
 
 struct fib_table *fib_trie_table(u32 id, struct fib_table *alias)
-- 
1.8.3.1

