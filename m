From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: Re: WARNING in try_charge
Date: Thu, 9 Aug 2018 22:57:43 +0900
Message-ID: <e2869136-9f59-9ce8-8b9f-f75b157ee31d@I-love.SAKURA.ne.jp>
References: <0000000000005e979605729c1564@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <0000000000005e979605729c1564@google.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: mhocko@kernel.org, Vladimir Davydov <vdavydov@virtuozzo.com>, Oleg Nesterov <oleg@redhat.com>, David Rientjes <rientjes@google.com>
Cc: syzbot <syzbot+bab151e82a4e973fa325@syzkaller.appspotmail.com>, cgroups@vger.kernel.org, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, syzkaller-bugs@googlegroups.com, Andrew Morton <akpm@linux-foundation.org>

From b1f38168f14397c7af9c122cd8207663d96e02ec Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Thu, 9 Aug 2018 22:49:40 +0900
Subject: [PATCH] mm, oom: task_will_free_mem(current) should retry until
 memory reserve fails

Commit 696453e66630ad45 ("mm, oom: task_will_free_mem should skip
oom_reaped tasks") changed to select next OOM victim as soon as
MMF_OOM_SKIP is set. But we don't need to select next OOM victim as
long as ALLOC_OOM allocation can succeed. And syzbot is hitting WARN(1)
caused by this race window [1].

Since memcg OOM case uses forced charge if current thread is killed,
out_of_memory() can return true without selecting next OOM victim.
Therefore, this patch changes task_will_free_mem(current) to ignore
MMF_OOM_SKIP unless ALLOC_OOM allocation failed.

[1] https://syzkaller.appspot.com/bug?id=ea8c7912757d253537375e981b61749b2da69258

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Reported-by: syzbot <syzbot+bab151e82a4e973fa325@syzkaller.appspotmail.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: David Rientjes <rientjes@google.com>
---
 include/linux/oom.h | 3 +++
 mm/oom_kill.c       | 8 ++++----
 mm/page_alloc.c     | 7 +++++--
 3 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/include/linux/oom.h b/include/linux/oom.h
index 69864a5..b5abacd 100644
--- a/include/linux/oom.h
+++ b/include/linux/oom.h
@@ -38,6 +38,9 @@ struct oom_control {
 	 */
 	const int order;
 
+	/* Did we already try ALLOC_OOM allocation? i*/
+	const bool reserve_tried;
+
 	/* Used by oom implementation, do not set */
 	unsigned long totalpages;
 	struct task_struct *chosen;
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 0e10b86..95453e8 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -782,7 +782,7 @@ static inline bool __task_will_free_mem(struct task_struct *task)
  * Caller has to make sure that task->mm is stable (hold task_lock or
  * it operates on the current).
  */
-static bool task_will_free_mem(struct task_struct *task)
+static bool task_will_free_mem(struct task_struct *task, bool select_new)
 {
 	struct mm_struct *mm = task->mm;
 	struct task_struct *p;
@@ -803,7 +803,7 @@ static bool task_will_free_mem(struct task_struct *task)
 	 * This task has already been drained by the oom reaper so there are
 	 * only small chances it will free some more
 	 */
-	if (test_bit(MMF_OOM_SKIP, &mm->flags))
+	if (test_bit(MMF_OOM_SKIP, &mm->flags) && select_new)
 		return false;
 
 	if (atomic_read(&mm->mm_users) <= 1)
@@ -939,7 +939,7 @@ static void oom_kill_process(struct oom_control *oc, const char *message)
 	 * so it can die quickly
 	 */
 	task_lock(p);
-	if (task_will_free_mem(p)) {
+	if (task_will_free_mem(p, true)) {
 		mark_oom_victim(p);
 		wake_oom_reaper(p);
 		task_unlock(p);
@@ -1069,7 +1069,7 @@ bool out_of_memory(struct oom_control *oc)
 	 * select it.  The goal is to allow it to allocate so that it may
 	 * quickly exit and free its memory.
 	 */
-	if (task_will_free_mem(current)) {
+	if (task_will_free_mem(current, oc->reserve_tried)) {
 		mark_oom_victim(current);
 		wake_oom_reaper(current);
 		return true;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 879b861..03ca29a 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3455,7 +3455,7 @@ void warn_alloc(gfp_t gfp_mask, nodemask_t *nodemask, const char *fmt, ...)
 }
 
 static inline struct page *
-__alloc_pages_may_oom(gfp_t gfp_mask, unsigned int order,
+__alloc_pages_may_oom(gfp_t gfp_mask, unsigned int order, bool reserve_tried,
 	const struct alloc_context *ac, unsigned long *did_some_progress)
 {
 	struct oom_control oc = {
@@ -3464,6 +3464,7 @@ void warn_alloc(gfp_t gfp_mask, nodemask_t *nodemask, const char *fmt, ...)
 		.memcg = NULL,
 		.gfp_mask = gfp_mask,
 		.order = order,
+		.reserve_tried = reserve_tried,
 	};
 	struct page *page;
 
@@ -4239,7 +4240,9 @@ bool gfp_pfmemalloc_allowed(gfp_t gfp_mask)
 		goto retry_cpuset;
 
 	/* Reclaim has failed us, start killing things */
-	page = __alloc_pages_may_oom(gfp_mask, order, ac, &did_some_progress);
+	page = __alloc_pages_may_oom(gfp_mask, order, alloc_flags == ALLOC_OOM
+				     || (gfp_mask & __GFP_NOMEMALLOC), ac,
+				     &did_some_progress);
 	if (page)
 		goto got_pg;
 
-- 
1.8.3.1


