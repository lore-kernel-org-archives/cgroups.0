Received: from mail-oi2-f0.google.com (mail-oi2-f0.google.com [74.125.231.192])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF1551514F8
	for <cgroups@vger.kernel.org>; Sat, 29 Aug 2026 00:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.192
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787963616; cv=none; b=VMTiFLG25xm+KdY39Gbyk6EP0ddaegu/DYhEW7GKT3HfaiY9Ci6rNYAVaehPSV6X4HI/CbKQFyUljLxMcYmUS7wnBB7W8VWh3/Tt43ImF8FERJ8pEnkxwZuJ2lCXik7iyOX6hdKcDAchZpG3GhdbY08AiQFY2ufshm/Ql+VTq4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787963616; c=relaxed/simple;
	bh=nkPhFdgmWtXtAyV4iyyrZcCvowT2KbVn3gNKW2Yrtfc=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=Rben+zXG/3euAhVvKFOC1d/I8TaJDrKzGR3wRw07F4T8cJ3Mbo6JYNnzDG+0vxELN1yJiot7UVmV9RF8PmwGngSYAO3/nGM8AD2snT53vFIKDIaRHG1TWbZbMcF0+roR9lvmgGCM3UYT77uwSM+JzGxRDNz0eJscgg8Rv0NuKSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=74.125.231.192
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi2-f0.google.com with SMTP id 5614622812f47-4a49b13b745so543612b6e.0
        for <cgroups@vger.kernel.org>; Fri, 28 Aug 2026 17:33:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787963613; x=1788568413;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=IlIMu5bgBCnFIxaX2eV5zuV1R2iOSwt6vufRHu6k+8k=;
        b=dt5JxmhuxSIW/ksyDkpevROxlf5Daoklrj6Cs1j2nhUAODCOrH0FhkBCco7www+ymR
         2f6fHcnTlTs1XAoMSx78/FvUl/0arsmKk/fTAETrICGAN1EvROgOTjtZp2fPkq5yTPZH
         80AuPrN+2urh0nlkdum//vimOpXa9VS/H9gF/IGZi3m2dEMtMrb5hWoU88qakmqUgVOM
         AleHtvs6BGeqlYxpxkpFVK2jSm5DWghn4cbZOuAa+vhxW4iTuutfazM9+iZSs3axruj0
         hfe4T5hswBRWeZBi3zaBQ7RU8GOjhQRUJ2Yh/oohBk8OrK92ZCSax5D+UyFlqneddu6/
         1E3g==
X-Forwarded-Encrypted: i=1; AHgh+RptTxeLNhNy1koXhaAivUtkAwBKKPloyXxxK8qlvNne31wk5NLvd/zzTC1Fu9d7nezW9tO2WQeh@vger.kernel.org
X-Gm-Message-State: AFuF++kLoci48N17UDFCxGsGiamZphnm9DIJ3KSBpoUDG+ynlQyJPdBR
	PgNFMscBBNnja8x3pgPAciiEA+OT29wFQkqbtWWFn3KnmcoEgdRh/KdpXMwSg3twqvVveQQsUtx
	FELi3neuuqqmTbyv2jc3/551wzLCh7UOsa5yIC6hxkTG38vuBL7tHT8Eee/k=
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1306:b0:4b3:80b8:8741 with SMTP id
 5614622812f47-4b39804f929mr11891424b6e.5.1787963613752; Fri, 28 Aug 2026
 17:33:33 -0700 (PDT)
Date: Fri, 28 Aug 2026 17:33:33 -0700
In-Reply-To: <6a807bfd.f7a79266.2f965f.0008.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a9228dd.1d9ded08.62e62.00f7.GAE@google.com>
Subject: Re: [syzbot] [block?] [cgroups?] possible deadlock in blkg_conf_prep
From: syzbot <syzbot+144a1c0e22e53a08ef5a@syzkaller.appspotmail.com>
To: axboe@kernel.dk, cgroups@vger.kernel.org, josef@toxicpanda.com, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com, tj@kernel.org
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    818bebeb63dd drm/xe: Don't hand out the flat CCS storage a..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=104ced79580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ccca94d2c01b9e78
dashboard link: https://syzkaller.appspot.com/bug?extid=144a1c0e22e53a08ef5a
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16f08379580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=124ced79580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-818bebeb.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/6e4100526b12/vmlinux-818bebeb.xz
kernel image: https://storage.googleapis.com/syzbot-assets/723c4783ee96/bzImage-818bebeb.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+144a1c0e22e53a08ef5a@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Not tainted
------------------------------------------------------
syz.1.18/6027 is trying to acquire lock:
ffffffff8efc6c00
 (
fs_reclaim){+.+.}-{0:0}, at: might_alloc include/linux/sched/mm.h:314 [inline]
fs_reclaim){+.+.}-{0:0}, at: slab_pre_alloc_hook mm/slub.c:4539 [inline]
fs_reclaim){+.+.}-{0:0}, at: slab_alloc_node mm/slub.c:4899 [inline]
fs_reclaim){+.+.}-{0:0}, at: kmem_cache_alloc_noprof+0x63/0x6a0 mm/slub.c:4933

