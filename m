From: Petr Mladek <pmladek@suse.com>
Subject: [BUG] cgroup/workques/fork: deadlock when moving cgroups
Date: Wed, 13 Apr 2016 11:42:16 +0200
Message-ID: <20160413094216.GC5774@pathway.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Michal Hocko <mhocko@suse.cz>, Cyril Hrubis <chrubis@suse.cz>, linux-kernel@vger.kernel.org

Hi,

Cyril reported a system lock up when running
memcg_move_charge_at_immigrate_test.sh test[*] repeatedly.

I have reproduced it also with the plain 4.6-rc3.

There seems to be a deadlock where 4 processes are involved. It makes
the system unable to fork any new processes. I had to use alt-sysrq
command to get to debugging information.

Please, find the entire log at http://pastebin.com/pL9eKsFb

Interesting is the lockdep output:

[  409.669856] Showing all locks held in the system:
[  409.669856] 2 locks held by systemd/1:
[  409.669856]  #0:  (&p->lock){+.+.+.}, at: [<ffffffff8124e54d>] seq_read+0x3d/0x3a0
[  409.669856]  #1:  (cgroup_mutex){+.+.+.}, at: [<ffffffff8112379e>] proc_cgroup_show+0x4e/0x300
[  409.669856] 1 lock held by kthreadd/2:
[  409.669856]  #0:  (&cgroup_threadgroup_rwsem){++++++}, at: [<ffffffff8106b235>] copy_process.part.30+0x555/0x1d30
[  409.669856] 3 locks held by kworker/0:2/114:
[  409.669856]  #0:  ("cgroup_destroy"){.+.+..}, at: [<ffffffff8108c971>] process_one_work+0x151/0x6b0
[  409.669856]  #1:  ((&css->destroy_work)){+.+...}, at: [<ffffffff8108c971>] process_one_work+0x151/0x6b0
[  409.669856]  #2:  (cgroup_mutex){+.+.+.}, at: [<ffffffff8111a80d>] css_release_work_fn+0x2d/0xf0
[  409.669856] 1 lock held by kworker/0:3/588:
[  409.669856]  #0:  (&pool->manager_arb){+.+.+.}, at: [<ffffffff8108d1bc>] worker_thread+0x2ec/0x490
[  409.669856] 1 lock held by in:imklog/816:
[  409.669856]  #0:  (&f->f_pos_lock){+.+.+.}, at: [<ffffffff81248013>] __fdget_pos+0x43/0x50
[  409.669856] 6 locks held by memcg_move_char/2860:
[  409.669856]  #0:  (sb_writers#6){.+.+.+}, at: [<ffffffff812299e1>] __sb_start_write+0xd1/0xf0
[  409.669856]  #1:  (&of->mutex){+.+.+.}, at: [<ffffffff812ae4d6>] kernfs_fop_write+0x66/0x190
[  409.669856]  #2:  (cgroup_mutex){+.+.+.}, at: [<ffffffff8111ef7c>] cgroup_kn_lock_live+0x5c/0x1f0
[  409.669856]  #3:  (&cgroup_threadgroup_rwsem){++++++}, at: [<ffffffff810c6a64>] percpu_down_write+0x24/0xd0
[  409.669856]  #4:  (lock#4){+.+...}, at: [<ffffffff811aa1d4>] lru_add_drain_all+0x34/0x1a0
[  409.669856]  #5:  (cpu_hotplug.lock){++++++}, at: [<ffffffff8106e097>] get_online_cpus+0x17/0x70


The problematic processes seem to be:

1. memcg_move_char/2860:
========================

It is the process from the test suite. It is waiting in lru_add_drain_all()
when calling flush_work() on CPU0[**]. Note that it holds many locks
including 'cgroup_mutex' and 'cgroup_threadgroup_rwsem'.

