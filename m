From: Michal Hocko <mhocko@suse.cz>
Subject: [PATCH] memcg: Do not hang on OOM when killed by userspace OOM
 access to memory reserves
Date: Thu, 9 Jan 2014 15:30:48 +0100
Message-ID: <20140109143048.GE27538@dhcp22.suse.cz>
References: <alpine.DEB.2.02.1312111434200.7354@chino.kir.corp.google.com>
 <20131212103159.GB2630@dhcp22.suse.cz>
 <alpine.DEB.2.02.1312131551220.28704@chino.kir.corp.google.com>
 <20131217162342.GG28991@dhcp22.suse.cz>
 <alpine.DEB.2.02.1312171240541.21640@chino.kir.corp.google.com>
 <20131218200434.GA4161@dhcp22.suse.cz>
 <alpine.DEB.2.02.1312182157510.1247@chino.kir.corp.google.com>
 <20131219144134.GH10855@dhcp22.suse.cz>
 <20140107162503.f751e880410f61a109cdcc2b@linux-foundation.org>
 <20140108103319.GF27937@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20140108103319.GF27937@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>, Johannes Weiner <hannes@cmpxchg.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>

On Wed 08-01-14 11:33:19, Michal Hocko wrote:
> On Tue 07-01-14 16:25:03, Andrew Morton wrote:
> [...]
> > > OK, so can we at least agree on the patch posted here:
> > > https://lkml.org/lkml/2013/12/12/129. This is a real bug and definitely
> > > worth fixing.
> > 
> > Yes, can we please get Eric's bug fixed?  I don't believe that Eric has
> > tested either https://lkml.org/lkml/2013/12/12/129 or
> > http://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-avoid-oom-notification-when-current-needs-access-to-memory-reserves.patch.
> > Is he the only person who can reproduce this?
> 
> I have gathered 3 patches from all the discussion and plan to post them
> today or tomorrow as the time permits. https://lkml.org/lkml/2013/12/12/129
> will be a part of it.

OK, I've decided to post the oom notification parts later because they
will likely generate some discussion which might distract from the
actual fix so here it goes (can be applied on both mmotm and the current
Linus' tree):
---
From 6185aaf3cd429b1ecf2d11d424e29b597feb7811 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Thu, 12 Dec 2013 11:37:27 +0100
Subject: [PATCH] memcg: Do not hang on OOM when killed by userspace OOM

Eric has reported that he can see task(s) stuck in memcg OOM handler
regularly. The only way out is to
	echo 0 > $GROUP/memory.oom_controll
His usecase is:
- Setup a hierarchy with memory and the freezer
  (disable kernel oom and have a process watch for oom).
- In that memory cgroup add a process with one thread per cpu.
- In one thread slowly allocate once per second I think it is 16M of ram
  and mlock and dirty it (just to force the pages into ram and stay there).
- When oom is achieved loop:
  * attempt to freeze all of the tasks.
  * if frozen send every task SIGKILL, unfreeze, remove the directory in
    cgroupfs.

Eric has then pinpointed the issue to be memcg specific.

All tasks are sitting on the memcg_oom_waitq when memcg oom is disabled.
Those that have received fatal signal will bypass the charge and should
continue on their way out. The tricky part is that the exit path might
trigger a page fault (e.g. exit_robust_list), thus the memcg charge,
while its memcg is still under OOM because nobody has released any
charges yet.
Unlike with the in-kernel OOM handler the exiting task doesn't get
TIF_MEMDIE set so it doesn't shortcut futher charges of the killed task
and falls to the memcg OOM again without any way out of it as there are
no fatal signals pending anymore.

This patch fixes the issue by checking PF_EXITING early in
__mem_cgroup_try_charge and bypass the charge same as if it had fatal
signal pending or TIF_MEMDIE set.

Normally exiting tasks (aka not killed) will bypass the charge now but
this should be OK as the task is leaving and will release memory and
increasing the memory pressure just to release it in a moment seems
dubious wasting of cycles. Besides that charges after exit_signals
should be rare.

Reported-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 mm/memcontrol.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index b8dfed1b9d87..b86fbb04b7c6 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2685,7 +2685,8 @@ static int __mem_cgroup_try_charge(struct mm_struct *mm,
 	 * MEMDIE process.
 	 */
 	if (unlikely(test_thread_flag(TIF_MEMDIE)
-		     || fatal_signal_pending(current)))
+		     || fatal_signal_pending(current))
+		     || current->flags & PF_EXITING)
 		goto bypass;
 
 	if (unlikely(task_in_memcg_oom(current)))
-- 
1.8.5.2

-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
