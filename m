Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EF1B4772B8
	for <cgroups@vger.kernel.org>; Sat, 17 Oct 2026 23:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792280551; cv=none; b=BMWaAxgjfv6je32UbYShXuTIQfgJLj0dm1KJaC4UtxJH01iTvkGTcsvZEWMHT3IyzZWOckCgW1HGY2fq6WdZKgvvnhAfdS/DccxaWqAFIlOxfGPxIT1iCmK9MVYRrHuDXjqlnb0Zkolrd5osYM95rgqlO3v1jJRhdkB/S0mnLso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792280551; c=relaxed/simple;
	bh=FdC9RuunKVN0rickt7jmRn+kYZhlndDu+64L/2mKya0=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=UhNBg8JRU3d9QOlMFP1Mtp344P2yx6V+91srGmb+mdwvOpmYR/uqrltimjIjdjRfun4lXFGgzCPoPTGtZe1zmH4dVkdAKvH05jtitvz83ABml2Ymz/u8e/CD3ViyfCnAALNYVRZF4cJJvpzBPq0MgJGcWBKwXgvmtZu2k8yCFZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-4e937c5bd4fso1385289b6e.2
        for <cgroups@vger.kernel.org>; Sat, 17 Oct 2026 16:42:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792280549; x=1792885349;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ulz0XGKnxhl+8qtO3fftNe3Z7GVcPt33pyCT2Um33DA=;
        b=zRSKXbeJe9NaDQ6YGOrSL7i73JfNE0mwyj2yF10Yjswzn0oYpvdfGIi0GGr5h/WTMY
         qL8Topl40l1DJd3/um6hF1+yAk/Ty1+zyZq040cv0AWyaOxAUTX3EXcNmpjSVGSaoumw
         cYJXBAh4gSAt0sWaRdivq6R3uwof7y+I3eNEgnd5cwiqJ/QRERLYU10sW8r4N8cetK/f
         z46/X1x4DYwHCBHdo/96iTdws2SBoVpMbKZOfSZNwfNlyXJPvIPANSOqP3CZOcpPXMT6
         RYxfh5OFQLIEiUmHyqt3amzorCta1R06gpo4E2tjxMPSmbrqEQE6aCnWs7EvWcyMHJjh
         fiNQ==
X-Forwarded-Encrypted: i=1; AKwUvBxkJyUEWqJMdgYlHPltEWwiye0Isr/t+sHFKKVmimNM/at9OsF2ru1DXuzY4rrHLah0Aaci0R2W@vger.kernel.org
X-Gm-Message-State: AFq9FYJqOSGse3KGaqy3ENbvsKIULcfhNG1+anz0dKZg8YL8YzM48dcM
	b8aPlQ7fDVzusBZPPI2RRKlQraeVxPMvBZAEBt6mof7NnmCW6CBUBb4OX7xQXo6eKjikCYyFYn/
	RtzMKRcCwk0wbTG1dFGIV+GvYxYvhq3SDAtfoQHEfOcf6Sfh5zIVreLJNfUM=
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:3c49:b0:53c:7298:35a9 with SMTP id
 5614622812f47-53cc3e3c8bbmr2979416b6e.8.1792280549338; Sat, 17 Oct 2026
 16:42:29 -0700 (PDT)
Date: Sat, 17 Oct 2026 16:42:29 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ad407e5.6814cce4.34c49f.00a4.GAE@google.com>
Subject: [syzbot] [mm?] INFO: rcu detected stall in filemap_fault (4)
From: syzbot <syzbot+af37a78f810994eae641@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, cgroups@vger.kernel.org, hannes@cmpxchg.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, mhocko@kernel.org, 
	muchun.song@linux.dev, roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    70dd4ee72eb2 Merge tag 'pinctrl-v7.3-3' of git://git.kerne..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15b2320d580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4ccb65e03706547e
