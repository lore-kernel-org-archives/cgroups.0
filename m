From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [RFC PATCH 1/8] memcg: refactor updating memcg->moving_account
Date: Thu, 20 Jul 2023 07:08:18 +0000
Message-ID: <20230720070825.992023-2-yosryahmed@google.com>
References: <20230720070825.992023-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689836910; x=1692428910;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=P4XNYMJYgxf4Y2ysW943aMZDD9DgQegnQSW9aAxie4w=;
        b=PyMiTiRslPlYxeAzNGyf+s2RMn2Y5D+io4F49/M2XRwJrS8TwV/LhLqLj0BM+kLdbs
         SJdh95igG91J+W+YW3QhUBoovRNlfDdy0rtENHO9Q0tdlMq6Mi6nZDp8wPmseQG3GEz7
         yTNtdLVRNpjOoL79dp3VDPbMRHNV99200JwxoCivq9oH22XjolvYivx1g2ceZNC2Pn7s
         Da/CFyreh5mYpyR/lWRRdvMG1hkWdPWRhELE3hNZjAEKxkN7vhsHgeLNCSqpeMvOeAHq
         lRZ2ErdDGOl8n4urJ5Mk+4WBu+P+b25Mk8sxetPQU+cK2DCaPQPxX5kv/nJSdD/CPPwf
         W7UA==
In-Reply-To: <20230720070825.992023-1-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Luis Chamberlain <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Iurii Zaikin <yzaikin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "T.J. Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

memcg->moving_account is used to signal that a memcg move is taking
place, so that folio_memcg_lock() would start acquiring the per-memcg
move lock instead of just initiating an rcu read section.

Refactor incrementing and decrementing memcg->moving_account, together
with rcu synchornization and the elaborate comment into helpers, to
allow for reuse by incoming patches.

Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 mm/memcontrol.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e8ca4bdcb03c..ffdb848f4003 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6305,16 +6305,26 @@ static const struct mm_walk_ops charge_walk_ops = {
 	.pmd_entry	= mem_cgroup_move_charge_pte_range,
 };
 
-static void mem_cgroup_move_charge(void)
+static void mem_cgroup_start_move_charge(struct mem_cgroup *memcg)
 {
-	lru_add_drain_all();
 	/*
 	 * Signal folio_memcg_lock() to take the memcg's move_lock
 	 * while we're moving its pages to another memcg. Then wait
 	 * for already started RCU-only updates to finish.
 	 */
-	atomic_inc(&mc.from->moving_account);
+	atomic_inc(&memcg->moving_account);
 	synchronize_rcu();
+}
+
+static void mem_cgroup_end_move_charge(struct mem_cgroup *memcg)
+{
+	atomic_dec(&memcg->moving_account);
+}
+
+static void mem_cgroup_move_charge(void)
+{
+	lru_add_drain_all();
+	mem_cgroup_start_move_charge(mc.from);
 retry:
 	if (unlikely(!mmap_read_trylock(mc.mm))) {
 		/*
@@ -6334,7 +6344,7 @@ static void mem_cgroup_move_charge(void)
 	 */
 	walk_page_range(mc.mm, 0, ULONG_MAX, &charge_walk_ops, NULL);
 	mmap_read_unlock(mc.mm);
-	atomic_dec(&mc.from->moving_account);
+	mem_cgroup_end_move_charge(mc.from);
 }
 
 static void mem_cgroup_move_task(void)
-- 
2.41.0.255.g8b1d071c50-goog

