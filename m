From: Yosry Ahmed <yosryahmed@google.com>
Subject: [RFC PATCH 2/7] memcg: do not disable interrupts when holding stats_flush_lock
Date: Thu, 23 Mar 2023 04:00:32 +0000
Message-ID: <20230323040037.2389095-3-yosryahmed@google.com>
References: <20230323040037.2389095-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679544045;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0V6KepxSWjC0U8YUMhyf5sEsW80RflfKR4tDJnFyjUM=;
        b=nvFwhwj7qGyMPQaTPrzYFw+T0XNSe66OQzM5b4pjwLTwVBRy9Yg/AbwpYFnRMIM5gG
         L465fbRhjctsBw/iYduTrtP7LUUTB2pfnwQVaagEQM0GyAtfd40drA654+PpJ27hrtIB
         BUWcp/c32KQ98SFLCZ9FSHYNM6vaide1p2wRQYwdJvG/bU3/l2g1YAjLINeXoxbcrV2W
         3/G5Y/6fhAJDfUsgxXfVWzP78YqVFCMwh/+/7IKP9AVvA+7qfhsyQkLxneMASA+CreO0
         VfuwrktKMl3lyTDdGpOXeKO210ebUx1dz4XnfSvMg+6i1Ne/G/0TP1oqkrL/txGwmyNx
         VJtg==
In-Reply-To: <20230323040037.2389095-1-yosryahmed@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Jens Axboe <axboe@kernel.dk>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>
Cc: Vasily Averin <vasily.averin@linux.dev>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org, Yosry Ahmed <yosryahmed@google.com>

The rstat flushing code was modified so that we do not disable interrupts
when we hold the global rstat lock. Do the same for stats_flush_lock on
the memcg side to avoid unnecessarily disabling interrupts throughout
flushing.

Since the code exclusively uses trylock to acquire this lock, it should
be fine to hold from interrupt contexts or normal contexts without
disabling interrupts as a deadlock cannot occur. For interrupt contexts
we will return immediately without flushing anyway.

Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
---
 mm/memcontrol.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 5abffe6f8389..e0e92b38fa51 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -636,15 +636,17 @@ static inline void memcg_rstat_updated(struct mem_cgroup *memcg, int val)
 
 static void __mem_cgroup_flush_stats(void)
 {
-	unsigned long flag;
-
-	if (!spin_trylock_irqsave(&stats_flush_lock, flag))
+	/*
+	 * This lock can be acquired from interrupt context, but we only acquire
+	 * using trylock so it should be fine as we cannot cause a deadlock.
+	 */
+	if (!spin_trylock(&stats_flush_lock))
 		return;
 
 	flush_next_time = jiffies_64 + 2*FLUSH_TIME;
 	cgroup_rstat_flush_irqsafe(root_mem_cgroup->css.cgroup);
 	atomic_set(&stats_flush_threshold, 0);
-	spin_unlock_irqrestore(&stats_flush_lock, flag);
+	spin_unlock(&stats_flush_lock);
 }
 
 void mem_cgroup_flush_stats(void)
-- 
2.40.0.rc1.284.g88254d51c5-goog

