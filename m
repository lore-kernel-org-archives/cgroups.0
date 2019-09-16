From: Qian Cai <cai@lca.pw>
Subject: [PATCH] mm/memcontrol: fix a -Wunused-function warning
Date: Mon, 16 Sep 2019 11:40:53 -0400
Message-ID: <1568648453-5482-1-git-send-email-cai@lca.pw>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=2u752yS3oLnDaYH6yTgBbPOp6ynQQ7UEDYNUBRkEYzU=;
        b=oSAgnCbhD4qDdHEm2xKg8gd+frd0gplSiPL7p871e/IbQ3Xl+AoJriMi48+WtFfMiH
         Er7h6Ina/mwJDFGre4pqWP4axz9nWEaIsC0Mhg4jWWlTxJLjxt2PTXBMZIrdR7ueylMQ
         JjnBypKA663HUGsAUZdZa+CJSiDEk7HeQOtW8iN1K2wpYE6VphkL0B7aNMOaXbqeI4fq
         g7hWJaYnXgwqAaotMNT3gfqh6eze7k6/zlkaN/LbASqJE+8AKlLGIYlLCCa69g0youHX
         5nbYx0F2ArTT0i4inpzgu4YzObm7Q/JOwgvXXPrTcIMrcswjP8l3AOMi6LPSITs/lgVR
         ZhFw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: akpm@linux-foundation.org
Cc: hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Qian Cai <cai@lca.pw>

mem_cgroup_id_get() was introduced in the commit 73f576c04b94
("mm:memcontrol: fix cgroup creation failure after many small jobs").

Later, it no longer has any user since the commits,

1f47b61fb407 ("mm: memcontrol: fix swap counter leak on swapout from offline cgroup")
58fa2a5512d9 ("mm: memcontrol: add sanity checks for memcg->id.ref on get/put")

so safe to remove it.

Signed-off-by: Qian Cai <cai@lca.pw>
---
 mm/memcontrol.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 9ec5e12486a7..9a375b376157 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4675,11 +4675,6 @@ static void mem_cgroup_id_put_many(struct mem_cgroup *memcg, unsigned int n)
 	}
 }
 
-static inline void mem_cgroup_id_get(struct mem_cgroup *memcg)
-{
-	mem_cgroup_id_get_many(memcg, 1);
-}
-
 static inline void mem_cgroup_id_put(struct mem_cgroup *memcg)
 {
 	mem_cgroup_id_put_many(memcg, 1);
-- 
1.8.3.1

