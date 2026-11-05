Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.71
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793878432;
	b=egCfu3oDYl9rn1GQtqm6vhJr3cSB7oAltIShPcMt3sbshVLnSx6qwMIVeATU9baKIZg8
	 T993S5R28QV7qXcwsKZX8vYhghrblo5y34GAAT9+OUcr/9pkNgfsL1kS2KmzeCE3oj6QN
	 IUj4MzUYl8RciCOizmDrgQcq/IKAFljHHM8Lll3D7gRElKbTIUMG2wWmIdbpR6Cn366/y
	 i+WP+mAYXHwToFZ7Q2rZpspbqz5XAKvJKeKQaemuSkPpthKh8tuSa67fV50RkxaO0xor/
	 0POlxywMJq4+iMccqKI2SSUZ5bHpJGkrTgpoLmJI4pr9vDmbD6ikua7Oz6zCwleuLCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793878432;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 MIME-Version:X-Received:Date:X-Google-Appengine-App-Id:
	 X-Google-Appengine-App-Id-Alias:Message-ID:Subject:From:To:
	 Content-Type;
	bh=TsM13Gjb1RGZrPBzQ8p0f1DcuzEPm7z1cx96hPQ4yNY=;
	b=dJach564/zMm7ebQ45DABZwMf8GiiY2xGxPyz8gHW+VVaPoTyffirVLP3cLYKbl4T6S/
	 LAY+jpLUU8XCynKMcZvyQB1X5PlNUXwZBwq35iMMOMO17h5c9VyaKlrtHZDUj3Mq2vGcj
	 rzCApaoY3ESF1sGL3kz3u6pAVQfjS/S2dnTMP2QxuR1R76c23wSYk5CEPPhPflicErVkg
	 OxTnAqYvL2vwrahHytldug3OcHybp8PFyiIXv/b1QPrtOudWOkLv+myJytnkepX+cP7Qr
	 tvslsiAVL9asXQ2g1OUJpyd4kwch9ju7QIYtcEyYx/dHM1DGG7zAX/cDvEneCbpCF4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.210.71
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com [209.85.210.71])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD5D4606A31B
	for <cgroups@vger.kernel.org>; Thu,  5 Nov 2026 11:33:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AD5D4606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-8488f31d754so1224034a34.0
        for <cgroups@vger.kernel.org>; Thu, 05 Nov 2026 03:33:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793878431; x=1794483231;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TsM13Gjb1RGZrPBzQ8p0f1DcuzEPm7z1cx96hPQ4yNY=;
        b=GwE2wK6c1AmoI1er0ehThMwr1O6pCmemxhM2wKbJCIrDuQ58g1vcB6mtZFXKBsxk+D
         jqRV3E961cQYRq7+RI1Idzbzi6ZTAzrolN3sykw3Uf8HiTNqMB6LaNFqwsshB6DRX6a5
         ha+sQf14uIS9z0gNGtdYutgV81Eb5qjsf1J04c2Y/eVIniS7EXDrulj59p9sJiw2yg67
         Wsvjxq0xF8+Jo68VxTyy3q2WaAU11/QIdDk0rHZWJORlzi4bl80+PPvXEzNPZ3ajnu3P
         HB1VEXA6VyH6MqrsdzIvhf3c98qwlxtE/B3NwpqKRC9BieeuLhiC/YMGEAEAvlTRw8mE
         G01Q==
X-Gm-Message-State: APuU4Z8Z/ZA60PfmVF5cFGpNgJbk699SUS6YUgk4qZcQTt5+he88IyW3
	teP6IBI3S2a8aq+tB9dSu+gP3cUY7oz6C2zZalNjhWAvPH03lfljJWsSasCqhR+q14SH9l1IVCZ
	96DfXNDAO40YKvWynl+Jf5H/nokq766ky8hQrxvGUPE9oKvuCaMvEykjDMMk=
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1806:b0:4b9:a88b:888e with SMTP id
 5614622812f47-5640dd023c6mr13236242b6e.36.1793878430781; Thu, 05 Nov 2026
 03:33:50 -0800 (PST)