dashboard link: https://syzkaller.appspot.com/bug?extid=af37a78f810994eae641
compiler:       Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10de5da9580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-70dd4ee7.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/f1d9bae25289/vmlinux-70dd4ee7.xz
kernel image: https://storage.googleapis.com/syzbot-assets/d8b2b9fc2571/bzImage-70dd4ee7.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+af37a78f810994eae641@syzkaller.appspotmail.com

rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
rcu: 	Tasks blocked on level-0 rcu_node (CPUs 0-0): P5320/1:b..l
rcu: 	(detected by 0, t=10502 jiffies, g=61125, q=864 ncpus=1)
task:syz-execprog    state:R  running task     stack:22864 pid:5320  tgid:5314  ppid:5313   task_flags:0x440040 flags:0x00080000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5533 [inline]
 __schedule+0x17db/0x58f0 kernel/sched/core.c:7284
 preempt_schedule_irq+0x4b/0x90 kernel/sched/core.c:7606
 irqentry_exit_to_kernel_mode include/linux/irq-entry-common.h:539 [inline]
 irqentry_exit+0x14f/0x920 kernel/entry/common.c:167
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:674
RIP: 0010:task_css include/linux/cgroup.h:548 [inline]
RIP: 0010:mem_cgroup_from_task+0x8f/0x120 mm/memcontrol.c:1134
Code: 38 48 c7 c7 58 c8 d9 8f be ff ff ff ff e8 a9 1a a8 09 85 c0 75 23 49 83 c6 2c 4c 89 f0 48 c1 e8 03 42 0f b6 04 38 84 c0 75 6e <41> f6 06 04 75 09 e8 76 f7 68 ff 85 c0 74 28 48 83 c3 20 48 89 d8
RSP: 0018:ffffc9000e0ef610 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffffffff8fd9f0c0 RCX: 0000000000000046
RDX: 000000009a0f617f RSI: ffffffff8e6f5004 RDI: ffffffff8c6dec80
RBP: 1ffff110061db463 R08: ffffffff8242ae78 R09: 0000000000000000
R10: dffffc0000000000 R11: ffffed10070f1e47 R12: ffff88803878f230
R13: dffffc0000000000 R14: ffff888000f525ac R15: dffffc0000000000
 get_mem_cgroup_from_mm+0xd6/0x290 mm/memcontrol.c:1187
 __mem_cgroup_charge+0x15/0x80 mm/memcontrol.c:5226
 mem_cgroup_charge include/linux/memcontrol.h:662 [inline]
 filemap_add_folio+0x140/0x4e0 mm/filemap.c:965
 page_cache_ra_unbounded+0x46d/0x9d0 mm/readahead.c:293
 do_page_cache_ra mm/readahead.c:348 [inline]
 page_cache_ra_order+0xb47/0xee0 mm/readahead.c:558
 do_sync_mmap_readahead+0x75e/0x990 mm/filemap.c:3443
 filemap_fault+0x7d9/0x13b0 mm/filemap.c:3597
 __do_fault+0x138/0x2a0 mm/memory.c:5565
 do_read_fault mm/memory.c:6000 [inline]
 do_fault mm/memory.c:6134 [inline]
 do_pte_missing+0x2215/0x34b0 mm/memory.c:4700
 handle_pte_fault mm/memory.c:6558 [inline]
 __handle_mm_fault mm/memory.c:6707 [inline]
 handle_mm_fault+0x1a53/0x3750 mm/memory.c:6876
 do_user_addr_fault+0xa4f/0x1340 arch/x86/mm/fault.c:1343
 handle_page_fault arch/x86/mm/fault.c:1483 [inline]
 exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1536
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:595
RIP: 0033:0x46fe0e
RSP: 002b:000010e09c0a5178 EFLAGS: 00010216
RAX: 00000000015e4970 RBX: 000000000173a820 RCX: 0000000000000000
RDX: 000000000001a058 RSI: 00000000015ca918 RDI: 000000000041db80
RBP: 000010e09c0a51a0 R08: 00000000015ca918 R09: 00000000015cb3b8
R10: 0000000001911ec0 R11: 0000000000000000 R12: 0000000043fdf3b9
R13: 0000000000000000 R14: 000010e09c078960 R15: 000000000000012a
 </TASK>
