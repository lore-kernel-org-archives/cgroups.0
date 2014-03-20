From: Viresh Kumar <viresh.kumar@linaro.org>
Subject: [RFC 2/4] timer: don't migrate pinned timers
Date: Thu, 20 Mar 2014 19:18:59 +0530
Message-ID: <3fa0ea3a19a51ae2797a25e281763451ad8d2844.1395322529.git.viresh.kumar@linaro.org>
References: <cover.1395322529.git.viresh.kumar@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1395322529.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1395322529.git.viresh.kumar@linaro.org>
References: <cover.1395322529.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tglx@linutronix.de, fweisbec@gmail.com, peterz@infradead.org, mingo@kernel.org, tj@kernel.org, lizefan@huawei.com
Cc: linaro-kernel@lists.linaro.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>

migrate_timer() is called when a CPU goes down and its timers are required to be
migrated to some other CPU. Its the responsibility of the users of the timer to
remove it before control reaches to migrate_timers().

As these were the pinned timers, the best we can do is: don't migrate these and
report to the user as well.

That's all this patch does.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/timer.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/kernel/timer.c b/kernel/timer.c
index fec4ab4..a7f8b99 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1606,11 +1606,22 @@ static int init_timers_cpu(int cpu)
 static void migrate_timer_list(struct tvec_base *new_base, struct list_head *head)
 {
 	struct timer_list *timer;
+	int is_pinned;
 
 	while (!list_empty(head)) {
 		timer = list_first_entry(head, struct timer_list, entry);
 		/* We ignore the accounting on the dying cpu */
 		detach_timer(timer, false);
+
+		is_pinned = tbase_get_pinned(timer->base);
+
+		/* Check if CPU still has pinned timers */
+		if (is_pinned) {
+			pr_warn("%s: can't migrate pinned timer: %p, removing it\n",
+					__func__, timer);
+			continue;
+		}
+
 		timer_set_base(timer, new_base);
 		internal_add_timer(new_base, timer);
 	}
-- 
1.7.12.rc2.18.g61b472e
