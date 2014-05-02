From: Sasha Levin <sasha.levin@oracle.com>
Subject: blkcg: circular dependency between blkcg_pol_mutex and s_active
Date: Fri, 02 May 2014 11:56:59 -0400
Message-ID: <5363C04B.4010400@oracle.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>, axboe@kernel.dk, Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>, cgroups@vger.kernel.org

Hi all,

While fuzzing with trinity inside a KVM tools guest running the latest -next
kernel I've stumbled on the following:

[ 1585.219328] ======================================================
[ 1585.220035] [ INFO: possible circular locking dependency detected ]
[ 1585.220035] 3.15.0-rc3-next-20140430-sasha-00016-g4e281fa-dirty #429 Tainted: G        W
[ 1585.220035] -------------------------------------------------------
[ 1585.220035] trinity-c173/9024 is trying to acquire lock:
[ 1585.220035] (blkcg_pol_mutex){+.+.+.}, at: blkcg_reset_stats (include/linux/spinlock.h:328 block/blk-cgroup.c:455)
[ 1585.220035]
[ 1585.220035] but task is already holding lock:
[ 1585.220035] (s_active#89){++++.+}, at: kernfs_fop_write (fs/kernfs/file.c:283)
[ 1585.220035]
[ 1585.220035] which lock already depends on the new lock.
[ 1585.220035]
[ 1585.220035]
[ 1585.220035] the existing dependency chain (in reverse order) is:
[ 1585.220035]
-> #2 (s_active#89){++++.+}:
[ 1585.220035] lock_acquire (arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3602)
[ 1585.220035] __kernfs_remove (arch/x86/include/asm/atomic.h:27 fs/kernfs/dir.c:352 fs/kernfs/dir.c:1024)
[ 1585.220035] kernfs_remove_by_name_ns (fs/kernfs/dir.c:1219)
[ 1585.220035] cgroup_addrm_files (include/linux/kernfs.h:427 kernel/cgroup.c:1074 kernel/cgroup.c:2899)
[ 1585.220035] cgroup_clear_dir (kernel/cgroup.c:1092 (discriminator 2))
[ 1585.240173] rebind_subsystems (kernel/cgroup.c:1144)
[ 1585.240173] cgroup_setup_root (kernel/cgroup.c:1568)
[ 1585.240173] cgroup_mount (kernel/cgroup.c:1716)
[ 1585.240173] mount_fs (fs/super.c:1094)
[ 1585.240173] vfs_kern_mount (fs/namespace.c:899)
[ 1585.240173] do_mount (fs/namespace.c:2238 fs/namespace.c:2561)
[ 1585.240173] SyS_mount (fs/namespace.c:2758 fs/namespace.c:2729)
[ 1585.240173] tracesys (arch/x86/kernel/entry_64.S:746)
[ 1585.240173]
-> #1 (cgroup_tree_mutex){+.+.+.}:
[ 1585.240173] lock_acquire (arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3602)
[ 1585.240173] mutex_lock_nested (kernel/locking/mutex.c:486 kernel/locking/mutex.c:587)
[ 1585.240173] cgroup_add_cftypes (include/linux/list.h:76 kernel/cgroup.c:3040)
[ 1585.240173] blkcg_policy_register (block/blk-cgroup.c:1106)
[ 1585.240173] throtl_init (block/blk-throttle.c:1694)
[ 1585.240173] do_one_initcall (init/main.c:789)
[ 1585.240173] kernel_init_freeable (init/main.c:854 init/main.c:863 init/main.c:882 init/main.c:1003)
[ 1585.240173] kernel_init (init/main.c:935)
[ 1585.240173] ret_from_fork (arch/x86/kernel/entry_64.S:552)
[ 1585.240173]
-> #0 (blkcg_pol_mutex){+.+.+.}:
[ 1585.240173] __lock_acquire (kernel/locking/lockdep.c:1840 kernel/locking/lockdep.c:1945 kernel/locking/lockdep.c:2131 kernel/locking/lockdep.c:3182)
[ 1585.240173] lock_acquire (arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3602)
[ 1585.240173] mutex_lock_nested (kernel/locking/mutex.c:486 kernel/locking/mutex.c:587)
[ 1585.240173] blkcg_reset_stats (include/linux/spinlock.h:328 block/blk-cgroup.c:455)
[ 1585.240173] cgroup_file_write (kernel/cgroup.c:2714)
[ 1585.240173] kernfs_fop_write (fs/kernfs/file.c:295)
[ 1585.240173] vfs_write (fs/read_write.c:532)
[ 1585.240173] SyS_write (fs/read_write.c:584 fs/read_write.c:576)
[ 1585.240173] tracesys (arch/x86/kernel/entry_64.S:746)
[ 1585.240173]
[ 1585.240173] other info that might help us debug this:
[ 1585.240173]
[ 1585.240173] Chain exists of:
blkcg_pol_mutex --> cgroup_tree_mutex --> s_active#89

[ 1585.240173]  Possible unsafe locking scenario:
[ 1585.240173]
[ 1585.240173]        CPU0                    CPU1
[ 1585.240173]        ----                    ----
[ 1585.240173]   lock(s_active#89);
[ 1585.240173]                                lock(cgroup_tree_mutex);
[ 1585.240173]                                lock(s_active#89);
[ 1585.240173]   lock(blkcg_pol_mutex);
[ 1585.240173]
[ 1585.240173]  *** DEADLOCK ***
[ 1585.240173]
[ 1585.240173] 4 locks held by trinity-c173/9024:
[ 1585.240173] #0: (&f->f_pos_lock){+.+.+.}, at: __fdget_pos (fs/file.c:714)
[ 1585.240173] #1: (sb_writers#18){.+.+.+}, at: vfs_write (include/linux/fs.h:2255 fs/read_write.c:530)
[ 1585.240173] #2: (&of->mutex){+.+.+.}, at: kernfs_fop_write (fs/kernfs/file.c:283)
[ 1585.240173] #3: (s_active#89){++++.+}, at: kernfs_fop_write (fs/kernfs/file.c:283)
[ 1585.240173]
[ 1585.240173] stack backtrace:
[ 1585.240173] CPU: 3 PID: 9024 Comm: trinity-c173 Tainted: G        W     3.15.0-rc3-next-20140430-sasha-00016-g4e281fa-dirty #429
[ 1585.240173]  ffffffff919687b0 ffff8805f6373bb8 ffffffff8e52cdbb 0000000000000002
[ 1585.240173]  ffffffff919d8400 ffff8805f6373c08 ffffffff8e51fb88 0000000000000004
[ 1585.240173]  ffff8805f6373c98 ffff8805f6373c08 ffff88061be70d98 ffff88061be70dd0
[ 1585.240173] Call Trace:
[ 1585.240173] dump_stack (lib/dump_stack.c:52)
[ 1585.240173] print_circular_bug (kernel/locking/lockdep.c:1216)
[ 1585.240173] __lock_acquire (kernel/locking/lockdep.c:1840 kernel/locking/lockdep.c:1945 kernel/locking/lockdep.c:2131 kernel/locking/lockdep.c:3182)
[ 1585.240173] ? sched_clock (arch/x86/include/asm/paravirt.h:192 arch/x86/kernel/tsc.c:305)
[ 1585.240173] ? sched_clock_local (kernel/sched/clock.c:214)
[ 1585.240173] lock_acquire (arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3602)
[ 1585.240173] ? blkcg_reset_stats (include/linux/spinlock.h:328 block/blk-cgroup.c:455)
[ 1585.240173] mutex_lock_nested (kernel/locking/mutex.c:486 kernel/locking/mutex.c:587)
[ 1585.240173] ? blkcg_reset_stats (include/linux/spinlock.h:328 block/blk-cgroup.c:455)
[ 1585.240173] ? get_parent_ip (kernel/sched/core.c:2485)
[ 1585.240173] ? get_parent_ip (kernel/sched/core.c:2485)
[ 1585.240173] ? blkcg_reset_stats (include/linux/spinlock.h:328 block/blk-cgroup.c:455)
[ 1585.240173] ? preempt_count_sub (kernel/sched/core.c:2541)
[ 1585.240173] blkcg_reset_stats (include/linux/spinlock.h:328 block/blk-cgroup.c:455)
[ 1585.240173] cgroup_file_write (kernel/cgroup.c:2714)
[ 1585.240173] ? cgroup_file_write (kernel/cgroup.c:2692)
[ 1585.240173] kernfs_fop_write (fs/kernfs/file.c:295)
[ 1585.240173] vfs_write (fs/read_write.c:532)
[ 1585.240173] SyS_write (fs/read_write.c:584 fs/read_write.c:576)


Thanks,
Sasha