but task is already holding lock:
ffff888028683bc0 (&q->blkcg_mutex){+.+.}-{4:4}, at: blkg_conf_prep+0xbc/0xf10 block/blk-cgroup.c:849

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (&q->blkcg_mutex){+.+.}-{4:4}:
       lock_acquire kernel/locking/lockdep.c:5886 [inline]
       lock_acquire+0x1b9/0x370 kernel/locking/lockdep.c:5843
       __mutex_lock_common kernel/locking/mutex.c:646 [inline]
       __mutex_lock+0x1a4/0x1bc0 kernel/locking/mutex.c:821
       blkcg_activate_policy+0x34f/0xbf0 block/blk-cgroup.c:1608
       blk_throtl_init+0x39a/0x5b0 block/blk-throttle.c:1339
       tg_set_conf.isra.0+0x252/0x500 block/blk-throttle.c:1368
       cgroup_file_write+0x1e6/0x8a0 kernel/cgroup/cgroup.c:4412
       kernfs_fop_write_iter+0x3e0/0x5f0 fs/kernfs/file.c:345
       new_sync_write fs/read_write.c:595 [inline]
       vfs_write+0x6af/0x1050 fs/read_write.c:687
       ksys_write+0x12a/0x250 fs/read_write.c:739
       do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
       do_syscall_64+0x123/0x790 arch/x86/entry/syscall_64.c:84
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #1 (&q->q_usage_counter(io)#17){++++}-{0:0}:
       lock_acquire kernel/locking/lockdep.c:5886 [inline]
       lock_acquire+0x1b9/0x370 kernel/locking/lockdep.c:5843
       blk_alloc_queue+0x610/0x790 block/blk-core.c:504
       blk_mq_alloc_queue+0x174/0x290 block/blk-mq.c:4420
       __blk_mq_alloc_disk+0x29/0x120 block/blk-mq.c:4467
       loop_add+0x498/0xb60 drivers/block/loop.c:2071
       loop_init+0x1d3/0x200 drivers/block/loop.c:2310
       do_one_initcall+0x11c/0x6f0 init/main.c:1353
       do_initcall_level init/main.c:1415 [inline]
       do_initcalls init/main.c:1431 [inline]
       do_basic_setup init/main.c:1451 [inline]
       kernel_init_freeable+0x6ea/0x7b0 init/main.c:1666
       kernel_init+0x21/0x1e0 init/main.c:1556
       ret_from_fork+0x730/0xd60 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

-> #0 (fs_reclaim){+.+.}-{0:0}:
       check_prev_add+0xeb/0xe60 kernel/locking/lockdep.c:3181
       check_prevs_add kernel/locking/lockdep.c:3300 [inline]
       validate_chain kernel/locking/lockdep.c:3924 [inline]
       __lock_acquire+0x1492/0x1ec0 kernel/locking/lockdep.c:5253
       lock_acquire kernel/locking/lockdep.c:5886 [inline]
       lock_acquire+0x1b9/0x370 kernel/locking/lockdep.c:5843
       __fs_reclaim_acquire mm/page_alloc.c:4375 [inline]
       fs_reclaim_acquire+0xc4/0x100 mm/page_alloc.c:4389
       might_alloc include/linux/sched/mm.h:314 [inline]
       slab_pre_alloc_hook mm/slub.c:4539 [inline]
       slab_alloc_node mm/slub.c:4899 [inline]
       kmem_cache_alloc_noprof+0x63/0x6a0 mm/slub.c:4933
       __radix_tree_preload+0x333/0x820 lib/radix-tree.c:338
       blkg_conf_prep+0x489/0xf10 block/blk-cgroup.c:885
       tg_set_conf.isra.0+0x1ed/0x500 block/blk-throttle.c:1373
       cgroup_file_write+0x1e6/0x8a0 kernel/cgroup/cgroup.c:4412
       kernfs_fop_write_iter+0x3e0/0x5f0 fs/kernfs/file.c:345
       new_sync_write fs/read_write.c:595 [inline]
       vfs_write+0x6af/0x1050 fs/read_write.c:687
       ksys_write+0x12a/0x250 fs/read_write.c:739
       do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
       do_syscall_64+0x123/0x790 arch/x86/entry/syscall_64.c:84
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

