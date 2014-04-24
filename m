From: Daniel Sangorrin <daniel.sangorrin-g3qfMnKXm6lL9jVzuh4AOg@public.gmane.org>
Subject: Re: [RFC 0/4] Migrate timers away from cpuset on setting cpuset.quiesce
Date: Thu, 24 Apr 2014 16:25:37 +0900
Message-ID: <201404240725.s3O7PrUv003720@toshiba.co.jp>
References: <cover.1395322529.git.viresh.kumar@linaro.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1395322529.git.viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: linaro-kernel-cunTk1MwBs8s++Sfvej+rw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Dear Viresh Kumar,

I tried your set of patches for isolating particular CPU cores from unpinned
timers. On x86_64 they were working fine, however I found out that on ARM
they would fail under the following test:

# mount -t cpuset none /cpuset
# cd /cpuset
# mkdir rt
# cd rt
# echo 1 > cpus
# echo 1 > cpu_exclusive
# cd
# taskset 0x2 ./setquiesce.sh  <--- contains "echo 1 > /cpuset/rt/quiesce"
[   75.622375] ------------[ cut here ]------------
[   75.627258] WARNING: CPU: 0 PID: 0 at kernel/locking/lockdep.c:2595 __migrate_hrtimers+0x17c/0x1bc()
[   75.636840] DEBUG_LOCKS_WARN_ON(current->hardirq_context)
[   75.636840] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.14.0-rc1-37710-g23c8f02 #1
[   75.649627] [<c0014d18>] (unwind_backtrace) from [<c00119e8>] (show_stack+0x10/0x14)
[   75.649627] [<c00119e8>] (show_stack) from [<c065b61c>] (dump_stack+0x78/0x94)
[   75.662689] [<c065b61c>] (dump_stack) from [<c003e9a4>] (warn_slowpath_common+0x60/0x84)
[   75.670410] [<c003e9a4>] (warn_slowpath_common) from [<c003ea24>] (warn_slowpath_fmt+0x30/0x40)
[   75.677673] [<c003ea24>] (warn_slowpath_fmt) from [<c005d7b0>] (__migrate_hrtimers+0x17c/0x1bc)
[   75.677673] [<c005d7b0>] (__migrate_hrtimers) from [<c009e004>] (generic_smp_call_function_single_interrupt+0x8c/0x104)
[   75.699645] [<c009e004>] (generic_smp_call_function_single_interrupt) from [<c00134d0>] (handle_IPI+0xa4/0x16c)
[   75.706970] [<c00134d0>] (handle_IPI) from [<c0008614>] (gic_handle_irq+0x54/0x5c)
[   75.715087] [<c0008614>] (gic_handle_irq) from [<c0012624>] (__irq_svc+0x44/0x5c)
[   75.725311] Exception stack(0xc08a3f58 to 0xc08a3fa0)
....

I also backported your patches to Linux 3.10.y and found the same problem
both in ARM and x86_64. However, I think I figured out the reason for those
errors. Please, could you check the patch below (it applies on the top of
your tree, branch isolate-cpusets) and let me know what you think?

Thanks,
Daniel

-------------------------PATCH STARTS HERE---------------------------------
cpuset: quiesce: change irq disable/enable by irq save/restore

The function __migrate_timers can be called under interrupt context
or thread context depending on the core where the system call was
executed. In case it executes under interrupt context, it
seems a bad idea to leave interrupts enabled after migrating the
timers. In fact, this caused kernel errors on the ARM architecture and
on the x86_64 architecture with the 3.10 kernel (backported version
of the cpuset-quiesce patch).

Signed-off-by: Daniel Sangorrin <daniel.sangorrin-g3qfMnKXm6lL9jVzuh4AOg@public.gmane.org>
Signed-off-by: Yoshitake Kobayashi <yoshitake.kobayashi-g3qfMnKXm6lL9jVzuh4AOg@public.gmane.org>
---
 kernel/hrtimer.c | 5 +++--
 kernel/timer.c   | 5 +++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index e8cd1db..abb1707 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1701,8 +1701,9 @@ static void __migrate_hrtimers(int scpu, bool remove_pinned)
 	struct hrtimer_clock_base *clock_base;
 	unsigned int active_bases;
 	int i;
