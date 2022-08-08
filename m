From: Chengming Zhou <zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: [PATCH v2 02/10] sched/psi: optimize task switch inside shared cgroups again
Date: Mon,  8 Aug 2022 19:03:33 +0800
Message-ID: <20220808110341.15799-3-zhouchengming@bytedance.com>
References: <20220808110341.15799-1-zhouchengming@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hPrlmdp1+V2T+kE3vc+RCj17IKZw6QBjGZGzgKFOvkI=;
        b=Kb18Kkz/FcTk+kpvnWEWXxWKUiHWjU/a38UAe0J9oi34EDsm6Co1bo3Zqvx9ylNFpi
         zSy8zc6Gy9HN623y5k2Zm0+SIs424CxyWxlwpiF+qPhBebYmNbPMIF9wfMaUreHm0fRd
         hwQq0i47LAlZqSdcPgzP6BRJBE1EM8QefCU2z9kmajjawcOBYhzyEljrQ7va+ajt1x79
         uvBKqQg31+mXaZ5PEP4feNkSwcXNpug/23Q8jXHuVOOcGsxoeJAe8uIfSZY3Ou/FKr4H
         Mgd+HJ2nZsK1RIFHmMGpbh1bK90rLlVNnZShq/GMo8EzgL7CzOCJy7/vE7xoD586s+0f
         XMxg==
In-Reply-To: <20220808110341.15799-1-zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, dietmar.eggemann-5wv7dgnIgG8@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, Chengming Zhou <zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

commit 4117cebf1a9f ("psi: Optimize task switch inside shared cgroups")
defer prev task sleep handling to psi_task_switch(), so we don't need
to clear and set TSK_ONCPU state for common cgroups.

    A
    |
    B
   / \
  C   D
 /     \
prev   next

After that commit psi_task_switch() do:
1. psi_group_change(next, .set=TSK_ONCPU) for D
2. psi_group_change(prev, .clear=TSK_ONCPU | TSK_RUNNING) for C
3. psi_group_change(prev, .clear=TSK_RUNNING) for B, A

But there is a limitation "prev->psi_flags == next->psi_flags" that
if not satisfied, will make this cgroups optimization unusable for both
sleep switch or running switch cases. For example:

prev->in_memstall != next->in_memstall when sleep switch:
1. psi_group_change(next, .set=TSK_ONCPU) for D, B, A
2. psi_group_change(prev, .clear=TSK_ONCPU | TSK_RUNNING) for C, B, A

prev->in_memstall != next->in_memstall when running switch:
1. psi_group_change(next, .set=TSK_ONCPU) for D, B, A
2. psi_group_change(prev, .clear=TSK_ONCPU) for C, B, A

The reason why this limitation exist is that we consider a group is
PSI_MEM_FULL if the CPU is actively reclaiming and nothing productive
could run even if it were runnable. So when CPU curr changed from prev
to next and their in_memstall status is different, we have to change
PSI_MEM_FULL status for their common cgroups.

This patch remove this limitation by making psi_group_change() change
PSI_MEM_FULL status depend on CPU curr->in_memstall status.

Signed-off-by: Chengming Zhou <zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
---
 kernel/sched/psi.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
index 115a7e52fa23..9e8c5d9e585c 100644
--- a/kernel/sched/psi.c
+++ b/kernel/sched/psi.c
@@ -823,8 +823,6 @@ void psi_task_switch(struct task_struct *prev, struct task_struct *next,
 	u64 now = cpu_clock(cpu);
 
 	if (next->pid) {
-		bool identical_state;
-
 		psi_flags_change(next, 0, TSK_ONCPU);
 		/*
 		 * When switching between tasks that have an identical
@@ -832,11 +830,9 @@ void psi_task_switch(struct task_struct *prev, struct task_struct *next,
 		 * we reach the first common ancestor. Iterate @next's
 		 * ancestors only until we encounter @prev's ONCPU.
 		 */
-		identical_state = prev->psi_flags == next->psi_flags;
 		iter = NULL;
 		while ((group = iterate_groups(next, &iter))) {
-			if (identical_state &&
-			    per_cpu_ptr(group->pcpu, cpu)->tasks[NR_ONCPU]) {
+			if (per_cpu_ptr(group->pcpu, cpu)->tasks[NR_ONCPU]) {
 				common = group;
 				break;
 			}
@@ -883,7 +879,7 @@ void psi_task_switch(struct task_struct *prev, struct task_struct *next,
 		 * TSK_ONCPU is handled up to the common ancestor. If we're tasked
 		 * with dequeuing too, finish that for the rest of the hierarchy.
 		 */
-		if (sleep) {
+		if (sleep || unlikely(prev->in_memstall != next->in_memstall)) {
 			clear &= ~TSK_ONCPU;
 			for (; group; group = iterate_groups(prev, &iter))
 				psi_group_change(group, cpu, clear, set, now, wake_clock);
-- 
2.36.1