locks held by syz.1.18/6027: 6, last CPU#3:
 #0: ffff888035cc8b70 (&f->f_pos_lock){+.+.}-{4:4}, at: fdget_pos+0x2aa/0x380 fs/file.c:1259
 #1: ffff8880372a4460 (sb_writers#11){.+.+}-{0:0}, at: ksys_write+0x12a/0x250 fs/read_write.c:739
 #2: ffff888037174c80 (&of->mutex){+.+.}-{4:4}, at: kernfs_fop_write_iter+0x2c2/0x5f0 fs/kernfs/file.c:336
 #3: ffff8880534200f8 (kn->active#66){.+.+}-{0:0}, at: kernfs_get_active_of fs/kernfs/file.c:73 [inline]
 #3: ffff8880534200f8 (kn->active#66){.+.+}-{0:0}, at: kernfs_fop_write_iter+0x332/0x5f0 fs/kernfs/file.c:337
 #4: ffff888028683a40 (&q->rq_qos_mutex){+.+.}-{4:4}, at: blkg_conf_open_bdev+0x253/0x410 block/blk-cgroup.c:806
 #5: ffff888028683bc0 (&q->blkcg_mutex){+.+.}-{4:4}, at: blkg_conf_prep+0xbc/0xf10 block/blk-cgroup.c:849

stack backtrace:
CPU: 3 UID: 0 PID: 6027 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x100/0x190 lib/dump_stack.c:120
 print_circular_bug.cold+0x178/0x1be kernel/locking/lockdep.c:2059
 check_noncircular+0x146/0x160 kernel/locking/lockdep.c:2191
 check_prev_add+0xeb/0xe60 kernel/locking/lockdep.c:3181
 check_prevs_add kernel/locking/lockdep.c:3300 [inline]
 validate_chain kernel/locking/lockdep.c:3924 [inline]
 __lock_acquire+0x1492/0x1ec0 kernel/locking/lockdep.c:5253
 lock_acquire kernel/locking/lockdep.c:5886 [inline]
 lock_acquire+0x1b9/0x370 kernel/locking/lockdep.c:5843
 __fs_reclaim_acquire mm/page_alloc.c:4375 [inline]
 fs_reclaim_acquire+0xc4/0x100 mm/page_alloc.c:4389
 might_alloc include/linux/sched/mm.h:314 [inline]
 slab_pre_alloc_hook mm/slub.c:4539 [inline]
 slab_alloc_node mm/slub.c:4899 [inline]
 kmem_cache_alloc_noprof+0x63/0x6a0 mm/slub.c:4933
 __radix_tree_preload+0x333/0x820 lib/radix-tree.c:338
 blkg_conf_prep+0x489/0xf10 block/blk-cgroup.c:885
 tg_set_conf.isra.0+0x1ed/0x500 block/blk-throttle.c:1373
 cgroup_file_write+0x1e6/0x8a0 kernel/cgroup/cgroup.c:4412
 kernfs_fop_write_iter+0x3e0/0x5f0 fs/kernfs/file.c:345
 new_sync_write fs/read_write.c:595 [inline]
 vfs_write+0x6af/0x1050 fs/read_write.c:687
 ksys_write+0x12a/0x250 fs/read_write.c:739
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x123/0x790 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f7b6519e159
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f7b66080028 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 00007f7b65425fa0 RCX: 00007f7b6519e159
RDX: 000000000000006a RSI: 00002000000000c0 RDI: 0000000000000005
RBP: 00007f7b65235024 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f7b65426038 R14: 00007f7b65425fa0 R15: 00007ffc8680c158
 </TASK>


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