+	unsigned long flags;

-	local_irq_disable();
+	local_irq_save(flags);
 	old_base = &per_cpu(hrtimer_bases, scpu);
 	new_base = &__get_cpu_var(hrtimer_bases);
 	/*
@@ -1722,7 +1723,7 @@ static void __migrate_hrtimers(int scpu, bool remove_pinned)

 	/* Check, if we got expired work to do */
 	__hrtimer_peek_ahead_timers();
-	local_irq_enable();
+	local_irq_restore(flags);
 }
 #endif /* CONFIG_HOTPLUG_CPU || CONFIG_CPUSETS */

diff --git a/kernel/timer.c b/kernel/timer.c
index 4676a07..2715b7d 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1644,6 +1644,7 @@ static void __migrate_timers(int cpu, bool remove_pinned)
 	struct tvec_base *old_base;
 	struct tvec_base *new_base;
 	int i;
+	unsigned long flags;

 	old_base = per_cpu(tvec_bases, cpu);
 	new_base = get_cpu_var(tvec_bases);
@@ -1651,7 +1652,7 @@ static void __migrate_timers(int cpu, bool remove_pinned)
 	 * The caller is globally serialized and nobody else
 	 * takes two locks at once, deadlock is not possible.
 	 */
-	spin_lock_irq(&new_base->lock);
+	spin_lock_irqsave(&new_base->lock, flags);
 	spin_lock_nested(&old_base->lock, SINGLE_DEPTH_NESTING);

 	BUG_ON(old_base->running_timer);
@@ -1671,7 +1672,7 @@ static void __migrate_timers(int cpu, bool remove_pinned)
 	}

 	spin_unlock(&old_base->lock);
-	spin_unlock_irq(&new_base->lock);
+	spin_unlock_irqrestore(&new_base->lock, flags);
 	put_cpu_var(tvec_bases);
 }
 #endif /* CONFIG_HOTPLUG_CPU || CONFIG_CPUSETS */
-- 
1.8.1.1
-------------------------PATCH ENDS HERE---------------------------------

On 2014/03/20 22:48, Viresh Kumar wrote:
> For networking platforms we need to provide one isolated CPU per user space data
> plane thread. These CPUs should not be interrupted by kernel at all unless
> userspace has requested for some syscalls. And so must live in isolated mode.
> Currently, there are background kernel activities that are running on almost
> every CPU, like: timers/hrtimers/watchdogs/etc, and these are required to be
> migrated to other CPUs.
> 
> This patchset tries to migrate un-pinned timers away in the first attempt. And
> support for migrating others like hrtimers/workqueues/etc would be added later.
> 
> This has only went through basic testing currently on ARM Samsung Exynos board
> which only has two CPUs. Separate cpusets were created for these two CPUs and
> then timers were migrated from one cpuset to other.
> 
> This option was earlier suggested by Peter Z. here.
> 
> https://lkml.org/lkml/2014/1/15/186
> 
> Please provide your inputs on how this can be improved..
> 
> Viresh Kumar (4):
>   timer: track pinned timers with TIMER_PINNED flag
>   timer: don't migrate pinned timers
>   timer: create timer_quiesce_cpu() for cpusets.quiesce option
>   cpuset: Add cpusets.quiesce option
> 
>  include/linux/timer.h | 10 +++---
>  kernel/cpuset.c       | 56 +++++++++++++++++++++++++++++++
>  kernel/timer.c        | 92 +++++++++++++++++++++++++++++++++++++++++----------
>  3 files changed, 136 insertions(+), 22 deletions(-)
> 

-- 
Toshiba Corporate Software Engineering Center
Daniel SANGORRIN
E-mail:  daniel.sangorrin-g3qfMnKXm6lL9jVzuh4AOg@public.gmane.org
