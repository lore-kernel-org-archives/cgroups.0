From: Qian Cai <cai@lca.pw>
Subject: [PATCH -next] mm/memcg: fix a -Wparentheses compilation warning
Date: Wed, 31 Jul 2019 09:45:53 -0400
Message-ID: <1564580753-17531-1-git-send-email-cai@lca.pw>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=8f2ucm94N3RAHWXp2XYv1ymSM73yXUEwnSMo5qDl8Gc=;
        b=FkJBduK7o2U9DkS56fiFYacXOe0s7mfPx9W0zVWXLGIoBYvxPS2C2Ogl6X1ZM5uZB4
         cNBAvSNVe+z5s06SyzfhFcV2RMEo+4pQRXPG6a+ptBnkhXvLwFhmgz0gt+BJW3wJbihR
         nQ+IC+gD8EKjLqqM8uUq0xBkQAcLq2ShOD+pLbe7omO5lVwVExK79k9jyXMHHP9ALfdG
         HN5osGJO/3roRO/n8DH2DeHGHAjojwdQ4gDaHzxo6r6GRyDbZlbArnEjESad9OoMyJV3
         prsq8zmDCb3fv9cBiBkmI//oNrGrN1yzBD8iF6WSFS37+kW8o3ZD2SB4jdrbHoccKKeQ
         LE/A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: akpm@linux-foundation.org
Cc: miles.chen@mediatek.com, mhocko@suse.com, hannes@cmpxchg.org, vdavydov.dev@gmail.com, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Qian Cai <cai@lca.pw>

The linux-next commit ("mm/memcontrol.c: fix use after free in
mem_cgroup_iter()") [1] introduced a compilation warning,

mm/memcontrol.c:1160:17: warning: using the result of an assignment as a
condition without parentheses [-Wparentheses]
        } while (memcg = parent_mem_cgroup(memcg));
                 ~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~
mm/memcontrol.c:1160:17: note: place parentheses around the assignment
to silence this warning
        } while (memcg = parent_mem_cgroup(memcg));
                       ^
                 (                               )
mm/memcontrol.c:1160:17: note: use '==' to turn this assignment into an
equality comparison
        } while (memcg = parent_mem_cgroup(memcg));
                       ^
                       ==

Fix it by adding a pair of parentheses.

[1] https://lore.kernel.org/linux-mm/20190730015729.4406-1-miles.chen@mediatek.com/

Signed-off-by: Qian Cai <cai@lca.pw>
---
 mm/memcontrol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 694b6f8776dc..4f66a8305ae0 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1157,7 +1157,7 @@ static void invalidate_reclaim_iterators(struct mem_cgroup *dead_memcg)
 	do {
 		__invalidate_reclaim_iterators(memcg, dead_memcg);
 		last = memcg;
-	} while (memcg = parent_mem_cgroup(memcg));
+	} while ((memcg = parent_mem_cgroup(memcg)));
 
 	/*
 	 * When cgruop1 non-hierarchy mode is used,
-- 
1.8.3.1

