From: Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH V2 2/8] timer: don't migrate pinned timers
Date: Fri,  4 Apr 2014 14:05:29 +0530
Message-ID: <7444411917cec76349dc369714ff9ea74347902e.1396599474.git.viresh.kumar@linaro.org>
References: <cover.1396599474.git.viresh.kumar@linaro.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1396599474.git.viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
In-Reply-To: <cover.1396599474.git.viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
References: <cover.1396599474.git.viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: linaro-kernel-cunTk1MwBs8s++Sfvej+rw@public.gmane.org, linaro-networking-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Arvind.Chauhan-5wv7dgnIgG8@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

migrate_timer() is called when a CPU goes down and its timers are required to be
migrated to some other CPU. Its the responsibility of the users of the timer to
remove it before control reaches to migrate_timers().

As these were the pinned timers, the best we can do is: don't migrate these and
report to the user as well.

That's all this patch does.

Signed-off-by: Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 kernel/timer.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/kernel/timer.c b/kernel/timer.c
index e8bcaff..6c3a371 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1606,11 +1606,21 @@ static int init_timers_cpu(int cpu)
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
+		if (unlikely(WARN(is_pinned,
+				  "%s: can't migrate pinned timer: %p, deactivating it\n",
+				  __func__, timer)))
+			continue;
+
 		timer_set_base(timer, new_base);
 		internal_add_timer(new_base, timer);
 	}
-- 
1.7.12.rc2.18.g61b472e