[  409.669856] memcg_move_char D ffff8800ab82b978     0  2860   1438 0x00000000
[  409.669856]  ffff8800ab82b978 ffffffff8244c908 ffff880036d44800 ffff880036a0d1c0
[  409.669856]  ffff8800ab82c000 ffff8800ab82bb00 ffff8800ab82baf8 ffff880036a0d1c0
[  409.669856]  0000000000000004 ffff8800ab82b990 ffffffff8195c77c 7fffffffffffffff
[  409.669856] Call Trace:
[  409.669856]  [<ffffffff8195c77c>] schedule+0x3c/0x90
[  409.669856]  [<ffffffff81960e74>] schedule_timeout+0x294/0x480
[  409.669856]  [<ffffffff810c9fd6>] ? mark_held_locks+0x66/0x90
[  409.669856]  [<ffffffff81961c1c>] ? _raw_spin_unlock_irq+0x2c/0x50
[  409.669856]  [<ffffffff810ca0f9>] ? trace_hardirqs_on_caller+0xf9/0x1c0
[  409.669856]  [<ffffffff8195d9d6>] wait_for_completion+0x96/0x100
[  409.669856]  [<ffffffff810a1a30>] ? wake_up_q+0x80/0x80
[  409.669856]  [<ffffffff8108b7ca>] flush_work+0x1ca/0x270
[  409.669856]  [<ffffffff8108b82e>] ? flush_work+0x22e/0x270
[  409.669856]  [<ffffffff81088f20>] ? destroy_worker+0xd0/0xd0
[  409.669856]  [<ffffffff811aa2fb>] lru_add_drain_all+0x15b/0x1a0
[  409.669856]  [<ffffffff81211c8b>] mem_cgroup_move_task+0x5b/0xe0
[  409.669856]  [<ffffffff81214640>] ? mem_cgroup_move_account+0x290/0x290
[  409.669856]  [<ffffffff8111fa9e>] cgroup_taskset_migrate+0x1ee/0x360
[  409.669856]  [<ffffffff8111fd05>] cgroup_migrate+0xf5/0x190
[  409.669856]  [<ffffffff8111fc15>] ? cgroup_migrate+0x5/0x190
[  409.669856]  [<ffffffff8111ffa5>] cgroup_attach_task+0x205/0x230
[  409.669856]  [<ffffffff8111fde2>] ? cgroup_attach_task+0x42/0x230
[  409.669856]  [<ffffffff811203dd>] __cgroup_procs_write.isra.30+0x2bd/0x470
[  409.669856]  [<ffffffff8112017f>] ? __cgroup_procs_write.isra.30+0x5f/0x470
[  409.669856]  [<ffffffff811205a0>] cgroup_tasks_write+0x10/0x20
[  409.669856]  [<ffffffff8111bf6e>] cgroup_file_write+0x3e/0x1b0
[  409.669856]  [<ffffffff812ae5b4>] kernfs_fop_write+0x144/0x190
[  409.669856]  [<ffffffff81225838>] __vfs_write+0x28/0xe0
[  409.669856]  [<ffffffff810c69a4>] ? percpu_down_read+0x44/0x80
[  409.669856]  [<ffffffff812299e1>] ? __sb_start_write+0xd1/0xf0
[  409.669856]  [<ffffffff812299e1>] ? __sb_start_write+0xd1/0xf0
[  409.669856]  [<ffffffff81226742>] vfs_write+0xa2/0x1a0
[  409.669856]  [<ffffffff81247296>] ? __fget_light+0x66/0x90
[  409.669856]  [<ffffffff81227ab9>] SyS_write+0x49/0xa0
[  409.669856]  [<ffffffff819623fc>] entry_SYSCALL_64_fastpath+0x1f/0xbd


2. kworker/0:2/114:
===================

It is a worker on CPU0 that is blocked in css_release_work_fn().
It is unable to get 'cgroup_mutex' that is already owned by
'memcg_move_char/2860'.


