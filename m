From: Yosry Ahmed <yosryahmed@google.com>
Subject: [RFC PATCH 7/7] memcg: do not modify rstat tree for zero updates
Date: Thu, 23 Mar 2023 04:00:37 +0000
Message-ID: <20230323040037.2389095-8-yosryahmed@google.com>
References: <20230323040037.2389095-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679544054;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=GbeROioJTSRzpGZIx65CHc5YHmhlz1VRWOdmKxovUco=;
        b=Hsck6MLI0adIPASRaTY3d/eUkBNtZFq5fHTozHNB8yOtl2ZkHkJQQ4GNrxQh4iSoWz
         JkY9CbdFxu+ujh+Pyx1oKlS53Vj0EANz1HJ/mNRwoFFcZsbYiHuLCMd4Lx5axIZ0gB5l
         yaad/tHsVvn1tHU57blkHy/+dS8g9HHclDAV/QT3pdal8fCNCqCcJD9lMmCv5J074fQc
         TEWaFK69tR0mz3hWUAlm/mUgTwQep/HE638zK7huhLNEr0Yv6vPjLeQWwk4UQCFbwI31
         KRefecpL1tiBaS/Y5Rnpmz8ntCNmT0BogLXtNGk9m7i1zmm8BH4noVNiIwwFJbgEqIWE
         ZH9g==
In-Reply-To: <20230323040037.2389095-1-yosryahmed@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Jens Axboe <axboe@kernel.dk>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>
Cc: Vasily Averin <vasily.averin@linux.dev>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org, Yosry Ahmed <yosryahmed@google.com>

In some situations, we may end up calling memcg_rstat_updated() with a
value of 0, which means the stat was not actually updated. An example is
if we fail to reclaim any pages in shrink_folio_list().

Do not add the cgroup to the rstat updated tree in this case, to avoid
unnecessarily flushing it.

Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
---
 mm/memcontrol.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 39a9c7a978ae..7afd29399409 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -618,6 +618,9 @@ static inline void memcg_rstat_updated(struct mem_cgroup *memcg, int val)
 {
 	unsigned int x;
 
+	if (!val)
+		return;
+
 	cgroup_rstat_updated(memcg->css.cgroup, smp_processor_id());
 
 	x = __this_cpu_add_return(stats_updates, abs(val));
-- 
2.40.0.rc1.284.g88254d51c5-goog

