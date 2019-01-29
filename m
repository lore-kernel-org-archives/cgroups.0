From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Subject: Re: [PATCH v3] oom, oom_reaper: do not enqueue same task twice
Date: Tue, 29 Jan 2019 19:34:00 +0900
Message-ID: <5ee34fc6-1485-34f8-8790-903ddabaa809@i-love.sakura.ne.jp>
References: <6da6ca69-5a6e-a9f6-d091-f89a8488982a@gmail.com>
 <72aa8863-a534-b8df-6b9e-f69cf4dd5c4d@i-love.sakura.ne.jp>
 <33a07810-6dbc-36be-5bb6-a279773ccf69@i-love.sakura.ne.jp>
 <34e97b46-0792-cc66-e0f2-d72576cdec59@i-love.sakura.ne.jp>
 <2b0c7d6c-c58a-da7d-6f0a-4900694ec2d3@gmail.com>
 <1d161137-55a5-126f-b47e-b2625bd798ca@i-love.sakura.ne.jp>
 <20190127083724.GA18811@dhcp22.suse.cz>
 <ec0d0580-a2dd-f329-9707-0cb91205a216@i-love.sakura.ne.jp>
 <20190127114021.GB18811@dhcp22.suse.cz>
 <e865a044-2c10-9858-f4ef-254bc71d6cc2@i-love.sakura.ne.jp>
 <20190128215315.GA2011@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190128215315.GA2011@cmpxchg.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>, =?UTF-8?Q?Arkadiusz_Mi=c5=9bkiewicz?= <a.miskiewicz@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, Aleksa Sarai <asarai@suse.de>, Jay Kamat <jgkamat@fb.com>, Roman Gushchin <guro@fb.com>, linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, linux-mm <linux-mm@kvack.org>

Johannes Weiner wrote:
> On Sun, Jan 27, 2019 at 11:57:38PM +0900, Tetsuo Handa wrote:
> > This bug existed since the OOM reaper became invokable from
> > task_will_free_mem(current) path in out_of_memory() in Linux 4.7,
> > but memcg's group oom killing made it easier to trigger this bug by
> > calling wake_oom_reaper() on the same task from one out_of_memory()
> > request.
> 
> This changelog seems a little terse compared to how tricky this is.
> 
> Can you please include an explanation here *how* this bug is possible?
> I.e. the race condition that causes the function te be entered twice
> and the existing re-entrance check in there to fail.

OK. Here is an updated patch. Only changelog part has changed.
I hope this will provide enough information to stable kernel maintainers.
----------
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: oom, oom_reaper: do not enqueue same task twice

Arkadiusz reported that enabling memcg's group oom killing causes strange
memcg statistics where there is no task in a memcg despite the number of
tasks in that memcg is not 0.  It turned out that there is a bug in
wake_oom_reaper() which allows enqueuing same task twice which makes
impossible to decrease the number of tasks in that memcg due to a refcount
leak.

This bug existed since the OOM reaper became invokable from
task_will_free_mem(current) path in out_of_memory() in Linux 4.7,

  T1@P1     |T2@P1     |T3@P1     |OOM reaper
  ----------+----------+----------+------------
                                   # Processing an OOM victim in a different memcg domain.
                        try_charge()
                          mem_cgroup_out_of_memory()
                            mutex_lock(&oom_lock)
             try_charge()
               mem_cgroup_out_of_memory()
                 mutex_lock(&oom_lock)
  try_charge()
    mem_cgroup_out_of_memory()
      mutex_lock(&oom_lock)
                            out_of_memory()
                              oom_kill_process(P1)
                                do_send_sig_info(SIGKILL, @P1)
                                mark_oom_victim(T1@P1)
                                wake_oom_reaper(T1@P1) # T1@P1 is enqueued.
                            mutex_unlock(&oom_lock)
                 out_of_memory()
                   mark_oom_victim(T2@P1)
                   wake_oom_reaper(T2@P1) # T2@P1 is enqueued.
                 mutex_unlock(&oom_lock)
      out_of_memory()
        mark_oom_victim(T1@P1)
        wake_oom_reaper(T1@P1) # T1@P1 is enqueued again due to oom_reaper_list == T2@P1 && T1@P1->oom_reaper_list == NULL.
      mutex_unlock(&oom_lock)
                                   # Completed processing an OOM victim in a different memcg domain.
                                   spin_lock(&oom_reaper_lock)
                                   # T1P1 is dequeued.
                                   spin_unlock(&oom_reaper_lock)

but memcg's group oom killing made it easier to trigger this bug by
calling wake_oom_reaper() on the same task from one out_of_memory()
request.

Fix this bug using an approach used by commit 855b018325737f76 ("oom,
oom_reaper: disable oom_reaper for oom_kill_allocating_task").  As a side
effect of this patch, this patch also avoids enqueuing multiple threads
sharing memory via task_will_free_mem(current) path.

Fixes: af8e15cc85a25315 ("oom, oom_reaper: do not enqueue task if it is on the oom_reaper_list head")
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Reported-by: Arkadiusz Miśkiewicz <arekm@maven.pl>
Tested-by: Arkadiusz Miśkiewicz <arekm@maven.pl>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Roman Gushchin <guro@fb.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Aleksa Sarai <asarai@suse.de>
Cc: Jay Kamat <jgkamat@fb.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
---
 include/linux/sched/coredump.h | 1 +
 mm/oom_kill.c                  | 4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/sched/coredump.h b/include/linux/sched/coredump.h
index ec912d0..ecdc654 100644
--- a/include/linux/sched/coredump.h
+++ b/include/linux/sched/coredump.h
@@ -71,6 +71,7 @@ static inline int get_dumpable(struct mm_struct *mm)
 #define MMF_HUGE_ZERO_PAGE	23      /* mm has ever used the global huge zero page */
 #define MMF_DISABLE_THP		24	/* disable THP for all VMAs */
 #define MMF_OOM_VICTIM		25	/* mm is the oom victim */
+#define MMF_OOM_REAP_QUEUED	26	/* mm was queued for oom_reaper */
 #define MMF_DISABLE_THP_MASK	(1 << MMF_DISABLE_THP)
 
 #define MMF_INIT_MASK		(MMF_DUMPABLE_MASK | MMF_DUMP_FILTER_MASK |\
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index f0e8cd9..059e617 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -647,8 +647,8 @@ static int oom_reaper(void *unused)
 
 static void wake_oom_reaper(struct task_struct *tsk)
 {
-	/* tsk is already queued? */
-	if (tsk == oom_reaper_list || tsk->oom_reaper_list)
+	/* mm is already queued? */
+	if (test_and_set_bit(MMF_OOM_REAP_QUEUED, &tsk->signal->oom_mm->flags))
 		return;
 
 	get_task_struct(tsk);
-- 
1.8.3.1

