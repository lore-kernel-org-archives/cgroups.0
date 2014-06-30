From: Li Zefan <lizefan@huawei.com>
Subject: [BUG] cpuset: lockdep warning
Date: Mon, 30 Jun 2014 11:46:21 +0800
Message-ID: <53B0DD8D.5060805@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>

Hi Tejun,

In this lockdep warning kernfs and workqueue are involved, so I'm not sure what's
happening here.

This was triggered when tasks were being moved to parent cpuset due to hotplug.
The kernel is 3.16-rc1, with no modification.

localhost:/ # mount -t cgroup -o cpuset xxx /cpuset
localhost:/ # mkdir /cpuset/tmp
localhost:/ # echo 1 > /cpuset/tmp/cpuset.cpus
localhost:/ # echo 0 > cpuset/tmp/cpuset.mems
localhost:/ # echo $$ > /cpuset/tmp/tasks
localhost:/ # echo 0 > /sys/devices/system/cpu/cpu1/online


[ 1810.292243] ======================================================
[ 1810.292251] [ INFO: possible circular locking dependency detected ]
[ 1810.292259] 3.16.0-rc1-0.1-default+ #7 Not tainted
[ 1810.292266] -------------------------------------------------------
[ 1810.292273] kworker/1:0/32649 is trying to acquire lock:
[ 1810.292280]  (cgroup_mutex){+.+.+.}, at: [<ffffffff8110e3d7>] cgroup_transfer_tasks+0x37/0x150
[ 1810.292300]
[ 1810.292300] but task is already holding lock:
[ 1810.292309]  (cpuset_hotplug_work){+.+...}, at: [<ffffffff81085412>] process_one_work+0x192/0x520
[ 1810.292327]
[ 1810.292327] which lock already depends on the new lock.
[ 1810.292327]
[ 1810.292339]
[ 1810.292339] the existing dependency chain (in reverse order) is:
[ 1810.292348]
[ 1810.292348] -> #2 (cpuset_hotplug_work){+.+...}:
[ 1810.292360]        [<ffffffff810c4ee6>] validate_chain+0x656/0x7c0
[ 1810.292371]        [<ffffffff810c53d2>] __lock_acquire+0x382/0x660
[ 1810.292380]        [<ffffffff810c57a9>] lock_acquire+0xf9/0x170
[ 1810.292389]        [<ffffffff810862b9>] flush_work+0x39/0x90
[ 1810.292398]        [<ffffffff811158b1>] cpuset_write_resmask+0x51/0x120
[ 1810.292409]        [<ffffffff8110cc39>] cgroup_file_write+0x49/0x1f0
[ 1810.292419]        [<ffffffff81286c7d>] kernfs_fop_write+0xfd/0x190
[ 1810.292431]        [<ffffffff81204a15>] vfs_write+0xe5/0x190
[ 1810.292443]        [<ffffffff8120545c>] SyS_write+0x5c/0xc0
[ 1810.292452]        [<ffffffff815acb92>] system_call_fastpath+0x16/0x1b
[ 1810.292464]
[ 1810.292464] -> #1 (s_active#175){++++.+}:
[ 1810.292476]        [<ffffffff810c4ee6>] validate_chain+0x656/0x7c0
[ 1810.292486]        [<ffffffff810c53d2>] __lock_acquire+0x382/0x660
[ 1810.292495]        [<ffffffff810c57a9>] lock_acquire+0xf9/0x170
[ 1810.292504]        [<ffffffff812848eb>] kernfs_drain+0x13b/0x1c0
[ 1810.292513]        [<ffffffff81285418>] __kernfs_remove+0xc8/0x220
[ 1810.292523]        [<ffffffff812855c0>] kernfs_remove_by_name_ns+0x50/0xb0
[ 1810.292533]        [<ffffffff8110802e>] cgroup_addrm_files+0x16e/0x290
[ 1810.292543]        [<ffffffff811081bd>] cgroup_clear_dir+0x6d/0xa0
[ 1810.292552]        [<ffffffff8110c30f>] rebind_subsystems+0x10f/0x350
[ 1810.292562]        [<ffffffff8110f2cf>] cgroup_setup_root+0x1bf/0x290
[ 1810.292571]        [<ffffffff8110f4c3>] cgroup_mount+0x123/0x3d0
[ 1810.292581]        [<ffffffff81208b7d>] mount_fs+0x4d/0x1a0
[ 1810.292591]        [<ffffffff8122b439>] vfs_kern_mount+0x79/0x160
[ 1810.292602]        [<ffffffff8122be69>] do_new_mount+0xd9/0x200
[ 1810.292611]        [<ffffffff8122cadc>] do_mount+0x1dc/0x220
[ 1810.292621]        [<ffffffff8122cbdc>] SyS_mount+0xbc/0xe0
[ 1810.292630]        [<ffffffff815acb92>] system_call_fastpath+0x16/0x1b
[ 1810.292640]
[ 1810.292640] -> #0 (cgroup_mutex){+.+.+.}:
[ 1810.292651]        [<ffffffff810c481e>] check_prev_add+0x43e/0x4b0
[ 1810.292660]        [<ffffffff810c4ee6>] validate_chain+0x656/0x7c0
[ 1810.292669]        [<ffffffff810c53d2>] __lock_acquire+0x382/0x660
[ 1810.292678]        [<ffffffff810c57a9>] lock_acquire+0xf9/0x170
[ 1810.292687]        [<ffffffff815aa13f>] mutex_lock_nested+0x6f/0x380
[ 1810.292697]        [<ffffffff8110e3d7>] cgroup_transfer_tasks+0x37/0x150
[ 1810.292707]        [<ffffffff811129c0>] hotplug_update_tasks_insane+0x110/0x1d0
[ 1810.292718]        [<ffffffff81112bbd>] cpuset_hotplug_update_tasks+0x13d/0x180
[ 1810.292729]        [<ffffffff811148ec>] cpuset_hotplug_workfn+0x18c/0x630
[ 1810.292739]        [<ffffffff810854d4>] process_one_work+0x254/0x520
[ 1810.292748]        [<ffffffff810875dd>] worker_thread+0x13d/0x3d0
[ 1810.292758]        [<ffffffff8108e0c8>] kthread+0xf8/0x100
[ 1810.292768]        [<ffffffff815acaec>] ret_from_fork+0x7c/0xb0
[ 1810.292778]
[ 1810.292778] other info that might help us debug this:
[ 1810.292778]
[ 1810.292789] Chain exists of:
[ 1810.292789]   cgroup_mutex --> s_active#175 --> cpuset_hotplug_work
[ 1810.292789]
[ 1810.292807]  Possible unsafe locking scenario:
[ 1810.292807]
[ 1810.292816]        CPU0                    CPU1
[ 1810.292822]        ----                    ----
[ 1810.292827]   lock(cpuset_hotplug_work);
[ 1810.292835]                                lock(s_active#175);
[ 1810.292845]                                lock(cpuset_hotplug_work);
[ 1810.292855]   lock(cgroup_mutex);
[ 1810.292862]
[ 1810.292862]  *** DEADLOCK ***
[ 1810.292862]
[ 1810.292872] 2 locks held by kworker/1:0/32649:
[ 1810.292878]  #0:  ("events"){.+.+.+}, at: [<ffffffff81085412>] process_one_work+0x192/0x520
[ 1810.292895]  #1:  (cpuset_hotplug_work){+.+...}, at: [<ffffffff81085412>] process_one_work+0x192/0x520
[ 1810.292911]
[ 1810.292911] stack backtrace:
[ 1810.292920] CPU: 1 PID: 32649 Comm: kworker/1:0 Not tainted 3.16.0-rc1-0.1-default+ #7
[ 1810.292929] Hardware name: Huawei Technologies Co., Ltd. Tecal RH2285          /BC11BTSA              , BIOS CTSAV036 04/27/2011
[ 1810.292943] Workqueue: events cpuset_hotplug_workfn
[ 1810.292951]  ffffffff824b01e0 ffff8800afdd3918 ffffffff815a5f78 ffff8800afdd3958
[ 1810.292964]  ffffffff810c263f 000000001d1fa490 ffff8800afdd3978 ffff88061d1fa490
[ 1810.292976]  0000000000000000 ffff88061d1fad08 ffff88061d1fad40 ffff8800afdd39f8
[ 1810.292989] Call Trace:
[ 1810.292998]  [<ffffffff815a5f78>] dump_stack+0x72/0x8a
[ 1810.293010]  [<ffffffff810c263f>] print_circular_bug+0x10f/0x120
[ 1810.293019]  [<ffffffff810c481e>] check_prev_add+0x43e/0x4b0
[ 1810.293029]  [<ffffffff810c4ee6>] validate_chain+0x656/0x7c0
[ 1810.293038]  [<ffffffff810c53d2>] __lock_acquire+0x382/0x660
[ 1810.293047]  [<ffffffff810c57a9>] lock_acquire+0xf9/0x170
[ 1810.293056]  [<ffffffff8110e3d7>] ? cgroup_transfer_tasks+0x37/0x150
[ 1810.293066]  [<ffffffff815aa13f>] mutex_lock_nested+0x6f/0x380
[ 1810.293075]  [<ffffffff8110e3d7>] ? cgroup_transfer_tasks+0x37/0x150
[ 1810.293085]  [<ffffffff8110e3d7>] ? cgroup_transfer_tasks+0x37/0x150
[ 1810.293096]  [<ffffffff810a68f3>] ? local_clock+0x13/0x30
[ 1810.293104]  [<ffffffff810c3595>] ? lock_release_holdtime+0x35/0x230
[ 1810.293114]  [<ffffffff8110e3d7>] cgroup_transfer_tasks+0x37/0x150
[ 1810.293124]  [<ffffffff810c40dd>] ? trace_hardirqs_on_caller+0x14d/0x1f0
[ 1810.293134]  [<ffffffff810c418d>] ? trace_hardirqs_on+0xd/0x10
[ 1810.293144]  [<ffffffff811129c0>] hotplug_update_tasks_insane+0x110/0x1d0
[ 1810.293154]  [<ffffffff81112bbd>] cpuset_hotplug_update_tasks+0x13d/0x180
[ 1810.293165]  [<ffffffff811148ec>] cpuset_hotplug_workfn+0x18c/0x630
[ 1810.293175]  [<ffffffff811149b0>] ? cpuset_hotplug_workfn+0x250/0x630
[ 1810.293185]  [<ffffffff810854d4>] process_one_work+0x254/0x520
[ 1810.293194]  [<ffffffff81085412>] ? process_one_work+0x192/0x520
[ 1810.293204]  [<ffffffff810875dd>] worker_thread+0x13d/0x3d0
[ 1810.293214]  [<ffffffff810874a0>] ? maybe_create_worker+0x190/0x190
[ 1810.293223]  [<ffffffff8108e0c8>] kthread+0xf8/0x100
[ 1810.293233]  [<ffffffff8108dfd0>] ? __init_kthread_worker+0x70/0x70
[ 1810.293242]  [<ffffffff815acaec>] ret_from_fork+0x7c/0xb0
[ 1810.293251]  [<ffffffff8108dfd0>] ? __init_kthread_worker+0x70/0x70
[ 1810.317270] numa_remove_cpu cpu 1 node 0: mask now 0,2-3,8-11
[ 1810.318776] smpboot: CPU 1 is now offline
