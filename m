From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.0 036/262] memcg: killed threads should not invoke memcg OOM killer
Date: Wed, 27 Mar 2019 13:58:11 -0400
Message-ID: <20190327180158.10245-36-sashal@kernel.org>
References: <20190327180158.10245-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553709783;
        bh=pPf0xG7tuJ/KeSsZbMSwoj8AVi5Un66nVo/A/1eQSFM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CaENcYPGYio1KqBnWQi9APPoYaZrdGohufPuawQZc6bmaKTC+HEtPqHFEQfeb6r89
         I88mB8kxI+OtVjI4yYiXc2533KwBuE+4qxIVzV9fwR0/I6x6XWKoHF2JNNgSYxV6nc
         QTMDL77c0VJaKPZprfS3hg6l7PPmpxyDUaGu3ku0=
In-Reply-To: <20190327180158.10245-1-sashal@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, David Rientjes <rientjes@google.com>, Kirill Tkhai <ktkhai@virtuozzo.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Sasha Levin <sashal@kernel.org>, cgroups@vger.kernel.org, linux-mm@kvack.org

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

[ Upstream commit 7775face207922ea62a4e96b9cd45abfdc7b9840 ]

If a memory cgroup contains a single process with many threads
(including different process group sharing the mm) then it is possible
to trigger a race when the oom killer complains that there are no oom
elible tasks and complain into the log which is both annoying and
confusing because there is no actual problem.  The race looks as
follows:

P1				oom_reaper		P2
try_charge						try_charge
  mem_cgroup_out_of_memory
    mutex_lock(oom_lock)
      out_of_memory
        oom_kill_process(P1,P2)
         wake_oom_reaper
    mutex_unlock(oom_lock)
    				oom_reap_task
							  mutex_lock(oom_lock)
							    select_bad_process # no victim

The problem is more visible with many threads.

Fix this by checking for fatal_signal_pending from
mem_cgroup_out_of_memory when the oom_lock is already held.

The oom bypass is safe because we do the same early in the try_charge
path already.  The situation migh have changed in the mean time.  It
should be safe to check for fatal_signal_pending and tsk_is_oom_victim
but for a better code readability abstract the current charge bypass
condition into should_force_charge and reuse it from that path.  "

Link: http://lkml.kernel.org/r/01370f70-e1f6-ebe4-b95e-0df21a0bc15e@i-love.sakura.ne.jp
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Kirill Tkhai <ktkhai@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/memcontrol.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index af7f18b32389..79a7d2a06bba 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -248,6 +248,12 @@ enum res_type {
 	     iter != NULL;				\
 	     iter = mem_cgroup_iter(NULL, iter, NULL))
 
+static inline bool should_force_charge(void)
+{
+	return tsk_is_oom_victim(current) || fatal_signal_pending(current) ||
+		(current->flags & PF_EXITING);
+}
+
 /* Some nice accessors for the vmpressure. */
 struct vmpressure *memcg_to_vmpressure(struct mem_cgroup *memcg)
 {
@@ -1389,8 +1395,13 @@ static bool mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	};
 	bool ret;
 
-	mutex_lock(&oom_lock);
-	ret = out_of_memory(&oc);
+	if (mutex_lock_killable(&oom_lock))
+		return true;
+	/*
+	 * A few threads which were not waiting at mutex_lock_killable() can
+	 * fail to bail out. Therefore, check again after holding oom_lock.
+	 */
+	ret = should_force_charge() || out_of_memory(&oc);
 	mutex_unlock(&oom_lock);
 	return ret;
 }
@@ -2209,9 +2220,7 @@ static int try_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	 * bypass the last charges so that they can exit quickly and
 	 * free their memory.
 	 */
-	if (unlikely(tsk_is_oom_victim(current) ||
-		     fatal_signal_pending(current) ||
-		     current->flags & PF_EXITING))
+	if (unlikely(should_force_charge()))
 		goto force;
 
 	/*
-- 
2.19.1

