Received: from mail-oi1-f208.google.com (mail-oi1-f208.google.com [209.85.167.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F81341F5DB
	for <cgroups@vger.kernel.org>; Sat, 15 Aug 2026 14:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786805256; cv=none; b=fIIdJBnwytdRmviJDvxADbhb7d8h1+1yOQpGSqVTqdxi3kVfEGpUKLgCKBqp6vhUVGkeHWzdA9nH5UKV+j02nyLon7uklafZgfKQtqKUz8hW91j1eOjxVH9WO7nx6UtCh3X3P4NhIb+Uzm+5erSwQJNr/PJ+CqwfhjvpJ59WsVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786805256; c=relaxed/simple;
	bh=NvRgjXmbp/QjFwLs8ZR6Q0IHUa7P1KA6y8RlRxUtdUc=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=gXudCi6CEViXEeKDjXkb4PhYhicaZ3n5u15ia4bQhh7AK4UzVVWo6MQ8+2aVHRXYrsavMeHud5BMBXQbbmYSdaUOIZ8/Sl3YxZ+KEdnhsGH/2ncmelyEHAoN6hQ5T77CcO3hcaJKfIeeKX+GnvlP7qJ+JLJyXxNgCWbqTj4G4vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f208.google.com with SMTP id 5614622812f47-49d4cb3ca23so2488290b6e.3
        for <cgroups@vger.kernel.org>; Sat, 15 Aug 2026 07:47:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786805245; x=1787410045;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NxNZUEvj7eltm74yI1Nql6YMM9EbQEY65YzvLdWlJ7o=;
        b=eJdNDSTYotcZ5EW3FhQM6bY2Q6RqknCwtUCSVGHkIiFU7ewq5Ppo1OxFZZxMUlTBzO
         dMr25WObUvMq4bbnILFHoablVDhVuXA2trKBhcKjeIWhaKSFdaUAht2LVeUEBF/4M3B+
         P6XDjBKuz1isWMIjCCMxkrVV5h3bpcx0E19sXN3go8sASHQExozr8/ps4BUs++12PsUv
         xlPs/k5SUSuVbPjhnd2RYqWH2o83ZYN6JqpjiolNTe3wQIEksP3DnM5//wFrQwSo7UjD
         gGA46iY9418Kzv5BHGx5DMRv71hA55fC/nlSE8TV/KkTzObf0Jj03VyNvWq6DrbW+L5q
         878A==
X-Forwarded-Encrypted: i=1; AHgh+RoTEOGdgrZnEmRYa72jTPRxomTKFJjDN+DmTsMEwdtkoTiahZ4XMXv61GDCBicBhk8Kfz25X+Hi@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0gAoCAL0yWYyuWeaEC9GJ0V1QGpVRWN5z+UxpEfO2HBexNr4M
	IcuGNsbcBJFx4PWr0m86xBcwv0xYfReFThVJwAvMTJSkfftH0sqM7Qey4riCoKi0DIwbyuFiPkH
	9UVhfpDoIubW8YFpG44JiRfbFLzJU7Yr71K53fGJEDPEsI4e7GV9zrpe0Dko=
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:6783:b0:492:3ed0:9073 with SMTP id
 5614622812f47-4b240f7f628mr12277261b6e.4.1786805245556; Sat, 15 Aug 2026
 07:47:25 -0700 (PDT)
Date: Sat, 15 Aug 2026 07:47:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a807bfd.f7a79266.2f965f.0008.GAE@google.com>
Subject: [syzbot] [block?] [cgroups?] possible deadlock in blkg_conf_prep
From: syzbot <syzbot+144a1c0e22e53a08ef5a@syzkaller.appspotmail.com>
To: axboe@kernel.dk, cgroups@vger.kernel.org, josef@toxicpanda.com, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com, tj@kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    3d08ff75a47a Add linux-next specific files for 20260810
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=10427879580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5ba0556605934602
dashboard link: https://syzkaller.appspot.com/bug?extid=144a1c0e22e53a08ef5a
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/227afac921c2/disk-3d08ff75.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/236f7cfe0ac3/vmlinux-3d08ff75.xz
kernel image: https://storage.googleapis.com/syzbot-assets/aea89831fd96/bzImage-3d08ff75.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+144a1c0e22e53a08ef5a@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Tainted: G             L     
------------------------------------------------------
syz.6.2908/17662 is trying to acquire lock:
ffffffff8ec88800 (fs_reclaim){+.+.}-{0:0}, at: might_alloc include/linux/sched/mm.h:316 [inline]
ffffffff8ec88800 (fs_reclaim){+.+.}-{0:0}, at: slab_pre_alloc_hook mm/slub.c:4636 [inline]
ffffffff8ec88800 (fs_reclaim){+.+.}-{0:0}, at: slab_alloc_node mm/slub.c:4974 [inline]
ffffffff8ec88800 (fs_reclaim){+.+.}-{0:0}, at: kmem_cache_alloc_noprof+0x5f/0x600 mm/slub.c:5010

but task is already holding lock:
ffff888026b33bc0 (&q->blkcg_mutex){+.+.}-{4:4}, at: blkg_conf_prep+0xa3/0xd80 block/blk-cgroup.c:846

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (&q->blkcg_mutex){+.+.}-{4:4}:
       __mutex_lock_common kernel/locking/mutex.c:646 [inline]
       __mutex_lock+0x19d/0x1550 kernel/locking/mutex.c:821
       blkcg_activate_policy+0x1cb/0x8e0 block/blk-cgroup.c:1595
       blk_throtl_init+0x2f7/0x420 block/blk-throttle.c:1339
       tg_set_conf+0x1db/0x4e0 block/blk-throttle.c:1368
       cgroup_file_write+0x331/0x8f0 kernel/cgroup/cgroup.c:4412
       kernfs_fop_write_iter+0x3a4/0x540 fs/kernfs/file.c:345
       new_sync_write fs/read_write.c:595 [inline]
       vfs_write+0x612/0xba0 fs/read_write.c:687
       ksys_write+0x150/0x270 fs/read_write.c:739
       do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
       do_syscall_64+0x166/0x510 arch/x86/entry/syscall_64.c:84
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #1 (&q->q_usage_counter(io)#17){++++}-{0:0}:
       blk_alloc_queue+0x544/0x690 block/blk-core.c:504
       blk_mq_alloc_queue block/blk-mq.c:4420 [inline]
       __blk_mq_alloc_disk+0x194/0x390 block/blk-mq.c:4467
       loop_add+0x480/0xb40 drivers/block/loop.c:2071
       loop_init+0xd7/0x160 drivers/block/loop.c:2310
       do_one_initcall+0x250/0x870 init/main.c:1359
       do_initcall_level+0x10a/0x1a0 init/main.c:1421
       do_initcalls+0x59/0xa0 init/main.c:1437
       kernel_init_freeable+0x29d/0x3e0 init/main.c:1672
       kernel_init+0x22/0x1d0 init/main.c:1562
       ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

-> #0 (fs_reclaim){+.+.}-{0:0}:
       check_prev_add kernel/locking/lockdep.c:3181 [inline]
       check_prevs_add kernel/locking/lockdep.c:3300 [inline]
       validate_chain kernel/locking/lockdep.c:3924 [inline]
       __lock_acquire+0x15ff/0x2e50 kernel/locking/lockdep.c:5254
       lock_acquire+0x115/0x350 kernel/locking/lockdep.c:5908
       __fs_reclaim_acquire mm/page_alloc.c:4375 [inline]
       fs_reclaim_acquire+0x71/0x100 mm/page_alloc.c:4389
       might_alloc include/linux/sched/mm.h:316 [inline]
       slab_pre_alloc_hook mm/slub.c:4636 [inline]
       slab_alloc_node mm/slub.c:4974 [inline]
       kmem_cache_alloc_noprof+0x5f/0x600 mm/slub.c:5010
       __radix_tree_preload+0x2df/0x870 lib/radix-tree.c:338
       blkg_conf_prep+0x621/0xd80 block/blk-cgroup.c:882
       tg_set_conf+0x20b/0x4e0 block/blk-throttle.c:1373
       cgroup_file_write+0x331/0x8f0 kernel/cgroup/cgroup.c:4412
       kernfs_fop_write_iter+0x3a4/0x540 fs/kernfs/file.c:345
       new_sync_write fs/read_write.c:595 [inline]
       vfs_write+0x612/0xba0 fs/read_write.c:687
       ksys_write+0x150/0x270 fs/read_write.c:739
       do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
       do_syscall_64+0x166/0x510 arch/x86/entry/syscall_64.c:84
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

Chain exists of:
  fs_reclaim --> &q->q_usage_counter(io)#17 --> &q->blkcg_mutex

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&q->blkcg_mutex);
                               lock(&q->q_usage_counter(io)#17);
                               lock(&q->blkcg_mutex);
  lock(fs_reclaim);

 *** DEADLOCK ***

locks held by syz.6.2908/17662: 6, last CPU#0:
 #0: ffff888035aab0b0 (&f->f_pos_lock){+.+.}-{4:4}, at: fdget_pos+0x246/0x320 fs/file.c:1259
 #1: ffff8880767f2460 (sb_writers#10){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:2754 [inline]
 #1: ffff8880767f2460 (sb_writers#10){.+.+}-{0:0}, at: vfs_write+0x22b/0xba0 fs/read_write.c:683
 #2: ffff888068348480 (&of->mutex){+.+.}-{4:4}, at: kernfs_fop_write_iter+0x1d8/0x540 fs/kernfs/file.c:336
 #3: ffff888064aeab48 (kn->active#70){.+.+}-{0:0}, at: kernfs_get_active_of fs/kernfs/file.c:73 [inline]
 #3: ffff888064aeab48 (kn->active#70){.+.+}-{0:0}, at: kernfs_fop_write_iter+0x22b/0x540 fs/kernfs/file.c:337
 #4: ffff888026b33a40 (&q->rq_qos_mutex){+.+.}-{4:4}, at: blkg_conf_open_bdev+0x2a8/0x3c0 block/blk-cgroup.c:803
 #5: ffff888026b33bc0 (&q->blkcg_mutex){+.+.}-{4:4}, at: blkg_conf_prep+0xa3/0xd80 block/blk-cgroup.c:846

stack backtrace:
CPU: 0 UID: 0 PID: 17662 Comm: syz.6.2908 Tainted: G             L      syzkaller #0 PREEMPT(full) 
Tainted: [L]=SOFTLOCKUP
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/24/2026
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_circular_bug+0x2e2/0x300 kernel/locking/lockdep.c:2059
 check_noncircular+0x12f/0x150 kernel/locking/lockdep.c:2191
 check_prev_add kernel/locking/lockdep.c:3181 [inline]
 check_prevs_add kernel/locking/lockdep.c:3300 [inline]
 validate_chain kernel/locking/lockdep.c:3924 [inline]
 __lock_acquire+0x15ff/0x2e50 kernel/locking/lockdep.c:5254
 lock_acquire+0x115/0x350 kernel/locking/lockdep.c:5908
 __fs_reclaim_acquire mm/page_alloc.c:4375 [inline]
 fs_reclaim_acquire+0x71/0x100 mm/page_alloc.c:4389
 might_alloc include/linux/sched/mm.h:316 [inline]
 slab_pre_alloc_hook mm/slub.c:4636 [inline]
 slab_alloc_node mm/slub.c:4974 [inline]
 kmem_cache_alloc_noprof+0x5f/0x600 mm/slub.c:5010
 __radix_tree_preload+0x2df/0x870 lib/radix-tree.c:338
 blkg_conf_prep+0x621/0xd80 block/blk-cgroup.c:882
 tg_set_conf+0x20b/0x4e0 block/blk-throttle.c:1373
 cgroup_file_write+0x331/0x8f0 kernel/cgroup/cgroup.c:4412
 kernfs_fop_write_iter+0x3a4/0x540 fs/kernfs/file.c:345
 new_sync_write fs/read_write.c:595 [inline]
 vfs_write+0x612/0xba0 fs/read_write.c:687
 ksys_write+0x150/0x270 fs/read_write.c:739
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x510 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f1a06d9e0d9
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f1a07bcb028 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 00007f1a07025fa0 RCX: 00007f1a06d9e0d9
RDX: 000000000000006a RSI: 00002000000000c0 RDI: 0000000000000008
RBP: 00007f1a06e35024 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f1a07026038 R14: 00007f1a07025fa0 R15: 00007ffdd2d5d118
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
