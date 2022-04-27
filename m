From: YoungJun Park <her0gyugyu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] mm: memcontrol: annotation typo error
Date: Wed, 27 Apr 2022 16:17:49 +0900
Message-ID: <20220427071749.81345-1-her0gyugyu@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=N+lrgi/0M85P7HYpF70zDPeGfYctINM3Nu7Hv1hhv8w=;
        b=Dmaz/5beHXaZ3SilA9s4PheTqGgczMacCq8WYyNnDyP4coR1sNWgxE5ghs8qnXO4Fe
         zqMrMzv7qEkR/m43GTpWOlqm+QIBEKZ1mFICjeZU8pSBiLqOEJWe3oSB3mNX0uctIjvq
         nQshYi+wBF14j+34XaWhAmX6SGaesnjFg5gcW5Ry4YrGs/1m/6xPOUf1JbLX2aZAVK0z
         McamG8f/t+iyOc6Zq6a65u6bnhkF/QDY06A8p0iFWvo1s3SmoXBdoecYZJ9fSgEv7fxr
         mFFW+XIjBd8up7NiluKBWpcHetcSxbNwqVghqY1NGNi/y36lsqZLaCqK64e66KpSW+HQ
         eHhA==
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, YoungJun Park <her0gyugyu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

fix annotation typo error

Signed-off-by: YoungJun Park <her0gyugyu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 mm/memcontrol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 598fece89e2b..7a2dba1ae042 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1140,7 +1140,7 @@ static void invalidate_reclaim_iterators(struct mem_cgroup *dead_memcg)
 	} while ((memcg = parent_mem_cgroup(memcg)));
 
 	/*
-	 * When cgruop1 non-hierarchy mode is used,
+	 * When cgroup1 non-hierarchy mode is used,
 	 * parent_mem_cgroup() does not walk all the way up to the
 	 * cgroup root (root_mem_cgroup). So we have to handle
 	 * dead_memcg from cgroup root separately.
-- 
2.17.1