Date: Thu, 05 Nov 2026 03:33:50 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6aec699e.73adde43.12e2c1.0001.GAE@google.com>
Subject: [syzbot] [cgroups?] possible deadlock in cpuset_can_attach
From: syzbot <syzbot+e0faf21748da6475085c@syzkaller.appspotmail.com>
To: cgroups@vger.kernel.org, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, 
	mkoutny@suse.com, syzkaller-bugs@googlegroups.com, tj@kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    2637bdec0535 Add linux-next specific files for 20261102
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=16b732dd580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=36463c6fa5166870
dashboard link: https://syzkaller.appspot.com/bug?extid=e0faf21748da6475085c
compiler:       Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/b372f49b197e/disk-2637bdec.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/7bc62209aebf/vmlinux-2637bdec.xz
kernel image: https://storage.googleapis.com/syzbot-assets/aa86e255d7bc/bzImage-2637bdec.xz

AI-generated root cause summary:
A circular locking dependency exists between cgroup/cpuset synchronization and
the CPU hotplug lock via memory reclaim and network socket operations. During
cgroup task migration, cgroup_attach_lock() acquires cpu_hotplug_lock followed
by cgroup_threadgroup_rwsem, after which cpuset_can_attach() acquires
cpuset_mutex, establishing the order cpu_hotplug_lock ->
cgroup_threadgroup_rwsem -> cpuset_mutex. In contrast,
rebuild_sched_domains_cpuslocked() holds cpuset_mutex while calling
generate_sched_domains(), which performs GFP_KERNEL allocations under
cpuset_mutex and thereby depends on fs_reclaim; fs_reclaim in turn depends on
block I/O (NBD), network sockets (sk_lock), and tunnel initialization in L2TP,
where l2tp_tunnel_register() calls setup_udp_tunnel_sock() and acquires
cpu_hotplug_lock via static_key_slow_inc(). This creates an inverted dependency
chain from cpuset_mutex to cpu_hotplug_lock, triggering a lockdep warning and
posing a risk of system deadlock.

full analysis:  https://syzkaller.appspot.com/x/ai_root_cause?x=e0faf21748da6475085c

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e0faf21748da6475085c@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Tainted: G S           L     
------------------------------------------------------
syz-executor/15837 is trying to acquire lock:
ffffffff901aad60 (cpuset_mutex){+.+.}-{4:4}, at: cpuset_can_attach+0xac/0x1170 kernel/cgroup/cpuset.c:3226

