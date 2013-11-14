From: David Rientjes <rientjes@google.com>
Subject: [patch 1/2] mm, memcg: avoid oom notification when current needs
 access to memory reserves
Date: Thu, 14 Nov 2013 15:26:51 -0800 (PST)
Message-ID: <alpine.DEB.2.02.1311141525440.30112@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1310301838300.13556@chino.kir.corp.google.com> <20131031054942.GA26301@cmpxchg.org> <alpine.DEB.2.02.1311131416460.23211@chino.kir.corp.google.com> <20131113233419.GJ707@cmpxchg.org> <alpine.DEB.2.02.1311131649110.6735@chino.kir.corp.google.com>
 <20131114032508.GL707@cmpxchg.org> <alpine.DEB.2.02.1311141447160.21413@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        bh=barpBMoxo0+wHxwibtoxNXLDmwa0GK/26C/V4aQKlis=;
        b=SS6Up2Chob58pxohr6ltnFfRq3248sd+PQRbdxmSaQH5FMQaLJTr9SONXxV+b7ddRu
         Hy1JmX+eUj38qI9Be+BZb9TduAfTfow7fY7zO3ZhBUYY9sBvIwZjyu6HpE6t1lJSpr7i
         FjI2Tuv/dm977AufoCeEWN6VHgkqHTLl0cPZDD4ti77+AbVQuZmEBIX9gwmyIUsAKusU
         3efsenzSxz/M9ESxuhe/ifrECJbez4zQxKc2dW5UR3Ot+r7UklBaTcspe34M+Y93h1ZP
         EyYV0bqkQq/uKhG0HOZ2OY58Rj1u7L7DGlESuI/BeWG6h5qvMV/iEOHLlnGOhyL76IGv
         efbw==
In-Reply-To: <alpine.DEB.2.02.1311141447160.21413@chino.kir.corp.google.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org

When current has a pending SIGKILL or is already in the exit path, it
only needs access to memory reserves to fully exit.  In that sense, the
memcg is not actually oom for current, it simply needs to bypass memory
charges to exit and free its memory, which is guarantee itself that
memory will be freed.

We only want to notify userspace for actionable oom conditions where
something needs to be done (and all oom handling can already be deferred
to userspace through this method by disabling the memcg oom killer with
memory.oom_control), not simply when a memcg has reached its limit, which
would actually have to happen before memcg reclaim actually frees memory
for charges.

Reported-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/memcontrol.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1783,16 +1783,6 @@ static void mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	unsigned int points = 0;
 	struct task_struct *chosen = NULL;
 
-	/*
-	 * If current has a pending SIGKILL or is exiting, then automatically
-	 * select it.  The goal is to allow it to allocate so that it may
-	 * quickly exit and free its memory.
-	 */
-	if (fatal_signal_pending(current) || current->flags & PF_EXITING) {
-		set_thread_flag(TIF_MEMDIE);
-		return;
-	}
-
 	check_panic_on_oom(CONSTRAINT_MEMCG, gfp_mask, order, NULL);
 	totalpages = mem_cgroup_get_limit(memcg) >> PAGE_SHIFT ? : 1;
 	for_each_mem_cgroup_tree(iter, memcg) {
@@ -2243,6 +2233,16 @@ bool mem_cgroup_oom_synchronize(bool handle)
 	if (!handle)
 		goto cleanup;
 
+	/*
+	 * If current has a pending SIGKILL or is exiting, then automatically
+	 * select it.  The goal is to allow it to allocate so that it may
+	 * quickly exit and free its memory.
+	 */
+	if (fatal_signal_pending(current) || current->flags & PF_EXITING) {
+		set_thread_flag(TIF_MEMDIE);
+		goto cleanup;
+	}
+
 	owait.memcg = memcg;
 	owait.wait.flags = 0;
 	owait.wait.func = memcg_oom_wake_function;

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
