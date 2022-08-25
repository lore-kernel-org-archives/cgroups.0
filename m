From: Chengming Zhou <zhouchengming@bytedance.com>
Subject: [PATCH v4 05/10] sched/psi: optimize task switch inside shared cgroups again
Date: Fri, 26 Aug 2022 00:41:06 +0800
Message-ID: <20220825164111.29534-6-zhouchengming@bytedance.com>
References: <20220825164111.29534-1-zhouchengming@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=/PP0ux4xnVggwZX9NLWdLDgmxpszMjAcO6bhJJu5nGY=;
        b=UvrI7uci/V05kvoMUf3ILFGeF/R2vrNsWDDvRZeB1AmYyS1o9UyAv2f66GZ5tWvutD
         jPDVN2oJpVizBYXfth4UD7YeuYwPlowmHWVQPbCwt05ME/b6wVLIV9kc2kPirv/OFl9i
         btPY2W2iucdmMEUFSBkdATSREsUNQ7vaoH149BgbQ3S86zaHC9oUg5Yw0rzLnq4G/rLg
         HuzDirca8bvvnoQqqiucI0eHE4eUPaOvKMPTWtbpp4+7mLuKzHKzvYuahaS9ZFfI2a3m
         gDBqSb5pjSbikdNeNk/H+bN1mm72C/boZEjpal5ZqWuH8ZObfBghEQkPuPZd4kwYlIyd
         lFHw==
In-Reply-To: <20220825164111.29534-1-zhouchengming@bytedance.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: hannes@cmpxchg.org, tj@kernel.org, mkoutny@suse.com, surenb@google.com
Cc: mingo@redhat.com, peterz@infradead.org, gregkh@linuxfoundation.org, corbet@lwn.net, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, songmuchun@bytedance.com, Chengming Zhou <zhouchengming@bytedance.com>

Way back when PSI_MEM_FULL was accounted from the timer tick, task
switching could simply iterate next and prev to the common ancestor to
update TSK_ONCPU and be done.

Then memstall ticks were replaced with checking curr->in_memstall
directly in psi_group_change(). That meant that now if the task switch
was between a memstall and a !memstall task, we had to iterate through
the common ancestors at least ONCE to fix up their state_masks.

We added the identical_state filter to make sure the common ancestor
elimination was skipped in that case. It seems that was always a
little too eager, because it caused us to walk the common ancestors
*twice* instead of the required once: the iteration for next could
have stopped at the common ancestor; prev could have updated TSK_ONCPU
up to the common ancestor, then finish to the root without changing
any flags, just to get the new curr->in_memstall into the state_masks.

This patch recognizes this and makes it so that we walk to the root
exactly once if state_mask needs updating, which is simply catching up
on a missed optimization that could have been done in commit 7fae6c8171d2
("psi: Use ONCPU state tracking machinery to detect reclaim") directly.

Apart from this, it's also necessary for the next patch "sched/psi: remove
NR_ONCPU task accounting". Suppose we walk the common ancestors twice:

(1) psi_group_change(.clear = 0, .set = TSK_ONCPU)
(2) psi_group_change(.clear = TSK_ONCPU, .set = 0)

We previously used tasks[NR_ONCPU] to record TSK_ONCPU, tasks[NR_ONCPU]++
in (1) then tasks[NR_ONCPU]-- in (2), so tasks[NR_ONCPU] still be correct.

The next patch change to use one bit in state mask to record TSK_ONCPU,
PSI_ONCPU bit will be set in (1), but then be cleared in (2), which cause
the psi_group_cpu has task running on CPU but without PSI_ONCPU bit set!

With this patch, we will never walk the common ancestors twice, so won't
have above problem.

Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
---
 kernel/sched/psi.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
index 77d53c03a76f..d71dbc2356ff 100644
--- a/kernel/sched/psi.c
+++ b/kernel/sched/psi.c
@@ -820,20 +820,15 @@ void psi_task_switch(struct task_struct *prev, struct task_struct *next,
 	u64 now = cpu_clock(cpu);
 
 	if (next->pid) {
-		bool identical_state;
-
 		psi_flags_change(next, 0, TSK_ONCPU);
 		/*
-		 * When switching between tasks that have an identical
-		 * runtime state, the cgroup that contains both tasks
-		 * we reach the first common ancestor. Iterate @next's
-		 * ancestors only until we encounter @prev's ONCPU.
+		 * Set TSK_ONCPU on @next's cgroups. If @next shares any
+		 * ancestors with @prev, those will already have @prev's
+		 * TSK_ONCPU bit set, and we can stop the iteration there.
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
@@ -877,10 +872,12 @@ void psi_task_switch(struct task_struct *prev, struct task_struct *next,
 			psi_group_change(group, cpu, clear, set, now, wake_clock);
 
 		/*
-		 * TSK_ONCPU is handled up to the common ancestor. If we're tasked
-		 * with dequeuing too, finish that for the rest of the hierarchy.
+		 * TSK_ONCPU is handled up to the common ancestor. If there are
+		 * any other differences between the two tasks (e.g. prev goes
+		 * to sleep, or only one task is memstall), finish propagating
+		 * those differences all the way up to the root.
 		 */
-		if (sleep) {
+		if ((prev->psi_flags ^ next->psi_flags) & ~TSK_ONCPU) {
 			clear &= ~TSK_ONCPU;
 			for (; group; group = iterate_groups(prev, &iter))
 				psi_group_change(group, cpu, clear, set, now, wake_clock);
-- 
2.37.2

