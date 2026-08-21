Received: from mail-oi2-f11.google.com (mail-oi2-f11.google.com [74.125.231.203])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21159448B87
	for <cgroups@vger.kernel.org>; Fri, 21 Aug 2026 09:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.203
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787304050; cv=none; b=jydN32Gx5NXtMStLUE7g7zyjDtjvv/ULK16kGJmV5kAKXIiyxaK7t9uqa9ulDTJcl5hvDKbg0k96V0peJx6x8W0oYGcnayBRXsD+aG4wArBFPiV6a8u9BuOaQBmlCe5fcmaoxAV8spFFQSNx3ezTG8cPcvQqOR+0CEQyhU0mRZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787304050; c=relaxed/simple;
	bh=rApTZfzqud6xiunif4O6/4Ni8veRPlY2aqD+J/VDMbk=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=WNX5kqMm5g0khryZQDnqVYzsPvAsiPholY+QzjGkyxulARG79wrcWHPvdjBKYcCL03h5dDx0hbXZoBYp3jaXWPikqYXafjHpFNNXB8td3sJH7D5hK1xiiYaVI25+4Nxu0MdQfAAp2v9nLgp4YmzeAFWmK3+D7/Oxg+hbWEoi0Ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=74.125.231.203
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi2-f11.google.com with SMTP id 5614622812f47-4af7193adb7so309847b6e.0
        for <cgroups@vger.kernel.org>; Fri, 21 Aug 2026 02:20:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787304039; x=1787908839;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=ZKvC+5m73uO7ROWkWkuPjlS52ddEAzIvEuOVTswbBGQ=;
        b=lYilZdXpPRoQe4L3/KQsBOF8zEAp5yUD5KTV++TOvVDaCfpO+ueo+wQyAWoRzJM1zp
         MW6Dj9kESxFmR7dQaQlK/gl8HToAz+5SX0VhsMaZ/2KBApRqycWIljZWd1Bw8c7Nbkci
         DAyikxsYdQ8HvjeliF9ikfFxn5RW5HcG4/umrXFBim5IDSVb7mDF6aU6d5iI/S7zUjNU
         zoUG3hfvF5HwPSbWZwMG13HOB8MFLVbhTjpAxvD1VtJynMDncocjjixpTF+IVf1YS29h
         NDQnYVVW4eCcXz1sV77u+Cn6L3nkOQWiwfNrSMjOo/FM0aQDLJmtNXr3iZaXVEuG7+Kb
         I2zQ==
X-Forwarded-Encrypted: i=1; AHgh+Rp9lL68/LDenLxrPfjk2EylRbT0tVwsPy81ovXmx6KT1DiNujegx1mKu53uBEh3j1I0FUyqmgbk@vger.kernel.org
X-Gm-Message-State: AOJu0YwcIEA8STfrhaMd20E0gDbxENLbhNkAGMO76b9AWPCsyHmmXqSJ
	00neveI+lF2rsIGzKV+FOVLhE/3DAb6XfZ+geFTRlahw8AHCE/1Co9fdS60mzC7tWa+5WEh26eo
	Ta2AB5W2O+S/IqL39cYJ6Zl9ReDgHiLkgfh/wEKSum2zDLTqRZOR13gM3POI=
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1526:b0:4a0:97bc:53a4 with SMTP id
 5614622812f47-4b2ef21e5c8mr4662256b6e.5.1787304039177; Fri, 21 Aug 2026
 02:20:39 -0700 (PDT)