but task is already holding lock:
ffffffff9019add0 (cgroup_threadgroup_rwsem){++++}-{0:0}, at: cgroup_attach_lock kernel/cgroup/cgroup.c:2550 [inline]
ffffffff9019add0 (cgroup_threadgroup_rwsem){++++}-{0:0}, at: cgroup_procs_write_start+0x574/0x900 kernel/cgroup/cgroup.c:3182

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #9 (cgroup_threadgroup_rwsem){++++}-{0:0}:
       percpu_down_write+0x4f/0x330 kernel/locking/percpu-rwsem.c:232
       cgroup_attach_lock kernel/cgroup/cgroup.c:2550 [inline]
       cgroup_procs_write_start+0x574/0x900 kernel/cgroup/cgroup.c:3182
       __cgroup_procs_write+0xa4/0x2f0 kernel/cgroup/cgroup.c:5508
       cgroup_procs_write+0x27/0x50 kernel/cgroup/cgroup.c:5543
       cgroup_file_write+0x331/0x8f0 kernel/cgroup/cgroup.c:4426
       kernfs_fop_write_iter+0x3a4/0x540 fs/kernfs/file.c:345
       new_sync_write fs/read_write.c:595 [inline]
       vfs_write+0x612/0xba0 fs/read_write.c:687
       ksys_write+0x150/0x270 fs/read_write.c:1036
       do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
       do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #8 (cpu_hotplug_lock){++++}-{0:0}:
       percpu_down_read_internal include/linux/percpu-rwsem.h:53 [inline]
       percpu_down_read include/linux/percpu-rwsem.h:77 [inline]
       cpus_read_lock+0x3d/0x160 kernel/cpu.c:490
       static_key_slow_inc+0x12/0x30 kernel/jump_label.c:190
       udp_tunnel_encap_enable include/net/udp_tunnel.h:232 [inline]
       setup_udp_tunnel_sock+0x2df/0x4f0 net/ipv4/udp_tunnel_core.c:90
       l2tp_tunnel_register+0xe77/0x1570 net/l2tp/l2tp_core.c:1690
       pppol2tp_tunnel_get net/l2tp/l2tp_ppp.c:663 [inline]
       pppol2tp_connect+0x8e3/0x18b0 net/l2tp/l2tp_ppp.c:711
       connect_socket net/socket.c:2143 [inline]
       __sys_connect_file net/socket.c:2168 [inline]
       __sys_connect+0x316/0x450 net/socket.c:2185
       __do_sys_connect net/socket.c:2191 [inline]
       __se_sys_connect net/socket.c:2188 [inline]
       __x64_sys_connect+0x7a/0x90 net/socket.c:2188
       do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
       do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #7 (sk_lock-AF_INET6){+.+.}-{0:0}:
       lock_sock_nested+0x41/0x100 net/core/sock.c:3908
       lock_sock include/net/sock.h:1717 [inline]
       inet_shutdown+0x6a/0x390 net/ipv4/af_inet.c:911
       nbd_mark_nsock_dead+0x2cb/0x550 drivers/block/nbd.c:319
       sock_shutdown+0x15e/0x260 drivers/block/nbd.c:420
       nbd_clear_sock+0x24/0x170 drivers/block/nbd.c:1463
       nbd_config_put+0x477/0x7e0 drivers/block/nbd.c:1492
       nbd_genl_connect+0x19b8/0x1cd0 drivers/block/nbd.c:2319
       genl_family_rcv_msg_doit+0x233/0x340 net/netlink/genetlink.c:1114
       genl_family_rcv_msg net/netlink/genetlink.c:1194 [inline]
       genl_rcv_msg+0x614/0x7a0 net/netlink/genetlink.c:1209
       netlink_rcv_skb+0x226/0x4a0 net/netlink/af_netlink.c:2584
       genl_rcv+0x28/0x40 net/netlink/genetlink.c:1218
       netlink_unicast_kernel net/netlink/af_netlink.c:1335 [inline]
       netlink_unicast+0x8ef/0xa80 net/netlink/af_netlink.c:1361
       netlink_sendmsg+0x7f0/0xb20 net/netlink/af_netlink.c:1920
       sock_sendmsg_nosec+0x14e/0x190 net/socket.c:800
       __sock_sendmsg net/socket.c:818 [inline]
       ____sys_sendmsg+0x54e/0x850 net/socket.c:2715
       ___sys_sendmsg+0x2a6/0x360 net/socket.c:2769
       __sys_sendmsg net/socket.c:2801 [inline]
       __do_sys_sendmsg net/socket.c:2806 [inline]
       __se_sys_sendmsg net/socket.c:2804 [inline]
       __x64_sys_sendmsg+0x1b1/0x290 net/socket.c:2804
       do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
       do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #6 (&nsock->tx_lock){+.+.}-{4:4}:
       __mutex_lock_common kernel/locking/mutex.c:646 [inline]
       __mutex_lock+0x197/0x15a0 kernel/locking/mutex.c:821
       nbd_handle_cmd drivers/block/nbd.c:1143 [inline]
       nbd_queue_rq+0x373/0xff0 drivers/block/nbd.c:1207
       blk_mq_dispatch_rq_list+0x499/0x1990 block/blk-mq.c:2141
       __blk_mq_do_dispatch_sched block/blk-mq-sched.c:168 [inline]
       blk_mq_do_dispatch_sched block/blk-mq-sched.c:182 [inline]
       __blk_mq_sched_dispatch_requests+0xd36/0x1580 block/blk-mq-sched.c:307
       blk_mq_sched_dispatch_requests+0xd7/0x190 block/blk-mq-sched.c:329
       blk_mq_run_work_fn+0x167/0x2f0 block/blk-mq.c:2556
       process_one_work kernel/workqueue.c:3495 [inline]
       process_scheduled_works+0xc3d/0x1630 kernel/workqueue.c:3578
       worker_thread+0xa47/0xfb0 kernel/workqueue.c:3659
       kthread+0x38b/0x480 kernel/kthread.c:436
       ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

