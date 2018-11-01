From: Nishanth Aravamudan <naravamudan@digitalocean.com>
Subject: Re: Kernel panic when enabling cgroup2 io controller at runtime
Date: Thu, 1 Nov 2018 16:06:56 -0700
Message-ID: <20181101230656.GA24021@breakout>
References: <20181101190340.GA10674@breakout>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=PBqYWVIG06GzdyMZbxj4Bw9qdNfjT85QI9u0P/71bQI=;
        b=agxsN4N4w77Y1keXptsd4YRrFy9gOSxZVrLXb0FewNbH91NoNBqHqb/SZpgsNakn1n
         VZBKM32hOJ6P06JPYsQEq8epWRX8R6dcnGcubJV0Oa2KiAtWfeW57PdX5OeVnfwBjtgj
         9rtNtSxt0MFXwW+1Pw4zyLIagELpDa8TzLwec=
Content-Disposition: inline
In-Reply-To: <20181101190340.GA10674@breakout>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On 01.11.2018 [12:03:40 -0700], Nishanth Aravamudan wrote:
> Hi,
> 
> tl;dr: I see a kernel NULL pointer dereference with Linus' master
> (7c6c54b5) when enabling the IO cgroup2 controller at runtime. Is this
> PEBKAC and if so what config option am I missing?

Actually, this might be totally unrelated to my cgroup testing, and just
happened to be exacerbated by it? Adding LKML to the CC, preserving the
prior oops below and pasting another oops I just got after waiting a bit
during a normal boot.

