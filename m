Received: from va-2-17.ptr.blmpb.com (va-2-17.ptr.blmpb.com [209.127.231.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A01E25B0B3
	for <cgroups@vger.kernel.org>; Mon,  3 Aug 2026 05:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785736095; cv=none; b=PymTm7Gxm3OqWwoH5ZMsGrAYxr16OQAPTTUot5qJbTGUvoUqEj2duku8d4DiOpu+B+EVmL9gg+JaQf6bktXEh+7j4HO29GrRwJMaxn/uFsnHp8hgHlROC2yb4oUmiSnV5YmcqoGVSKXxffDx3kGV898Edco49cfJ/NLENGmQcr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785736095; c=relaxed/simple;
	bh=EauQ9BghjqSxLhzXyJ3noC34EMWxmypsFHlJG7gXHYo=;
	h=To:From:Content-Type:References:Subject:Mime-Version:In-Reply-To:
	 Date:Message-Id; b=SK0pRnHJgRwI7U+rrgre98+bn0FCftBzWJvRR9f+JDTs29QwsFmGoM2j/RW1fUbNEEUfihMLNOzTfRoFryU1j21/uDIjZBQAT7fPh1ufmrmGGE9OC7PVPUNSiDMrU3y3StqcJg0u8NBFr/6nR+yksgxv+CUGfMBtMauOZQvps6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=jHCmBqwz; arc=none smtp.client-ip=209.127.231.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="jHCmBqwz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1785736086;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=3hQ7eOEVWE3uTMjC79at0GsUxBojp7MvHxsTMIuP8jg=;
 b=jHCmBqwzU7ILM3+1hSXyLDj0fAl1HjAmlODBpWZmkQjvqcuEyvC3mXQd+2avA1SKTl8bCg
 FoP+wk8VVDdTq+SUFfd+pP1xfGwmC5OMvrTbw6db97Q+N5o2607z7ftVxppB5Kyc84Z8lt
 211IlUJBeZFUVYi3aHo/HKNTybOhVvRcH2ht8DRnzsaxhJrQbegb0DZCYZ7kPiymm+5kpx
 sP5aTlSrYPqGgttcdeZ/+N5i9i9p4tTrlh3rphH2AdsWhQGhzEXgo4Nnloj9Rt+BBZ5g7+
 RP8dsLittBIOdjZ1HcurhJ/fgVNcm4AMKh8WKl3sPpeJNcZ9WcR/v34fj3CA2A==
To: "syzbot" <syzbot+14254d81dd19ba7d7e41@syzkaller.appspotmail.com>, 
	<axboe@kernel.dk>, <cgroups@vger.kernel.org>, <josef@toxicpanda.com>, 
	<linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<syzkaller-bugs@googlegroups.com>, <tj@kernel.org>
User-Agent: Mozilla Thunderbird
From: "yu kuai" <yukuai@fygo.io>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <6a6e8a06.6ce73036.24301b.0015.GAE@google.com>
Reply-To: yukuai@fygo.io
Subject: Re: [syzbot] [block?] [cgroups?] possible deadlock in blkcg_deactivate_policy (2)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Original-From: yu kuai <yukuai@fygo.io>
In-Reply-To: <6a6e8a06.6ce73036.24301b.0015.GAE@google.com>
Date: Mon, 3 Aug 2026 13:48:01 +0800
Message-Id: <a2f6ddd2-057b-457b-a8d4-c3a2c10c1651@fygo.io>
Received: from [192.168.1.104] ([39.182.0.181]) by smtp.larksuite.com with ESMTPS; Mon, 03 Aug 2026 05:48:05 +0000
X-Lms-Return-Path: <lba+26a702b95+6582be+vger.kernel.org+yukuai@fygo.io>

Hi,

=E5=9C=A8 2026/8/2 8:06, syzbot =E5=86=99=E9=81=93:
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    3708dd948844 Merge tag 'pm-7.2-rc6' of git://git.kernel.o=
r..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=3D11fa7a4958000=
0
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3D145fa60d73086=
782
> dashboard link: https://syzkaller.appspot.com/bug?extid=3D14254d81dd19ba7=
d7e41
> compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for D=
ebian) 2.44
>
> Unfortunately, I don't have any reproducer for this issue yet.
>
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/aa997b3eeef4/dis=
k-3708dd94.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/1ab7e579d11e/vmlinu=
x-3708dd94.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/7038f45d2e15/b=
zImage-3708dd94.xz
>
> IMPORTANT: if you fix the issue, please add the following tag to the comm=
it:
> Reported-by: syzbot+14254d81dd19ba7d7e41@syzkaller.appspotmail.com
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> WARNING: possible circular locking dependency detected
> syzkaller #0 Tainted: G             L
> ------------------------------------------------------
> syz.9.12466/9015 is trying to acquire lock:
> ffff8880283a3bc0 (&q->blkcg_mutex){+.+.}-{4:4}, at: blkcg_deactivate_poli=
cy+0x167/0x600 block/blk-cgroup.c:1681
>
> but task is already holding lock:
> ffff8880553aa8b8 (&eq->sysfs_lock){+.+.}-{4:4}, at: elevator_exit+0x88/0x=
f0 block/elevator.c:160
>
> which lock already depends on the new lock.
>
>
> the existing dependency chain (in reverse order) is:
>
> -> #5 (&eq->sysfs_lock){+.+.}-{4:4}:
>         lock_acquire kernel/locking/lockdep.c:5868 [inline]
>         lock_acquire+0x1b9/0x370 kernel/locking/lockdep.c:5825
>         __mutex_lock_common kernel/locking/mutex.c:646 [inline]
>         __mutex_lock+0x1a4/0x1bd0 kernel/locking/mutex.c:821
>         elevator_exit+0x88/0xf0 block/elevator.c:160
>         elevator_switch+0x3a7/0x7e0 block/elevator.c:580
>         elevator_change+0x352/0x530 block/elevator.c:681
>         elevator_set_none+0x92/0xf0 block/elevator.c:769
>         blk_unregister_queue+0x178/0x310 block/blk-sysfs.c:1073
>         __del_gendisk+0x2e3/0xb20 block/genhd.c:739
>         del_gendisk+0x10e/0x1b0 block/genhd.c:819
>         loop_remove drivers/block/loop.c:2112 [inline]
>         loop_control_remove drivers/block/loop.c:2171 [inline]
>         loop_control_ioctl+0x4f8/0x620 drivers/block/loop.c:2213
>         vfs_ioctl fs/ioctl.c:51 [inline]
>         __do_sys_ioctl fs/ioctl.c:597 [inline]
>         __se_sys_ioctl fs/ioctl.c:583 [inline]
>         __x64_sys_ioctl+0x18e/0x210 fs/ioctl.c:583
>         do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>         do_syscall_64+0x115/0x870 arch/x86/entry/syscall_64.c:94
>         entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> -> #4 (&q->elevator_lock){+.+.}-{4:4}:
>         lock_acquire kernel/locking/lockdep.c:5868 [inline]
>         lock_acquire+0x1b9/0x370 kernel/locking/lockdep.c:5825
>         __mutex_lock_common kernel/locking/mutex.c:646 [inline]
>         __mutex_lock+0x1a4/0x1bd0 kernel/locking/mutex.c:821
>         elevator_change+0x1bc/0x530 block/elevator.c:679
>         elv_iosched_store+0x3be/0x460 block/elevator.c:826
>         queue_attr_store+0x25f/0x2f0 block/blk-sysfs.c:906
>         sysfs_kf_write+0xf2/0x150 fs/sysfs/file.c:145
>         kernfs_fop_write_iter+0x3e0/0x5f0 fs/kernfs/file.c:345
>         new_sync_write fs/read_write.c:595 [inline]
>         vfs_write+0x6ac/0x1050 fs/read_write.c:687
>         ksys_write+0x12a/0x250 fs/read_write.c:739
>         do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>         do_syscall_64+0x115/0x870 arch/x86/entry/syscall_64.c:94
>         entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> -> #3 (&q->q_usage_counter(io)#17){++++}-{0:0}:
>         lock_acquire kernel/locking/lockdep.c:5868 [inline]
>         lock_acquire+0x1b9/0x370 kernel/locking/lockdep.c:5825
>         blk_alloc_queue+0x610/0x790 block/blk-core.c:504
>         blk_mq_alloc_queue+0x174/0x290 block/blk-mq.c:4420
>         __blk_mq_alloc_disk+0x29/0x120 block/blk-mq.c:4467
>         loop_add+0x498/0xb60 drivers/block/loop.c:2041
>         loop_init+0x1d3/0x200 drivers/block/loop.c:2280
>         do_one_initcall+0x11d/0x700 init/main.c:1347
>         do_initcall_level init/main.c:1409 [inline]
>         do_initcalls init/main.c:1425 [inline]
>         do_basic_setup init/main.c:1445 [inline]
>         kernel_init_freeable+0x6ea/0x7b0 init/main.c:1658
>         kernel_init+0x1f/0x1e0 init/main.c:1548
>         ret_from_fork+0x72b/0xd50 arch/x86/kernel/process.c:158
>         ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>
> -> #2 (fs_reclaim){+.+.}-{0:0}:
>         lock_acquire kernel/locking/lockdep.c:5868 [inline]
>         lock_acquire+0x1b9/0x370 kernel/locking/lockdep.c:5825
>         __fs_reclaim_acquire mm/page_alloc.c:4329 [inline]
>         fs_reclaim_acquire+0xc4/0x100 mm/page_alloc.c:4343
>         might_alloc include/linux/sched/mm.h:317 [inline]
>         prepare_alloc_pages+0x166/0x5f0 mm/page_alloc.c:5048
>         __alloc_frozen_pages_noprof+0x1af/0x2dc0 mm/page_alloc.c:5293
>         __alloc_pages_noprof+0xb/0x110 mm/page_alloc.c:5338
>         __alloc_pages_node_noprof include/linux/gfp.h:291 [inline]
>         alloc_pages_node_noprof include/linux/gfp.h:318 [inline]
>         pcpu_alloc_pages mm/percpu-vm.c:95 [inline]
>         pcpu_populate_chunk+0x118/0x990 mm/percpu-vm.c:285
>         pcpu_alloc_noprof+0x881/0x1ca0 mm/percpu.c:1876
>         bpf_map_alloc_percpu+0x9a/0xf0 kernel/bpf/syscall.c:584
>         prealloc_init kernel/bpf/hashtab.c:339 [inline]
>         htab_map_alloc+0x1054/0x14e0 kernel/bpf/hashtab.c:639
>         map_create_alloc kernel/bpf/syscall.c:1523 [inline]
>         map_create+0x874/0x3120 kernel/bpf/syscall.c:1640
>         __sys_bpf+0x2a6e/0x4e80 kernel/bpf/syscall.c:6395
>         __do_sys_bpf kernel/bpf/syscall.c:6537 [inline]
>         __se_sys_bpf kernel/bpf/syscall.c:6534 [inline]
>         __x64_sys_bpf+0xce/0x140 kernel/bpf/syscall.c:6534
>         do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>         do_syscall_64+0x115/0x870 arch/x86/entry/syscall_64.c:94
>         entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> -> #1 (pcpu_alloc_mutex){+.+.}-{4:4}:
>         lock_acquire kernel/locking/lockdep.c:5868 [inline]
>         lock_acquire+0x1b9/0x370 kernel/locking/lockdep.c:5825
>         __mutex_lock_common kernel/locking/mutex.c:646 [inline]
>         __mutex_lock+0x1a4/0x1bd0 kernel/locking/mutex.c:821
>         pcpu_alloc_noprof+0xe87/0x1ca0 mm/percpu.c:1788
>         percpu_ref_init+0x37/0x3f0 lib/percpu-refcount.c:72
>         blkg_alloc+0xf0/0xf80 block/blk-cgroup.c:313
>         blkg_conf_prep+0x46e/0xf10 block/blk-cgroup.c:873
>         tg_set_conf.isra.0+0x1ed/0x500 block/blk-throttle.c:1373
>         cgroup_file_write+0x1e6/0x8a0 kernel/cgroup/cgroup.c:4316
>         kernfs_fop_write_iter+0x3e0/0x5f0 fs/kernfs/file.c:345
>         new_sync_write fs/read_write.c:595 [inline]
>         vfs_write+0x6ac/0x1050 fs/read_write.c:687
>         ksys_write+0x12a/0x250 fs/read_write.c:739
>         do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>         do_syscall_64+0x115/0x870 arch/x86/entry/syscall_64.c:94
>         entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> -> #0 (&q->blkcg_mutex){+.+.}-{4:4}:
>         check_prev_add+0xeb/0xe60 kernel/locking/lockdep.c:3165
>         check_prevs_add kernel/locking/lockdep.c:3284 [inline]
>         validate_chain kernel/locking/lockdep.c:3908 [inline]
>         __lock_acquire+0x136c/0x1a40 kernel/locking/lockdep.c:5237
>         lock_acquire kernel/locking/lockdep.c:5868 [inline]
>         lock_acquire+0x1b9/0x370 kernel/locking/lockdep.c:5825
>         __mutex_lock_common kernel/locking/mutex.c:646 [inline]
>         __mutex_lock+0x1a4/0x1bd0 kernel/locking/mutex.c:821
>         blkcg_deactivate_policy+0x167/0x600 block/blk-cgroup.c:1681
>         bfq_exit_queue+0x29d/0x430 block/bfq-iosched.c:7165
>         blk_mq_exit_sched+0x20e/0x4e0 block/blk-mq-sched.c:702
>         elevator_exit+0x93/0xf0 block/elevator.c:161
>         elevator_switch+0x3a7/0x7e0 block/elevator.c:580
>         elevator_change+0x352/0x530 block/elevator.c:681
>         elevator_set_none+0x92/0xf0 block/elevator.c:769
>         blk_unregister_queue+0x178/0x310 block/blk-sysfs.c:1073
>         __del_gendisk+0x2e3/0xb20 block/genhd.c:739
>         del_gendisk+0x10e/0x1b0 block/genhd.c:819
>         loop_remove drivers/block/loop.c:2112 [inline]
>         loop_control_remove drivers/block/loop.c:2171 [inline]
>         loop_control_ioctl+0x4f8/0x620 drivers/block/loop.c:2213
>         vfs_ioctl fs/ioctl.c:51 [inline]
>         __do_sys_ioctl fs/ioctl.c:597 [inline]
>         __se_sys_ioctl fs/ioctl.c:583 [inline]
>         __x64_sys_ioctl+0x18e/0x210 fs/ioctl.c:583
>         do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>         do_syscall_64+0x115/0x870 arch/x86/entry/syscall_64.c:94
>         entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> other info that might help us debug this:
>
> Chain exists of:
>    &q->blkcg_mutex --> &q->elevator_lock --> &eq->sysfs_lock
>
>   Possible unsafe locking scenario:
>
>         CPU0                    CPU1
>         ----                    ----
>    lock(&eq->sysfs_lock);
>                                 lock(&q->elevator_lock);
>                                 lock(&eq->sysfs_lock);
>    lock(&q->blkcg_mutex);

This is a known problem because blkcg allocation can trigger percpu memory =
allocation
with queue frozen. The plan is to move such memory allocation out of queue =
frozen, but
it has to be done after blkg protection is converted to blkcg_mutex.

>
>   *** DEADLOCK ***
>
> 3 locks held by syz.9.12466/9015:
>   #0: ffff8880283cc3a0 (&set->update_nr_hwq_lock){++++}-{4:4}, at: del_ge=
ndisk+0x106/0x1b0 block/genhd.c:818
>   #1: ffff8880283a3d68 (&q->elevator_lock){+.+.}-{4:4}, at: elevator_chan=
ge+0x1bc/0x530 block/elevator.c:679
>   #2: ffff8880553aa8b8 (&eq->sysfs_lock){+.+.}-{4:4}, at: elevator_exit+0=
x88/0xf0 block/elevator.c:160
>
> stack backtrace:
> CPU: 0 UID: 0 PID: 9015 Comm: syz.9.12466 Tainted: G             L      s=
yzkaller #0 PREEMPT(full)
> Tainted: [L]=3DSOFTLOCKUP
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS G=
oogle 07/16/2026
> Call Trace:
>   <TASK>
>   __dump_stack lib/dump_stack.c:94 [inline]
>   dump_stack_lvl+0x100/0x190 lib/dump_stack.c:120
>   print_circular_bug.cold+0x178/0x1c7 kernel/locking/lockdep.c:2043
>   check_noncircular+0x146/0x160 kernel/locking/lockdep.c:2175
>   check_prev_add+0xeb/0xe60 kernel/locking/lockdep.c:3165
>   check_prevs_add kernel/locking/lockdep.c:3284 [inline]
>   validate_chain kernel/locking/lockdep.c:3908 [inline]
>   __lock_acquire+0x136c/0x1a40 kernel/locking/lockdep.c:5237
>   lock_acquire kernel/locking/lockdep.c:5868 [inline]
>   lock_acquire+0x1b9/0x370 kernel/locking/lockdep.c:5825
>   __mutex_lock_common kernel/locking/mutex.c:646 [inline]
>   __mutex_lock+0x1a4/0x1bd0 kernel/locking/mutex.c:821
>   blkcg_deactivate_policy+0x167/0x600 block/blk-cgroup.c:1681
>   bfq_exit_queue+0x29d/0x430 block/bfq-iosched.c:7165
>   blk_mq_exit_sched+0x20e/0x4e0 block/blk-mq-sched.c:702
>   elevator_exit+0x93/0xf0 block/elevator.c:161
>   elevator_switch+0x3a7/0x7e0 block/elevator.c:580
>   elevator_change+0x352/0x530 block/elevator.c:681
>   elevator_set_none+0x92/0xf0 block/elevator.c:769
>   blk_unregister_queue+0x178/0x310 block/blk-sysfs.c:1073
>   __del_gendisk+0x2e3/0xb20 block/genhd.c:739
>   del_gendisk+0x10e/0x1b0 block/genhd.c:819
>   loop_remove drivers/block/loop.c:2112 [inline]
>   loop_control_remove drivers/block/loop.c:2171 [inline]
>   loop_control_ioctl+0x4f8/0x620 drivers/block/loop.c:2213
>   vfs_ioctl fs/ioctl.c:51 [inline]
>   __do_sys_ioctl fs/ioctl.c:597 [inline]
>   __se_sys_ioctl fs/ioctl.c:583 [inline]
>   __x64_sys_ioctl+0x18e/0x210 fs/ioctl.c:583
>   do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>   do_syscall_64+0x115/0x870 arch/x86/entry/syscall_64.c:94
>   entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f266f39e019
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f2670208028 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> RAX: ffffffffffffffda RBX: 00007f266f625fa0 RCX: 00007f266f39e019
> RDX: 0000000000000000 RSI: 0000000000004c81 RDI: 0000000000000003
> RBP: 00007f266f43500c R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f266f626038 R14: 00007f266f625fa0 R15: 00007ffd3333f748
>   </TASK>
>
>
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>
> If the report is already addressed, let syzbot know by replying with:
> #syz fix: exact-commit-title
>
> If you want to overwrite report's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
>
> If the report is a duplicate of another one, reply with:
> #syz dup: exact-subject-of-another-report
>
> If you want to undo deduplication, reply with:
> #syz undup
>
--=20
Thanks,
Kuai
