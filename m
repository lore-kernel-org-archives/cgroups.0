From: Daniel Wagner <daniel.wagner@bmw-carit.de>
Subject: Re: [PATCH cgroup/for-4.4-fixes] cgroup: make css_set pin its css's
 to avoid use-afer-free
Date: Tue, 24 Nov 2015 11:31:18 +0100
Message-ID: <56543C76.2050008@bmw-carit.de>
References: <20151123195541.GA19072@mtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151123195541.GA19072@mtj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Dave Jones <davej@codemonkey.org.uk>, kernel-team@fb.com

Hi Tejun,

On 11/23/2015 08:55 PM, Tejun Heo wrote:
> A css_set represents the relationship between a set of tasks and
> css's.  css_set never pinned the associated css's.  This was okay
> because tasks used to always disassociate immediately (in RCU sense) -
> either a task is moved to a different css_set or exits and never
> accesses css_set again.
> 
> Unfortunately, afcf6c8b7544 ("cgroup: add cgroup_subsys->free() method
> and use it to fix pids controller") and patches leading up to it made
> a zombie hold onto its css_set and deref the associated css's on its
> release.  Nothing pins the css's after exit and it might have already
> been freed leading to use-after-free.
> 
>  general protection fault: 0000 [#1] PREEMPT SMP
>  task: ffffffff81bf2500 ti: ffffffff81be4000 task.ti: ffffffff81be4000
>  RIP: 0010:[<ffffffff810fa205>]  [<ffffffff810fa205>] pids_cancel.constprop.4+0x5/0x40
>  ...
>  Call Trace:
>   <IRQ>
>   [<ffffffff810fb02d>] ? pids_free+0x3d/0xa0
>   [<ffffffff810f8893>] cgroup_free+0x53/0xe0
>   [<ffffffff8104ed62>] __put_task_struct+0x42/0x130
>   [<ffffffff81053557>] delayed_put_task_struct+0x77/0x130
>   [<ffffffff810c6b34>] rcu_process_callbacks+0x2f4/0x820
>   [<ffffffff810c6af3>] ? rcu_process_callbacks+0x2b3/0x820
>   [<ffffffff81056e54>] __do_softirq+0xd4/0x460
>   [<ffffffff81057369>] irq_exit+0x89/0xa0
>   [<ffffffff81876212>] smp_apic_timer_interrupt+0x42/0x50
>   [<ffffffff818747f4>] apic_timer_interrupt+0x84/0x90
>   <EOI>
>  ...
>  Code: 5b 5d c3 48 89 df 48 c7 c2 c9 f9 ae 81 48 c7 c6 91 2c ae 81 e8 1d 94 0e 00 31 c0 5b 5d c3 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 <f0> 48 83 87 e0 00 00 00 ff 78 01 c3 80 3d 08 7a c1 00 00 74 02
>  RIP  [<ffffffff810fa205>] pids_cancel.constprop.4+0x5/0x40
>   RSP <ffff88001fc03e20>
>  ---[ end trace 89a4a4b916b90c49 ]---
>  Kernel panic - not syncing: Fatal exception in interrupt
>  Kernel Offset: disabled
>  ---[ end Kernel panic - not syncing: Fatal exception in interrupt
> 
> Fix it by making css_set pin the associate css's until its release.

I still see this one with the patch applied:

[   19.369455] ------------[ cut here ]------------
[   19.369851] WARNING: CPU: 1 PID: 1 at kernel/cgroup_pids.c:97 pids_cancel.constprop.6+0x31/0x40()
[   19.370596] Modules linked in:
[   19.370916] CPU: 1 PID: 1 Comm: systemd Not tainted 4.4.0-rc1+ #29
[   19.371418] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.8.2-0-g33fbe13 by qemu-project.org 04/01/2014
[   19.372542]  ffffffff81f65382 ffff88007c043b90 ffffffff81551ffc 0000000000000000
[   19.373173]  ffff88007c043bc8 ffffffff810de202 ffff88007a752000 ffff88007a29ab00
[   19.374144]  ffff88007c043c80 ffff88007a1d8400 0000000000000001 ffff88007c043bd8
[   19.375185] Call Trace:
[   19.375506]  [<ffffffff81551ffc>] dump_stack+0x4e/0x82
[   19.376238]  [<ffffffff810de202>] warn_slowpath_common+0x82/0xc0
[   19.376975]  [<ffffffff810de2fa>] warn_slowpath_null+0x1a/0x20
[   19.377765]  [<ffffffff8118e031>] pids_cancel.constprop.6+0x31/0x40
[   19.378623]  [<ffffffff8118e0fd>] pids_can_attach+0x6d/0xf0
[   19.379451]  [<ffffffff81188a4c>] cgroup_taskset_migrate+0x6c/0x330
[   19.380142]  [<ffffffff81188e05>] cgroup_migrate+0xf5/0x190
[   19.380592]  [<ffffffff81188d15>] ? cgroup_migrate+0x5/0x190
[   19.381041]  [<ffffffff81189016>] cgroup_attach_task+0x176/0x200
[   19.381500]  [<ffffffff81188ea5>] ? cgroup_attach_task+0x5/0x200
[   19.381962]  [<ffffffff8118949d>] __cgroup_procs_write+0x2ad/0x460
[   19.382482]  [<ffffffff8118924e>] ? __cgroup_procs_write+0x5e/0x460
[   19.382949]  [<ffffffff81189684>] cgroup_procs_write+0x14/0x20
[   19.383432]  [<ffffffff811854e5>] cgroup_file_write+0x35/0x1c0
[   19.383864]  [<ffffffff812e26f1>] kernfs_fop_write+0x141/0x190
[   19.384367]  [<ffffffff81265f88>] __vfs_write+0x28/0xe0
[   19.384759]  [<ffffffff811292d7>] ? percpu_down_read+0x57/0xa0
[   19.385274]  [<ffffffff81268c14>] ? __sb_start_write+0xb4/0xf0
[   19.385712]  [<ffffffff81268c14>] ? __sb_start_write+0xb4/0xf0
[   19.386160]  [<ffffffff812666fc>] vfs_write+0xac/0x1a0
[   19.386563]  [<ffffffff812860b6>] ? __fget_light+0x66/0x90
[   19.386960]  [<ffffffff81267019>] SyS_write+0x49/0xb0
[   19.387373]  [<ffffffff81bcef32>] entry_SYSCALL_64_fastpath+0x12/0x76
[   19.387861] ---[ end trace 46552476f436a20f ]---

cheers,
daniel
