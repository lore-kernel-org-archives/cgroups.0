From: Daniel Bristot de Oliveira <daolivei@redhat.com>
Subject: Re: [PATCH] cgroup: disable irqs while holding css_set_lock
Date: Tue, 7 Jun 2016 12:13:46 -0300
Message-ID: <36a39304-98e6-5551-eb89-9bcc9b7b371e@redhat.com>
References: <aa70cd2645974808785960bfb0ddfebdec6e3095.1465243518.git.bristot@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <aa70cd2645974808785960bfb0ddfebdec6e3095.1465243518.git.bristot@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-kernel@vger.kernel.org
Cc: Rik van Riel <riel@redhat.com>, "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Juri Lelli <juri.lelli@arm.com>, cgroups@vger.kernel.org

Oops.

While doing further tests on my patch I found a problem:

[   82.390739] =================================
[   82.390749] [ INFO: inconsistent lock state ]
[   82.390759] 4.7.0-rc2+ #5 Not tainted
[   82.390768] ---------------------------------
[   82.390777] inconsistent {HARDIRQ-ON-W} -> {IN-HARDIRQ-W} usage.
[   82.390790] swapper/5/0 [HC1[1]:SC0[0]:HE0:SE1] takes:
[   82.390801]  (css_set_lock){?.+...}, at: [<ffffffff8115e1cc>] put_css_set+0x4c/0x70
[   82.390854] {HARDIRQ-ON-W} state was registered at:
[   82.390865]   [<ffffffff8110a4ef>] mark_held_locks+0x6f/0xa0
[   82.390880]   [<ffffffff8110a5c5>] trace_hardirqs_on_caller+0xa5/0x1b0
[   82.390896]   [<ffffffff8110a6dd>] trace_hardirqs_on+0xd/0x10
[   82.390910]   [<ffffffff8188c59c>] _raw_spin_unlock_irq+0x2c/0x40
[   82.390926]   [<ffffffff8116361c>] cgroup_mount+0x59c/0xc10
[   82.390941]   [<ffffffff812871a8>] mount_fs+0x38/0x170
[   82.390956]   [<ffffffff812a866b>] vfs_kern_mount+0x6b/0x150
[   82.390979]   [<ffffffff812ab3a0>] do_mount+0x250/0xe80
[   82.391012]   [<ffffffff812ac305>] SyS_mount+0x95/0xe0
[   82.391044]   [<ffffffff8188cc7c>] entry_SYSCALL_64_fastpath+0x1f/0xbd
[   82.391071] irq event stamp: 92782
[   82.391084] hardirqs last  enabled at (92779): [<ffffffff8103e69e>] default_idle+0x1e/0x160
[   82.391116] hardirqs last disabled at (92780): [<ffffffff8188d9a1>] apic_timer_interrupt+0x91/0xa0
[   82.391152] softirqs last  enabled at (92782): [<ffffffff810b64d1>] _local_bh_enable+0x21/0x50
[   82.391184] softirqs last disabled at (92781): [<ffffffff810b750c>] irq_enter+0x6c/0x90
[   82.391202] 
               other info that might help us debug this:
[   82.391215]  Possible unsafe locking scenario:

[   82.391228]        CPU0
[   82.391233]        ----
[   82.391239]   lock(css_set_lock);
[   82.391249]   <Interrupt>
[   82.391255]     lock(css_set_lock);
[   82.391265] 
                *** DEADLOCK ***
q
[   82.391460] no locks held by swapper/5/0.
[   82.391621] 
               stack backtrace:
[   82.391910] CPU: 5 PID: 0 Comm: swapper/5 Not tainted 4.7.0-rc2+ #5
[   82.392045] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.8.2-20150714_191134- 04/01/2014
[   82.392180]  0000000000000086 8f22cb6bc668205e ffff88013fd43c20 ffffffff81438973
[   82.392315]  ffff88013a45a680 ffffffff82857680 ffff88013fd43c70 ffffffff81109e45
[   82.392448]  0000000000000000 0000000000000000 ffff880100000001 0000000000000002
[   82.392578] Call Trace:
[   82.392691]  <IRQ>  [<ffffffff81438973>] dump_stack+0x85/0xc2
[   82.392817]  [<ffffffff81109e45>] print_usage_bug+0x215/0x240
[   82.392939]  [<ffffffff8110a3c0>] mark_lock+0x550/0x610
[   82.393052]  [<ffffffff811093a0>] ? check_usage_backwards+0x160/0x160
[   82.393167]  [<ffffffff8110b10e>] __lock_acquire+0x6ee/0x1440
[   82.393281]  [<ffffffff8112787d>] ? debug_lockdep_rcu_enabled+0x1d/0x20
[   82.393396]  [<ffffffff8110b1ee>] ? __lock_acquire+0x7ce/0x1440
[   82.393509]  [<ffffffff8110b228>] ? __lock_acquire+0x808/0x1440
[   82.393621]  [<ffffffff8110c2d0>] lock_acquire+0xf0/0x1d0
[   82.393731]  [<ffffffff8115e1cc>] ? put_css_set+0x4c/0x70
[   82.393850]  [<ffffffff8188cbc9>] _raw_spin_lock_irqsave+0x49/0x5d
[   82.393985]  [<ffffffff8115e1cc>] ? put_css_set+0x4c/0x70
[   82.394093]  [<ffffffff8115e1cc>] put_css_set+0x4c/0x70
[   82.394201]  [<ffffffff81165591>] cgroup_free+0x91/0x120
[   82.394310]  [<ffffffff810ad0d2>] __put_task_struct+0x42/0x140
[   82.394419]  [<ffffffff810fd064>] dl_task_timer+0xc4/0x2c0
[   82.394528]  [<ffffffff810fcfa0>] ? enqueue_task_dl+0x480/0x480
[   82.394638]  [<ffffffff811349cb>] __hrtimer_run_queues+0xfb/0x4c0
[   82.394749]  [<ffffffff8113556b>] hrtimer_interrupt+0xab/0x1b0
[   82.394864]  [<ffffffff81059798>] local_apic_timer_interrupt+0x38/0x60
[   82.394976]  [<ffffffff8188f91d>] smp_apic_timer_interrupt+0x3d/0x50
[   82.395087]  [<ffffffff8188d9a6>] apic_timer_interrupt+0x96/0xa0
[   82.395196]  <EOI>  [<ffffffff8106b806>] ? native_safe_halt+0x6/0x10
[   82.395310]  [<ffffffff8110a6dd>] ? trace_hardirqs_on+0xd/0x10
[   82.395420]  [<ffffffff8103e6a3>] default_idle+0x23/0x160
[   82.395528]  [<ffffffff8103ef6f>] arch_cpu_idle+0xf/0x20
[   82.395637]  [<ffffffff810fecaa>] default_idle_call+0x2a/0x40
[   82.395744]  [<ffffffff810fefea>] cpu_startup_entry+0x32a/0x400
[   82.395854]  [<ffffffff81057f5a>] start_secondary+0x15a/0x190


This problem is fixed with this change:

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index c695d55..fcc8aee 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1928,8 +1928,12 @@ static void cgroup_enable_task_cg_lists(void)
                 * entry won't be deleted though the process has exited.
                 * Do it while holding siglock so that we don't end up
                 * racing against cgroup_exit().
+                *
+                * Interruptions were already disabled when acquiring
+                * the css_set_lock, so we do not need to disable it
+                * again when acquiring the sighand->siglock here.
                 */
-               spin_lock_irq(&p->sighand->siglock);
+               spin_lock(&p->sighand->siglock);
                if (!(p->flags & PF_EXITING)) {
                        struct css_set *cset = task_css_set(p);
 
@@ -1938,7 +1942,7 @@ static void cgroup_enable_task_cg_lists(void)
                        list_add_tail(&p->cg_list, &cset->tasks);
                        get_css_set(cset);
                }
-               spin_unlock_irq(&p->sighand->siglock);
+               spin_unlock(&p->sighand->siglock);
        } while_each_thread(g, p);
        read_unlock(&tasklist_lock);
 out_unlock:

I will prepare a v2 of the patch including this change.

I am sorry for the noise.

-- Daniel