Date: Fri, 21 Aug 2026 02:20:39 -0700
In-Reply-To: <6a807bfd.f7a79266.2f965f.0008.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a881867.dbb3a75c.13dd47.000f.GAE@google.com>
Subject: Re: [syzbot] [block?] [cgroups?] possible deadlock in blkg_conf_prep
From: syzbot <syzbot+144a1c0e22e53a08ef5a@syzkaller.appspotmail.com>
To: axboe@kernel.dk, cgroups@vger.kernel.org, josef@toxicpanda.com, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com, tj@kernel.org
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    818bebeb63dd drm/xe: Don't hand out the flat CCS storage a..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=112c9e79580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ccca94d2c01b9e78
dashboard link: https://syzkaller.appspot.com/bug?extid=144a1c0e22e53a08ef5a
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=152c9e79580000

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
syz.3.20/6039 is trying to acquire lock:
ffffffff8efc6c00 (fs_reclaim
){+.+.}-{0:0}, at: might_alloc include/linux/sched/mm.h:314 [inline]
){+.+.}-{0:0}, at: slab_pre_alloc_hook mm/slub.c:4539 [inline]
){+.+.}-{0:0}, at: slab_alloc_node mm/slub.c:4899 [inline]
){+.+.}-{0:0}, at: kmem_cache_alloc_noprof+0x63/0x6a0 mm/slub.c:4933

but task is already holding lock:
ffff888028bae100 (&q->blkcg_mutex){+.+.}-{4:4}, at: blkg_conf_prep+0xbc/0xf10 block/blk-cgroup.c:849

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (&q->blkcg_mutex){+.+.}-{4:4}
:
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

-> #1 (&q->q_usage_counter(io)#2){++++}-{0:0}:
       lock_acquire kernel/locking/lockdep.c:5886 [inline]
       lock_acquire+0x1b9/0x370 kernel/locking/lockdep.c:5843
       blk_alloc_queue+0x610/0x790 block/blk-core.c:504
       __blk_alloc_disk+0xa0/0x170 block/genhd.c:1520
       brd_alloc.isra.0+0x41a/0x820 drivers/block/brd.c:327
       brd_init+0x167/0x190 drivers/block/brd.c:420
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
  fs_reclaim --> &q->q_usage_counter(io)#2 --> &q->blkcg_mutex

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&q->blkcg_mutex);
                               lock(&q->q_usage_counter(io)#2);
                               lock(&q->blkcg_mutex);
  lock(fs_reclaim);

 *** DEADLOCK ***

locks held by syz.3.20/6039: 6, last CPU#3:
 #0: ffff88802339cd30 (&f->f_pos_lock){+.+.}-{4:4}, at: fdget_pos+0x2aa/0x380 fs/file.c:1259
 #1: ffff888037ab0460 (sb_writers#11){.+.+}-{0:0}, at: ksys_write+0x12a/0x250 fs/read_write.c:739
 #2: ffff88802f2bbc80 (&of->mutex){+.+.}-{4:4}, at: kernfs_fop_write_iter+0x2c2/0x5f0 fs/kernfs/file.c:336
 #3: ffff88802a08a5a8 (kn->active#66){.+.+}-{0:0}, at: kernfs_get_active_of fs/kernfs/file.c:73 [inline]
 #3: ffff88802a08a5a8 (kn->active#66){.+.+}-{0:0}, at: kernfs_fop_write_iter+0x332/0x5f0 fs/kernfs/file.c:337
 #4: ffff888028badf80 (&q->rq_qos_mutex){+.+.}-{4:4}, at: blkg_conf_open_bdev+0x253/0x410 block/blk-cgroup.c:806
 #5: ffff888028bae100 (&q->blkcg_mutex){+.+.}-{4:4}, at: blkg_conf_prep+0xbc/0xf10 block/blk-cgroup.c:849

stack backtrace:
CPU: 3 UID: 0 PID: 6039 Comm: syz.3.20 Not tainted syzkaller #0 PREEMPT(full) 
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
RIP: 0033:0x7f87a939e0d9
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f87aa1ff028 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 00007f87a9625fa0 RCX: 00007f87a939e0d9
RDX: 000000000000006a RSI: 00002000000000c0 RDI: 0000000000000005
RBP: 00007f87a9435024 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f87a9626038 R14: 00007f87a9625fa0 R15: 00007ffd6065d3e8
 </TASK>


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