[   38.450985] BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
[   38.458879] PGD 0 P4D 0 
[   38.461444] Oops: 0000 [#1] SMP PTI
[   38.464964] CPU: 27 PID: 2159 Comm: auditd Kdump: loaded Tainted: G           O      4.19.0+ #3
[   38.473713] Hardware name: Dell Inc. PowerEdge R640/0W23H8, BIOS 1.2.11 10/19/2017
[   38.481298] RIP: 0010:get_request+0x133/0x8b0
[   38.485674] Code: ff ff ff 41 f7 d4 48 89 85 78 ff ff ff 4c 01 f8 41 83 c4 02 48 89 45 90 44 89 a5 74 ff ff ff 4d 8b 27 48 85 db 49 8b 44 24 18 <48> 8b 00 48 89 855
[   38.504489] RSP: 0018:ffffb59e5c3bb9c0 EFLAGS: 00010086
[   38.509722] RAX: 0000000000000000 RBX: ffffa0424bd78e00 RCX: 0000000000000001
[   38.516888] RDX: 0000355bbf83dbb0 RSI: 0000000000000800 RDI: ffffa041eb1a6c80
[   38.524047] RBP: ffffb59e5c3bba68 R08: 0000000000600000 R09: ffff9fe264871360
[   38.531188] R10: ffffb59e5c3bbb28 R11: 0000000000001000 R12: ffff9fe2635d9360
[   38.538340] R13: 0000000000000001 R14: 0000000000000040 R15: ffffa041eb1a6c40
[   38.545490] FS:  00007fec3109c700(0000) GS:ffffa0427f540000(0000) knlGS:0000000000000000
[   38.553618] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   38.559381] CR2: 0000000000000000 CR3: 000000beaf27a002 CR4: 00000000007606e0
[   38.566524] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   38.573680] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   38.580830] PKRU: 55555554
[   38.583543] Call Trace:
[   38.586013]  ? wait_woken+0x80/0x80
[   38.589543]  blk_queue_bio+0x131/0x460
[   38.593304]  generic_make_request+0x1a4/0x410
[   38.597673]  raid10_unplug+0x112/0x1b0 [raid10]
[   38.602211]  ? raid10_unplug+0x112/0x1b0 [raid10]
[   38.606927]  blk_flush_plug_list+0xce/0x250
[   38.611123]  blk_finish_plug+0x2c/0x40
[   38.614892]  ext4_writepages+0x635/0xe90
[   38.618837]  do_writepages+0x4b/0xe0
[   38.622424]  ? ext4_mark_inode_dirty+0x1d0/0x1d0
[   38.627068]  ? do_writepages+0x4b/0xe0
[   38.630838]  ? call_rcu+0x10/0x20
[   38.634168]  ? inode_switch_wbs+0x15d/0x190
[   38.638363]  __filemap_fdatawrite_range+0xc1/0x100
[   38.643161]  ? __filemap_fdatawrite_range+0xc1/0x100
[   38.648137]  file_write_and_wait_range+0x5a/0xb0
[   38.652767]  ext4_sync_file+0x111/0x3b0
[   38.656611]  vfs_fsync_range+0x48/0x80
[   38.660375]  ? __fget_light+0x54/0x60
[   38.664049]  do_fsync+0x3d/0x70
[   38.667203]  __x64_sys_fsync+0x14/0x20
[   38.670965]  do_syscall_64+0x5a/0x120
[   38.674639]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[   38.679710] RIP: 0033:0x7fec320eeb07
[   38.683764] Code: 00 00 0f 05 48 3d 00 f0 ff ff 77 3f f3 c3 0f 1f 44 00 00 53 89 fb 48 83 ec 10 e8 04 f5 ff ff 89 df 89 c2 b8 4a 00 00 00 0f 05 <48> 3d 00 f0 ff ff4
[   38.703360] RSP: 002b:00007fec3109be40 EFLAGS: 00000293 ORIG_RAX: 000000000000004a
[   38.711331] RAX: ffffffffffffffda RBX: 0000000000000005 RCX: 00007fec320eeb07
[   38.718882] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000005
[   38.726428] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
[   38.733936] R10: 0000000000000000 R11: 0000000000000293 R12: 00007fec3109bfc0
[   38.741467] R13: 0000000000000000 R14: 0000000000000000 R15: 00007ffdfe1da3e0
[   38.749025] Modules linked in: ebtable_filter ebtables ip6table_filter iptable_filter nbd vport_stt(O) openvswitch(O) nf_nat_ipv6 nf_nat_ipv4 nf_conncount nf_nat u0
[   38.749064]  multipath linear mlx5_ib raid1 raid10 ses enclosure scsi_transport_sas ib_uverbs ib_core mlx5_core mgag200 i2c_algo_bit mlxfw ttm devlink drm_kms_helpi
[   38.861715] CR2: 0000000000000000
[    0.061107] do_IRQ: 0.35 No irq handler for vector
[    0.103225] [Firmware Bug]: the BIOS has corrupted hw-PMU resources (MSR 38d is b0)
[    2.894501] scsi 0:0:32:0: Wrong diagnostic page; asked for 10 got 0
[    3.263453] Out of memory: Kill process 222 (systemd-udevd) score 10 or sacrifice child
[    3.271482] Killed process 222 (systemd-udevd) total-vm:26388kB, anon-rss:1244kB, file-rss:3088kB, shmem-rss:0kB
[    3.325928] Out of memory: Kill process 225 (systemd-udevd) score 10 or sacrifice child
[    3.333960] Killed process 386 (mdadm) total-vm:7236kB, anon-rss:120kB, file-rss:1788kB, shmem-rss:0kB
[    3.981778] Out of memory: Kill process 450 (loadkeys) score 5 or sacrifice child
[    3.989311] Killed process 450 (loadkeys) total-vm:4708kB, anon-rss:272kB, file-rss:1780kB, shmem-rss:0kB
[    3.999073] Out of memory: Kill process 422 (console_setup) score 4 or sacrifice child
[    4.007017] Killed process 422 (console_setup) total-vm:4800kB, anon-rss:116kB, file-rss:1836kB, shmem-rss:0kB
[    4.019602] Out of memory: Kill process 345 (modprobe) score 2 or sacrifice child
[    4.027129] Killed process 345 (modprobe) total-vm:7168kB, anon-rss:64kB, file-rss:920kB, shmem-rss:0kB
[    4.036751] Out of memory: Kill process 407 (modprobe) score 2 or sacrifice child
[    4.044264] Killed process 407 (modprobe) total-vm:6640kB, anon-rss:64kB, file-rss:780kB, shmem-rss:0kB
[    4.054011] Out of memory: Kill process 455 (init) score 0 or sacrifice child
[    4.061175] Killed process 457 (init) total-vm:4800kB, anon-rss:188kB, file-rss:0kB, shmem-rss:0kB
[    4.075054] Out of memory: Kill process 455 (init) score 0 or sacrifice child
[    4.082219] Killed process 455 (init) total-vm:4800kB, anon-rss:188kB, file-rss:0kB, shmem-rss:0kB
[    4.095381] Kernel panic - not syncing: System is deadlocked on memory
[    4.101928] CPU: 0 PID: 316 Comm: kworker/u2:9 Not tainted 4.19.0+ #3
[    4.108383] Hardware name: Dell Inc. PowerEdge R640/0W23H8, BIOS 1.2.11 10/19/2017
[    4.115971] Workqueue: mlx5_page_allocator pages_work_handler [mlx5_core]
[    4.122768] Call Trace:
[    4.125223]  dump_stack+0x63/0x85
[    4.128550]  panic+0xfe/0x264
[    4.131530]  out_of_memory+0x4fb/0x500
[    4.135294]  __alloc_pages_slowpath+0xa80/0xea0
[    4.139833]  __alloc_pages_nodemask+0x250/0x280
[    4.144378]  give_pages+0x1e7/0x730 [mlx5_core]
[    4.148925]  ? __switch_to_asm+0x40/0x70
[    4.152865]  pages_work_handler+0x33/0xb0 [mlx5_core]
[    4.157930]  process_one_work+0x20f/0x400
[    4.161951]  worker_thread+0x34/0x410
[    4.165624]  kthread+0x121/0x140
[    4.168865]  ? process_one_work+0x400/0x400
[    4.173060]  ? kthread_park+0x90/0x90
[    4.176734]  ret_from_fork+0x35/0x40
[    4.180326] Kernel Offset: 0x3a400000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
[    4.196269] ---[ end Kernel panic - not syncing: System is deadlocked on memory ]---