rcu: rcu_preempt kthread starved for 1643 jiffies! g61125 f0x0 RCU_GP_WAIT_FQS(5) ->state=I ->cpu=0
rcu: 	Unless rcu_preempt kthread gets sufficient CPU time, OOM is now expected behavior.
rcu: RCU grace-period kthread stack dump:
task:rcu_preempt     state:I stack:27496 pid:17    tgid:17    ppid:2      task_flags:0x208040 flags:0x00080000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5533 [inline]
 __schedule+0x17db/0x58f0 kernel/sched/core.c:7284
 preempt_schedule_common+0x7f/0xd0 kernel/sched/core.c:7463
 preempt_schedule_thunk+0x16/0x40 arch/x86/entry/thunk.S:12
 __raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:211 [inline]
 _raw_spin_unlock_irqrestore+0x76/0x80 kernel/locking/spinlock.c:221
 debug_object_assert_init+0x20d/0x380 lib/debugobjects.c:1072
 debug_timer_assert_init kernel/time/timer.c:803 [inline]
 debug_assert_init kernel/time/timer.c:848 [inline]
 __mod_timer+0x4b/0xed0 kernel/time/timer.c:1025
 schedule_timeout+0x14d/0x2c0 kernel/time/sleep_timeout.c:98
 rcu_gp_fqs_loop+0x30c/0x11f0 kernel/rcu/tree.c:2122
 rcu_gp_kthread+0x9e/0x2b0 kernel/rcu/tree.c:2330
 kthread+0x38b/0x480 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
rcu: Stack dump where RCU GP kthread last ran:
CPU: 0 UID: 0 PID: 5761 Comm: syz.2.24 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:get_current arch/x86/include/asm/current.h:25 [inline]
RIP: 0010:__sanitizer_cov_trace_pc+0x8/0x80 kernel/kcov.c:212
Code: 8b 3d 34 de ab 0c 48 89 de 5b e9 93 fc 66 00 cc cc cc 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 48 8b 04 24 <65> 48 8b 0d c8 9d ce 12 65 48 8b 15 c8 9d ce 12 f7 c2 00 01 00 ff
RSP: 0018:ffffc9000d3278e8 EFLAGS: 00000202
RAX: ffffffff8be56f10 RBX: 1ffff11006b094a2 RCX: ffff888034c90000
RDX: ffff88803584a508 RSI: ffff88803584a508 RDI: ffffc9000d327ab8
RBP: 1ffff11006b094a1 R08: ffff888034c9001b R09: 1ffff11006992003
R10: dffffc0000000000 R11: ffffed1006992004 R12: ffff88803584a508
R13: ffff88803584a508 R14: ffff88803584a508 R15: ffff88803584a510
FS:  00007f0baa9bd6c0(0000) GS:ffff88808b0b4000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000000058 CR3: 000000004004c000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 __list_add include/linux/list.h:172 [inline]
 list_add_tail include/linux/list.h:206 [inline]
 plist_add+0x420/0x580 lib/plist.c:111
 __futex_queue+0xed/0x160 kernel/futex/core.c:866
 futex_queue kernel/futex/futex.h:333 [inline]
 futex_wait_setup+0x424/0x590 kernel/futex/waitwake.c:695
 __futex_wait+0x15f/0x400 kernel/futex/waitwake.c:717
 futex_wait+0x121/0x390 kernel/futex/waitwake.c:750
 do_futex+0x3e7/0x4e0 kernel/futex/syscalls.c:133
 __do_sys_futex kernel/futex/syscalls.c:210 [inline]
 __se_sys_futex+0x3a8/0x450 kernel/futex/syscalls.c:191
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f0ba9b9e559
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f0baa9bd0e8 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: ffffffffffffffda RBX: 00007f0ba9e25fa8 RCX: 00007f0ba9b9e559
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 00007f0ba9e25fa8
RBP: 00007f0ba9e25fa0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f0ba9e26038 R14: 00007ffe158db450 R15: 00007ffe158db538
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