-> #5 (&cmd->lock){+.+.}-{4:4}:
       __mutex_lock_common kernel/locking/mutex.c:646 [inline]
       __mutex_lock+0x197/0x15a0 kernel/locking/mutex.c:821
       nbd_queue_rq+0xc1/0xff0 drivers/block/nbd.c:1199
       blk_mq_dispatch_rq_list+0x499/0x1990 block/blk-mq.c:2141
       __blk_mq_do_dispatch_sched block/blk-mq-sched.c:168 [inline]
       blk_mq_do_dispatch_sched block/blk-mq-sched.c:182 [inline]
       __blk_mq_sched_dispatch_requests+0xd36/0x1580 block/blk-mq-sched.c:307
       blk_mq_sched_dispatch_requests+0xd7/0x190 block/blk-mq-sched.c:329
       blk_mq_run_work_fn+0x167/0x2f0 block/blk-mq.c:2556
       process_one_work kernel/workqueue.c:3495 [inline]
       process_scheduled_works+0xc3d/0x1630 kernel/workqueue.c:3578
       worker_thread+0xa47/0xfb0 kernel/workqueue.c:3659
       kthread+0x38b/0x480 kernel/kthread.c:436
       ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

-> #4 (set->srcu){.+.+}-{0:0}:
       srcu_lock_sync include/linux/srcu.h:225 [inline]
       __synchronize_srcu+0xca/0x2f0 kernel/rcu/srcutree.c:1662
       elevator_switch+0x1e8/0x7b0 block/elevator.c:576
       elevator_change+0x2fa/0x480 block/elevator.c:681
       elevator_set_default+0x375/0x440 block/elevator.c:754
       blk_register_queue+0x404/0x4f0 block/blk-sysfs.c:992
       __add_disk+0x6b8/0xdb0 block/genhd.c:531
       add_disk_fwnode+0x100/0x3a0 block/genhd.c:600
       add_disk include/linux/blkdev.h:801 [inline]
       nbd_dev_add+0x733/0xb60 drivers/block/nbd.c:2026
       nbd_init+0x168/0x1f0 drivers/block/nbd.c:2743
       do_one_initcall+0x250/0x870 init/main.c:1419
       do_initcall_level+0x10a/0x1a0 init/main.c:1481
       do_initcalls+0x59/0xa0 init/main.c:1497
       kernel_init_freeable+0x29d/0x3e0 init/main.c:1732
       kernel_init+0x22/0x1d0 init/main.c:1622
       ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

-> #3 (&q->elevator_lock){+.+.}-{4:4}:
       __mutex_lock_common kernel/locking/mutex.c:646 [inline]
       __mutex_lock+0x197/0x15a0 kernel/locking/mutex.c:821
       elevator_change+0x1af/0x480 block/elevator.c:679
       elevator_set_none+0xb5/0x140 block/elevator.c:769
       blk_mq_elv_switch_none block/blk-mq.c:5160 [inline]
       __blk_mq_update_nr_hw_queues block/blk-mq.c:5205 [inline]
       blk_mq_update_nr_hw_queues+0x60b/0x1b70 block/blk-mq.c:5273
       nbd_start_device+0x189/0xb30 drivers/block/nbd.c:1530
       nbd_genl_connect+0x167d/0x1cd0 drivers/block/nbd.c:2310
       genl_family_rcv_msg_doit+0x233/0x340 net/netlink/genetlink.c:1114
       genl_family_rcv_msg net/netlink/genetlink.c:1194 [inline]
       genl_rcv_msg+0x614/0x7a0 net/netlink/genetlink.c:1209
       netlink_rcv_skb+0x226/0x4a0 net/netlink/af_netlink.c:2584
       genl_rcv+0x28/0x40 net/netlink/genetlink.c:1218
       netlink_unicast_kernel net/netlink/af_netlink.c:1335 [inline]
       netlink_unicast+0x8ef/0xa80 net/netlink/af_netlink.c:1361
       netlink_sendmsg+0x7f0/0xb20 net/netlink/af_netlink.c:1920
       sock_sendmsg_nosec+0x14e/0x190 net/socket.c:800
       __sock_sendmsg net/socket.c:818 [inline]
       ____sys_sendmsg+0x54e/0x850 net/socket.c:2715
       ___sys_sendmsg+0x2a6/0x360 net/socket.c:2769
       __sys_sendmsg net/socket.c:2801 [inline]
       __do_sys_sendmsg net/socket.c:2806 [inline]
       __se_sys_sendmsg net/socket.c:2804 [inline]
       __x64_sys_sendmsg+0x1b1/0x290 net/socket.c:2804
       do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
       do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #2 (&q->q_usage_counter(io)#50){++++}-{0:0}:
       blk_alloc_queue+0x544/0x690 block/blk-core.c:505
       blk_mq_alloc_queue block/blk-mq.c:4460 [inline]
       __blk_mq_alloc_disk+0x194/0x390 block/blk-mq.c:4507
       nbd_dev_add+0x494/0xb60 drivers/block/nbd.c:1996
       nbd_init+0x168/0x1f0 drivers/block/nbd.c:2743
       do_one_initcall+0x250/0x870 init/main.c:1419
       do_initcall_level+0x10a/0x1a0 init/main.c:1481
       do_initcalls+0x59/0xa0 init/main.c:1497
       kernel_init_freeable+0x29d/0x3e0 init/main.c:1732
       kernel_init+0x22/0x1d0 init/main.c:1622
       ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

