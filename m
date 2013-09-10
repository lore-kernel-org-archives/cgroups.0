From: "Daisuke Nishimura" <nishimura-YQH0OdQVrdy45+QrQBaojngSJqDPrsil@public.gmane.org>
Subject: [PATCH][BUG] sched/fair: child->se.parent,cfs_rq might point to invalid ones
Date: Tue, 10 Sep 2013 18:16:36 +0900
Message-ID: <039601ceae06$733d3130$59b79390$@mxp.nes.nec.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: ja
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: 'Ingo Molnar' <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, 'Peter Zijlstra' <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: 'LKML' <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, 'cgroups' <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

There is a small race  between copy_process() and cgroup_attach_task()
where child->se.parent,cfs_rq point to invalid(old) ones.

        parent doing fork()      | someone moving the parent to another cgroup
  -------------------------------+---------------------------------------------
    copy_process()
      + dup_task_struct()
        -> parent->se is copied to child->se.
           se.parent,cfs_rq of them point to old ones.

                                     cgroup_attach_task()
                                       + cgroup_task_migrate()
                                         -> parent->cgroup is updated.
                                       + cpu_cgroup_attach()
                                         + sched_move_task()
                                           + task_move_group_fair()
                                             +- set_task_rq()
                                                -> se.parent,cfs_rq of parent
                                                   are updated.

      + cgroup_fork()
        -> parent->cgroup is copied to child->cgroup. (*1)
      + sched_fork()
        + task_fork_fair()
          -> se.parent,cfs_rq of child are accessed
             while they point to old ones. (*2)

In the worst case, this bug can lead to "use-after-free" and cause panic,
because it's new cgroup's refcount that is incremented at (*1),
so the old cgroup(and related data) can be freed before (*2).
In fact, a panic caused by this bug was originally caught in RHEL6.4.

    BUG: unable to handle kernel NULL pointer dereference at (null)
    IP: [<ffffffff81051e3e>] sched_slice+0x6e/0xa0
    PGD 11c7a3067 PUD 11c35f067 PMD 0
    Oops: 0000 [#1] SMP
    last sysfs file: /sys/kernel/mm/ksm/run
    CPU 0
    Modules linked in: nfs lockd fscache auth_rpcgss nfs_acl autofs4 sunrpc ipv6 vhost_net macvtap macvlan tun uinput microcode virtio_balloon 8139too 8139cp mii snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm snd_timer snd soundcore snd_page_alloc virtio_net i2c_piix4 i2c_core ext4 mbcache jbd2 virtio_blk virtio_pci virtio_ring virtio pata_acpi ata_generic ata_piix dm_mirror dm_region_hash dm_log dm_mod [last unloaded: speedstep_lib]

    Pid: 5485, comm: fork_exit Not tainted 2.6.32-358.6.1.el6.x86_64 #1 Red Hat KVM
    RIP: 0010:[<ffffffff81051e3e>]  [<ffffffff81051e3e>] sched_slice+0x6e/0xa0
    RSP: 0018:ffff88011ab37d30  EFLAGS: 00010046
    RAX: 0000000008562577 RBX: ffff880117abf800 RCX: 0000000000000000
    RDX: 0000000000000000 RSI: 0000000000000400 RDI: 00000000002160ec
    RBP: ffff88011ab37d50 R08: 0000000000000401 R09: 0000000000000000
    R10: ffff880108346278 R11: 0000000000000000 R12: ffff88011ab37d30
    R13: ffff880117e5aad8 R14: ffff880119d75a00 R15: ffff88011c1820b8
    FS:  00007f5577a0b700(0000) GS:ffff880028200000(0000) knlGS:0000000000000000
    CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
    CR2: 0000000000000000 CR3: 00000001185ef000 CR4: 00000000000006f0
    DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
    DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
    Process fork_exit (pid: 5485, threadinfo ffff88011ab36000, task ffff88011c182080)
    Stack:
     0000000000000400 00000000003ff004 0000000004216342 ffff880117e5aad8
    <d> ffff88011ab37d70 ffffffff81051f25 ffff880117e5aaa0 ffff880028216700
    <d> ffff88011ab37dc0 ffffffff81056a3a 0000000000000286 000000008103b8ac
    Call Trace:
     [<ffffffff81051f25>] place_entity+0x75/0xa0
     [<ffffffff81056a3a>] task_fork_fair+0xaa/0x160
     [<ffffffff81063c0b>] sched_fork+0x6b/0x140
     [<ffffffff8106c3c2>] copy_process+0x5b2/0x1450
     [<ffffffff81063b49>] ? wake_up_new_task+0xd9/0x130
     [<ffffffff8106d2f4>] do_fork+0x94/0x460
     [<ffffffff81072a9e>] ? sys_wait4+0xae/0x100
     [<ffffffff81009598>] sys_clone+0x28/0x30
     [<ffffffff8100b393>] stub_clone+0x13/0x20
     [<ffffffff8100b072>] ? system_call_fastpath+0x16/0x1b
    Code: 85 c9 48 8b 93 78 01 00 00 74 20 48 8b 33 48 89 c7 e8 07 ff ff ff 48 8b 9b 70 01 00 00 48 85 db 75 db 48 83 c4 10 5b 41 5c c9 c3 <48> 8b 0a 48 89 4d e0 48 8b 52 08 48 89 55 e8 48 8b 13 48 c7 45
    RIP  [<ffffffff81051e3e>] sched_slice+0x6e/0xa0
     RSP <ffff88011ab37d30>
    CR2: 0000000000000000

Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Signed-off-by: Daisuke Nishimura <nishimura-YQH0OdQVrdy45+QrQBaojngSJqDPrsil@public.gmane.org>
---
 kernel/sched/fair.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 68f1609..31cbc15 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5818,11 +5818,15 @@ static void task_fork_fair(struct task_struct *p)
 	cfs_rq = task_cfs_rq(current);
 	curr = cfs_rq->curr;
 
-	if (unlikely(task_cpu(p) != this_cpu)) {
-		rcu_read_lock();
-		__set_task_cpu(p, this_cpu);
-		rcu_read_unlock();
-	}
+	/*
+	 * Not only the cpu but also the task_group of the parent might have
+	 * been changed after parent->se.parent,cfs_rq were copied to
+	 * child->se.parent,cfs_rq. So call __set_task_cpu() to make those
+	 * of child point to valid ones.
+	 */
+	rcu_read_lock();
+	__set_task_cpu(p, this_cpu);
+	rcu_read_unlock();
 
 	update_curr(cfs_rq);
 
-- 
1.7.1