[  409.669856] kworker/0:2     D ffff880036d4bcd8     0   114      2 0x00000000
[  409.669856] Workqueue: cgroup_destroy css_release_work_fn
[  409.669856]  ffff880036d4bcd8 00000000ffffffff ffff8800acd40100 ffff880036d44800
[  409.669856]  ffff880036d4c000 ffffffff81e94280 0000000000000246 ffff880036d44800
[  409.669856]  00000000ffffffff ffff880036d4bcf0 ffffffff8195c77c ffffffff81e94288
[  409.669856] Call Trace:
[  409.669856]  [<ffffffff8195c77c>] schedule+0x3c/0x90
[  409.669856]  [<ffffffff8195cb35>] schedule_preempt_disabled+0x15/0x20
[  409.669856]  [<ffffffff8195ec49>] mutex_lock_nested+0x169/0x3f0
[  409.669856]  [<ffffffff8111a80d>] ? css_release_work_fn+0x2d/0xf0
[  409.669856]  [<ffffffff8111a80d>] css_release_work_fn+0x2d/0xf0
[  409.669856]  [<ffffffff8108c9ec>] process_one_work+0x1cc/0x6b0
[  409.669856]  [<ffffffff8108c971>] ? process_one_work+0x151/0x6b0
[  409.669856]  [<ffffffff8108cffb>] worker_thread+0x12b/0x490
[  409.669856]  [<ffffffff8108ced0>] ? process_one_work+0x6b0/0x6b0
[  409.669856]  [<ffffffff81093dd4>] kthread+0xe4/0x100
[  409.669856]  [<ffffffff81962632>] ret_from_fork+0x22/0x50
[  409.669856]  [<ffffffff81093cf0>] ? kthread_create_on_node+0x200/0x200


3. kworker/0:3/588:
===================

It tries to create another worker on CPU0 to proceed the pending
works. It waits until the kthread is created by kthreadd.


[  409.669856] kworker/0:3     D ffff8800ad8ebb68     0   588      2 0x00000000
[  409.669856]  ffff8800ad8ebb68 ffffffff82435ae8 ffff88012a648040 ffff8800acd40100
[  409.669856]  ffff8800ad8ec000 ffff8800ad8ebcc8 ffff8800ad8ebcc0 ffff8800acd40100
[  409.669856]  ffff8800acd40100 ffff8800ad8ebb80 ffffffff8195c77c 7fffffffffffffff
[  409.669856] Call Trace:
[  409.669856]  [<ffffffff8195c77c>] schedule+0x3c/0x90
[  409.669856]  [<ffffffff81960e74>] schedule_timeout+0x294/0x480
[  409.669856]  [<ffffffff810c9fd6>] ? mark_held_locks+0x66/0x90
[  409.669856]  [<ffffffff81961c1c>] ? _raw_spin_unlock_irq+0x2c/0x50
[  409.669856]  [<ffffffff810ca0f9>] ? trace_hardirqs_on_caller+0xf9/0x1c0
[  409.669856]  [<ffffffff8195d72b>] wait_for_completion_killable+0xab/0x170
[  409.669856]  [<ffffffff810a1a30>] ? wake_up_q+0x80/0x80
[  409.669856]  [<ffffffff8108ced0>] ? process_one_work+0x6b0/0x6b0
[  409.669856]  [<ffffffff81093c4a>] kthread_create_on_node+0x15a/0x200
[  409.669856]  [<ffffffff8121d6d8>] ? create_object+0x238/0x2e0
[  409.669856]  [<ffffffff814505a9>] ? snprintf+0x39/0x40
[  409.669856]  [<ffffffff8108b9db>] create_worker+0xbb/0x190
[  409.669856]  [<ffffffff8108d205>] worker_thread+0x335/0x490
[  409.669856]  [<ffffffff8108ced0>] ? process_one_work+0x6b0/0x6b0
[  409.669856]  [<ffffffff81093dd4>] kthread+0xe4/0x100
[  409.669856]  [<ffffffff81962632>] ret_from_fork+0x22/0x50
[  409.669856]  [<ffffffff81093cf0>] ? kthread_create_on_node+0x200/0x200


4. kthreadd/2:
==============

