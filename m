From: Roman Gushchin <guro@fb.com>
Subject: [RFC PATCH v2 1/7] mm, oom: refactor select_bad_process() to take memcg as an argument
Date: Thu, 1 Jun 2017 19:35:09 +0100
Message-ID: <1496342115-3974-2-git-send-email-guro@fb.com>
References: <1496342115-3974-1-git-send-email-guro@fb.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=mzmOgyE1gaBG12NBGLKrt/TqBYptCqZlvLjWFEfByzM=;
 b=b5D0fUvDpvhPJZBjAKt93eX7w2JtZD1N28tAs8Q1BFvoiqDLhKrLvB2h3KAGUjsOrAXJ
 WDtB/fy1jr971dVLPuE8Kn25MBrPqeCzlhoeONnWsMB+HhUigQPpOSTtAjBvaRijxE6E
 PsCmG5shKrBwIpTBAsqMulH2eA24LpHKcVw= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=mzmOgyE1gaBG12NBGLKrt/TqBYptCqZlvLjWFEfByzM=;
 b=UXb5J+oSkmAmSSaK4UCB65rSFHK9bTD8s4PlPzlJlmGCc/AD+z52dOME5nj8t0GmX5P4+WIankZUvQOuxMmxQP2J8DrNQsifZakSfRkb8e8ypood+55qvhTnBbSn1UXwp0FBljHH/Cep6TS//ryzRkeAJBRqGU6SJFkO8ggUFuo=
In-Reply-To: <1496342115-3974-1-git-send-email-guro@fb.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm@kvack.org
Cc: Roman Gushchin <guro@fb.com>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Li Zefan <lizefan@huawei.com>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

The select_bad_process() function will be used further
to select a process to kill in the victim cgroup.
This cgroup doesn't necessary match oc->memcg,
which is a cgroup, which limits were caused cgroup-wide OOM
(or NULL in case of global OOM).

So, refactor select_bad_process() to take a pointer to
a cgroup to iterate over as an argument.

Signed-off-by: Roman Gushchin <guro@fb.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: kernel-team@fb.com
Cc: cgroups@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
---
 mm/oom_kill.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 04c9143..f8b0fb1 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -343,10 +343,11 @@ static int oom_evaluate_task(struct task_struct *task, void *arg)
  * Simple selection loop. We choose the process with the highest number of
  * 'points'. In case scan was aborted, oc->chosen is set to -1.
  */
-static void select_bad_process(struct oom_control *oc)
+static void select_bad_process(struct oom_control *oc,
+			       struct mem_cgroup *memcg)
 {
-	if (is_memcg_oom(oc))
-		mem_cgroup_scan_tasks(oc->memcg, oom_evaluate_task, oc);
+	if (memcg)
+		mem_cgroup_scan_tasks(memcg, oom_evaluate_task, oc);
 	else {
 		struct task_struct *p;
 
@@ -1032,7 +1033,7 @@ bool out_of_memory(struct oom_control *oc)
 		return true;
 	}
 
-	select_bad_process(oc);
+	select_bad_process(oc, oc->memcg);
 	/* Found nothing?!?! Either we hang forever, or we panic. */
 	if (!oc->chosen && !is_sysrq_oom(oc) && !is_memcg_oom(oc)) {
 		dump_header(oc, NULL);
-- 
2.7.4

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
