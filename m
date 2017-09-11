From: Roman Gushchin <guro@fb.com>
Subject: [v8 1/4] mm, oom: refactor the oom_kill_process() function
Date: Mon, 11 Sep 2017 14:17:39 +0100
Message-ID: <20170911131742.16482-2-guro@fb.com>
References: <20170911131742.16482-1-guro@fb.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=m+YF+52/WSTKHXQZFDAo+EiQnh0T+NSthUVjNsjpwA8=;
 b=jnRKcm2UDG9F2cXzHucx0QjN0PjZLgcVo7gM2/sJEwCPMuC3Js16BWxnOQFqNqCiZ0aY
 F1TXbHVOO/MvbiZdtQ1PEMRBZ1JXlvfsnHfhb+rlmgsbGhSOAub/jeT+1IwA/d3wt+FW
 L4HFNBdvl9r/xE/A6SNPA0rgTICzX/BkJeU= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=m+YF+52/WSTKHXQZFDAo+EiQnh0T+NSthUVjNsjpwA8=;
 b=ZuwRFh8JnruA1h0Oq7ngBnbjBjIOfz+/OCIS3W+EqnL+ISJGifqRYot8hCrZULkkwjmNT6mhWcvXujVUiVwZtXR/A2TK0cOHLfJBofOg6Iq4trDZ7YdxgxNv9U18nyceICceha4Qc6NYwwM4txiq1ELRBlbQ0D7Mx7qot1sDwF8=
In-Reply-To: <20170911131742.16482-1-guro@fb.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm@kvack.org
Cc: Roman Gushchin <guro@fb.com>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, David Rientjes <rientjes@google.com>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

The oom_kill_process() function consists of two logical parts:
the first one is responsible for considering task's children as
a potential victim and printing the debug information.
The second half is responsible for sending SIGKILL to all
tasks sharing the mm struct with the given victim.

This commit splits the oom_kill_process() function with
an intention to re-use the the second half: __oom_kill_process().

The cgroup-aware OOM killer will kill multiple tasks
belonging to the victim cgroup. We don't need to print
the debug information for the each task, as well as play
with task selection (considering task's children),
so we can't use the existing oom_kill_process().

Signed-off-by: Roman Gushchin <guro@fb.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: kernel-team@fb.com
Cc: cgroups@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
---
 mm/oom_kill.c | 123 +++++++++++++++++++++++++++++++---------------------------
 1 file changed, 65 insertions(+), 58 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 99736e026712..f061b627092c 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -804,68 +804,12 @@ static bool task_will_free_mem(struct task_struct *task)
 	return ret;
 }
 
-static void oom_kill_process(struct oom_control *oc, const char *message)
+static void __oom_kill_process(struct task_struct *victim)
 {
-	struct task_struct *p = oc->chosen;
-	unsigned int points = oc->chosen_points;
-	struct task_struct *victim = p;
-	struct task_struct *child;
-	struct task_struct *t;
+	struct task_struct *p;
 	struct mm_struct *mm;
-	unsigned int victim_points = 0;
-	static DEFINE_RATELIMIT_STATE(oom_rs, DEFAULT_RATELIMIT_INTERVAL,
-					      DEFAULT_RATELIMIT_BURST);
 	bool can_oom_reap = true;
 
-	/*
-	 * If the task is already exiting, don't alarm the sysadmin or kill
-	 * its children or threads, just give it access to memory reserves
-	 * so it can die quickly
-	 */
-	task_lock(p);
-	if (task_will_free_mem(p)) {
-		mark_oom_victim(p);
-		wake_oom_reaper(p);
-		task_unlock(p);
-		put_task_struct(p);
-		return;
-	}
-	task_unlock(p);
-
-	if (__ratelimit(&oom_rs))
-		dump_header(oc, p);
-
-	pr_err("%s: Kill process %d (%s) score %u or sacrifice child\n",
-		message, task_pid_nr(p), p->comm, points);
-
-	/*
-	 * If any of p's children has a different mm and is eligible for kill,
-	 * the one with the highest oom_badness() score is sacrificed for its
-	 * parent.  This attempts to lose the minimal amount of work done while
-	 * still freeing memory.
-	 */
-	read_lock(&tasklist_lock);
-	for_each_thread(p, t) {
-		list_for_each_entry(child, &t->children, sibling) {
-			unsigned int child_points;
-
-			if (process_shares_mm(child, p->mm))
-				continue;
-			/*
-			 * oom_badness() returns 0 if the thread is unkillable
-			 */
-			child_points = oom_badness(child,
-				oc->memcg, oc->nodemask, oc->totalpages);
-			if (child_points > victim_points) {
-				put_task_struct(victim);
-				victim = child;
-				victim_points = child_points;
-				get_task_struct(victim);
-			}
-		}
-	}
-	read_unlock(&tasklist_lock);
-
 	p = find_lock_task_mm(victim);
 	if (!p) {
 		put_task_struct(victim);
@@ -939,6 +883,69 @@ static void oom_kill_process(struct oom_control *oc, const char *message)
 }
 #undef K
 
+static void oom_kill_process(struct oom_control *oc, const char *message)
+{
+	struct task_struct *p = oc->chosen;
+	unsigned int points = oc->chosen_points;
+	struct task_struct *victim = p;
+	struct task_struct *child;
+	struct task_struct *t;
+	unsigned int victim_points = 0;
+	static DEFINE_RATELIMIT_STATE(oom_rs, DEFAULT_RATELIMIT_INTERVAL,
+					      DEFAULT_RATELIMIT_BURST);
+
+	/*
+	 * If the task is already exiting, don't alarm the sysadmin or kill
+	 * its children or threads, just give it access to memory reserves
+	 * so it can die quickly
+	 */
+	task_lock(p);
+	if (task_will_free_mem(p)) {
+		mark_oom_victim(p);
+		wake_oom_reaper(p);
+		task_unlock(p);
+		put_task_struct(p);
+		return;
+	}
+	task_unlock(p);
+
+	if (__ratelimit(&oom_rs))
+		dump_header(oc, p);
+
+	pr_err("%s: Kill process %d (%s) score %u or sacrifice child\n",
+		message, task_pid_nr(p), p->comm, points);
+
+	/*
+	 * If any of p's children has a different mm and is eligible for kill,
+	 * the one with the highest oom_badness() score is sacrificed for its
+	 * parent.  This attempts to lose the minimal amount of work done while
+	 * still freeing memory.
+	 */
+	read_lock(&tasklist_lock);
+	for_each_thread(p, t) {
+		list_for_each_entry(child, &t->children, sibling) {
+			unsigned int child_points;
+
+			if (process_shares_mm(child, p->mm))
+				continue;
+			/*
+			 * oom_badness() returns 0 if the thread is unkillable
+			 */
+			child_points = oom_badness(child,
+				oc->memcg, oc->nodemask, oc->totalpages);
+			if (child_points > victim_points) {
+				put_task_struct(victim);
+				victim = child;
+				victim_points = child_points;
+				get_task_struct(victim);
+			}
+		}
+	}
+	read_unlock(&tasklist_lock);
+
+	__oom_kill_process(victim);
+}
+
 /*
  * Determines whether the kernel must panic because of the panic_on_oom sysctl.
  */
-- 
2.13.5

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
