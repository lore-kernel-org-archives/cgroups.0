Received: from mail-oi1-f207.google.com (mail-oi1-f207.google.com [209.85.167.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F746188CC9
	for <cgroups@vger.kernel.org>; Sun,  2 Aug 2026 00:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785629265; cv=none; b=G6PrzJmZaP8kxWXnZ5l+vXe+bbQ7EEReg8mA3OQSYrGAJ6Xi5xNRS1f6OFi/wacy9RQ6eUl2th94o6CT1w2QzjlM/026eL1Cyp/FvHMYbc3KHoTX6A4QUK6fNkYmMR+UM1csdETuVzmHjo/oT5R2R4D3O0xOHSIL5CXnQxI7Jr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785629265; c=relaxed/simple;
	bh=dd3cXSpY1JABrbCeP7GCni5mroPFt21FEs9W1bCbdy8=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=fCtd/i8mgn9Pubc52p76igxRrbW694c3JEjeDa2GMqZ3aGCPRC3IY9PDPDNHUhB7ioO64ykOEWjuG8mR274dIwZme7RcxG8PTypMvMR6E08u/aJeJDV679R2E1OhXiP4B74AqlUInt8/Ctu0jLf4OELbRVGLngT9nP8++zRu8JI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f207.google.com with SMTP id 5614622812f47-49aa4525b82so3050738b6e.1
        for <cgroups@vger.kernel.org>; Sat, 01 Aug 2026 17:07:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785629262; x=1786234062;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=I0pKXPWv25y2OKbbtjKKP7n3rWQEuSunKJz3EV8RNp4=;
        b=QZfQAL9wKbZ3LX1iAldEIcYbATorhbxavc94/i2ytYrOiPVgRc9ZuHS2gjFJSv0pqO
         6L5d/KUeH4oHdvEMf6t8n8GQL7+U60rK3GO5o3zA3u0kUhEyGn0MtE8eD6Yup5vtbCNP
         M5HwVK6PbCa1g4lzABb68tpvuUX1mcFtXEzxwuH6biNDoJ6braNYZcAb9JBt5KRqTRIF
         98yZ1wQOxFP0rDUDXfcW1bKrRh8btc50N0ewv+rLwI+NHmCC1AedEBDN+o388XI2Vcya
         uRblCcXF9P0xTiO3MyPtqoYWZubQY8a7Wvj/2UkhoWmqdVxcrkrqldAcjSgiv+T26H/j
         SICg==
X-Gm-Message-State: AOJu0YyAs62uZFkamlgClD1lyusuK6WlZidiC86ITMEG/bVLc8QCdUvF
	N1ofwKWFDcAhFgINS7BvGPenEef4YpIdRyLEMpqfAtz32pRd1sO1A2FAxA4Ni+unnrvcMSVEAz4
	ZbnBl8VYNgGwqWsk7kCEkzi+9uNXN+R4RcHrmCT5hgrKx9zTHtkKBqoOljB4xIg==
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1910:b0:495:fecb:bf9c with SMTP id
 5614622812f47-4af5e0582c7mr10136658b6e.6.1785629262205; Sat, 01 Aug 2026
 17:07:42 -0700 (PDT)
Date: Sat, 01 Aug 2026 17:07:42 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a6e8a4e.2d659fcc.1d46f5.01c7.GAE@google.com>
Subject: [syzbot] [cgroups?] possible deadlock in _task_rq_lock
From: syzbot <syzbot+e8aac527b30cc7380cf3@syzkaller.appspotmail.com>
To: cgroups@vger.kernel.org, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, 
	mkoutny@suse.com, syzkaller-bugs@googlegroups.com, tj@kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    8ba098e6b6ff Merge tag 'v7.2-rc5-smb3-client-fixes' of git..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=109cd499580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f221a1b5d497ed15
dashboard link: https://syzkaller.appspot.com/bug?extid=e8aac527b30cc7380cf3
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-8ba098e6.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/068ab6124703/vmlinux-8ba098e6.xz
kernel image: https://storage.googleapis.com/syzbot-assets/4658fabc1ddc/bzImage-8ba098e6.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e8aac527b30cc7380cf3@syzkaller.appspotmail.com

------------[ cut here ]------------
======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Not tainted
------------------------------------------------------
migration/0/19 is trying to acquire lock:
ffffffff8eaf3f60 (console_owner){....}-{0:0}, at: console_trylock_spinning kernel/printk/printk.c:2026 [inline]
ffffffff8eaf3f60 (console_owner){....}-{0:0}, at: vprintk_emit+0x4c0/0x6b0 kernel/printk/printk.c:2478

but task is already holding lock:
ffff88802b23b660 (&rq->__lock){-.-.}-{2:2}, at: raw_spin_rq_lock_nested kernel/sched/core.c:675 [inline]
ffff88802b23b660 (&rq->__lock){-.-.}-{2:2}, at: raw_spin_rq_lock_nested+0x88/0x140 kernel/sched/core.c:659

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #4 (&rq->__lock){-.-.}-{2:2}:
       lock_acquire kernel/locking/lockdep.c:5868 [inline]
       lock_acquire+0x1b9/0x370 kernel/locking/lockdep.c:5825
       _raw_spin_lock_nested+0x31/0x40 kernel/locking/spinlock.c:382
       raw_spin_rq_lock_nested+0x2c/0x140 kernel/sched/core.c:667
       raw_spin_rq_lock kernel/sched/sched.h:1653 [inline]
       _task_rq_lock+0xcf/0x500 kernel/sched/core.c:762
       cgroup_move_task+0x81/0x320 kernel/sched/psi.c:1170
       css_set_move_task+0x285/0x600 kernel/cgroup/cgroup.c:925
       cgroup_post_fork+0x1f9/0x9a0 kernel/cgroup/cgroup.c:6988
       copy_process+0x6b7a/0x8030 kernel/fork.c:2550
       kernel_clone+0x176/0x9d0 kernel/fork.c:2748
       user_mode_thread+0xcc/0x110 kernel/fork.c:2824
       rest_init+0x21/0x260 init/main.c:682
       start_kernel+0x48e/0x490 init/main.c:1175
       x86_64_start_reservations+0x24/0x30 arch/x86/kernel/head64.c:310
       x86_64_start_kernel+0x12b/0x130 arch/x86/kernel/head64.c:291
       common_startup_64+0x13e/0x158

-> #3 (&p->pi_lock){-.-.}-{2:2}:
       lock_acquire kernel/locking/lockdep.c:5868 [inline]
       lock_acquire+0x1b9/0x370 kernel/locking/lockdep.c:5825
       __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:132 [inline]
       _raw_spin_lock_irqsave+0x3a/0x60 kernel/locking/spinlock.c:166
       class_raw_spinlock_irqsave_constructor include/linux/spinlock.h:571 [inline]
       try_to_wake_up+0xbd/0x1c90 kernel/sched/core.c:4292
       __wake_up_common+0x135/0x1f0 kernel/sched/wait.c:108
       __wake_up_common_lock kernel/sched/wait.c:125 [inline]
       __wake_up+0x31/0x60 kernel/sched/wait.c:146
       tty_port_default_wakeup+0x47/0x60 drivers/tty/tty_port.c:67
       serial8250_tx_chars+0x68f/0x860 drivers/tty/serial/8250/8250_port.c:1723
       serial8250_handle_irq_locked+0x770/0x9a0 drivers/tty/serial/8250/8250_port.c:1837
       serial8250_handle_irq.part.0+0xb4/0x530 drivers/tty/serial/8250/8250_port.c:1853
       serial8250_handle_irq drivers/tty/serial/8250/8250_port.c:1849 [inline]
       serial8250_default_handle_irq+0xc2/0x280 drivers/tty/serial/8250/8250_port.c:1867
       serial8250_interrupt+0xf8/0x1b0 drivers/tty/serial/8250/8250_core.c:86
       __handle_irq_event_percpu+0x232/0x880 kernel/irq/handle.c:209
       handle_irq_event_percpu kernel/irq/handle.c:246 [inline]
       handle_irq_event+0xab/0x1e0 kernel/irq/handle.c:263
       handle_edge_irq+0x34c/0x950 kernel/irq/chip.c:859
       generic_handle_irq_desc include/linux/irqdesc.h:188 [inline]
       handle_irq arch/x86/kernel/irq.c:209 [inline]
       call_irq_handler arch/x86/kernel/irq.c:265 [inline]
       __common_interrupt+0xd8/0x2f0 arch/x86/kernel/irq.c:280
       common_interrupt+0xb9/0xe0 arch/x86/kernel/irq.c:273
       asm_common_interrupt+0x26/0x40 arch/x86/include/asm/idtentry.h:665
       native_safe_halt arch/x86/include/asm/irqflags.h:48 [inline]
       pv_native_safe_halt+0xf/0x20 arch/x86/kernel/paravirt.c:63
       arch_safe_halt arch/x86/include/asm/paravirt.h:62 [inline]
       default_idle+0x9/0x10 arch/x86/kernel/process.c:768
       default_idle_call+0x6c/0xb0 kernel/sched/idle.c:122
       cpuidle_idle_call kernel/sched/idle.c:199 [inline]
       do_idle+0x3a7/0x5b0 kernel/sched/idle.c:355
       cpu_startup_entry+0x4f/0x60 kernel/sched/idle.c:454
       start_secondary+0x21d/0x2d0 arch/x86/kernel/smpboot.c:312
       common_startup_64+0x13e/0x158

-> #2 (&tty->write_wait){-...}-{3:3}:
       lock_acquire kernel/locking/lockdep.c:5868 [inline]
       lock_acquire+0x1b9/0x370 kernel/locking/lockdep.c:5825
       __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:132 [inline]
       _raw_spin_lock_irqsave+0x3a/0x60 kernel/locking/spinlock.c:166
       __wake_up_common_lock kernel/sched/wait.c:124 [inline]
       __wake_up+0x1c/0x60 kernel/sched/wait.c:146
       tty_port_default_wakeup+0x47/0x60 drivers/tty/tty_port.c:67
       serial8250_tx_chars+0x68f/0x860 drivers/tty/serial/8250/8250_port.c:1723
       __start_tx+0x3e4/0x490 drivers/tty/serial/8250/8250_port.c:1430
       serial8250_start_tx+0x368/0x540 drivers/tty/serial/8250/8250_port.c:1539
       __uart_start+0x295/0x510 drivers/tty/serial/serial_core.c:161
       uart_write+0x211/0xb20 drivers/tty/serial/serial_core.c:629
       process_output_block drivers/tty/n_tty.c:557 [inline]
       n_tty_write+0x431/0x1160 drivers/tty/n_tty.c:2366
       iterate_tty_write drivers/tty/tty_io.c:1006 [inline]
       file_tty_write.isra.0+0x4d2/0x890 drivers/tty/tty_io.c:1081
       tty_write drivers/tty/tty_io.c:1102 [inline]
       redirected_tty_write drivers/tty/tty_io.c:1125 [inline]
       redirected_tty_write+0xd4/0x120 drivers/tty/tty_io.c:1105
       new_sync_write fs/read_write.c:595 [inline]
       vfs_write+0x6ac/0x1050 fs/read_write.c:687
       ksys_write+0x12a/0x250 fs/read_write.c:739
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0x115/0x840 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #1 (&port_lock_key){-...}-{3:3}:
       lock_acquire kernel/locking/lockdep.c:5868 [inline]
       lock_acquire+0x1b9/0x370 kernel/locking/lockdep.c:5825
       __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:132 [inline]
       _raw_spin_lock_irqsave+0x3a/0x60 kernel/locking/spinlock.c:166
       uart_port_lock_irqsave include/linux/serial_core.h:719 [inline]
       serial8250_console_write+0x177/0x1a50 drivers/tty/serial/8250/8250_port.c:3344
       console_emit_next_record kernel/printk/printk.c:3183 [inline]
       console_flush_one_record+0x790/0xe50 kernel/printk/printk.c:3269
       console_flush_all kernel/printk/printk.c:3343 [inline]
       __console_flush_and_unlock kernel/printk/printk.c:3373 [inline]
       console_unlock+0x103/0x260 kernel/printk/printk.c:3413
       vprintk_emit+0x407/0x6b0 kernel/printk/printk.c:2479
       _printk+0xcf/0x110 kernel/printk/printk.c:2504
       register_console.cold+0xc0/0x248 kernel/printk/printk.c:4208
       univ8250_console_init+0x6f/0x80 drivers/tty/serial/8250/8250_core.c:515
       console_init+0x3d5/0x5b0 kernel/printk/printk.c:4407
       start_kernel+0x314/0x490 init/main.c:1112
       x86_64_start_reservations+0x24/0x30 arch/x86/kernel/head64.c:310
       x86_64_start_kernel+0x12b/0x130 arch/x86/kernel/head64.c:291
       common_startup_64+0x13e/0x158

-> #0 (console_owner){....}-{0:0}:
       check_prev_add+0xeb/0xe60 kernel/locking/lockdep.c:3165
       check_prevs_add kernel/locking/lockdep.c:3284 [inline]
       validate_chain kernel/locking/lockdep.c:3908 [inline]
       __lock_acquire+0x136c/0x1a40 kernel/locking/lockdep.c:5237
       lock_acquire kernel/locking/lockdep.c:5868 [inline]
       lock_acquire+0x1b9/0x370 kernel/locking/lockdep.c:5825
       console_trylock_spinning kernel/printk/printk.c:2026 [inline]
       vprintk_emit+0x4d1/0x6b0 kernel/printk/printk.c:2478
       _printk+0xcf/0x110 kernel/printk/printk.c:2504
       __report_bug.cold+0x34/0x141 lib/bug.c:248
       report_bug+0xb2/0x220 lib/bug.c:286
       handle_bug+0x16a/0x2a0 arch/x86/kernel/traps.c:436
       exc_invalid_op+0x17/0x50 arch/x86/kernel/traps.c:490
       asm_exc_invalid_op+0x1a/0x20 arch/x86/include/asm/idtentry.h:593
       lockdep_assert_rq_held kernel/sched/sched.h:1641 [inline]
       lockdep_assert_rq_held kernel/sched/sched.h:1638 [inline]
       update_rq_clock+0x40a/0xd20 kernel/sched/core.c:865
       pick_next_task kernel/sched/core.c:6338 [inline]
       __schedule+0x1e2d/0x6730 kernel/sched/core.c:7149
       __schedule_loop kernel/sched/core.c:7311 [inline]
       schedule+0xdd/0x2c0 kernel/sched/core.c:7326
       smpboot_thread_fn+0x893/0xaa0 kernel/smpboot.c:156
       kthread+0x370/0x450 kernel/kthread.c:436
       ret_from_fork+0x72b/0xd50 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

other info that might help us debug this:

Chain exists of:
  console_owner --> &p->pi_lock --> &rq->__lock

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&rq->__lock);
                               lock(&p->pi_lock);
                               lock(&rq->__lock);
  lock(console_owner);

 *** DEADLOCK ***

1 lock held by migration/0/19:
 #0: ffff88802b23b660 (&rq->__lock){-.-.}-{2:2}, at: raw_spin_rq_lock_nested kernel/sched/core.c:675 [inline]
 #0: ffff88802b23b660 (&rq->__lock){-.-.}-{2:2}, at: raw_spin_rq_lock_nested+0x88/0x140 kernel/sched/core.c:659

stack backtrace:
CPU: 0 UID: 0 PID: 19 Comm: migration/0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Stopper: 0x0 <- 0x0
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x100/0x190 lib/dump_stack.c:120
 print_circular_bug.cold+0x178/0x1c7 kernel/locking/lockdep.c:2043
 check_noncircular+0x146/0x160 kernel/locking/lockdep.c:2175
 check_prev_add+0xeb/0xe60 kernel/locking/lockdep.c:3165
 check_prevs_add kernel/locking/lockdep.c:3284 [inline]
 validate_chain kernel/locking/lockdep.c:3908 [inline]
 __lock_acquire+0x136c/0x1a40 kernel/locking/lockdep.c:5237
 lock_acquire kernel/locking/lockdep.c:5868 [inline]
 lock_acquire+0x1b9/0x370 kernel/locking/lockdep.c:5825
 console_trylock_spinning kernel/printk/printk.c:2026 [inline]
 vprintk_emit+0x4d1/0x6b0 kernel/printk/printk.c:2478
 _printk+0xcf/0x110 kernel/printk/printk.c:2504
 __report_bug.cold+0x34/0x141 lib/bug.c:248
 report_bug+0xb2/0x220 lib/bug.c:286
 handle_bug+0x16a/0x2a0 arch/x86/kernel/traps.c:436
 exc_invalid_op+0x17/0x50 arch/x86/kernel/traps.c:490
 asm_exc_invalid_op+0x1a/0x20 arch/x86/include/asm/idtentry.h:593
RIP: 0010:lockdep_assert_rq_held kernel/sched/sched.h:1641 [inline]
RIP: 0010:lockdep_assert_rq_held kernel/sched/sched.h:1638 [inline]
RIP: 0010:update_rq_clock+0x40a/0xd20 kernel/sched/core.c:865
Code: ab c8 0b 00 00 48 83 c4 18 5b 5d 41 5c 41 5d 41 5e 41 5f e9 d8 6f e6 09 a8 04 0f 84 df fc ff ff 90 0f 0b 90 e9 d6 fc ff ff 90 <0f> 0b 90 e9 92 fc ff ff 4c 8d 83 c0 0b 00 00 48 b8 00 00 00 00 00
RSP: 0018:ffffc9000045fc28 EFLAGS: 00010046
RAX: 0000000000000000 RBX: ffff88802b33b600 RCX: 0000000000000001
RDX: 0000000000000046 RSI: ffffffff8e183111 RDI: ffffffff8c400a80
RBP: ffffc9000045fdd0 R08: 0000000000000001 R09: 0000000000000001
R10: ffff88806b806007 R11: 0000000bf5b29000 R12: ffffffff9122dd84
R13: ffff88802b33c4e0 R14: ffff888024812540 R15: ffff88802b23c198
 pick_next_task kernel/sched/core.c:6338 [inline]
 __schedule+0x1e2d/0x6730 kernel/sched/core.c:7149
 __schedule_loop kernel/sched/core.c:7311 [inline]
 schedule+0xdd/0x2c0 kernel/sched/core.c:7326
 smpboot_thread_fn+0x893/0xaa0 kernel/smpboot.c:156
 kthread+0x370/0x450 kernel/kthread.c:436
 ret_from_fork+0x72b/0xd50 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
debug_locks && !(lock_is_held(&(__rq_lockp(rq))->dep_map) != 0)
WARNING: kernel/sched/sched.h:1641 at lockdep_assert_rq_held kernel/sched/sched.h:1641 [inline], CPU#0: migration/0/19
WARNING: kernel/sched/sched.h:1641 at lockdep_assert_rq_held kernel/sched/sched.h:1638 [inline], CPU#0: migration/0/19
WARNING: kernel/sched/sched.h:1641 at update_rq_clock+0x40a/0xd20 kernel/sched/core.c:865, CPU#0: migration/0/19
Modules linked in:
CPU: 0 UID: 0 PID: 19 Comm: migration/0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Stopper: 0x0 <- 0x0
RIP: 0010:lockdep_assert_rq_held kernel/sched/sched.h:1641 [inline]
RIP: 0010:lockdep_assert_rq_held kernel/sched/sched.h:1638 [inline]
RIP: 0010:update_rq_clock+0x40a/0xd20 kernel/sched/core.c:865
Code: ab c8 0b 00 00 48 83 c4 18 5b 5d 41 5c 41 5d 41 5e 41 5f e9 d8 6f e6 09 a8 04 0f 84 df fc ff ff 90 0f 0b 90 e9 d6 fc ff ff 90 <0f> 0b 90 e9 92 fc ff ff 4c 8d 83 c0 0b 00 00 48 b8 00 00 00 00 00
RSP: 0018:ffffc9000045fc28 EFLAGS: 00010046
RAX: 0000000000000000 RBX: ffff88802b33b600 RCX: 0000000000000001
RDX: 0000000000000046 RSI: ffffffff8e183111 RDI: ffffffff8c400a80
RBP: ffffc9000045fdd0 R08: 0000000000000001 R09: 0000000000000001
R10: ffff88806b806007 R11: 0000000bf5b29000 R12: ffffffff9122dd84
R13: ffff88802b33c4e0 R14: ffff888024812540 R15: ffff88802b23c198
FS:  0000000000000000(0000) GS:ffff888096be1000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000f73d60b8 CR3: 0000000029a59000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 pick_next_task kernel/sched/core.c:6338 [inline]
 __schedule+0x1e2d/0x6730 kernel/sched/core.c:7149
 __schedule_loop kernel/sched/core.c:7311 [inline]
 schedule+0xdd/0x2c0 kernel/sched/core.c:7326
 smpboot_thread_fn+0x893/0xaa0 kernel/smpboot.c:156
 kthread+0x370/0x450 kernel/kthread.c:436
 ret_from_fork+0x72b/0xd50 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
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