It is a kthread that is responsible for forking other kthreads.
It is blocked in copy_process() when calling threadgroup_change_begin()
because 'cgroup_threadgroup_rwsem' is held by 'memcg_move_char/2860'.

[  409.669856] kthreadd        D ffff88012a64fc20     0     2      0 0x00000000
[  409.669856]  ffff88012a64fc20 ffffffff830aedd0 ffffffff81e0b540 ffff88012a648040
[  409.669856]  ffff88012a650000 ffffffff830aedb8 ffffffff830aedd0 ffff88012a648040
[  409.669856]  0000000000000000 ffff88012a64fc38 ffffffff8195c77c ffff88012a648040
[  409.669856] Call Trace:
[  409.669856]  [<ffffffff8195c77c>] schedule+0x3c/0x90
[  409.669856]  [<ffffffff8196070b>] rwsem_down_read_failed+0xcb/0x120
[  409.669856]  [<ffffffff81452e38>] call_rwsem_down_read_failed+0x18/0x30
[  409.669856]  [<ffffffff810c69be>] percpu_down_read+0x5e/0x80
[  409.669856]  [<ffffffff8106b235>] ? copy_process.part.30+0x555/0x1d30
[  409.669856]  [<ffffffff8106b235>] copy_process.part.30+0x555/0x1d30
[  409.669856]  [<ffffffff810cafa0>] ? __lock_acquire+0xab0/0x1ad0
[  409.669856]  [<ffffffff81093cf0>] ? kthread_create_on_node+0x200/0x200
[  409.669856]  [<ffffffff810ca0f9>] ? trace_hardirqs_on_caller+0xf9/0x1c0
[  409.669856]  [<ffffffff8106cbdc>] _do_fork+0xdc/0x6c0
[  409.669856]  [<ffffffff81094aa5>] ? kthreadd+0x2c5/0x380
[  409.669856]  [<ffffffff8106d1e9>] kernel_thread+0x29/0x30
[  409.669856]  [<ffffffff81094b01>] kthreadd+0x321/0x380
[  409.669856]  [<ffffffff81962632>] ? ret_from_fork+0x22/0x50
[  409.669856]  [<ffffffff81962632>] ret_from_fork+0x22/0x50
[  409.669856]  [<ffffffff810947e0>] ? kthread_create_on_cpu+0x60/0x60


By other words, "memcg_move_char/2860" flushes a work. But it cannot
get flushed because one worker is blocked and another one could not
get created. All these operations are blocked by the very same
"memcg_move_char/2860".

Note that also "systemd/1" is waiting for "cgroup_mutex" in
proc_cgroup_show(). But it seems that it is not in the main
cycle causing the deadlock.

I am able to reproduce this problem quite easily (within few minutes).
There are often even more tasks waiting for the cgroups-related locks
but they are not causing the deadlock.


The question is how to solve this problem. I see several possibilities:

  + avoid using workqueues in lru_add_drain_all()

  + make lru_add_drain_all() killable and restartable

  + do not block fork() when lru_add_drain_all() is running,
    e.g. using some lazy techniques like RCU, workqueues

  + at least do not block fork of workers; AFAIK, they have a limited
     cgroups usage anyway because they are marked with PF_NO_SETAFFINITY


I am willing to test any potential fix or even work on the fix.
But I do not have that big insight into the problem, so I would
need some pointers.


[*] It comes from the LTP test suite. The relevant sources might
be found at
https://github.com/linux-test-project/ltp/blob/master/testcases/kernel/controllers/memcg/functional/memcg_move_charge_at_immigrate_test.sh
https://github.com/linux-test-project/ltp/blob/master/testcases/kernel/controllers/memcg/functional/memcg_lib.sh
https://github.com/linux-test-project/ltp/blob/master/testcases/kernel/controllers/memcg/functional/memcg_process.c

[**] Some of the details are not visible from the provided log. We have first
reproduced this problem with an internal kernel based on the upstream 4.4.
I checked more details using a crash dump. Then I reproduced the same
deadlock with plain 4.6-rc3 and rather used logs from this kernel
in this mail.


Best Regards,
Petr
