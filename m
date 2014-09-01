From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster-Mmb7MZpHnFY@public.gmane.org>
Subject: cgroup : BUG: unable to handle kernel NULL pointer dereference (3.17.0-rc2)
Date: Mon, 01 Sep 2014 18:52:03 +0200
Message-ID: <5404A433.4080800@gmx.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Today I got within a 32bit x86 KVM  the following BUG (first time so far I can tell) :


...
Sep  1 18:46:11 n22kvm kernel:   11.832115] systemd-udevd[1012]: starting version 215
Sep  1 18:46:11 n22kvm kernel: [   12.196956] random: systemd-udevd urandom read with 20 bits of entropy available
Sep  1 18:46:11 n22kvm kernel: [   13.618175] cdrom_id (1070) used greatest stack depth: 5740 bytes left
Sep  1 18:46:11 n22kvm kernel: [   16.509115] EXT4-fs (vda4): re-mounted. Opts: (null)
Sep  1 18:46:11 n22kvm kernel: [   17.179782] runscript.sh (1161) used greatest stack depth: 5612 bytes left
Sep  1 18:46:11 n22kvm kernel: [   17.434859] Adding 499964k swap on /dev/vda3.  Priority:-1 extents:1 across:499964k FS
Sep  1 18:46:11 n22kvm kernel: [   17.746466] ------------[ cut here ]------------
Sep  1 18:46:11 n22kvm kernel: [   17.746485] WARNING: CPU: 1 PID: 1228 at kernel/cgroup.c:1034 cgroup_get+0x89/0xa0()
Sep  1 18:46:11 n22kvm kernel: [   17.746487] Modules linked in:
Sep  1 18:46:11 n22kvm kernel: [   17.746498] CPU: 1 PID: 1228 Comm: runscript.sh Not tainted 3.17.0-rc2 #4
Sep  1 18:46:11 n22kvm kernel: [   17.746501] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.7.5-0-ge51488c-20140602_164612-nilsson.home.kraxel.org 04/01/2014
Sep  1 18:46:11 n22kvm kernel: [   17.746504]  00000000 00000000 e5eede54 c16ee73d 00000000 e5eede84 c10468ef c18bf750
Sep  1 18:46:11 n22kvm kernel: [   17.746513]  00000001 000004cc c18caaab 0000040a c10bb999 c10bb999 e5d9e200 e5ef6420
Sep  1 18:46:11 n22kvm kernel: [   17.746521]  f632fb20 e5eede94 c104692d 00000009 00000000 e5eedeb0 c10bb999 c13e9ec6
Sep  1 18:46:11 n22kvm kernel: [   17.746539] Call Trace:
Sep  1 18:46:11 n22kvm kernel: [   17.746560]  [<c16ee73d>] dump_stack+0x41/0x52
Sep  1 18:46:11 n22kvm kernel: [   17.746566]  [<c10468ef>] warn_slowpath_common+0x7f/0xa0
Sep  1 18:46:11 n22kvm kernel: [   17.746571]  [<c10bb999>] ? cgroup_get+0x89/0xa0
Sep  1 18:46:11 n22kvm kernel: [   17.746576]  [<c10bb999>] ? cgroup_get+0x89/0xa0
Sep  1 18:46:11 n22kvm kernel: [   17.746580]  [<c104692d>] warn_slowpath_null+0x1d/0x20
Sep  1 18:46:11 n22kvm kernel: [   17.746584]  [<c10bb999>] cgroup_get+0x89/0xa0
Sep  1 18:46:11 n22kvm kernel: [   17.746603]  [<c13e9ec6>] ? kstrtoll+0x16/0x70
Sep  1 18:46:11 n22kvm kernel: [   17.746608]  [<c10bbe58>] cgroup_kn_lock_live+0x28/0x70
Sep  1 18:46:11 n22kvm kernel: [   17.746613]  [<c10be3c1>] __cgroup_procs_write.isra.26+0x51/0x230
Sep  1 18:46:11 n22kvm kernel: [   17.746618]  [<c10be5a0>] ? __cgroup_procs_write.isra.26+0x230/0x230
Sep  1 18:46:11 n22kvm kernel: [   17.746623]  [<c10be5b2>] cgroup_tasks_write+0x12/0x20
Sep  1 18:46:11 n22kvm kernel: [   17.746628]  [<c10bb7b0>] cgroup_file_write+0x40/0x130
Sep  1 18:46:11 n22kvm kernel: [   17.746633]  [<c10bb770>] ? kill_css+0xc0/0xc0
Sep  1 18:46:11 n22kvm kernel: [   17.746653]  [<c11aee71>] kernfs_fop_write+0xd1/0x160
Sep  1 18:46:11 n22kvm kernel: [   17.746658]  [<c11aeda0>] ? kernfs_vma_page_mkwrite+0x90/0x90
Sep  1 18:46:11 n22kvm kernel: [   17.746671]  [<c1148e58>] vfs_write+0x98/0x1e0
Sep  1 18:46:11 n22kvm kernel: [   17.746676]  [<c11aeda0>] ? kernfs_vma_page_mkwrite+0x90/0x90
Sep  1 18:46:11 n22kvm kernel: [   17.746688]  [<c116338d>] ? __fdget+0xd/0x10
Sep  1 18:46:11 n22kvm kernel: [   17.746692]  [<c114934d>] SyS_write+0x4d/0xa0
Sep  1 18:46:11 n22kvm kernel: [   17.746699]  [<c16f656b>] sysenter_do_call+0x12/0x12
Sep  1 18:46:11 n22kvm kernel: [   17.746702] ---[ end trace 6f2e0c38c2108a74 ]---
Sep  1 18:46:11 n22kvm kernel: [   17.746823] BUG: unable to handle kernel NULL pointer dereference at 00000038
Sep  1 18:46:11 n22kvm kernel: [   17.747798] IP: [<c10bbd69>] cgroup_put+0x9/0x80
Sep  1 18:46:11 n22kvm kernel: [   17.747798] *pde = 00000000
Sep  1 18:46:11 n22kvm kernel: [   17.747798] Oops: 0000 [#1] SMP
Sep  1 18:46:11 n22kvm kernel: [   17.747798] Modules linked in:
Sep  1 18:46:11 n22kvm kernel: [   17.747798] CPU: 1 PID: 1228 Comm: runscript.sh Tainted: G        W      3.17.0-rc2 #4
Sep  1 18:46:11 n22kvm kernel: [   17.747798] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.7.5-0-ge51488c-20140602_164612-nilsson.home.kraxel.org 04/01/2014
Sep  1 18:46:11 n22kvm kernel: [   17.747798] task: f5823700 ti: e5eec000 task.ti: e5eec000
Sep  1 18:46:11 n22kvm kernel: [   17.747798] EIP: 0060:[<c10bbd69>] EFLAGS: 00010282 CPU: 1
Sep  1 18:46:11 n22kvm kernel: [   17.747798] EIP is at cgroup_put+0x9/0x80
Sep  1 18:46:11 n22kvm kernel: [   17.747798] EAX: 00000000 EBX: 00000000 ECX: 0053e2a5 EDX: 0000000a
Sep  1 18:46:11 n22kvm kernel: [   17.747798] ESI: 00000000 EDI: f632fb20 EBP: e5eedea0 ESP: e5eede8c
Sep  1 18:46:11 n22kvm kernel: [   17.747798]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
Sep  1 18:46:11 n22kvm kernel: [   17.747798] CR0: 8005003b CR2: 00000038 CR3: 25ce6000 CR4: 000006c0
Sep  1 18:46:11 n22kvm kernel: [   17.747798] Stack:
Sep  1 18:46:11 n22kvm kernel: [   17.747798]  c11ae603 00000000 00000001 00000000 e5ef6420 e5eedeb0 c10bbe19 00000000
Sep  1 18:46:11 n22kvm kernel: [   17.747798]  e5ef6420 e5eedec0 c10bbe91 f5823700 00000000 e5eedefc c10be3c1 00000246
Sep  1 18:46:11 n22kvm kernel: [   17.747798]  00000000 f5823c6c f5823c60 00000002 00000000 f60b4280 f6369d80 e5eedf1c
Sep  1 18:46:11 n22kvm kernel: [   17.747798] Call Trace:
Sep  1 18:46:11 n22kvm kernel: [   17.747798]  [<c11ae603>] ? kernfs_unbreak_active_protection+0x43/0x50
Sep  1 18:46:11 n22kvm kernel: [   17.747798]  [<c10bbe19>] cgroup_kn_unlock+0x39/0x50
Sep  1 18:46:11 n22kvm kernel: [   17.747798]  [<c10bbe91>] cgroup_kn_lock_live+0x61/0x70
Sep  1 18:46:11 n22kvm kernel: [   17.747798]  [<c10be3c1>] __cgroup_procs_write.isra.26+0x51/0x230
Sep  1 18:46:11 n22kvm kernel: [   17.747798]  [<c10be5a0>] ? __cgroup_procs_write.isra.26+0x230/0x230
Sep  1 18:46:11 n22kvm kernel: [   17.747798]  [<c10be5b2>] cgroup_tasks_write+0x12/0x20
Sep  1 18:46:11 n22kvm kernel: [   17.747798]  [<c10bb7b0>] cgroup_file_write+0x40/0x130
Sep  1 18:46:11 n22kvm kernel: [   17.747798]  [<c10bb770>] ? kill_css+0xc0/0xc0
Sep  1 18:46:11 n22kvm kernel: [   17.747798]  [<c11aee71>] kernfs_fop_write+0xd1/0x160
Sep  1 18:46:11 n22kvm kernel: [   17.747798]  [<c11aeda0>] ? kernfs_vma_page_mkwrite+0x90/0x90
Sep  1 18:46:11 n22kvm kernel: [   17.747798]  [<c1148e58>] vfs_write+0x98/0x1e0
Sep  1 18:46:11 n22kvm kernel: [   17.747798]  [<c11aeda0>] ? kernfs_vma_page_mkwrite+0x90/0x90
Sep  1 18:46:11 n22kvm kernel: [   17.747798]  [<c116338d>] ? __fdget+0xd/0x10
Sep  1 18:46:11 n22kvm kernel: [   17.747798]  [<c114934d>] SyS_write+0x4d/0xa0
Sep  1 18:46:11 n22kvm kernel: [   17.747798]  [<c16f656b>] sysenter_do_call+0x12/0x12
Sep  1 18:46:11 n22kvm kernel: [   17.747798] Code: d4 fe ff ff c7 04 24 2c 42 8c c1 e8 e4 ef 62 00 e9 72 ff ff ff 8d b6 00 00 00 00 8d bc 27 00 00 00 00 55 89 e5 53 89 c3 83 ec 10 <f6> 40 38 01 74 09 83 c4 10 5b 5d c3 8d 76 00 31 c9 31 d2 b8 d0
Sep  1 18:46:11 n22kvm kernel: [   17.747798] EIP: [<c10bbd69>] cgroup_put+0x9/0x80 SS:ESP 0068:e5eede8c
Sep  1 18:46:11 n22kvm kernel: [   17.747798] CR2: 0000000000000038
Sep  1 18:46:11 n22kvm kernel: [   17.853514] ---[ end trace 6f2e0c38c2108a75 ]---
Sep  1 18:46:11 n22kvm kernel: [   28.640724] random: nonblocking pool is initialized
Sep  1 18:46:12 n22kvm sshd[1708]: Server listening on 0.0.0.0 port 22.
Sep  1 18:46:12 n22kvm sshd[1708]: Server listening on :: port 22.


-- 
Toralf
pgp key: 0076 E94E
