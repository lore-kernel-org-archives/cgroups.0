From: Yue Zhao <findns94@gmail.com>
Subject: [PATCH v2, 2/4] mm, memcg: Prevent memory.swappiness load/store tearing
Date: Mon,  6 Mar 2023 23:41:36 +0800
Message-ID: <20230306154138.3775-3-findns94@gmail.com>
References: <20230306154138.3775-1-findns94@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678117333;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=0NtQyJ6eQBb0wGTDfYWZm4PPrLnDXxCUuuQDDh4+5sU=;
        b=p6QOaLsOhtyQJzkmQb72krbjZZTYJqL3+85RbgaTSEfMrdL/bMTMGHgczRpwUo3QWG
         7+j2vCkJDM9ruYYy+Nfu3XvmdOG8slzKlROb03WCQdG8DDGqhGgQqvRJOhNL8pFLrmmI
         +ev1QP60Jnuv1fKaWdyuD+HazZp1e/27BIpKObz53uW92JMY5YhWsqHKGt3WSE57mUEs
         ZQphWrShLIPoNvsh0QjWJrUKOdv6ocOuNswcj7aP8e+ueiH02tCrQaqF0bqLiihZWKWv
         DyqCYh0Me+WO8Ftqx1ReuWcYmdt/cO7hbA9z9IsmPYdp0El45dD6vMPePBkHn1+jhLNx
         pejg==
In-Reply-To: <20230306154138.3775-1-findns94@gmail.com>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: akpm@linux-foundation.org
Cc: roman.gushchin@linux.dev, hannes@cmpxchg.org, mhocko@kernel.org, shakeelb@google.com, muchun.song@linux.dev, willy@infradead.org, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, tangyeechou@gmail.com, Yue Zhao <findns94@gmail.com>

The knob for cgroup v1 memory controller: memory.swappiness
is not protected by any locking so it can be modified while it is used.
This is not an actual problem because races are unlikely.
But it is better to use READ_ONCE/WRITE_ONCE to prevent compiler from
doing anything funky.

The access of memcg->swappiness and vm_swappiness is lockless,
so both of them can be concurrently set at the same time
as we are trying to read them. 

Signed-off-by: Yue Zhao <findns94@gmail.com>
---
 include/linux/swap.h | 8 ++++----
 mm/memcontrol.c      | 4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 209a425739a9..3f3fe43d1766 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -620,18 +620,18 @@ static inline int mem_cgroup_swappiness(struct mem_cgroup *memcg)
 {
 	/* Cgroup2 doesn't have per-cgroup swappiness */
 	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
-		return vm_swappiness;
+		return READ_ONCE(vm_swappiness);
 
 	/* root ? */
 	if (mem_cgroup_disabled() || mem_cgroup_is_root(memcg))
-		return vm_swappiness;
+		return READ_ONCE(vm_swappiness);
 
-	return memcg->swappiness;
+	return READ_ONCE(memcg->swappiness);
 }
 #else
 static inline int mem_cgroup_swappiness(struct mem_cgroup *mem)
 {
-	return vm_swappiness;
+	return READ_ONCE(vm_swappiness);
 }
 #endif
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 06821e5f7604..dca895c66a9b 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4179,9 +4179,9 @@ static int mem_cgroup_swappiness_write(struct cgroup_subsys_state *css,
 		return -EINVAL;
 
 	if (!mem_cgroup_is_root(memcg))
-		memcg->swappiness = val;
+		WRITE_ONCE(memcg->swappiness, val);
 	else
-		vm_swappiness = val;
+		WRITE_ONCE(vm_swappiness, val);
 
 	return 0;
 }
-- 
2.17.1

