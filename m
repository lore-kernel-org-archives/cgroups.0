From: Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 5/8] hrtimer: don't migrate pinned timers
Date: Fri,  4 Apr 2014 14:05:32 +0530
Message-ID: <62698fe1c1f632338b0441f63897372dc0f4cd13.1396599474.git.viresh.kumar@linaro.org>
References: <cover.1396599474.git.viresh.kumar@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1396599474.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1396599474.git.viresh.kumar@linaro.org>
References: <cover.1396599474.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tglx@linutronix.de, fweisbec@gmail.com, peterz@infradead.org, mingo@kernel.org, tj@kernel.org, lizefan@huawei.com
Cc: linaro-kernel@lists.linaro.org, linaro-networking@linaro.org, Arvind.Chauhan@arm.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>

migrate_hrtimer() is called when a CPU goes down and its timers are required to
be migrated to some other CPU. Its the responsibility of the users of the
hrtimer to remove it before control reaches to migrate_hrtimer().

As these were the pinned hrtimers, the best we can do is: don't migrate these
and report to the user as well.

That's all this patch does.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/hrtimer.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index c5a4bf4..853dd8c 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1640,6 +1640,7 @@ static void migrate_hrtimer_list(struct hrtimer_clock_base *old_base,
 {
 	struct hrtimer *timer;
 	struct timerqueue_node *node;
+	int is_pinned;
 
 	while ((node = timerqueue_getnext(&old_base->active))) {
 		timer = container_of(node, struct hrtimer, node);
@@ -1652,6 +1653,15 @@ static void migrate_hrtimer_list(struct hrtimer_clock_base *old_base,
 		 * under us on another CPU
 		 */
 		__remove_hrtimer(timer, HRTIMER_STATE_MIGRATE, 0);
+
+		is_pinned = timer->state & HRTIMER_STATE_PINNED;
+
+		/* Check if CPU still has pinned timers */
+		if (unlikely(WARN(is_pinned,
+				  "%s: can't migrate pinned timer: %p, deactivating it\n",
+				  __func__, timer)))
+			continue;
+
 		timer->base = new_base;
 		/*
 		 * Enqueue the timers on the new cpu. This does not
-- 
1.7.12.rc2.18.g61b472e