-> #1 (fs_reclaim){+.+.}-{0:0}:
       __fs_reclaim_acquire mm/page_alloc.c:4390 [inline]
       fs_reclaim_acquire+0x71/0x100 mm/page_alloc.c:4404
       might_alloc include/linux/sched/mm.h:316 [inline]
       slab_pre_alloc_hook mm/slub.c:4673 [inline]
       slab_alloc_node mm/slub.c:5011 [inline]
       __do_kmalloc_node mm/slub.c:5530 [inline]
       __kmalloc_noprof+0xbc/0x710 mm/slub.c:5556
       generate_sched_domains kernel/cgroup/cpuset.c:924 [inline]
       rebuild_sched_domains_locked+0x608/0x950 kernel/cgroup/cpuset.c:1046
       rebuild_sched_domains_cpuslocked kernel/cgroup/cpuset.c:1078 [inline]
       cpuset_handle_hotplug+0xff9/0x10b0 kernel/cgroup/cpuset.c:4187
       cpuset_cpu_inactive kernel/sched/core.c:8634 [inline]
       sched_cpu_deactivate+0x7cb/0xf00 kernel/sched/core.c:8752
       cpuhp_invoke_callback+0x434/0x810 kernel/cpu.c:194
       cpuhp_thread_fun+0x362/0x780 kernel/cpu.c:1109
       smpboot_thread_fn+0x5f8/0xb30 kernel/smpboot.c:162
       kthread+0x38b/0x480 kernel/kthread.c:436
       ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

-> #0 (cpuset_mutex){+.+.}-{4:4}:
       check_prev_add kernel/locking/lockdep.c:3209 [inline]
       check_prevs_add kernel/locking/lockdep.c:3328 [inline]
       validate_chain kernel/locking/lockdep.c:3952 [inline]
       __lock_acquire+0x164c/0x2de0 kernel/locking/lockdep.c:5288
       lock_acquire+0x115/0x350 kernel/locking/lockdep.c:5942
       __mutex_lock_common kernel/locking/mutex.c:646 [inline]
       __mutex_lock+0x197/0x15a0 kernel/locking/mutex.c:821
       cpuset_can_attach+0xac/0x1170 kernel/cgroup/cpuset.c:3226
       cgroup_migrate_execute+0x20e/0x1820 kernel/cgroup/cgroup.c:2724
       cgroup_migrate kernel/cgroup/cgroup.c:3086 [inline]
       cgroup_attach_task+0x596/0x870 kernel/cgroup/cgroup.c:3117
       __cgroup_procs_write+0x28c/0x2f0 kernel/cgroup/cgroup.c:5530
       cgroup_procs_write+0x27/0x50 kernel/cgroup/cgroup.c:5543
       cgroup_file_write+0x331/0x8f0 kernel/cgroup/cgroup.c:4426
       kernfs_fop_write_iter+0x3a4/0x540 fs/kernfs/file.c:345
       new_sync_write fs/read_write.c:595 [inline]
       vfs_write+0x612/0xba0 fs/read_write.c:687
       ksys_write+0x150/0x270 fs/read_write.c:1036
       do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
       do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

Chain exists of:
  cpuset_mutex --> cpu_hotplug_lock --> cgroup_threadgroup_rwsem

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(cgroup_threadgroup_rwsem);
                               lock(cpu_hotplug_lock);
                               lock(cgroup_threadgroup_rwsem);
  lock(cpuset_mutex);

 *** DEADLOCK ***

