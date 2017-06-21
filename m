From: Roman Gushchin <guro@fb.com>
Subject: [v3 5/6] mm, oom: don't mark all oom victims tasks with TIF_MEMDIE
Date: Wed, 21 Jun 2017 22:19:15 +0100
Message-ID: <1498079956-24467-6-git-send-email-guro@fb.com>
References: <1498079956-24467-1-git-send-email-guro@fb.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=2QyPOu5zqNb7JGFU1gu2eScx6IcBRyDoy2cz7HE/Kxg=;
 b=AL4JMF7GWqnj16Jd6UZfgxuKLv3tqPoNL4LoPGOH1EEWJ+/VgULmly5hRoedya5KZQJ+
 /YnFSj36xHJygm2OdO94JNHx0E2lW9MseWoumnxKMWYNJIEFhAkpHUEeQ49VIU190mja
 TEBQUYDtKmvINqoQob3cO99JtHMDseaskME= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=2QyPOu5zqNb7JGFU1gu2eScx6IcBRyDoy2cz7HE/Kxg=;
 b=CkO23oUVZLgl6f5xoGWcU/LaVRobnC7gzwLEXkpR77rWc9L7zMJcD3CYx5cj9CSM+xhzjj9tc5Z+W0bRcbWQnf69m87qKcQNpxOgR62o3NqX1B9pfRxkmgtxoyCKEpqVh5ozI0mSCC6pVWB6n9dU5BC8XPCueFe214L3eycvaXI=
In-Reply-To: <1498079956-24467-1-git-send-email-guro@fb.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm@kvack.org
Cc: Roman Gushchin <guro@fb.com>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

We want to limit the number of tasks which are having an access
to the memory reserves. To ensure the progress it's enough
to have one such process at the time.

If we need to kill the whole cgroup, let's give an access to the
memory reserves only to the first process in the list, which is
(usually) the biggest process.
This will give us good chances that all other processes will be able
to quit without an access to the memory reserves.

Otherwise, to keep going forward, let's grant the access to the memory
reserves for tasks, which can't be reaped by the oom_reaper.
As it will be done from the oom reaper thread, which handles the
oom reaper queue consequently, there is no high risk to have too many
such processes at the same time.

To implement this solution, we need to stop using TIF_MEMDIE flag
as an universal marker for oom victims tasks. It's not a big issue,
as we have oom_mm pointer/tsk_is_oom_victim(), which are just better.

Signed-off-by: Roman Gushchin <guro@fb.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: kernel-team@fb.com
Cc: cgroups@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
---
 kernel/exit.c |  2 +-
 mm/oom_kill.c | 31 ++++++++++++++++++++++---------
 2 files changed, 23 insertions(+), 10 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index d211425..5b95d74 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -554,7 +554,7 @@ static void exit_mm(void)
 	task_unlock(current);
 	mm_update_next_owner(mm);
 	mmput(mm);
-	if (test_thread_flag(TIF_MEMDIE))
+	if (tsk_is_oom_victim(current))
 		exit_oom_victim();
 }
 
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 489ab69..b55bd18 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -556,8 +556,18 @@ static void oom_reap_task(struct task_struct *tsk)
 	struct mm_struct *mm = tsk->signal->oom_mm;
 
 	/* Retry the down_read_trylock(mmap_sem) a few times */
-	while (attempts++ < MAX_OOM_REAP_RETRIES && !__oom_reap_task_mm(tsk, mm))
+	while (attempts++ < MAX_OOM_REAP_RETRIES &&
+	       !__oom_reap_task_mm(tsk, mm)) {
+
+		/*
+		 * If the task has no access to the memory reserves,
+		 * grant it to help the task to exit.
+		 */
+		if (!test_tsk_thread_flag(tsk, TIF_MEMDIE))
+			set_tsk_thread_flag(tsk, TIF_MEMDIE);
+
 		schedule_timeout_idle(HZ/10);
+	}
 
 	if (attempts <= MAX_OOM_REAP_RETRIES)
 		goto done;
@@ -647,16 +657,13 @@ static inline void wake_oom_reaper(struct task_struct *tsk)
  */
 static void mark_oom_victim(struct task_struct *tsk)
 {
-	struct mm_struct *mm = tsk->mm;
-
 	WARN_ON(oom_killer_disabled);
-	/* OOM killer might race with memcg OOM */
-	if (test_and_set_tsk_thread_flag(tsk, TIF_MEMDIE))
-		return;
 
 	/* oom_mm is bound to the signal struct life time. */
-	if (!cmpxchg(&tsk->signal->oom_mm, NULL, mm))
-		mmgrab(tsk->signal->oom_mm);
+	if (cmpxchg(&tsk->signal->oom_mm, NULL, tsk->mm) != NULL)
+		return;
+
+	mmgrab(tsk->signal->oom_mm);
 
 	/*
 	 * Make sure that the task is woken up from uninterruptible sleep
@@ -665,7 +672,13 @@ static void mark_oom_victim(struct task_struct *tsk)
 	 * that TIF_MEMDIE tasks should be ignored.
 	 */
 	__thaw_task(tsk);
-	atomic_inc(&oom_victims);
+
+	/*
+	 * If there are no oom victims in flight,
+	 * give the task an access to the memory reserves.
+	 */
+	if (atomic_inc_return(&oom_victims) == 1)
+		set_tsk_thread_flag(tsk, TIF_MEMDIE);
 }
 
 /**
-- 
2.7.4

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