> [ 1015.243027] BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
> [ 1015.250913] PGD 0 P4D 0 
> [ 1015.253480] Oops: 0000 [#1] SMP PTI
> [ 1015.256997] CPU: 64 PID: 4129 Comm: monit Kdump: loaded Not tainted 4.19.0+ #3
> [ 1015.264231] Hardware name: Dell Inc. PowerEdge R640/0W23H8, BIOS 1.2.11 10/19/2017
> [ 1015.271819] RIP: 0010:get_request+0x133/0x8b0
> [ 1015.276184] Code: ff ff ff 41 f7 d4 48 89 85 78 ff ff ff 4c 01 f8 41 83 c4 02 48 89 45 90 44 89 a5 74 ff ff ff 4d 8b 27 48 85 db 49 8b 44 24 18 <48> 8b 00 48 89 855
> [ 1015.294963] RSP: 0018:ffffa4455abef9c0 EFLAGS: 00010086
> [ 1015.300196] RAX: 0000000000000000 RBX: ffff92cbf02ce900 RCX: 0000000000000001
> [ 1015.307337] RDX: 000031193f839fe8 RSI: 0000000000000800 RDI: ffff92cbeaaf8080
> [ 1015.314480] RBP: ffffa4455abefa68 R08: 0000000000600000 R09: ffff92cbe5ee89b0
> [ 1015.321622] R10: ffffa4455abefb28 R11: 0000000000001000 R12: ffff92cbe5248000
> [ 1015.328763] R13: 0000000000000001 R14: 0000000000000040 R15: ffff92cbeaaf8040
> [ 1015.335904] FS:  00007f38b114b740(0000) GS:ffff92cc00e00000(0000) knlGS:0000000000000000
> [ 1015.344005] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 1015.349761] CR2: 0000000000000000 CR3: 0000005e83002001 CR4: 00000000007606e0
> [ 1015.356901] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [ 1015.364042] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [ 1015.371182] PKRU: 55555554
> [ 1015.373895] Call Trace:
> [ 1015.376352]  ? wait_woken+0x80/0x80
> [ 1015.379852]  blk_queue_bio+0x131/0x460
> [ 1015.383611]  generic_make_request+0x1a4/0x410
> [ 1015.387983]  raid10_unplug+0x112/0x1b0 [raid10]
> [ 1015.392520]  ? raid10_unplug+0x112/0x1b0 [raid10]
> [ 1015.397234]  blk_flush_plug_list+0xce/0x250
> [ 1015.401430]  blk_finish_plug+0x2c/0x40
> [ 1015.405191]  ext4_writepages+0x635/0xe90
> [ 1015.409130]  ? generic_perform_write+0x124/0x1b0
> [ 1015.413756]  do_writepages+0x4b/0xe0
> [ 1015.417341]  ? ext4_mark_inode_dirty+0x1d0/0x1d0
> [ 1015.421970]  ? do_writepages+0x4b/0xe0
> [ 1015.425733]  ? call_rcu+0x10/0x20
> [ 1015.429061]  ? inode_switch_wbs+0x15d/0x190
> [ 1015.433253]  __filemap_fdatawrite_range+0xc1/0x100
> [ 1015.438053]  ? __filemap_fdatawrite_range+0xc1/0x100
> [ 1015.443029]  file_write_and_wait_range+0x5a/0xb0
> [ 1015.447658]  ext4_sync_file+0x111/0x3b0
> [ 1015.451505]  vfs_fsync_range+0x48/0x80
> [ 1015.455284]  ? __fget_light+0x54/0x60
> [ 1015.458966]  do_fsync+0x3d/0x70
> [ 1015.462139]  __x64_sys_fsync+0x14/0x20
> [ 1015.465900]  do_syscall_64+0x5a/0x120
> [ 1015.469576]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [ 1015.475044] RIP: 0033:0x7f38afe86b07
> [ 1015.478985] Code: 00 00 0f 05 48 3d 00 f0 ff ff 77 3f f3 c3 0f 1f 44 00 00 53 89 fb 48 83 ec 10 e8 04 f5 ff ff 89 df 89 c2 b8 4a 00 00 00 0f 05 <48> 3d 00 f0 ff ff4
> [ 1015.498501] RSP: 002b:00007fff53bc4140 EFLAGS: 00000293 ORIG_RAX: 000000000000004a
> [ 1015.506448] RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 00007f38afe86b07
> [ 1015.513971] RDX: 0000000000000000 RSI: 00007fff53bc4170 RDI: 0000000000000004
> [ 1015.521484] RBP: 00007fff53bc4170 R08: 0000000000000000 R09: 000000000000000a
> [ 1015.528991] R10: 00000000fffffff6 R11: 0000000000000293 R12: 0000561e723e1b68
> [ 1015.536504] R13: 0000000000000000 R14: 00007fff53bc42b4 R15: 0000000000000000
> [ 1015.544001] Modules linked in: ebtable_filter ebtables ip6table_filter iptable_filter nbd openvswitch nsh nf_nat_ipv6 nf_nat_ipv4 nf_conncount nf_nat bonding ip6tab
> [ 1015.544039]  raid1 raid10 ses enclosure scsi_transport_sas ib_uverbs ib_core mlx5_core mgag200 i2c_algo_bit mlxfw ttm devlink drm_kms_helper syscopyarea sysfillreci
> [ 1015.654479] CR2: 0000000000000000
> [    0.084151] [Firmware Bug]: the BIOS has corrupted hw-PMU resources (MSR 38d is b0)
> [    0.472249] BUG: unable to handle kernel paging request at 0000000000002088
> [    0.473712] PGD 0 P4D 0 
> [    0.473712] Oops: 0000 [#1] SMP PTI
> [    0.473712] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 4.19.0+ #3
> [    0.473712] Hardware name: Dell Inc. PowerEdge R640/0W23H8, BIOS 1.2.11 10/19/2017
> [    0.473712] RIP: 0010:__alloc_pages_nodemask+0xdc/0x280
> [    0.473712] Code: 00 00 44 89 fa 80 ca 80 83 f8 01 89 d8 44 0f 44 fa 48 8b 55 b0 c1 e8 08 83 e0 01 88 45 c8 48 89 f8 48 85 d2 0f 85 27 01 00 00 <3b> 77 08 0f 82 1e7
> [    0.473712] RSP: 0000:ffffb998000db7c8 EFLAGS: 00010246
> [    0.473712] RAX: 0000000000002080 RBX: 00000000006012c0 RCX: 0000000000000000
> [    0.473712] RDX: 0000000000000000 RSI: 0000000000000002 RDI: 0000000000002080
> [    0.473712] RBP: ffffb998000db820 R08: 0000000000000000 R09: 0000000000000000
> [    0.473712] R10: ffffb998000db8a0 R11: 000000000000000f R12: 0000000000000000
> [    0.473712] R13: 0000000000000000 R14: 00000000006012c0 R15: 0000000000000001
> [    0.473712] FS:  0000000000000000(0000) GS:ffff95edefe00000(0000) knlGS:0000000000000000
> [    0.473712] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    0.473712] CR2: 0000000000002088 CR3: 000000002a00a001 CR4: 00000000007606f0
> [    0.473712] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [    0.473712] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [    0.473712] PKRU: 00000000
> [    0.473712] Call Trace:
> [    0.473712]  new_slab+0xaa/0x710
> [    0.473712]  ___slab_alloc+0x37f/0x550
> [    0.473712]  ? acpi_ut_trace_ptr+0x2c/0x74
> [    0.473712]  ? alloc_desc+0x3c/0x220
> [    0.473712]  __slab_alloc+0x20/0x40
> [    0.473712]  ? __slab_alloc+0x20/0x40
> [    0.473712]  kmem_cache_alloc_node_trace+0xaf/0x200
> [    0.473712]  alloc_desc+0x3c/0x220
> [    0.473712]  __irq_alloc_descs+0x1c9/0x240
> [    0.473712]  irq_domain_alloc_descs+0x87/0xb0
> [    0.473712]  __irq_domain_alloc_irqs+0x1f2/0x310
> [    0.473712]  mp_map_pin_to_irq+0x299/0x2f0
> [    0.473712]  ? strstr+0x2c/0x70
> [    0.473712]  mp_map_gsi_to_irq+0xb5/0xe0
> [    0.473712]  acpi_register_gsi_ioapic+0x79/0x180
> [    0.473712]  acpi_register_gsi+0x15/0x20
> [    0.473712]  acpi_pci_irq_enable+0x124/0x2a0
> [    0.473712]  ? pci_read_config_word+0x23/0x40
> [    0.473712]  ? quirk_intel_mc_errata+0xd0/0xd0
> [    0.473712]  pcibios_enable_device+0x2e/0x40
> [    0.473712]  do_pci_enable_device+0x88/0x100
> [    0.473712]  pci_enable_device_flags+0xe8/0x130
> [    0.473712]  pci_enable_device+0x13/0x20
> [    0.473712]  pci_enable_bridge+0x52/0x90
> [    0.473712]  pci_enable_device_flags+0x91/0x130
> [    0.473712]  pci_enable_device_mem+0x13/0x20
> [    0.473712]  mellanox_check_broken_intx_masking+0x61/0x120
> [    0.473712]  pci_do_fixups+0xc9/0x120
> [    0.473712]  ? set_debug_rodata+0x17/0x17
> [    0.473712]  pci_apply_final_quirks+0x7a/0x127
> [    0.473712]  ? pci_proc_init+0x76/0x76
> [    0.473712]  do_one_initcall+0x4a/0x1c9
> [    0.473712]  kernel_init_freeable+0x21a/0x2c9
> [    0.473712]  ? rest_init+0xb0/0xb0
> [    0.473712]  kernel_init+0xe/0x110
> [    0.473712]  ret_from_fork+0x35/0x40
> [    0.473712] Modules linked in:
> [    0.473712] CR2: 0000000000002088
> [    0.473712] ---[ end trace ac0676b30797a2d2 ]---
> [    0.473712] RIP: 0010:__alloc_pages_nodemask+0xdc/0x280
> [    0.473712] Code: 00 00 44 89 fa 80 ca 80 83 f8 01 89 d8 44 0f 44 fa 48 8b 55 b0 c1 e8 08 83 e0 01 88 45 c8 48 89 f8 48 85 d2 0f 85 27 01 00 00 <3b> 77 08 0f 82 1e7
> [    0.473712] RSP: 0000:ffffb998000db7c8 EFLAGS: 00010246
> [    0.473712] RAX: 0000000000002080 RBX: 00000000006012c0 RCX: 0000000000000000
> [    0.473712] RDX: 0000000000000000 RSI: 0000000000000002 RDI: 0000000000002080
> [    0.473712] RBP: ffffb998000db820 R08: 0000000000000000 R09: 0000000000000000
> [    0.473712] R10: ffffb998000db8a0 R11: 000000000000000f R12: 0000000000000000
> [    0.473712] R13: 0000000000000000 R14: 00000000006012c0 R15: 0000000000000001
> [    0.473712] FS:  0000000000000000(0000) GS:ffff95edefe00000(0000) knlGS:0000000000000000
> [    0.473712] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    0.473712] CR2: 0000000000002088 CR3: 000000002a00a001 CR4: 00000000007606f0
> [    0.473712] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [    0.473712] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [    0.473712] PKRU: 00000000
> [    0.862647] Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000009
> [    0.866614] ---[ end Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000009 ]---
> 
> Longer details: I saw the panic originally when testing the recently
> submitted cpuset cgroup2 controller on a system with Ubuntu 18.04
> userspace. The only difference is that "cpuset" is in the list of
> available controllers, so I was doing "echo +io +cpuset" below. I am
> booting with 'cgroup_no_v1=all systemd.unified_cgroup_hierarchy=1':
> 
> # mount | grep cgroup2
> cgroup on /sys/fs/cgroup type cgroup2 (rw,nosuid,nodev,noexec,relatime,nsdelegate)
> # cd /sys/fs/cgroup
> # ls
> cgroup.controllers      cgroup.procs            cgroup.threads  user.slice
> cgroup.max.depth        cgroup.stat             init.scope
> cgroup.max.descendants  cgroup.subtree_control  system.slice
> # cat cgroup.controllers
> cpu io memory pids rdma
> # cat cgroup.subtree_control
> cpu memory pids
> # echo "+io" > cgroup.subtree_control
> ... wait a few seconds ...
> above panic is emitted on serial console
> 
> Thanks!
> -Nish