locks held by syz-executor/15837: 5, last CPU#0:
 #0: ffff88807f5ce478 (sb_writers#9){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:2762 [inline]
 #0: ffff88807f5ce478 (sb_writers#9){.+.+}-{0:0}, at: vfs_write+0x22b/0xba0 fs/read_write.c:683
 #1: ffff88805d27a880 (&of->mutex){+.+.}-{4:4}, at: kernfs_fop_write_iter+0x1d8/0x540 fs/kernfs/file.c:336
 #2: ffffffff9019aa60 (cgroup_mutex){+.+.}-{4:4}, at: cgroup_lock include/linux/cgroup.h:485 [inline]
 #2: ffffffff9019aa60 (cgroup_mutex){+.+.}-{4:4}, at: cgroup_kn_lock_live+0x14f/0x260 kernel/cgroup/cgroup.c:1713
 #3: ffffffff8ffe61d0 (cpu_hotplug_lock){++++}-{0:0}, at: cgroup_attach_lock kernel/cgroup/cgroup.c:2544 [inline]
 #3: ffffffff8ffe61d0 (cpu_hotplug_lock){++++}-{0:0}, at: cgroup_procs_write_start+0x568/0x900 kernel/cgroup/cgroup.c:3182
 #4: ffffffff9019add0 (cgroup_threadgroup_rwsem){++++}-{0:0}, at: cgroup_attach_lock kernel/cgroup/cgroup.c:2550 [inline]
 #4: ffffffff9019add0 (cgroup_threadgroup_rwsem){++++}-{0:0}, at: cgroup_procs_write_start+0x574/0x900 kernel/cgroup/cgroup.c:3182

stack backtrace:
CPU: 0 UID: 0 PID: 15837 Comm: syz-executor Tainted: G S           L      syzkaller #0 PREEMPT(full) 
Tainted: [S]=CPU_OUT_OF_SPEC, [L]=SOFTLOCKUP
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/15/2026
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_circular_bug+0x2e2/0x300 kernel/locking/lockdep.c:2087
 check_noncircular+0x12f/0x150 kernel/locking/lockdep.c:2219
 check_prev_add kernel/locking/lockdep.c:3209 [inline]
 check_prevs_add kernel/locking/lockdep.c:3328 [inline]
 validate_chain kernel/locking/lockdep.c:3952 [inline]
 __lock_acquire+0x164c/0x2de0 kernel/locking/lockdep.c:5288
 lock_acquire+0x115/0x350 kernel/locking/lockdep.c:5942
 __mutex_lock_common kernel/locking/mutex.c:646 [inline]
 __mutex_lock+0x197/0x15a0 kernel/locking/mutex.c:821
 cpuset_can_attach+0xac/0x1170 kernel/cgroup/cpuset.c:3226
 cgroup_migrate_execute+0x20e/0x1820 kernel/cgroup/cgroup.c:2724
 cgroup_migrate kernel/cgroup/cgroup.c:3086 [inline]
 cgroup_attach_task+0x596/0x870 kernel/cgroup/cgroup.c:3117
 __cgroup_procs_write+0x28c/0x2f0 kernel/cgroup/cgroup.c:5530
 cgroup_procs_write+0x27/0x50 kernel/cgroup/cgroup.c:5543
 cgroup_file_write+0x331/0x8f0 kernel/cgroup/cgroup.c:4426
 kernfs_fop_write_iter+0x3a4/0x540 fs/kernfs/file.c:345
 new_sync_write fs/read_write.c:595 [inline]
 vfs_write+0x612/0xba0 fs/read_write.c:687
 ksys_write+0x150/0x270 fs/read_write.c:1036
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f696f56034e
Code: 08 0f 85 a5 a8 ff ff 49 89 fb 48 89 f0 48 89 d7 48 89 ce 4c 89 c2 4d 89 ca 4c 8b 44 24 08 4c 8b 4c 24 10 4c 89 5c 24 08 0f 05 <c3> 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 80 00 00 00 00 48 83 ec 08
RSP: 002b:00007ffe2c5e9878 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 000055557a9d2500 RCX: 00007f696f56034e
RDX: 0000000000000001 RSI: 00007ffe2c5e9900 RDI: 0000000000000003
RBP: 00007ffe2c5e9e70 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
R13: 00007ffe2c5e9900 R14: 00007ffe2c5e9e30 R15: 00007ffe2c5e9e70
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
