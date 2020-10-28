From: Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v2] mm: memcg/slab: Fix return child memcg objcg for root memcg
Date: Wed, 28 Oct 2020 11:50:10 +0800
Message-ID: <20201028035013.99711-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gP9leRSqd8Nt5uw/ZcHLxalg6StnlmANhYwqDz5BamY=;
        b=GnFZV28/BNLRDucvzLESFv3OK7W6Iffx80nxt4gJX1KhQieE7APUfRH855/sp8RpMp
         cgkPejLvI+G6njV9mAmeo8VpZR4SfRadMjAssX2yRNc0iM3vyKnAhArixSQD58RO3L72
         Z0dOyUvEwxRX46FND2HUmFnhDDWdGNDCh5D+vNMyuk0wOXQ0ey1QMESV6UzxiDxR0yMU
         I/NSyZH3V7OUkd/ZNH6L5ToixcPb8J95qJPY7X1JOPEGvzroGJRZk1n/vBLocJO8sU4I
         fcnSEqdRLC/8x96lYmo1J1CBnTvGU14rV/VVdMwwMHdnccSu1XPj2SlK3p3yIP7wc1RY
         4KLQ==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, akpm@linux-foundation.org, shakeelb@google.com, guro@fb.com, iamjoonsoo.kim@lge.com, laoar.shao@gmail.com, chris@chrisdown.name, christian.brauner@ubuntu.com, peterz@infradead.org, mingo@kernel.org, keescook@chromium.org, tglx@linutronix.de, esyr@redhat.com, surenb@google.com, areber@redhat.com, elver@google.com
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, Muchun Song <songmuchun@bytedance.com>

Consider the following memcg hierarchy.

                    root
                   /    \
                  A      B

If we get the objcg of memcg A failed, the get_obj_cgroup_from_current
can return the wrong objcg for the root memcg.

Fixes: bf4f059954dc ("mm: memcg/slab: obj_cgroup API")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 changelog in v2:
 1. Do not use a comparison with the root_mem_cgroup

 mm/memcontrol.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1337775b04f3..8c8b4c3ed5a0 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2961,6 +2961,7 @@ __always_inline struct obj_cgroup *get_obj_cgroup_from_current(void)
 		objcg = rcu_dereference(memcg->objcg);
 		if (objcg && obj_cgroup_tryget(objcg))
 			break;
+		objcg = NULL;
 	}
 	rcu_read_unlock();
 
-- 
2.20.1

