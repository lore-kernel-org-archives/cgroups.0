Received: from mail-4397.protonmail.ch (mail-4397.protonmail.ch [185.70.43.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D700A415F13;
	Mon,  7 Sep 2026 19:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.43.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788809278; cv=none; b=m+1TBQaKuxzz7broWVuI9fQ5UpWqmMHCxx2ZNeo+A/CWL2bYoV53MT00eheMpF1DYN/AEG1dTL/0+BASYRnUzgyTe8N4ZSahG7MbuJMy6zvrJratJB7iP9VNCgfNTurVnyHTZVTBRQ+gUnIhyP72mDTK5k8NUe8mAAlwD8ZWKR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788809278; c=relaxed/simple;
	bh=KQkRWJa/S42oBN4Jx/yX1sIMHM4s4hfeMAAIs4vNwns=;
	h=Date:To:From:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=dcmA2XDHcAYmkNkxk8uGAJInuZfolN+LzD8tr1CXm+ljUqZhE56qh/d+ZZbCzC0jvKBRBykueLsAQU8fLpCC+FaI6OoL+9SqfeA0Gfr8LyiOTZv/mNopfQRvuo41Gic9+sRX4443mQibq0f6gMBBk5HjV9IbRJsTgzBt+1LKhCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=feldt.systems; spf=pass smtp.mailfrom=feldt.systems; dkim=pass (2048-bit key) header.d=feldt.systems header.i=@feldt.systems header.b=IvpeVm9P; arc=none smtp.client-ip=185.70.43.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=feldt.systems
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=feldt.systems
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=feldt.systems header.i=@feldt.systems header.b="IvpeVm9P"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=feldt.systems;
	s=protonmail2; t=1788809259; x=1789068459;
	bh=z5n2HzWFrUazyclH9ORbOoCnE/An9c/eBoeCNKCjNNE=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=IvpeVm9PLGKAr+bCAX1LyJygyTY9Bh8Wckk5v9/bUKMDqrgGKnXQNYQr5lcKoF5p/
	 ZgH0emx+bVf7Ctaih5ReYOl6LwT+9Xix2Hq3N1VMT3y62DQEr9meDOQuX3xucQTfJ6
	 iVqyRpNFG1IR3EPFxApl71fubbhOxoDh0GRHKz99+PdXcy3JerOErfWwEwVwaSjAUb
	 AbGYKdITy0tMiQJdBHOeZLHrbrilhaZe0V2N5q8HRSU9gUC4uM9CzwAViqknXTTF4N
	 PIQqIcE0ahPaHYwoaO8EUIgLu43VTVIwdZV0P/qoMNjsEJAw58cpytsrRlxic5512f
	 wy1dIwxNLGatQ==
Date: Mon, 07 Sep 2026 19:27:32 +0000
To: mkoutny@suse.com, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
From: Noah Feldt <noah@feldt.systems>
Cc: N.Feldt@mittwald.de, carnil@debian.org, dschatzberg@meta.com, hannes@cmpxchg.org, peterz@infradead.org, stable@vger.kernel.org, Noah Elias Feldt <noah@feldt.systems>
Subject: Re: [PATCH v2] cgroup: Avoid iteration of dying tasks with zero refcount
Message-ID: <20260907192723.72167-1-noah@feldt.systems>
Feedback-ID: 113045274:user:proton
X-Pm-Message-ID: 5f3db72d9d49d936510c6d4c1130a00c54ba3de1
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha256; boundary="------d6f859215e7a76ea2c8b0c10696b6ee0365c72ed613f24189a8699040c1255d0"; charset=utf-8

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------d6f859215e7a76ea2c8b0c10696b6ee0365c72ed613f24189a8699040c1255d0
From: Noah Feldt <noah@feldt.systems>
To: mkoutny@suse.com,
	Tejun Heo <tj@kernel.org>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: N.Feldt@mittwald.de,
	carnil@debian.org,
	dschatzberg@meta.com,
	hannes@cmpxchg.org,
	peterz@infradead.org,
	stable@vger.kernel.org,
	Noah Elias Feldt <noah@feldt.systems>
Subject: Re: [PATCH v2] cgroup: Avoid iteration of dying tasks with zero refcount
Date: Mon,  7 Sep 2026 21:27:23 +0200
Message-ID: <20260907192723.72167-1-noah@feldt.systems>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260907170345.45316-1-mkoutny@suse.com>
References: <20260907170345.45316-1-mkoutny@suse.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="----=_cgroup_lockup_20260907"

------=_cgroup_lockup_20260907
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Michal,

thanks for the v2. I tested it on the same production node and with the
same reproducer (the 2nd PoC) that triggered the original crash.

Result: it no longer panics, the use-after-free of the reaped leader is
gone. But the node now hard-locks up instead. dmesg is attached as
prod.log (module lists trimmed); the relevant part is:

  watchdog: CPU24: Watchdog detected hard LOCKUP on cpu 24
  RIP: 0010:native_queued_spin_lock_slowpath+0x2aa/0x2f0
  Call Trace:
   _raw_spin_lock_irqsave+0x3d/0x50
   cgroup_task_dead+0x29/0x140
   finish_task_switch.isra.0+0x238/0x2c0
   __schedule+0x4ec/0xfe0

i.e. one CPU spins forever holding css_set_lock with IRQs disabled, and
the other CPUs pile up on that spinlock until the NMI watchdog fires on
several of them.

> First, I replaced the if() with a while() loop because when one such
> dying leader could remain on dying_tasks, there can be more of them
> (matter of effort) and single css_task_iter_advance() won't be
 enough
> (we need to skip all such tasks before get_task_struct()).

The while() is what locks up:

> +	while (it->task_pos && it->cur_tasks_head == &it->cur_cset->dying_tasks) {
> +		task = list_entry(it->task_pos, struct task_struct, cg_list);
> +		if (!atomic_read(&task->signal->live))
> +			css_task_iter_advance(it);
> +	}

A LLM helped me debug this

When the leader is still live, atomic_read(&task->signal->live) != 0, so
the if() body is skipped, css_task_iter_advance() is never called,
it->task_pos never moves and the loop condition stays true forever. A
live dying-list leader thus spins the loop under css_set_lock -> the hard
lockup above.

The loop has to stop on the first live leader (that is exactly the task we
want to hand out) and only advance past the dead ones. Turning the skip
into a break makes it terminate. The variant I tested:

--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -5209,6 +5209,7 @@
  */
 struct task_struct *css_ta
sk_iter_next(struct css_task_iter *it)
 {
+	struct task_struct *task;
 	unsigned long irqflags;

 	if (it->cur_task) {
@@ -5222,6 +5223,22 @@
 	if (it->flags & CSS_TASK_ITER_SKIPPED)
 		css_task_iter_advance(it);

+	/*
+	 * @it->task_pos was picked on an earlier call. A dying leader stays on
+	 * dying_tasks until cgroup_task_free(), past its last usage ref drop,
+	 * so it may have been reaped since and get_task_struct() on it would
+	 * resurrect a task about to be freed. That last ref is dropped by an
+	 * RCU callback queued from release_task(), after signal->live hit zero,
+	 * so a leader still showing live threads in this irq-disabled section
+	 * can't lose its ref before the section ends.
+	 */
+	while (it->task_pos && it->cur_tasks_head == &it->cur_cset->dying_tasks) {
+		task = list_entry(it->task_pos, struct task_struct, cg_list);
+		if (atomic_read(&task->signal->live))
+			break;
+		css_task_iter_advance(it);
+	}
+
 	if (it->task_pos) {
 		it->c
ur_task = list_entry(it->task_pos, struct task_struct,
 					  cg_list);

Same reproducer after this change: no panic and no lockup, the node stays
up under the load that reproduced it before.

Tested-by: Noah Elias Feldt <N.Feldt@mittwald.de> # while-variant with the break

Thanks,
Noah

------=_cgroup_lockup_20260907
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=utf-8; name="prod.log"
Content-Disposition: attachment; filename="prod.log"



1788807752612	2026-09-07T19:02:32.612Z	[  402.257200] watchdog: CPU24: Watchdog detected hard LOCKUP on cpu 24
1788807752612	2026-09-07T19:02:32.612Z	[  401.990181]  </TASK>
1788807752612	2026-09-07T19:02:32.612Z	[  401.990175]  common_startup_64+0x13e/0x141
1788807752612	2026-09-07T19:02:32.612Z	[  401.990172]  start_secondary+0x128/0x170
1788807752612	2026-09-07T19:02:32.612Z	[  401.990169]  cpu_startup_entry+0x29/0x30
1788807752602	2026-09-07T19:02:32.602Z	[  401.990164]  do_idle+0x16c/0x2a0
1788807752602	2026-09-07T19:02:32.602Z	[  401.990161]  schedule_idle+0x23/0x40
1788807752602	2026-09-07T19:02:32.602Z	[  401.990156]  __schedule+0x4ec/0xfe0
1788807752602	2026-09-07T19:02:32.602Z	[  401.990152]  finish_task_switch.isra.0+0x238/0x2c0
1788807752602	2026-09-07T19:02:32.602Z	[  401.990148]  cgroup_task_dead+0x29/0x140
1788807752501	2026-09-07T19:02:32.501Z	[  401.990144]  _raw_spin_lock_irqsave+0x3d/0x50
1788807752501	2026-09-07T19:02:32.501Z	[  401.990139]  <TASK>
1
788807752501	2026-09-07T19:02:32.501Z	[  401.990137] Call Trace:
1788807752501	2026-09-07T19:02:32.501Z	[  401.990136] PKRU: 55555554
1788807752492	2026-09-07T19:02:32.492Z	[  401.990135] CR2: 00007f3834000020 CR3: 00000003cd22300d CR4: 0000000000f71ef0
1788807752492	2026-09-07T19:02:32.492Z	[  401.990134] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
1788807752492	2026-09-07T19:02:32.492Z	[  401.990132] FS:  0000000000000000(0000) GS:ff35266ea25e3000(0000) knlGS:0000000000000000
1788807752482	2026-09-07T19:02:32.482Z	[  401.990131] R13: 0000000000300000 R14: 000000000000005f R15: 0000000000000000
1788807752482	2026-09-07T19:02:32.482Z	[  401.990130] R10: 0000000000000000 R11: ff35266e4a8dd180 R12: ff35266e4bdf3400
1788807752482	2026-09-07T19:02:32.482Z	[  401.990129] RBP: ff35266e4a8f3400 R08: 00000056bb9f34e6 R09: 0000000000000001
1788807752471	2026-09-07T19:02:32.471Z	[  401.990128] RDX: 0000000000000060 RSI: 0000000001800101 RDI: ffffffffa83b3ee4
1788807752471	2026-09-
07T19:02:32.471Z	[  401.990127] RAX: 0000000000000000 RBX: ffffffffa83b3ee4 RCX: 0000000000000000
1788807752471	2026-09-07T19:02:32.471Z	[  401.990125] RSP: 0018:ff500c2fc02bfd90 EFLAGS: 00000046
1788807752462	2026-09-07T19:02:32.462Z	[  401.990123] Code: 63 f6 4c 8d a0 00 04 31 a8 49 81 fe 00 20 00 00 73 45 4e 03 24 f5 e0 60 ed a6 49 89 2c 24 8b 45 08 85 c0 75 09 f3 90 8b 45 08 <85> c0 74 f7 48 8b 55 00 48 85 d2 0f 84 6b ff ff ff 0f 0d 0a e9 63
1788807752462	2026-09-07T19:02:32.462Z	[  401.990118] RIP: 0010:native_queued_spin_lock_slowpath+0x2aa/0x2f0
1788807752452	2026-09-07T19:02:32.452Z	[  401.990116] Hardware name: ASUSTeK COMPUTER INC. RS500A-E12-RS12U/K14PA-U24 Series, BIOS 1201 08/25/2023
1788807752441	2026-09-07T19:02:32.441Z	[  401.990111] CPU: 11 UID: 0 PID: 0 Comm: swapper/11 Tainted: P           OEL      7.0.13+deb13-amd64 #1 PREEMPT(lazy)  Debian 7.0.13-1~bpo13+1
1788807752332	2026-09-07T19:02:32.332Z	[  401.990067]  nvme_tcp br_netfilter bridge stp llc overlay nvme
_fabrics drm efi_pstore configfs nfnetlink efivarfs ip_tables x_tables autofs4 isofs virtio_net net_failover failover nls_ascii nls_cp437 vfat fat sr_mod cdrom sd_mod zfs(POE) spl(OE) drbd(OE) lru_cache uas hid_generic usbhid cdc_ether usbnet hid usb_storage mii xhci_pci sp5100_tco xhci_hcd ahci nvme watchdog libahci libata nvme_core igb bnxt_en usbcore scsi_mod nvme_keyring i2c_algo_bit nvme_auth i2c_piix4 hkdf dca usb_common i2c_smbus scsi_common wmi aesni_intel
1788807752282	2026-09-07T19:02:32.282Z	[  401.989998] watchdog: CPU11: Watchdog detected hard LOCKUP on cpu 11
1788807752282	2026-09-07T19:02:32.282Z	[  401.775201]  </TASK>
1788807752282	2026-09-07T19:02:32.282Z	[  401.775195]  ret_from_fork_asm+0x1a/0x30
1788807752282	2026-09-07T19:02:32.282Z	[  401.775193]  ? __pfx_kthread+0x10/0x10
1788807752282	2026-09-07T19:02:32.282Z	[  401.775189]  ret_from_fork+0x2cf/0x360
1788807752282	2026-09-07T19:02:32.282Z	[  401.775187]  ? __pfx_kthread+0x10/0x10
1788807752282	2026-09-07
T19:02:32.282Z	[  401.775185]  kthread+0xe3/0x120
1788807752272	2026-09-07T19:02:32.272Z	[  401.775182]  ? __pfx_kthread_worker_fn+0x10/0x10
1788807752272	2026-09-07T19:02:32.272Z	[  401.775178]  kthread_worker_fn+0xb0/0x290
1788807752272	2026-09-07T19:02:32.272Z	[  401.775176]  ? __pfx_sync_rcu_exp_select_node_cpus+0x10/0x10
1788807752272	2026-09-07T19:02:32.272Z	[  401.775171]  __sync_rcu_exp_select_node_cpus+0x22f/0x410
1788807752262	2026-09-07T19:02:32.262Z	[  401.775167]  ? __schedule+0x4ec/0xfe0
1788807752262	2026-09-07T19:02:32.262Z	[  401.775161]  <TASK>
1788807752262	2026-09-07T19:02:32.262Z	[  401.775158] Call Trace:
1788807752262	2026-09-07T19:02:32.262Z	[  401.775157] PKRU: 55555554
1788807752262	2026-09-07T19:02:32.262Z	[  401.775156] CR2: 00007f2d6aec7490 CR3: 00000002f756e001 CR4: 0000000000f71ef0
1788807752262	2026-09-07T19:02:32.262Z	[  401.775155] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
1788807752162	2026-09-07T19:02:32.162Z	[  401.775153] FS:  00
00000000000000(0000) GS:ff35266ea48e3000(0000) knlGS:0000000000000000
1788807752162	2026-09-07T19:02:32.162Z	[  401.775152] R13: ffffffffa7710df0 R14: 0000000000000093 R15: 0000000000002785
1788807752152	2026-09-07T19:02:32.152Z	[  401.775151] R10: 0000000000000000 R11: ff35266e4cbdd180 R12: ffffffffa8309920
1788807752152	2026-09-07T19:02:32.152Z	[  401.775150] RBP: ff500c2fc2773e40 R08: ffffffffa5a49f10 R09: 0000000000000001
1788807752152	2026-09-07T19:02:32.152Z	[  401.775149] RDX: 0000000000000000 RSI: ff35266e4cbf3840 RDI: 0000000000000093
1788807752141	2026-09-07T19:02:32.141Z	[  401.775147] RAX: 0000000000000001 RBX: ff35266e4caf3480 RCX: 0000000000000000
1788807752141	2026-09-07T19:02:32.141Z	[  401.775145] RSP: 0018:ff500c2fc2773e00 EFLAGS: 00000202
1788807752131	2026-09-07T19:02:32.131Z	[  401.775143] Code: 48 2b 15 61 f7 85 02 75 66 c9 e9 5c e8 c6 ff 65 48 8b 05 71 f7 85 02 48 8d b0 40 08 31 a8 8b 46 08 a8 01 74 09 f3 90 8b 46 08 <a8> 01 75 f7 83 4e 08 01 4c 89 46 10 4
8 89 56 18 e8 a1 fd ff ff eb
1788807752131	2026-09-07T19:02:32.131Z	[  401.775137] RIP: 0010:smp_call_function_single+0xea/0x140
1788807752122	2026-09-07T19:02:32.122Z	[  401.775135] Hardware name: ASUSTeK COMPUTER INC. RS500A-E12-RS12U/K14PA-U24 Series, BIOS 1201 08/25/2023
1788807752122	2026-09-07T19:02:32.122Z	[  401.775134] Tainted: [P]=PROPRIETARY_MODULE, [O]=OOT_MODULE, [E]=UNSIGNED_MODULE, [L]=SOFTLOCKUP
1788807752111	2026-09-07T19:02:32.111Z	[  401.775130] CPU: 151 UID: 0 PID: 894 Comm: rcu_exp_par_gp_ Tainted: P           OEL      7.0.13+deb13-amd64 #1 PREEMPT(lazy)  Debian 7.0.13-1~bpo13+1
1788807752092	2026-09-07T19:02:32.092Z	[  401.775084]  nvme_tcp br_netfilter bridge stp llc overlay nvme_fabrics drm efi_pstore configfs nfnetlink efivarfs ip_tables x_tables autofs4 isofs virtio_net net_failover failover nls_ascii nls_cp437 vfat fat sr_mod cdrom sd_mod zfs(POE) spl(OE) drbd(OE) lru_cache uas hid_generic usbhid cdc_ether usbnet hid usb_storage mii xhci_pci sp5100_tco x
hci_hcd ahci nvme watchdog libahci libata nvme_core igb bnxt_en usbcore scsi_mod nvme_keyring i2c_algo_bit nvme_auth i2c_piix4 hkdf dca usb_common i2c_smbus scsi_common wmi aesni_intel
1788807751942	2026-09-07T19:02:31.942Z	[  401.775014] watchdog: BUG: soft lockup - CPU#151 stuck for 23s! [rcu_exp_par_gp_:894]
1788807751942	2026-09-07T19:02:31.942Z	[  401.755202]  </TASK>
1788807751942	2026-09-07T19:02:31.942Z	[  401.755196]  ret_from_fork_asm+0x1a/0x30
1788807751942	2026-09-07T19:02:31.942Z	[  401.755194]  ? __pfx_kthread+0x10/0x10
1788807751942	2026-09-07T19:02:31.942Z	[  401.755191]  ret_from_fork+0x2cf/0x360
1788807751942	2026-09-07T19:02:31.942Z	[  401.755188]  ? __pfx_kthread+0x10/0x10
1788807751931	2026-09-07T19:02:31.931Z	[  401.755186]  kthread+0xe3/0x120
1788807751931	2026-09-07T19:02:31.931Z	[  401.755183]  ? __pfx_kthread_worker_fn+0x10/0x10
1788807751931	2026-09-07T19:02:31.931Z	[  401.755179]  kthread_worker_fn+0xb0/0x290
1788807751931	2026-09-07T19:02:31.931Z	
[  401.755177]  ? __pfx_sync_rcu_exp_select_node_cpus+0x10/0x10
1788807751931	2026-09-07T19:02:31.931Z	[  401.755172]  __sync_rcu_exp_select_node_cpus+0x22f/0x410
1788807751922	2026-09-07T19:02:31.922Z	[  401.755168]  ? __schedule+0x4ec/0xfe0
1788807751922	2026-09-07T19:02:31.922Z	[  401.755162]  <TASK>
1788807751922	2026-09-07T19:02:31.922Z	[  401.755160] Call Trace:
1788807751922	2026-09-07T19:02:31.922Z	[  401.755159] PKRU: 55555554
1788807751922	2026-09-07T19:02:31.922Z	[  401.755158] CR2: 00007ff3ddd80285 CR3: 000000045820c01f CR4: 0000000000f71ef0
1788807751912	2026-09-07T19:02:31.912Z	[  401.755156] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
1788807751912	2026-09-07T19:02:31.912Z	[  401.755155] FS:  0000000000000000(0000) GS:ff35266ea44e3000(0000) knlGS:0000000000000000
1788807751912	2026-09-07T19:02:31.912Z	[  401.755154] R13: ffffffffa7710b30 R14: 0000000000000081 R15: 0000000000009d80
1788807751811	2026-09-07T19:02:31.811Z	[  401.755152] R10: 0000000000000000
 R11: ff35266e4c7dd180 R12: ffffffffa8309920
1788807751811	2026-09-07T19:02:31.811Z	[  401.755151] RBP: ff500c2fc242be40 R08: ffffffffa5a49f10 R09: 0000000000000001
1788807751802	2026-09-07T19:02:31.802Z	[  401.755150] RDX: 0000000000000000 RSI: ff35266e4c7f3840 RDI: 0000000000000081
1788807751802	2026-09-07T19:02:31.802Z	[  401.755149] RAX: 0000000000000001 RBX: ff35266e4c673480 RCX: 0000000000000000
1788807751802	2026-09-07T19:02:31.802Z	[  401.755146] RSP: 0018:ff500c2fc242be00 EFLAGS: 00000202
1788807751792	2026-09-07T19:02:31.792Z	[  401.755145] Code: 48 2b 15 61 f7 85 02 75 66 c9 e9 5c e8 c6 ff 65 48 8b 05 71 f7 85 02 48 8d b0 40 08 31 a8 8b 46 08 a8 01 74 09 f3 90 8b 46 08 <a8> 01 75 f7 83 4e 08 01 4c 89 46 10 48 89 56 18 e8 a1 fd ff ff eb
1788807751792	2026-09-07T19:02:31.792Z	[  401.755138] RIP: 0010:smp_call_function_single+0xea/0x140
1788807751782	2026-09-07T19:02:31.782Z	[  401.755136] Hardware name: ASUSTeK COMPUTER INC. RS500A-E12-RS12U/K14PA-U24 Series, BIOS 1201 
08/25/2023
1788807751782	2026-09-07T19:02:31.782Z	[  401.755135] Tainted: [P]=PROPRIETARY_MODULE, [O]=OOT_MODULE, [E]=UNSIGNED_MODULE, [L]=SOFTLOCKUP
1788807751771	2026-09-07T19:02:31.771Z	[  401.755130] CPU: 135 UID: 0 PID: 797 Comm: rcu_exp_par_gp_ Tainted: P           OEL      7.0.13+deb13-amd64 #1 PREEMPT(lazy)  Debian 7.0.13-1~bpo13+1
1788807751751	2026-09-07T19:02:31.751Z	[  401.755084]  nvme_tcp br_netfilter bridge stp llc overlay nvme_fabrics drm efi_pstore configfs nfnetlink efivarfs ip_tables x_tables autofs4 isofs virtio_net net_failover failover nls_ascii nls_cp437 vfat fat sr_mod cdrom sd_mod zfs(POE) spl(OE) drbd(OE) lru_cache uas hid_generic usbhid cdc_ether usbnet hid usb_storage mii xhci_pci sp5100_tco xhci_hcd ahci nvme watchdog libahci libata nvme_core igb bnxt_en usbcore scsi_mod nvme_keyring i2c_algo_bit nvme_auth i2c_piix4 hkdf dca usb_common i2c_smbus scsi_common wmi aesni_intel
1788807751612	2026-09-07T19:02:31.612Z	[  401.755014] watchdog: BUG: soft lockup 
- CPU#135 stuck for 23s! [rcu_exp_par_gp_:797]
1788807751612	2026-09-07T19:02:31.612Z	[  401.712199]  </TASK>
1788807751612	2026-09-07T19:02:31.612Z	[  401.712193]  ret_from_fork_asm+0x1a/0x30
1788807751612	2026-09-07T19:02:31.612Z	[  401.712190]  ? __pfx_kthread+0x10/0x10
1788807751612	2026-09-07T19:02:31.612Z	[  401.712187]  ret_from_fork+0x2cf/0x360
1788807751612	2026-09-07T19:02:31.612Z	[  401.712184]  ? __pfx_kthread+0x10/0x10
1788807751601	2026-09-07T19:02:31.601Z	[  401.712182]  kthread+0xe3/0x120
1788807751601	2026-09-07T19:02:31.601Z	[  401.712180]  ? __pfx_kthread_worker_fn+0x10/0x10
1788807751601	2026-09-07T19:02:31.601Z	[  401.712176]  kthread_worker_fn+0xb0/0x290
1788807751601	2026-09-07T19:02:31.601Z	[  401.712174]  ? __pfx_sync_rcu_exp_select_node_cpus+0x10/0x10
1788807751601	2026-09-07T19:02:31.601Z	[  401.712169]  __sync_rcu_exp_select_node_cpus+0x22f/0x410
1788807751591	2026-09-07T19:02:31.591Z	[  401.712165]  ? __schedule+0x4ec/0xfe0
1788807751591	2026-09
-07T19:02:31.591Z	[  401.712160]  <TASK>
1788807751591	2026-09-07T19:02:31.591Z	[  401.712158] Call Trace:
1788807751591	2026-09-07T19:02:31.591Z	[  401.712157] PKRU: 55555554
1788807751591	2026-09-07T19:02:31.591Z	[  401.712155] CR2: 0000557032089000 CR3: 00000012e8393005 CR4: 0000000000f71ef0
1788807751582	2026-09-07T19:02:31.582Z	[  401.712154] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
1788807751582	2026-09-07T19:02:31.582Z	[  401.712153] FS:  0000000000000000(0000) GS:ff35266ea3c23000(0000) knlGS:0000000000000000
1788807751582	2026-09-07T19:02:31.582Z	[  401.712152] R13: ffffffffa77105b0 R14: 0000000000000062 R15: 000000000000e090
1788807751572	2026-09-07T19:02:31.572Z	[  401.712151] R10: 0000000000000000 R11: ff35266e4bf1d180 R12: ffffffffa8309920
1788807751572	2026-09-07T19:02:31.572Z	[  401.712150] RBP: ff500c2fc1d9be40 R08: ffffffffa5a49f10 R09: 0000000000000001
1788807751572	2026-09-07T19:02:31.572Z	[  401.712148] RDX: 0000000000000000 RSI: ff35266e4bf33840 RD
I: 0000000000000062
1788807751471	2026-09-07T19:02:31.471Z	[  401.712147] RAX: 0000000000000001 RBX: ff35266e4beb3480 RCX: 0000000000000000
1788807751471	2026-09-07T19:02:31.471Z	[  401.712145] RSP: 0018:ff500c2fc1d9be00 EFLAGS: 00000202
1788807751462	2026-09-07T19:02:31.462Z	[  401.712144] Code: 48 2b 15 61 f7 85 02 75 66 c9 e9 5c e8 c6 ff 65 48 8b 05 71 f7 85 02 48 8d b0 40 08 31 a8 8b 46 08 a8 01 74 09 f3 90 8b 46 08 <a8> 01 75 f7 83 4e 08 01 4c 89 46 10 48 89 56 18 e8 a1 fd ff ff eb
1788807751462	2026-09-07T19:02:31.462Z	[  401.712137] RIP: 0010:smp_call_function_single+0xea/0x140
1788807751452	2026-09-07T19:02:31.452Z	[  401.712136] Hardware name: ASUSTeK COMPUTER INC. RS500A-E12-RS12U/K14PA-U24 Series, BIOS 1201 08/25/2023
1788807751452	2026-09-07T19:02:31.452Z	[  401.712135] Tainted: [P]=PROPRIETARY_MODULE, [O]=OOT_MODULE, [E]=UNSIGNED_MODULE, [L]=SOFTLOCKUP
1788807751442	2026-09-07T19:02:31.442Z	[  401.712130] CPU: 100 UID: 0 PID: 603 Comm: rcu_exp_par_gp_ Tainted: P    
       OEL      7.0.13+deb13-amd64 #1 PREEMPT(lazy)  Debian 7.0.13-1~bpo13+1
1788807751421	2026-09-07T19:02:31.421Z	[  401.712085]  nvme_tcp br_netfilter bridge stp llc overlay nvme_fabrics drm efi_pstore configfs nfnetlink efivarfs ip_tables x_tables autofs4 isofs virtio_net net_failover failover nls_ascii nls_cp437 vfat fat sr_mod cdrom sd_mod zfs(POE) spl(OE) drbd(OE) lru_cache uas hid_generic usbhid cdc_ether usbnet hid usb_storage mii xhci_pci sp5100_tco xhci_hcd ahci nvme watchdog libahci libata nvme_core igb bnxt_en usbcore scsi_mod nvme_keyring i2c_algo_bit nvme_auth i2c_piix4 hkdf dca usb_common i2c_smbus scsi_common wmi aesni_intel
1788807751271	2026-09-07T19:02:31.271Z	[  401.712015] watchdog: BUG: soft lockup - CPU#100 stuck for 23s! [rcu_exp_par_gp_:603]
1788807751271	2026-09-07T19:02:31.271Z	[  401.674202]  </TASK>
1788807751271	2026-09-07T19:02:31.271Z	[  401.674196]  ret_from_fork_asm+0x1a/0x30
1788807751271	2026-09-07T19:02:31.271Z	[  401.674194]  ? __pfx_kthread+
0x10/0x10
1788807751271	2026-09-07T19:02:31.271Z	[  401.674191]  ret_from_fork+0x2cf/0x360
1788807751271	2026-09-07T19:02:31.271Z	[  401.674188]  ? __pfx_kthread+0x10/0x10
1788807751261	2026-09-07T19:02:31.261Z	[  401.674186]  kthread+0xe3/0x120
1788807751261	2026-09-07T19:02:31.261Z	[  401.674183]  ? __pfx_kthread_worker_fn+0x10/0x10
1788807751261	2026-09-07T19:02:31.261Z	[  401.674179]  kthread_worker_fn+0xb0/0x290
1788807751261	2026-09-07T19:02:31.261Z	[  401.674177]  ? __pfx_sync_rcu_exp_select_node_cpus+0x10/0x10
1788807751252	2026-09-07T19:02:31.252Z	[  401.674172]  __sync_rcu_exp_select_node_cpus+0x22f/0x410
1788807751252	2026-09-07T19:02:31.252Z	[  401.674167]  ? __schedule+0x4ec/0xfe0
1788807751252	2026-09-07T19:02:31.252Z	[  401.674162]  <TASK>
1788807751252	2026-09-07T19:02:31.252Z	[  401.674160] Call Trace:
1788807751252	2026-09-07T19:02:31.252Z	[  401.674159] PKRU: 55555554
1788807751252	2026-09-07T19:02:31.252Z	[  401.674157] CR2: 00007f5d275870ac CR3: 0000000
16abb2001 CR4: 0000000000f71ef0
1788807751242	2026-09-07T19:02:31.242Z	[  401.674156] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
1788807751242	2026-09-07T19:02:31.242Z	[  401.674154] FS:  0000000000000000(0000) GS:ff35266ea3863000(0000) knlGS:0000000000000000
1788807751242	2026-09-07T19:02:31.242Z	[  401.674153] R13: ffffffffa77102f0 R14: 0000000000000052 R15: 0000000000001020
1788807751232	2026-09-07T19:02:31.232Z	[  401.674152] R10: 0000000000000000 R11: ff35266e4bb5d180 R12: ffffffffa8309920
1788807751232	2026-09-07T19:02:31.232Z	[  401.674151] RBP: ff500c2fc1a53e40 R08: ffffffffa5a49f10 R09: 0000000000000001
1788807751232	2026-09-07T19:02:31.232Z	[  401.674149] RDX: 0000000000000000 RSI: ff35266e4bb73840 RDI: 0000000000000052
1788807751222	2026-09-07T19:02:31.222Z	[  401.674148] RAX: 0000000000000001 RBX: ff35266e4bab3480 RCX: 0000000000000000
1788807751222	2026-09-07T19:02:31.222Z	[  401.674146] RSP: 0018:ff500c2fc1a53e00 EFLAGS: 00000202
1788807751122	2026-09-07T1
9:02:31.122Z	[  401.674144] Code: 48 2b 15 61 f7 85 02 75 66 c9 e9 5c e8 c6 ff 65 48 8b 05 71 f7 85 02 48 8d b0 40 08 31 a8 8b 46 08 a8 01 74 09 f3 90 8b 46 08 <a8> 01 75 f7 83 4e 08 01 4c 89 46 10 48 89 56 18 e8 a1 fd ff ff eb
1788807751122	2026-09-07T19:02:31.122Z	[  401.674138] RIP: 0010:smp_call_function_single+0xea/0x140
1788807751111	2026-09-07T19:02:31.111Z	[  401.674136] Hardware name: ASUSTeK COMPUTER INC. RS500A-E12-RS12U/K14PA-U24 Series, BIOS 1201 08/25/2023
1788807751111	2026-09-07T19:02:31.111Z	[  401.674135] Tainted: [P]=PROPRIETARY_MODULE, [O]=OOT_MODULE, [E]=UNSIGNED_MODULE, [L]=SOFTLOCKUP
1788807751102	2026-09-07T19:02:31.102Z	[  401.674130] CPU: 85 UID: 0 PID: 506 Comm: rcu_exp_par_gp_ Tainted: P           OEL      7.0.13+deb13-amd64 #1 PREEMPT(lazy)  Debian 7.0.13-1~bpo13+1
1788807751082	2026-09-07T19:02:31.082Z	[  401.674086]  nvme_tcp br_netfilter bridge stp llc overlay nvme_fabrics drm efi_pstore configfs nfnetlink efivarfs ip_tables x_tables autofs4 isofs v
irtio_net net_failover failover nls_ascii nls_cp437 vfat fat sr_mod cdrom sd_mod zfs(POE) spl(OE) drbd(OE) lru_cache uas hid_generic usbhid cdc_ether usbnet hid usb_storage mii xhci_pci sp5100_tco xhci_hcd ahci nvme watchdog libahci libata nvme_core igb bnxt_en usbcore scsi_mod nvme_keyring i2c_algo_bit nvme_auth i2c_piix4 hkdf dca usb_common i2c_smbus scsi_common wmi aesni_intel
1788807750941	2026-09-07T19:02:30.941Z	[  401.674015] watchdog: BUG: soft lockup - CPU#85 stuck for 23s! [rcu_exp_par_gp_:506]
1788807750941	2026-09-07T19:02:30.941Z	[  401.651204]  </TASK>
1788807750941	2026-09-07T19:02:30.941Z	[  401.651198]  ret_from_fork_asm+0x1a/0x30
1788807750941	2026-09-07T19:02:30.941Z	[  401.651196]  ? __pfx_kthread+0x10/0x10
1788807750941	2026-09-07T19:02:30.941Z	[  401.651192]  ret_from_fork+0x2cf/0x360
1788807750932	2026-09-07T19:02:30.932Z	[  401.651189]  ? __pfx_kthread+0x10/0x10
1788807750932	2026-09-07T19:02:30.932Z	[  401.651187]  kthread+0xe3/0x120
1788807750932	2026-
09-07T19:02:30.932Z	[  401.651185]  ? __pfx_kthread_worker_fn+0x10/0x10
1788807750932	2026-09-07T19:02:30.932Z	[  401.651181]  kthread_worker_fn+0xb0/0x290
1788807750932	2026-09-07T19:02:30.932Z	[  401.651179]  ? __pfx_sync_rcu_exp_select_node_cpus+0x10/0x10
1788807750922	2026-09-07T19:02:30.922Z	[  401.651174]  __sync_rcu_exp_select_node_cpus+0x22f/0x410
1788807750922	2026-09-07T19:02:30.922Z	[  401.651169]  ? __schedule+0x4ec/0xfe0
1788807750922	2026-09-07T19:02:30.922Z	[  401.651163]  <TASK>
1788807750922	2026-09-07T19:02:30.922Z	[  401.651161] Call Trace:
1788807750922	2026-09-07T19:02:30.922Z	[  401.651159] PKRU: 55555554
1788807750922	2026-09-07T19:02:30.922Z	[  401.651158] CR2: 0000000000b0ea65 CR3: 0000000f94baf04a CR4: 0000000000f71ef0
1788807750912	2026-09-07T19:02:30.912Z	[  401.651157] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
1788807750912	2026-09-07T19:02:30.912Z	[  401.651155] FS:  0000000000000000(0000) GS:ff35266ea33a3000(0000) knlGS:0000000000000000

1788807750912	2026-09-07T19:02:30.912Z	[  401.651154] R13: ffffffffa7710030 R14: 0000000000000046 R15: 00000000000004b7
1788807750902	2026-09-07T19:02:30.902Z	[  401.651153] R10: 0000000000000000 R11: ff35266e4b69d180 R12: ffffffffa8309920
1788807750902	2026-09-07T19:02:30.902Z	[  401.651152] RBP: ff500c2fc170be40 R08: ffffffffa5a49f10 R09: 0000000000000001
1788807750902	2026-09-07T19:02:30.902Z	[  401.651150] RDX: 0000000000000000 RSI: ff35266e4b6b3840 RDI: 0000000000000046
1788807750892	2026-09-07T19:02:30.892Z	[  401.651149] RAX: 0000000000000001 RBX: ff35266e4b7b3480 RCX: 0000000000000000
1788807750892	2026-09-07T19:02:30.892Z	[  401.651147] RSP: 0018:ff500c2fc170be00 EFLAGS: 00000202
1788807750882	2026-09-07T19:02:30.882Z	[  401.651145] Code: 48 2b 15 61 f7 85 02 75 66 c9 e9 5c e8 c6 ff 65 48 8b 05 71 f7 85 02 48 8d b0 40 08 31 a8 8b 46 08 a8 01 74 09 f3 90 8b 46 08 <a8> 01 75 f7 83 4e 08 01 4c 89 46 10 48 89 56 18 e8 a1 fd ff ff eb
1788807750882	2026-09-07T19:02:30.882Z	[
  401.651138] RIP: 0010:smp_call_function_single+0xea/0x140
1788807750882	2026-09-07T19:02:30.882Z	[  401.651136] Hardware name: ASUSTeK COMPUTER INC. RS500A-E12-RS12U/K14PA-U24 Series, BIOS 1201 08/25/2023
1788807750781	2026-09-07T19:02:30.781Z	[  401.651135] Tainted: [P]=PROPRIETARY_MODULE, [O]=OOT_MODULE, [E]=UNSIGNED_MODULE, [L]=SOFTLOCKUP
1788807750772	2026-09-07T19:02:30.772Z	[  401.651130] CPU: 66 UID: 0 PID: 409 Comm: rcu_exp_par_gp_ Tainted: P           OEL      7.0.13+deb13-amd64 #1 PREEMPT(lazy)  Debian 7.0.13-1~bpo13+1
1788807750752	2026-09-07T19:02:30.752Z	[  401.651086]  nvme_tcp br_netfilter bridge stp llc overlay nvme_fabrics drm efi_pstore configfs nfnetlink efivarfs ip_tables x_tables autofs4 isofs virtio_net net_failover failover nls_ascii nls_cp437 vfat fat sr_mod cdrom sd_mod zfs(POE) spl(OE) drbd(OE) lru_cache uas hid_generic usbhid cdc_ether usbnet hid usb_storage mii xhci_pci sp5100_tco xhci_hcd ahci nvme watchdog libahci libata nvme_core igb bnxt_en usbcore
 scsi_mod nvme_keyring i2c_algo_bit nvme_auth i2c_piix4 hkdf dca usb_common i2c_smbus scsi_common wmi aesni_intel
1788807750712	2026-09-07T19:02:30.712Z	[  401.651016] watchdog: BUG: soft lockup - CPU#66 stuck for 23s! [rcu_exp_par_gp_:409]
1788807750712	2026-09-07T19:02:30.712Z	[  401.635202]  </TASK>
1788807750611	2026-09-07T19:02:30.611Z	[  401.635196]  ret_from_fork_asm+0x1a/0x30
1788807750611	2026-09-07T19:02:30.611Z	[  401.635194]  ? __pfx_kthread+0x10/0x10
1788807750611	2026-09-07T19:02:30.611Z	[  401.635190]  ret_from_fork+0x2cf/0x360
1788807750601	2026-09-07T19:02:30.601Z	[  401.635187]  ? __pfx_kthread+0x10/0x10
1788807750601	2026-09-07T19:02:30.601Z	[  401.635185]  kthread+0xe3/0x120
1788807750601	2026-09-07T19:02:30.601Z	[  401.635183]  ? __pfx_kthread_worker_fn+0x10/0x10
1788807750601	2026-09-07T19:02:30.601Z	[  401.635179]  kthread_worker_fn+0xb0/0x290
1788807750601	2026-09-07T19:02:30.601Z	[  401.635177]  ? __pfx_sync_rcu_exp_select_node_cpus+0x10/0x10
1788807
750591	2026-09-07T19:02:30.591Z	[  401.635172]  __sync_rcu_exp_select_node_cpus+0x22f/0x410
1788807750591	2026-09-07T19:02:30.591Z	[  401.635168]  ? __schedule+0x4ec/0xfe0
1788807750591	2026-09-07T19:02:30.591Z	[  401.635163]  <TASK>
1788807750591	2026-09-07T19:02:30.591Z	[  401.635161] Call Trace:
1788807750591	2026-09-07T19:02:30.591Z	[  401.635160] PKRU: 55555554
1788807750582	2026-09-07T19:02:30.582Z	[  401.635159] CR2: 0000556fabf87fa8 CR3: 00000002060d6006 CR4: 0000000000f71ef0
1788807750582	2026-09-07T19:02:30.582Z	[  401.635158] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
1788807750582	2026-09-07T19:02:30.582Z	[  401.635156] FS:  0000000000000000(0000) GS:ff35266ea3063000(0000) knlGS:0000000000000000
1788807750572	2026-09-07T19:02:30.572Z	[  401.635155] R13: ffffffffa770fd70 R14: 0000000000000032 R15: 0000000000009722
1788807750572	2026-09-07T19:02:30.572Z	[  401.635154] R10: 0000000000000000 R11: ff35266e4b35d180 R12: ffffffffa8309920
1788807750572	2026-09-07T1
9:02:30.572Z	[  401.635153] RBP: ff500c2fc13c3e40 R08: ffffffffa5a49f10 R09: 0000000000000001
1788807750562	2026-09-07T19:02:30.562Z	[  401.635152] RDX: 0000000000000000 RSI: ff35266e4b373840 RDI: 0000000000000032
1788807750562	2026-09-07T19:02:30.562Z	[  401.635151] RAX: 0000000000000001 RBX: ff35266e4b2b3480 RCX: 0000000000000000
1788807750562	2026-09-07T19:02:30.562Z	[  401.635149] RSP: 0018:ff500c2fc13c3e00 EFLAGS: 00000202
1788807750552	2026-09-07T19:02:30.552Z	[  401.635147] Code: 48 2b 15 61 f7 85 02 75 66 c9 e9 5c e8 c6 ff 65 48 8b 05 71 f7 85 02 48 8d b0 40 08 31 a8 8b 46 08 a8 01 74 09 f3 90 8b 46 08 <a8> 01 75 f7 83 4e 08 01 4c 89 46 10 48 89 56 18 e8 a1 fd ff ff eb
1788807750552	2026-09-07T19:02:30.552Z	[  401.635141] RIP: 0010:smp_call_function_single+0xea/0x140
1788807750542	2026-09-07T19:02:30.542Z	[  401.635140] Hardware name: ASUSTeK COMPUTER INC. RS500A-E12-RS12U/K14PA-U24 Series, BIOS 1201 08/25/2023
1788807750542	2026-09-07T19:02:30.542Z	[  401.635139] Tainte
d: [P]=PROPRIETARY_MODULE, [O]=OOT_MODULE, [E]=UNSIGNED_MODULE, [L]=SOFTLOCKUP
1788807750431	2026-09-07T19:02:30.431Z	[  401.635134] CPU: 53 UID: 0 PID: 312 Comm: rcu_exp_par_gp_ Tainted: P           OEL      7.0.13+deb13-amd64 #1 PREEMPT(lazy)  Debian 7.0.13-1~bpo13+1
1788807750411	2026-09-07T19:02:30.411Z	[  401.635086]  nvme_tcp br_netfilter bridge stp llc overlay nvme_fabrics drm efi_pstore configfs nfnetlink efivarfs ip_tables x_tables autofs4 isofs virtio_net net_failover failover nls_ascii nls_cp437 vfat fat sr_mod cdrom sd_mod zfs(POE) spl(OE) drbd(OE) lru_cache uas hid_generic usbhid cdc_ether usbnet hid usb_storage mii xhci_pci sp5100_tco xhci_hcd ahci nvme watchdog libahci libata nvme_core igb bnxt_en usbcore scsi_mod nvme_keyring i2c_algo_bit nvme_auth i2c_piix4 hkdf dca usb_common i2c_smbus scsi_common wmi aesni_intel
1788807750372	2026-09-07T19:02:30.372Z	[  401.635015] watchdog: BUG: soft lockup - CPU#53 stuck for 23s! [rcu_exp_par_gp_:312]
1788807750362	2026-09-07T1
9:02:30.362Z	[  401.593029]  </TASK>
1788807750362	2026-09-07T19:02:30.362Z	[  401.593023]  common_startup_64+0x13e/0x141
1788807750362	2026-09-07T19:02:30.362Z	[  401.593019]  start_secondary+0x128/0x170
1788807750362	2026-09-07T19:02:30.362Z	[  401.593016]  cpu_startup_entry+0x29/0x30
1788807750362	2026-09-07T19:02:30.362Z	[  401.593012]  do_idle+0x16c/0x2a0
1788807750362	2026-09-07T19:02:30.362Z	[  401.593009]  schedule_idle+0x23/0x40
1788807750262	2026-09-07T19:02:30.262Z	[  401.593004]  __schedule+0x4ec/0xfe0
1788807750262	2026-09-07T19:02:30.262Z	[  401.593001]  finish_task_switch.isra.0+0x238/0x2c0
1788807750262	2026-09-07T19:02:30.262Z	[  401.592997]  cgroup_task_dead+0x29/0x140
1788807750252	2026-09-07T19:02:30.252Z	[  401.592993]  _raw_spin_lock_irqsave+0x3d/0x50
1788807750252	2026-09-07T19:02:30.252Z	[  401.592990]  <TASK>
1788807750252	2026-09-07T19:02:30.252Z	[  401.592989] Call Trace:
1788807750252	2026-09-07T19:02:30.252Z	[  401.592988] PKRU: 55555554
178880
7750252	2026-09-07T19:02:30.252Z	[  401.592987] CR2: 00007fd0b06c4ab8 CR3: 00000002a9b00003 CR4: 0000000000f71ef0
1788807750252	2026-09-07T19:02:30.252Z	[  401.592986] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
1788807750242	2026-09-07T19:02:30.242Z	[  401.592985] FS:  0000000000000000(0000) GS:ff35266ea3763000(0000) knlGS:0000000000000000
1788807750242	2026-09-07T19:02:30.242Z	[  401.592983] R13: 0000000001480000 R14: 0000000000000029 R15: 0000000000000000
1788807750232	2026-09-07T19:02:30.232Z	[  401.592982] R10: 0000000000000000 R11: ff35266e4ba5d180 R12: ff35266e4b073400
1788807750232	2026-09-07T19:02:30.232Z	[  401.592981] RBP: ff35266e4ba73400 R08: 00000056bb9fe813 R09: 0000000000000001
1788807750232	2026-09-07T19:02:30.232Z	[  401.592980] RDX: 000000000000002a RSI: 0000000000a80101 RDI: ffffffffa83b3ee4
1788807750222	2026-09-07T19:02:30.222Z	[  401.592978] RAX: 0000000000000000 RBX: ffffffffa83b3ee4 RCX: 0000000000000000
1788807750222	2026-09-07T19:02:30.222Z	[  4
01.592977] RSP: 0018:ff500c2fc0687d90 EFLAGS: 00000046
1788807750212	2026-09-07T19:02:30.212Z	[  401.592975] Code: 63 f6 4c 8d a0 00 04 31 a8 49 81 fe 00 20 00 00 73 45 4e 03 24 f5 e0 60 ed a6 49 89 2c 24 8b 45 08 85 c0 75 09 f3 90 8b 45 08 <85> c0 74 f7 48 8b 55 00 48 85 d2 0f 84 6b ff ff ff 0f 0d 0a e9 63
1788807750212	2026-09-07T19:02:30.212Z	[  401.592972] RIP: 0010:native_queued_spin_lock_slowpath+0x2aa/0x2f0
1788807750212	2026-09-07T19:02:30.212Z	[  401.592971] Hardware name: ASUSTeK COMPUTER INC. RS500A-E12-RS12U/K14PA-U24 Series, BIOS 1201 08/25/2023
1788807750202	2026-09-07T19:02:30.202Z	[  401.592970] Tainted: [P]=PROPRIETARY_MODULE, [O]=OOT_MODULE, [E]=UNSIGNED_MODULE, [L]=SOFTLOCKUP
1788807750202	2026-09-07T19:02:30.202Z	[  401.592966] CPU: 81 UID: 0 PID: 0 Comm: swapper/81 Tainted: P           OEL      7.0.13+deb13-amd64 #1 PREEMPT(lazy)  Debian 7.0.13-1~bpo13+1
1788807750082	2026-09-07T19:02:30.082Z	[  401.592927]  nvme_tcp br_netfilter bridge stp llc overlay nvme_f
abrics drm efi_pstore configfs nfnetlink efivarfs ip_tables x_tables autofs4 isofs virtio_net net_failover failover nls_ascii nls_cp437 vfat fat sr_mod cdrom sd_mod zfs(POE) spl(OE) drbd(OE) lru_cache uas hid_generic usbhid cdc_ether usbnet hid usb_storage mii xhci_pci sp5100_tco xhci_hcd ahci nvme watchdog libahci libata nvme_core igb bnxt_en usbcore scsi_mod nvme_keyring i2c_algo_bit nvme_auth i2c_piix4 hkdf dca usb_common i2c_smbus scsi_common wmi aesni_intel
1788807750041	2026-09-07T19:02:30.041Z	[  401.592862] watchdog: CPU81: Watchdog detected hard LOCKUP on cpu 81
1788807750041	2026-09-07T19:02:30.041Z	[  401.584383]  </TASK>
1788807750031	2026-09-07T19:02:30.031Z	[  401.584376] R13: 0000000000000000 R14: 000000c00bbb4a80 R15: 3fffffffffffffff
1788807750031	2026-09-07T19:02:30.031Z	[  401.584375] R10: 0000000000000000 R11: 0000000000000212 R12: 000000c013e0db60
1788807750031	2026-09-07T19:02:30.031Z	[  401.584374] RBP: 000000c013e0da30 R08: 0000000000000000 R09: 00000000000
00000
1788807750022	2026-09-07T19:02:30.022Z	[  401.584373] RDX: 0000000000000200 RSI: 000000c013e48200 RDI: 0000000000000023
1788807750022	2026-09-07T19:02:30.022Z	[  401.584372] RAX: ffffffffffffffda RBX: 0000000000000023 RCX: 00000000004085ae
1788807750022	2026-09-07T19:02:30.022Z	[  401.584370] RSP: 002b:000000c013e0d9f0 EFLAGS: 00000212 ORIG_RAX: 0000000000000000
1788807749922	2026-09-07T19:02:29.922Z	[  401.584369] Code: 48 83 ec 38 e8 13 00 00 00 48 83 c4 38 5d c3 cc cc cc cc cc cc cc cc cc cc cc cc cc 49 89 f2 48 89 fa 48 89 ce 48 89 df 0f 05 <48> 3d 01 f0 ff ff 76 15 48 f7 d8 48 89 c1 48 c7 c0 ff ff ff ff 48
1788807749912	2026-09-07T19:02:29.912Z	[  401.584338] RIP: 0033:0x4085ae
1788807749912	2026-09-07T19:02:29.912Z	[  401.584336]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
1788807749912	2026-09-07T19:02:29.912Z	[  401.584332]  ? do_syscall_64+0x29a/0x15f0
1788807749912	2026-09-07T19:02:29.912Z	[  401.584331]  ? srso_alias_return_thunk+0x5/0xfbef5
1788807749912	2026-0
9-07T19:02:29.912Z	[  401.584328]  ? do_syscall_64+0x10a/0x15f0
1788807749902	2026-09-07T19:02:29.902Z	[  401.584327]  ? srso_alias_return_thunk+0x5/0xfbef5
1788807749902	2026-09-07T19:02:29.902Z	[  401.584324]  ? do_syscall_64+0x10a/0x15f0
1788807749902	2026-09-07T19:02:29.902Z	[  401.584323]  ? srso_alias_return_thunk+0x5/0xfbef5
1788807749902	2026-09-07T19:02:29.902Z	[  401.584321]  ? trace_syscall_exit+0x62/0x90
1788807749902	2026-09-07T19:02:29.902Z	[  401.584319]  ? srso_alias_return_thunk+0x5/0xfbef5
1788807749891	2026-09-07T19:02:29.891Z	[  401.584318]  ? srso_alias_return_thunk+0x5/0xfbef5
1788807749891	2026-09-07T19:02:29.891Z	[  401.584315]  ? do_syscall_64+0x10a/0x15f0
1788807749891	2026-09-07T19:02:29.891Z	[  401.584313]  ? srso_alias_return_thunk+0x5/0xfbef5
1788807749891	2026-09-07T19:02:29.891Z	[  401.584311]  ? trace_syscall_exit+0x62/0x90
1788807749882	2026-09-07T19:02:29.882Z	[  401.584309]  ? srso_alias_return_thunk+0x5/0xfbef5
1788807749882	2026-09-07T19
:02:29.882Z	[  401.584307]  ? srso_alias_return_thunk+0x5/0xfbef5
1788807749882	2026-09-07T19:02:29.882Z	[  401.584303]  ? bpf_trace_run2+0xdf/0x1e0
1788807749882	2026-09-07T19:02:29.882Z	[  401.584301]  ? srso_alias_return_thunk+0x5/0xfbef5
1788807749882	2026-09-07T19:02:29.882Z	[  401.584296]  do_syscall_64+0xcd/0x15f0
1788807749882	2026-09-07T19:02:29.882Z	[  401.584293]  ksys_read+0x6b/0xe0
1788807749872	2026-09-07T19:02:29.872Z	[  401.584287]  vfs_read+0x25d/0x370
1788807749872	2026-09-07T19:02:29.872Z	[  401.584284]  ? rw_verify_area+0x54/0x180
1788807749872	2026-09-07T19:02:29.872Z	[  401.584281]  ? srso_alias_return_thunk+0x5/0xfbef5
1788807749872	2026-09-07T19:02:29.872Z	[  401.584277]  seq_read_iter+0x100/0x480
1788807749872	2026-09-07T19:02:29.872Z	[  401.584273]  kernfs_seq_start+0x56/0xb0
1788807749862	2026-09-07T19:02:29.862Z	[  401.584270]  __cgroup_procs_start+0x7b/0xf0
1788807749862	2026-09-07T19:02:29.862Z	[  401.584267]  css_task_iter_start+0x50/0xd0
1788
807749862	2026-09-07T19:02:29.862Z	[  401.584263]  _raw_spin_lock_irqsave+0x3d/0x50
1788807749862	2026-09-07T19:02:29.862Z	[  401.584259]  <TASK>
1788807749862	2026-09-07T19:02:29.862Z	[  401.584257] Call Trace:
1788807749862	2026-09-07T19:02:29.862Z	[  401.584256] PKRU: 55555554
1788807749852	2026-09-07T19:02:29.852Z	[  401.584255] CR2: 000004504f90e008 CR3: 0000000a14bc1033 CR4: 0000000000f71ef0
1788807749852	2026-09-07T19:02:29.852Z	[  401.584254] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
1788807749852	2026-09-07T19:02:29.852Z	[  401.584252] FS:  00007f0ebbfff6c0(0000) GS:ff35266ea4e23000(0000) knlGS:0000000000000000
1788807749741	2026-09-07T19:02:29.741Z	[  401.584251] R13: 0000000002b40000 R14: 0000000000000083 R15: ff3525b754a69000
1788807749741	2026-09-07T19:02:29.741Z	[  401.584250] R10: 0000000000000000 R11: 0000000000000000 R12: ff35266e4c6f3400
1788807749731	2026-09-07T19:02:29.731Z	[  401.584248] RBP: ff35266e4d133400 R08: ff3525b6d5809a00 R09: 000000000000
000b
1788807749731	2026-09-07T19:02:29.731Z	[  401.584247] RDX: 0000000000000084 RSI: 0000000002100101 RDI: ffffffffa83b3ee4
1788807749731	2026-09-07T19:02:29.731Z	[  401.584246] RAX: 0000000000000000 RBX: ffffffffa83b3ee4 RCX: 0000000000000000
1788807749731	2026-09-07T19:02:29.731Z	[  401.584244] RSP: 0018:ff500c30a491bc08 EFLAGS: 00000046
1788807749722	2026-09-07T19:02:29.722Z	[  401.584242] Code: 63 f6 4c 8d a0 00 04 31 a8 49 81 fe 00 20 00 00 73 45 4e 03 24 f5 e0 60 ed a6 49 89 2c 24 8b 45 08 85 c0 75 09 f3 90 8b 45 08 <85> c0 74 f7 48 8b 55 00 48 85 d2 0f 84 6b ff ff ff 0f 0d 0a e9 63
1788807749711	2026-09-07T19:02:29.711Z	[  401.584238] RIP: 0010:native_queued_spin_lock_slowpath+0x2aa/0x2f0
1788807749711	2026-09-07T19:02:29.711Z	[  401.584237] Hardware name: ASUSTeK COMPUTER INC. RS500A-E12-RS12U/K14PA-U24 Series, BIOS 1201 08/25/2023
1788807749711	2026-09-07T19:02:29.711Z	[  401.584236] Tainted: [P]=PROPRIETARY_MODULE, [O]=OOT_MODULE, [E]=UNSIGNED_MODULE, [L]=SOFTLOCKUP

1788807749702	2026-09-07T19:02:29.702Z	[  401.584232] CPU: 172 UID: 0 PID: 98713 Comm: kubelet Tainted: P           OEL      7.0.13+deb13-amd64 #1 PREEMPT(lazy)  Debian 7.0.13-1~bpo13+1
1788807749682	2026-09-07T19:02:29.682Z	[  401.584195]  nvme_tcp br_netfilter bridge stp llc overlay nvme_fabrics drm efi_pstore configfs nfnetlink efivarfs ip_tables x_tables autofs4 isofs virtio_net net_failover failover nls_ascii nls_cp437 vfat fat sr_mod cdrom sd_mod zfs(POE) spl(OE) drbd(OE) lru_cache uas hid_generic usbhid cdc_ether usbnet hid usb_storage mii xhci_pci sp5100_tco xhci_hcd ahci nvme watchdog libahci libata nvme_core igb bnxt_en usbcore scsi_mod nvme_keyring i2c_algo_bit nvme_auth i2c_piix4 hkdf dca usb_common i2c_smbus scsi_common wmi aesni_intel
1788807749542	2026-09-07T19:02:29.542Z	[  401.584135] watchdog: CPU172: Watchdog detected hard LOCKUP on cpu 172
1788807749542	2026-09-07T19:02:29.542Z	[  401.571200]  </TASK>
1788807749542	2026-09-07T19:02:29.542Z	[  401.571194]  ret_fr
om_fork_asm+0x1a/0x30
1788807749542	2026-09-07T19:02:29.542Z	[  401.571192]  ? __pfx_kthread+0x10/0x10
1788807749531	2026-09-07T19:02:29.531Z	[  401.571188]  ret_from_fork+0x2cf/0x360
1788807749531	2026-09-07T19:02:29.531Z	[  401.571186]  ? __pfx_kthread+0x10/0x10
1788807749531	2026-09-07T19:02:29.531Z	[  401.571183]  kthread+0xe3/0x120
1788807749531	2026-09-07T19:02:29.531Z	[  401.571181]  ? __pfx_kthread_worker_fn+0x10/0x10
1788807749531	2026-09-07T19:02:29.531Z	[  401.571177]  kthread_worker_fn+0xb0/0x290
1788807749521	2026-09-07T19:02:29.521Z	[  401.571175]  ? __pfx_sync_rcu_exp_select_node_cpus+0x10/0x10
1788807749521	2026-09-07T19:02:29.521Z	[  401.571170]  __sync_rcu_exp_select_node_cpus+0x22f/0x410
1788807749521	2026-09-07T19:02:29.521Z	[  401.571166]  ? __schedule+0x4ec/0xfe0
1788807749521	2026-09-07T19:02:29.521Z	[  401.571162]  <TASK>
1788807749521	2026-09-07T19:02:29.521Z	[  401.571160] Call Trace:
1788807749521	2026-09-07T19:02:29.521Z	[  401.571158] PKRU: 5555
5554
1788807749512	2026-09-07T19:02:29.512Z	[  401.571157] CR2: 000000c00083d000 CR3: 00000003378b4002 CR4: 0000000000f71ef0
1788807749512	2026-09-07T19:02:29.512Z	[  401.571156] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
1788807749512	2026-09-07T19:02:29.512Z	[  401.571154] FS:  0000000000000000(0000) GS:ff35266ea23a3000(0000) knlGS:0000000000000000
1788807749502	2026-09-07T19:02:29.502Z	[  401.571153] R13: ffffffffa770f530 R14: 0000000000000001 R15: 000000000000120c
1788807749502	2026-09-07T19:02:29.502Z	[  401.571152] R10: 0000000000000000 R11: ff35266e4a69d180 R12: ffffffffa8309920
1788807749502	2026-09-07T19:02:29.502Z	[  401.571150] RBP: ff500c2fc00fbe40 R08: ffffffffa5a49f10 R09: 0000000000000001
1788807749401	2026-09-07T19:02:29.401Z	[  401.571149] RDX: 0000000000000000 RSI: ff35266e4a6b3840 RDI: 0000000000000001
1788807749401	2026-09-07T19:02:29.401Z	[  401.571148] RAX: 0000000000000001 RBX: ff35266e4a673480 RCX: 0000000000000000
1788807749401	2026-09-07T19:02:
29.401Z	[  401.571146] RSP: 0018:ff500c2fc00fbe00 EFLAGS: 00000202
1788807749392	2026-09-07T19:02:29.392Z	[  401.571145] Code: 48 2b 15 61 f7 85 02 75 66 c9 e9 5c e8 c6 ff 65 48 8b 05 71 f7 85 02 48 8d b0 40 08 31 a8 8b 46 08 a8 01 74 09 f3 90 8b 46 08 <a8> 01 75 f7 83 4e 08 01 4c 89 46 10 48 89 56 18 e8 a1 fd ff ff eb
1788807749381	2026-09-07T19:02:29.381Z	[  401.571139] RIP: 0010:smp_call_function_single+0xea/0x140
1788807749381	2026-09-07T19:02:29.381Z	[  401.571137] Hardware name: ASUSTeK COMPUTER INC. RS500A-E12-RS12U/K14PA-U24 Series, BIOS 1201 08/25/2023
1788807749381	2026-09-07T19:02:29.381Z	[  401.571136] Tainted: [P]=PROPRIETARY_MODULE, [O]=OOT_MODULE, [E]=UNSIGNED_MODULE, [L]=SOFTLOCKUP
1788807749371	2026-09-07T19:02:29.371Z	[  401.571132] CPU: 2 UID: 0 PID: 16 Comm: rcu_exp_par_gp_ Tainted: P           OEL      7.0.13+deb13-amd64 #1 PREEMPT(lazy)  Debian 7.0.13-1~bpo13+1
1788807749352	2026-09-07T19:02:29.352Z	[  401.571087]  nvme_tcp br_netfilter bridge stp llc overla
y nvme_fabrics drm efi_pstore configfs nfnetlink efivarfs ip_tables x_tables autofs4 isofs virtio_net net_failover failover nls_ascii nls_cp437 vfat fat sr_mod cdrom sd_mod zfs(POE) spl(OE) drbd(OE) lru_cache uas hid_generic usbhid cdc_ether usbnet hid usb_storage mii xhci_pci sp5100_tco xhci_hcd ahci nvme watchdog libahci libata nvme_core igb bnxt_en usbcore scsi_mod nvme_keyring i2c_algo_bit nvme_auth i2c_piix4 hkdf dca usb_common i2c_smbus scsi_common wmi aesni_intel
1788807749212	2026-09-07T19:02:29.212Z	[  401.571017] watchdog: BUG: soft lockup - CPU#2 stuck for 22s! [rcu_exp_par_gp_:16]
1788807749212	2026-09-07T19:02:29.212Z	[  401.558164]  </TASK>
1788807749212	2026-09-07T19:02:29.212Z	[  401.558158]  ret_from_fork_asm+0x1a/0x30
1788807749212	2026-09-07T19:02:29.212Z	[  401.558156]  ? __pfx_kthreadd+0x10/0x10
1788807749202	2026-09-07T19:02:29.202Z	[  401.558152]  ret_from_fork+0x2cf/0x360
1788807749202	2026-09-07T19:02:29.202Z	[  401.558149]  ? __pfx_kthreadd+0x10/0x10
17
88807749202	2026-09-07T19:02:29.202Z	[  401.558145]  kthreadd+0x284/0x300
1788807749202	2026-09-07T19:02:29.202Z	[  401.558142]  ? __pfx_kthread+0x10/0x10
1788807749202	2026-09-07T19:02:29.202Z	[  401.558138]  kernel_thread+0x71/0xa0
1788807749202	2026-09-07T19:02:29.202Z	[  401.558134]  kernel_clone+0xbc/0x490
1788807749192	2026-09-07T19:02:29.192Z	[  401.558128]  copy_process+0x146f/0x1d00
1788807749192	2026-09-07T19:02:29.192Z	[  401.558123]  cgroup_can_fork+0x72/0x5c0
1788807749192	2026-09-07T19:02:29.192Z	[  401.558121]  _raw_spin_lock_irq+0x2f/0x40
1788807749192	2026-09-07T19:02:29.192Z	[  401.558115]  <TASK>
1788807749192	2026-09-07T19:02:29.192Z	[  401.558113] Call Trace:
1788807749192	2026-09-07T19:02:29.192Z	[  401.558112] PKRU: 55555554
1788807749182	2026-09-07T19:02:29.182Z	[  401.558111] CR2: 000004504f634030 CR3: 0000000132c9e003 CR4: 0000000000f71ef0
1788807749182	2026-09-07T19:02:29.182Z	[  401.558110] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
178880
7749182	2026-09-07T19:02:29.182Z	[  401.558108] FS:  0000000000000000(0000) GS:ff35266ea4e63000(0000) knlGS:0000000000000000
1788807749172	2026-09-07T19:02:29.172Z	[  401.558107] R13: 0000000002b80000 R14: 0000000000000022 R15: ff3525b2011a0000
1788807749172	2026-09-07T19:02:29.172Z	[  401.558106] R10: 0000000000000000 R11: 0000000000000000 R12: ff35266e4aeb3400
1788807749172	2026-09-07T19:02:29.172Z	[  401.558105] RBP: ff35266e4d173400 R08: 0000000000020459 R09: 0000000000000000
1788807749162	2026-09-07T19:02:29.162Z	[  401.558104] RDX: 0000000000000023 RSI: 00000000008c0101 RDI: ffffffffa83b3ee4
1788807749162	2026-09-07T19:02:29.162Z	[  401.558102] RAX: 0000000000000000 RBX: ffffffffa83b3ee4 RCX: 00000000000033a2
1788807749162	2026-09-07T19:02:29.162Z	[  401.558101] RSP: 0018:ff500c2fc008bc68 EFLAGS: 00000046
1788807749051	2026-09-07T19:02:29.051Z	[  401.558099] Code: e0 05 4d 63 f6 4c 8d a0 00 04 31 a8 49 81 fe 00 20 00 00 73 45 4e 03 24 f5 e0 60 ed a6 49 89 2c 24 8b 45 08 85
 c0 75 09 f3 90 <8b> 45 08 85 c0 74 f7 48 8b 55 00 48 85 d2 0f 84 6b ff ff ff 0f 0d
1788807749041	2026-09-07T19:02:29.041Z	[  401.558093] RIP: 0010:native_queued_spin_lock_slowpath+0x2a7/0x2f0
1788807749041	2026-09-07T19:02:29.041Z	[  401.558092] Hardware name: ASUSTeK COMPUTER INC. RS500A-E12-RS12U/K14PA-U24 Series, BIOS 1201 08/25/2023
1788807749041	2026-09-07T19:02:29.041Z	[  401.558091] Tainted: [P]=PROPRIETARY_MODULE, [O]=OOT_MODULE, [E]=UNSIGNED_MODULE, [L]=SOFTLOCKUP
1788807749032	2026-09-07T19:02:29.032Z	[  401.558086] CPU: 173 UID: 0 PID: 2 Comm: kthreadd Tainted: P           OEL      7.0.13+deb13-amd64 #1 PREEMPT(lazy)  Debian 7.0.13-1~bpo13+1
1788807749012	2026-09-07T19:02:29.012Z	[  401.558042]  nvme_tcp br_netfilter bridge stp llc overlay nvme_fabrics drm efi_pstore configfs nfnetlink efivarfs ip_tables x_tables autofs4 isofs virtio_net net_failover failover nls_ascii nls_cp437 vfat fat sr_mod cdrom sd_mod zfs(POE) spl(OE) drbd(OE) lru_cache uas hid_generic usbhid cdc
_ether usbnet hid usb_storage mii xhci_pci sp5100_tco xhci_hcd ahci nvme watchdog libahci libata nvme_core igb bnxt_en usbcore scsi_mod nvme_keyring i2c_algo_bit nvme_auth i2c_piix4 hkdf dca usb_common i2c_smbus scsi_common wmi aesni_intel
1788807748871	2026-09-07T19:02:28.871Z	[  401.557971] watchdog: CPU173: Watchdog detected hard LOCKUP on cpu 173
1788807748871	2026-09-07T19:02:28.871Z	[  401.544153]  </TASK>
1788807748871	2026-09-07T19:02:28.871Z	[  401.544149] R13: 0000000000000000 R14: 000000c0114e4fc0 R15: 003fffffffffffff
1788807748861	2026-09-07T19:02:28.861Z	[  401.544148] R10: 0000000000000000 R11: 0000000000000212 R12: 000000c013c5fb60
1788807748861	2026-09-07T19:02:28.861Z	[  401.544147] RBP: 000000c013c5fa30 R08: 0000000000000000 R09: 0000000000000000
1788807748861	2026-09-07T19:02:28.861Z	[  401.544146] RDX: 0000000000000200 RSI: 000000c013d1d200 RDI: 000000000000001a
1788807748852	2026-09-07T19:02:28.852Z	[  401.544145] RAX: ffffffffffffffda RBX: 000000000000001a
 RCX: 00000000004085ae
1788807748852	2026-09-07T19:02:28.852Z	[  401.544143] RSP: 002b:000000c013c5f9f0 EFLAGS: 00000212 ORIG_RAX: 0000000000000000
1788807748842	2026-09-07T19:02:28.842Z	[  401.544142] Code: 48 83 ec 38 e8 13 00 00 00 48 83 c4 38 5d c3 cc cc cc cc cc cc cc cc cc cc cc cc cc 49 89 f2 48 89 fa 48 89 ce 48 89 df 0f 05 <48> 3d 01 f0 ff ff 76 15 48 f7 d8 48 89 c1 48 c7 c0 ff ff ff ff 48
1788807748842	2026-09-07T19:02:28.842Z	[  401.544110] RIP: 0033:0x4085ae
1788807748842	2026-09-07T19:02:28.842Z	[  401.544108]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
1788807748842	2026-09-07T19:02:28.842Z	[  401.544104]  ? do_syscall_64+0x10a/0x15f0
1788807748831	2026-09-07T19:02:28.831Z	[  401.544102]  ? srso_alias_return_thunk+0x5/0xfbef5
1788807748831	2026-09-07T19:02:28.831Z	[  401.544100]  ? do_syscall_64+0x10a/0x15f0
1788807748831	2026-09-07T19:02:28.831Z	[  401.544098]  ? srso_alias_return_thunk+0x5/0xfbef5
1788807748831	2026-09-07T19:02:28.831Z	[  401.544097]  ? trace_sys
call_exit+0x62/0x90
1788807748831	2026-09-07T19:02:28.831Z	[  401.544095]  ? srso_alias_return_thunk+0x5/0xfbef5
1788807748822	2026-09-07T19:02:28.822Z	[  401.544093]  ? srso_alias_return_thunk+0x5/0xfbef5
1788807748822	2026-09-07T19:02:28.822Z	[  401.544091]  ? do_syscall_64+0x10a/0x15f0
1788807748822	2026-09-07T19:02:28.822Z	[  401.544088]  ? srso_alias_return_thunk+0x5/0xfbef5
1788807748822	2026-09-07T19:02:28.822Z	[  401.544087]  ? trace_syscall_exit+0x62/0x90
1788807748822	2026-09-07T19:02:28.822Z	[  401.544085]  ? srso_alias_return_thunk+0x5/0xfbef5
1788807748812	2026-09-07T19:02:28.812Z	[  401.544083]  ? srso_alias_return_thunk+0x5/0xfbef5
1788807748812	2026-09-07T19:02:28.812Z	[  401.544078]  ? bpf_trace_run2+0xdf/0x1e0
1788807748812	2026-09-07T19:02:28.812Z	[  401.544076]  ? srso_alias_return_thunk+0x5/0xfbef5
1788807748812	2026-09-07T19:02:28.812Z	[  401.544073]  ? bpf_prog_05f12f6e18d2e600_sys_exit+0x4d/0xb3
1788807748812	2026-09-07T19:02:28.812Z	[  401.544070]  ?
 srso_alias_return_thunk+0x5/0xfbef5
1788807748711	2026-09-07T19:02:28.711Z	[  401.544067]  ? lookup_nulls_elem_raw+0x4d/0x90
1788807748711	2026-09-07T19:02:28.711Z	[  401.544065]  ? srso_alias_return_thunk+0x5/0xfbef5
1788807748702	2026-09-07T19:02:28.702Z	[  401.544062]  ? do_syscall_64+0x10a/0x15f0
1788807748702	2026-09-07T19:02:28.702Z	[  401.544060]  ? srso_alias_return_thunk+0x5/0xfbef5
1788807748702	2026-09-07T19:02:28.702Z	[  401.544058]  ? trace_syscall_exit+0x62/0x90
1788807748702	2026-09-07T19:02:28.702Z	[  401.544056]  ? srso_alias_return_thunk+0x5/0xfbef5
1788807748702	2026-09-07T19:02:28.702Z	[  401.544054]  ? srso_alias_return_thunk+0x5/0xfbef5
1788807748692	2026-09-07T19:02:28.692Z	[  401.544050]  ? bpf_trace_run2+0xdf/0x1e0
1788807748692	2026-09-07T19:02:28.692Z	[  401.544048]  ? srso_alias_return_thunk+0x5/0xfbef5
1788807748692	2026-09-07T19:02:28.692Z	[  401.544046]  ? __pfx_ep_ptable_queue_proc+0x10/0x10
1788807748692	2026-09-07T19:02:28.692Z	[  401.54404
2]  ? do_epoll_ctl+0x2b5/0xec0
1788807748692	2026-09-07T19:02:28.692Z	[  401.544040]  ? srso_alias_return_thunk+0x5/0xfbef5
1788807748681	2026-09-07T19:02:28.681Z	[  401.544038]  ? __wake_up+0x44/0x60
1788807748681	2026-09-07T19:02:28.681Z	[  401.544036]  ? srso_alias_return_thunk+0x5/0xfbef5
1788807748681	2026-09-07T19:02:28.681Z	[  401.544033]  ? __wake_up_common+0x78/0xa0
1788807748681	2026-09-07T19:02:28.681Z	[  401.544031]  ? srso_alias_return_thunk+0x5/0xfbef5
1788807748681	2026-09-07T19:02:28.681Z	[  401.544028]  ? ep_autoremove_wake_function+0x23/0x50
1788807748672	2026-09-07T19:02:28.672Z	[  401.544026]  ? srso_alias_return_thunk+0x5/0xfbef5
1788807748672	2026-09-07T19:02:28.672Z	[  401.544022]  do_syscall_64+0xcd/0x15f0
1788807748672	2026-09-07T19:02:28.672Z	[  401.544018]  ksys_read+0x6b/0xe0
1788807748672	2026-09-07T19:02:28.672Z	[  401.544012]  vfs_read+0x25d/0x370
1788807748672	2026-09-07T19:02:28.672Z	[  401.544009]  ? rw_verify_area+0x54/0x180
1788807748661	
2026-09-07T19:02:28.661Z	[  401.544006]  ? srso_alias_return_thunk+0x5/0xfbef5
1788807748661	2026-09-07T19:02:28.661Z	[  401.544002]  seq_read_iter+0x100/0x480
1788807748661	2026-09-07T19:02:28.661Z	[  401.543998]  kernfs_seq_start+0x56/0xb0
1788807748661	2026-09-07T19:02:28.661Z	[  401.543995]  __cgroup_procs_start+0x7b/0xf0
1788807748661	2026-09-07T19:02:28.661Z	[  401.543991]  css_task_iter_start+0x50/0xd0
1788807748661	2026-09-07T19:02:28.661Z	[  401.543987]  _raw_spin_lock_irqsave+0x3d/0x50
1788807748652	2026-09-07T19:02:28.652Z	[  401.543981]  <TASK>
1788807748652	2026-09-07T19:02:28.652Z	[  401.543978] Call Trace:
1788807748652	2026-09-07T19:02:28.652Z	[  401.543978] PKRU: 55555554
1788807748652	2026-09-07T19:02:28.652Z	[  401.543976] CR2: 00007f1a4c283000 CR3: 00000008cf6dc036 CR4: 0000000000f71ef0
1788807748652	2026-09-07T19:02:28.652Z	[  401.543975] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
1788807748642	2026-09-07T19:02:28.642Z	[  401.543973] FS:  00007f82
c57fa6c0(0000) GS:ff35266ea5063000(0000) knlGS:0000000000000000
1788807748642	2026-09-07T19:02:28.642Z	[  401.543972] R13: 0000000002d80000 R14: 000000000000001d R15: ff3525b49dee7000
1788807748642	2026-09-07T19:02:28.642Z	[  401.543971] R10: 0000000000000000 R11: 0000000000000000 R12: ff35266e4ad73400
1788807748542	2026-09-07T19:02:28.542Z	[  401.543970] RBP: ff35266e4d373400 R08: ff3525b247c2fb80 R09: 000000000000000b
1788807748542	2026-09-07T19:02:28.542Z	[  401.543969] RDX: 000000000000001e RSI: 0000000000780101 RDI: ffffffffa83b3ee4
1788807748532	2026-09-07T19:02:28.532Z	[  401.543967] RAX: 0000000000000000 RBX: ffffffffa83b3ee4 RCX: 0000000000000000
1788807748532	2026-09-07T19:02:28.532Z	[  401.543965] RSP: 0018:ff500c3064e6fa38 EFLAGS: 00000046
1788807748522	2026-09-07T19:02:28.522Z	[  401.543963] Code: 63 f6 4c 8d a0 00 04 31 a8 49 81 fe 00 20 00 00 73 45 4e 03 24 f5 e0 60 ed a6 49 89 2c 24 8b 45 08 85 c0 75 09 f3 90 8b 45 08 <85> c0 74 f7 48 8b 55 00 48 85 d2 0f 84 6b f
f ff ff 0f 0d 0a e9 63
1788807748522	2026-09-07T19:02:28.522Z	[  401.543958] RIP: 0010:native_queued_spin_lock_slowpath+0x2aa/0x2f0
1788807748512	2026-09-07T19:02:28.512Z	[  401.543956] Hardware name: ASUSTeK COMPUTER INC. RS500A-E12-RS12U/K14PA-U24 Series, BIOS 1201 08/25/2023
1788807748512	2026-09-07T19:02:28.512Z	[  401.543955] Tainted: [P]=PROPRIETARY_MODULE, [O]=OOT_MODULE, [E]=UNSIGNED_MODULE, [L]=SOFTLOCKUP
1788807748502	2026-09-07T19:02:28.502Z	[  401.543951] CPU: 181 UID: 0 PID: 67573 Comm: kubelet Tainted: P           OEL      7.0.13+deb13-amd64 #1 PREEMPT(lazy)  Debian 7.0.13-1~bpo13+1
1788807748482	2026-09-07T19:02:28.482Z	[  401.543902]  nvme_tcp br_netfilter bridge stp llc overlay nvme_fabrics drm efi_pstore configfs nfnetlink efivarfs ip_tables x_tables autofs4 isofs virtio_net net_failover failover nls_ascii nls_cp437 vfat fat sr_mod cdrom sd_mod zfs(POE) spl(OE) drbd(OE) lru_cache uas hid_generic usbhid cdc_ether usbnet hid usb_storage mii xhci_pci sp5100_tco xhci
_hcd ahci nvme watchdog libahci libata nvme_core igb bnxt_en usbcore scsi_mod nvme_keyring i2c_algo_bit nvme_auth i2c_piix4 hkdf dca usb_common i2c_smbus scsi_common wmi aesni_intel
1788807748342	2026-09-07T19:02:28.342Z	[  401.543832] watchdog: CPU181: Watchdog detected hard LOCKUP on cpu 181
1788807748331	2026-09-07T19:02:28.331Z	[  401.488405]  </TASK>
1788807748331	2026-09-07T19:02:28.331Z	[  401.488399]  common_startup_64+0x13e/0x141
1788807748331	2026-09-07T19:02:28.331Z	[  401.488395]  start_secondary+0x128/0x170
1788807748331	2026-09-07T19:02:28.331Z	[  401.488392]  cpu_startup_entry+0x29/0x30
1788807748331	2026-09-07T19:02:28.331Z	[  401.488387]  do_idle+0x16c/0x2a0
1788807748331	2026-09-07T19:02:28.331Z	[  401.488384]  schedule_idle+0x23/0x40
1788807748321	2026-09-07T19:02:28.321Z	[  401.488379]  __schedule+0x4ec/0xfe0
1788807748321	2026-09-07T19:02:28.321Z	[  401.488375]  finish_task_switch.isra.0+0x238/0x2c0
1788807748321	2026-09-07T19:02:28.321Z	[  401.488371]  c
group_task_dead+0x29/0x140
1788807748321	2026-09-07T19:02:28.321Z	[  401.488367]  _raw_spin_lock_irqsave+0x3d/0x50
1788807748321	2026-09-07T19:02:28.321Z	[  401.488360]  <TASK>
1788807748321	2026-09-07T19:02:28.321Z	[  401.488358] Call Trace:
1788807748312	2026-09-07T19:02:28.312Z	[  401.488357] PKRU: 55555554
1788807748312	2026-09-07T19:02:28.312Z	[  401.488355] CR2: 00007f0cdb395000 CR3: 0000000290bb8003 CR4: 0000000000f71ef0
1788807748312	2026-09-07T19:02:28.312Z	[  401.488354] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
1788807748301	2026-09-07T19:02:28.301Z	[  401.488353] FS:  0000000000000000(0000) GS:ff35266ea3ca3000(0000) knlGS:0000000000000000
1788807748301	2026-09-07T19:02:28.301Z	[  401.488351] R13: 00000000019c0000 R14: 00000000000000ad R15: 0000000000000000
1788807748301	2026-09-07T19:02:28.301Z	[  401.488350] R10: 0000000000000000 R11: ff35266e4bf9d180 R12: ff35266e4d173400
1788807748292	2026-09-07T19:02:28.292Z	[  401.488349] RBP: ff35266e4bfb3400 R08: 00
000056bba3fe1a R09: 0000000000000001
1788807748292	2026-09-07T19:02:28.292Z	[  401.488347] RDX: 00000000000000ae RSI: 0000000002b80101 RDI: ffffffffa83b3ee4
1788807748292	2026-09-07T19:02:28.292Z	[  401.488346] RAX: 0000000000000000 RBX: ffffffffa83b3ee4 RCX: 0000000000000000
1788807748292	2026-09-07T19:02:28.292Z	[  401.488344] RSP: 0018:ff500c2fc072fd90 EFLAGS: 00000046
1788807748193	2026-09-07T19:02:28.193Z	[  401.488342] Code: 63 f6 4c 8d a0 00 04 31 a8 49 81 fe 00 20 00 00 73 45 4e 03 24 f5 e0 60 ed a6 49 89 2c 24 8b 45 08 85 c0 75 09 f3 90 8b 45 08 <85> c0 74 f7 48 8b 55 00 48 85 d2 0f 84 6b ff ff ff 0f 0d 0a e9 63
1788807748182	2026-09-07T19:02:28.182Z	[  401.488336] RIP: 0010:native_queued_spin_lock_slowpath+0x2aa/0x2f0
1788807748182	2026-09-07T19:02:28.182Z	[  401.488334] Hardware name: ASUSTeK COMPUTER INC. RS500A-E12-RS12U/K14PA-U24 Series, BIOS 1201 08/25/2023
1788807748172	2026-09-07T19:02:28.172Z	[  401.488328] CPU: 102 UID: 0 PID: 0 Comm: swapper/102 Tainted: P   
        OEL      7.0.13+deb13-amd64 #1 PREEMPT(lazy)  Debian 7.0.13-1~bpo13+1
1788807748152	2026-09-07T19:02:28.152Z	[  401.488282]  nvme_tcp br_netfilter bridge stp llc overlay nvme_fabrics drm efi_pstore configfs nfnetlink efivarfs ip_tables x_tables autofs4 isofs virtio_net net_failover failover nls_ascii nls_cp437 vfat fat sr_mod cdrom sd_mod zfs(POE) spl(OE) drbd(OE) lru_cache uas hid_generic usbhid cdc_ether usbnet hid usb_storage mii xhci_pci sp5100_tco xhci_hcd ahci nvme watchdog libahci libata nvme_core igb bnxt_en usbcore scsi_mod nvme_keyring i2c_algo_bit nvme_auth i2c_piix4 hkdf dca usb_common i2c_smbus scsi_common wmi aesni_intel
1788807748012	2026-09-07T19:02:28.012Z	[  401.488213] watchdog: CPU102: Watchdog detected hard LOCKUP on cpu 102
1788807748012	2026-09-07T19:02:28.012Z	[  401.447472]  </TASK>
1788807748012	2026-09-07T19:02:28.012Z	[  401.447466] R13: 0000000000000000 R14: 000000c002183c00 R15: 0000000000000000
1788807748001	2026-09-07T19:02:28.001Z	[  401.44
7465] R10: 0000000000000000 R11: 0000000000000206 R12: 0000000000f070e5
1788807748001	2026-09-07T19:02:28.001Z	[  401.447464] RBP: 000000c0016d0e00 R08: 0000000000000000 R09: 0000000000000000
1788807748001	2026-09-07T19:02:28.001Z	[  401.447463] RDX: 000000c0016d0be0 RSI: 0000000000000000 RDI: 0000000000004111
1788807747991	2026-09-07T19:02:27.991Z	[  401.447462] RAX: ffffffffffffffda RBX: 0000000000000005 RCX: 0000000000f1164d
1788807747991	2026-09-07T19:02:27.991Z	[  401.447460] RSP: 002b:000000c0016d0b60 EFLAGS: 00000206 ORIG_RAX: 0000000000000038
1788807747982	2026-09-07T19:02:27.982Z	[  401.447459] Code: 24 10 48 8b 74 24 18 48 8b 54 24 20 49 c7 c2 00 00 00 00 49 c7 c0 00 00 00 00 49 c7 c1 00 00 00 00 48 8b 44 24 08 41 5c 0f 05 <41> 54 48 3d 01 f0 ff ff 76 12 48 c7 44 24 28 ff ff ff ff 48 f7 d8
1788807747982	2026-09-07T19:02:27.982Z	[  401.447427] RIP: 0033:0xf1164d
1788807747982	2026-09-07T19:02:27.982Z	[  401.447425]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
178880774797
2	2026-09-07T19:02:27.972Z	[  401.447422]  ? do_syscall_64+0x10a/0x15f0
1788807747972	2026-09-07T19:02:27.972Z	[  401.447420]  ? srso_alias_return_thunk+0x5/0xfbef5
1788807747972	2026-09-07T19:02:27.972Z	[  401.447418]  ? do_syscall_64+0x10a/0x15f0
1788807747972	2026-09-07T19:02:27.972Z	[  401.447416]  ? srso_alias_return_thunk+0x5/0xfbef5
1788807747972	2026-09-07T19:02:27.972Z	[  401.447414]  ? do_syscall_64+0x10a/0x15f0
1788807747962	2026-09-07T19:02:27.962Z	[  401.447412]  ? srso_alias_return_thunk+0x5/0xfbef5
1788807747962	2026-09-07T19:02:27.962Z	[  401.447411]  ? trace_syscall_exit+0x62/0x90
1788807747962	2026-09-07T19:02:27.962Z	[  401.447409]  ? srso_alias_return_thunk+0x5/0xfbef5
1788807747962	2026-09-07T19:02:27.962Z	[  401.447407]  ? srso_alias_return_thunk+0x5/0xfbef5
1788807747962	2026-09-07T19:02:27.962Z	[  401.447405]  ? do_syscall_64+0x10a/0x15f0
1788807747952	2026-09-07T19:02:27.952Z	[  401.447403]  ? srso_alias_return_thunk+0x5/0xfbef5
1788807747952	2026-09
-07T19:02:27.952Z	[  401.447401]  ? trace_syscall_exit+0x62/0x90
1788807747952	2026-09-07T19:02:27.952Z	[  401.447400]  ? srso_alias_return_thunk+0x5/0xfbef5
1788807747952	2026-09-07T19:02:27.952Z	[  401.447397]  ? do_syscall_64+0x10a/0x15f0
1788807747952	2026-09-07T19:02:27.952Z	[  401.447396]  ? srso_alias_return_thunk+0x5/0xfbef5
1788807747852	2026-09-07T19:02:27.852Z	[  401.447394]  ? trace_syscall_exit+0x62/0x90
1788807747852	2026-09-07T19:02:27.852Z	[  401.447392]  ? srso_alias_return_thunk+0x5/0xfbef5
1788807747852	2026-09-07T19:02:27.852Z	[  401.447391]  ? srso_alias_return_thunk+0x5/0xfbef5
1788807747841	2026-09-07T19:02:27.841Z	[  401.447388]  ? bpf_trace_run2+0xdf/0x1e0
1788807747841	2026-09-07T19:02:27.841Z	[  401.447386]  ? srso_alias_return_thunk+0x5/0xfbef5
1788807747841	2026-09-07T19:02:27.841Z	[  401.447384]  ? srso_alias_return_thunk+0x5/0xfbef5
1788807747841	2026-09-07T19:02:27.841Z	[  401.447382]  ? bpf_prog_05cbe5ca7b74dd09_sys_enter+0x40/0xa6
1788807747
832	2026-09-07T19:02:27.832Z	[  401.447380]  ? srso_alias_return_thunk+0x5/0xfbef5
1788807747832	2026-09-07T19:02:27.832Z	[  401.447378]  ? lookup_nulls_elem_raw+0x4d/0x90
1788807747832	2026-09-07T19:02:27.832Z	[  401.447376]  ? srso_alias_return_thunk+0x5/0xfbef5
1788807747832	2026-09-07T19:02:27.832Z	[  401.447374]  ? do_syscall_64+0x10a/0x15f0
1788807747832	2026-09-07T19:02:27.832Z	[  401.447372]  ? srso_alias_return_thunk+0x5/0xfbef5
1788807747822	2026-09-07T19:02:27.822Z	[  401.447370]  ? trace_syscall_exit+0x62/0x90
1788807747822	2026-09-07T19:02:27.822Z	[  401.447368]  ? srso_alias_return_thunk+0x5/0xfbef5
1788807747822	2026-09-07T19:02:27.822Z	[  401.447366]  ? srso_alias_return_thunk+0x5/0xfbef5
1788807747822	2026-09-07T19:02:27.822Z	[  401.447363]  ? bpf_trace_run2+0xdf/0x1e0
1788807747822	2026-09-07T19:02:27.822Z	[  401.447361]  ? srso_alias_return_thunk+0x5/0xfbef5
1788807747811	2026-09-07T19:02:27.811Z	[  401.447360]  ? srso_alias_return_thunk+0x5/0xfbef5
178880
7747811	2026-09-07T19:02:27.811Z	[  401.447358]  ? bpf_prog_05cbe5ca7b74dd09_sys_enter+0x40/0xa6
1788807747811	2026-09-07T19:02:27.811Z	[  401.447356]  ? srso_alias_return_thunk+0x5/0xfbef5
1788807747811	2026-09-07T19:02:27.811Z	[  401.447353]  ? lookup_nulls_elem_raw+0x4d/0x90
1788807747802	2026-09-07T19:02:27.802Z	[  401.447351]  ? srso_alias_return_thunk+0x5/0xfbef5
1788807747802	2026-09-07T19:02:27.802Z	[  401.447349]  ? srso_alias_return_thunk+0x5/0xfbef5
1788807747802	2026-09-07T19:02:27.802Z	[  401.447345]  ? bpf_trace_run2+0xdf/0x1e0
1788807747802	2026-09-07T19:02:27.802Z	[  401.447343]  ? srso_alias_return_thunk+0x5/0xfbef5
1788807747802	2026-09-07T19:02:27.802Z	[  401.447341]  ? srso_alias_return_thunk+0x5/0xfbef5
1788807747792	2026-09-07T19:02:27.792Z	[  401.447339]  ? bpf_prog_05cbe5ca7b74dd09_sys_enter+0x40/0xa6
1788807747792	2026-09-07T19:02:27.792Z	[  401.447336]  ? srso_alias_return_thunk+0x5/0xfbef5
1788807747792	2026-09-07T19:02:27.792Z	[  401.447333]  ? loo
kup_nulls_elem_raw+0x4d/0x90
1788807747792	2026-09-07T19:02:27.792Z	[  401.447331]  ? srso_alias_return_thunk+0x5/0xfbef5
1788807747782	2026-09-07T19:02:27.782Z	[  401.447329]  ? srso_alias_return_thunk+0x5/0xfbef5
1788807747782	2026-09-07T19:02:27.782Z	[  401.447325]  ? memcg_list_lru_alloc+0xb1/0x290
1788807747782	2026-09-07T19:02:27.782Z	[  401.447323]  ? srso_alias_return_thunk+0x5/0xfbef5
1788807747782	2026-09-07T19:02:27.782Z	[  401.447319]  ? xa_load+0x7a/0xb0
1788807747782	2026-09-07T19:02:27.782Z	[  401.447316]  ? srso_alias_return_thunk+0x5/0xfbef5
1788807747782	2026-09-07T19:02:27.782Z	[  401.447312]  do_syscall_64+0xcd/0x15f0
1788807747672	2026-09-07T19:02:27.672Z	[  401.447307]  __do_sys_clone+0x65/0x90
1788807747672	2026-09-07T19:02:27.672Z	[  401.447303]  kernel_clone+0xbc/0x490
1788807747672	2026-09-07T19:02:27.672Z	[  401.447297]  copy_process+0x146f/0x1d00
1788807747661	2026-09-07T19:02:27.661Z	[  401.447292]  cgroup_can_fork+0x72/0x5c0
1788807747661	2026-
09-07T19:02:27.661Z	[  401.447290]  _raw_spin_lock_irq+0x2f/0x40
1788807747661	2026-09-07T19:02:27.661Z	[  401.447286]  <TASK>
1788807747661	2026-09-07T19:02:27.661Z	[  401.447284] Call Trace:
1788807747661	2026-09-07T19:02:27.661Z	[  401.447283] PKRU: 55555554
1788807747661	2026-09-07T19:02:27.661Z	[  401.447282] CR2: 00007f92357762a0 CR3: 000000079e621035 CR4: 0000000000f71ef0
1788807747652	2026-09-07T19:02:27.652Z	[  401.447281] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
1788807747652	2026-09-07T19:02:27.652Z	[  401.447279] FS:  00007f735cff96c0(0000) GS:ff35266ea43e3000(0000) knlGS:0000000000000000
1788807747652	2026-09-07T19:02:27.652Z	[  401.447278] R13: 0000000002100000 R14: 00000000000000b4 R15: ff3525b436072180
1788807747641	2026-09-07T19:02:27.641Z	[  401.447277] R10: 0000000000000000 R11: 0000000000000000 R12: ff35266e4d333400
1788807747641	2026-09-07T19:02:27.641Z	[  401.447276] RBP: ff35266e4c6f3400 R08: 0000000000020457 R09: 0000000000000000
1788807747641
	2026-09-07T19:02:27.641Z	[  401.447275] RDX: 00000000000000b5 RSI: 0000000002d40101 RDI: ffffffffa83b3ee4
1788807747632	2026-09-07T19:02:27.632Z	[  401.447273] RAX: 0000000000000000 RBX: ffffffffa83b3ee4 RCX: 00000000000033ae
1788807747632	2026-09-07T19:02:27.632Z	[  401.447271] RSP: 0018:ff500c308973b8f8 EFLAGS: 00000046
1788807747621	2026-09-07T19:02:27.621Z	[  401.447270] Code: 63 f6 4c 8d a0 00 04 31 a8 49 81 fe 00 20 00 00 73 45 4e 03 24 f5 e0 60 ed a6 49 89 2c 24 8b 45 08 85 c0 75 09 f3 90 8b 45 08 <85> c0 74 f7 48 8b 55 00 48 85 d2 0f 84 6b ff ff ff 0f 0d 0a e9 63
1788807747621	2026-09-07T19:02:27.621Z	[  401.447265] RIP: 0010:native_queued_spin_lock_slowpath+0x2aa/0x2f0
1788807747611	2026-09-07T19:02:27.611Z	[  401.447264] Hardware name: ASUSTeK COMPUTER INC. RS500A-E12-RS12U/K14PA-U24 Series, BIOS 1201 08/25/2023
1788807747611	2026-09-07T19:02:27.611Z	[  401.447263] Tainted: [P]=PROPRIETARY_MODULE, [O]=OOT_MODULE, [E]=UNSIGNED_MODULE, [L]=SOFTLOCKUP
1788807747602	2026-
09-07T19:02:27.602Z	[  401.447259] CPU: 131 UID: 0 PID: 71775 Comm: crio Tainted: P           OEL      7.0.13+deb13-amd64 #1 PREEMPT(lazy)  Debian 7.0.13-1~bpo13+1
1788807747492	2026-09-07T19:02:27.492Z	[  401.447218]  nvme_tcp br_netfilter bridge stp llc overlay nvme_fabrics drm efi_pstore configfs nfnetlink efivarfs ip_tables x_tables autofs4 isofs virtio_net net_failover failover nls_ascii nls_cp437 vfat fat sr_mod cdrom sd_mod zfs(POE) spl(OE) drbd(OE) lru_cache uas hid_generic usbhid cdc_ether usbnet hid usb_storage mii xhci_pci sp5100_tco xhci_hcd ahci nvme watchdog libahci libata nvme_core igb bnxt_en usbcore scsi_mod nvme_keyring i2c_algo_bit nvme_auth i2c_piix4 hkdf dca usb_common i2c_smbus scsi_common wmi aesni_intel
1788807747452	2026-09-07T19:02:27.452Z	[  401.447159] watchdog: CPU131: Watchdog detected hard LOCKUP on cpu 131
1788807747452	2026-09-07T19:02:27.452Z	[  401.414189]  </TASK>
1788807747442	2026-09-07T19:02:27.442Z	[  401.414183]  common_startup_64+0x13e/0x14
1
1788807747442	2026-09-07T19:02:27.442Z	[  401.414179]  start_secondary+0x128/0x170
1788807747442	2026-09-07T19:02:27.442Z	[  401.414176]  cpu_startup_entry+0x29/0x30
1788807747442	2026-09-07T19:02:27.442Z	[  401.414171]  do_idle+0x16c/0x2a0
1788807747442	2026-09-07T19:02:27.442Z	[  401.414168]  schedule_idle+0x23/0x40
1788807747442	2026-09-07T19:02:27.442Z	[  401.414163]  __schedule+0x4ec/0xfe0
1788807747432	2026-09-07T19:02:27.432Z	[  401.414159]  finish_task_switch.isra.0+0x238/0x2c0
1788807747432	2026-09-07T19:02:27.432Z	[  401.414154]  cgroup_task_dead+0x29/0x140
1788807747432	2026-09-07T19:02:27.432Z	[  401.414150]  _raw_spin_lock_irqsave+0x3d/0x50
1788807747432	2026-09-07T19:02:27.432Z	[  401.414143]  <TASK>
1788807747432	2026-09-07T19:02:27.432Z	[  401.414140] Call Trace:
1788807747432	2026-09-07T19:02:27.432Z	[  401.414139] PKRU: 55555554
1788807747331	2026-09-07T19:02:27.331Z	[  401.414138] CR2: 00007f80a2e2e180 CR3: 0000000a14bc1033 CR4: 0000000000f71ef0
178880
7747331	2026-09-07T19:02:27.331Z	[  401.414137] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
1788807747321	2026-09-07T19:02:27.321Z	[  401.414135] FS:  0000000000000000(0000) GS:ff35266ea2ba3000(0000) knlGS:0000000000000000
1788807747321	2026-09-07T19:02:27.321Z	[  401.414134] R13: 00000000008c0000 R14: 0000000000000051 R15: 0000000000000000
1788807747321	2026-09-07T19:02:27.321Z	[  401.414133] R10: 0000000000000000 R11: ff35266e4ae9d180 R12: ff35266e4ba73400
1788807747311	2026-09-07T19:02:27.311Z	[  401.414132] RBP: ff35266e4aeb3400 R08: 00000056bba0b65d R09: 0000000000000001
1788807747311	2026-09-07T19:02:27.311Z	[  401.414130] RDX: 0000000000000052 RSI: 0000000001480101 RDI: ffffffffa83b3ee4
1788807747311	2026-09-07T19:02:27.311Z	[  401.414129] RAX: 0000000000000000 RBX: ffffffffa83b3ee4 RCX: 0000000000000000
1788807747302	2026-09-07T19:02:27.302Z	[  401.414127] RSP: 0018:ff500c2fc0487d90 EFLAGS: 00000046
1788807747291	2026-09-07T19:02:27.291Z	[  401.414125] Code: 63 f6
 4c 8d a0 00 04 31 a8 49 81 fe 00 20 00 00 73 45 4e 03 24 f5 e0 60 ed a6 49 89 2c 24 8b 45 08 85 c0 75 09 f3 90 8b 45 08 <85> c0 74 f7 48 8b 55 00 48 85 d2 0f 84 6b ff ff ff 0f 0d 0a e9 63
1788807747291	2026-09-07T19:02:27.291Z	[  401.414119] RIP: 0010:native_queued_spin_lock_slowpath+0x2aa/0x2f0
1788807747291	2026-09-07T19:02:27.291Z	[  401.414118] Hardware name: ASUSTeK COMPUTER INC. RS500A-E12-RS12U/K14PA-U24 Series, BIOS 1201 08/25/2023
1788807747281	2026-09-07T19:02:27.281Z	[  401.414116] Tainted: [P]=PROPRIETARY_MODULE, [O]=OOT_MODULE, [E]=UNSIGNED_MODULE, [L]=SOFTLOCKUP
1788807747281	2026-09-07T19:02:27.281Z	[  401.414112] CPU: 34 UID: 0 PID: 0 Comm: swapper/34 Tainted: P           OEL      7.0.13+deb13-amd64 #1 PREEMPT(lazy)  Debian 7.0.13-1~bpo13+1
1788807747262	2026-09-07T19:02:27.262Z	[  401.414066]  nvme_tcp br_netfilter bridge stp llc overlay nvme_fabrics drm efi_pstore configfs nfnetlink efivarfs ip_tables x_tables autofs4 isofs virtio_net net_failover failover nls_a
scii nls_cp437 vfat fat sr_mod cdrom sd_mod zfs(POE) spl(OE) drbd(OE) lru_cache uas hid_generic usbhid cdc_ether usbnet hid usb_storage mii xhci_pci sp5100_tco xhci_hcd ahci nvme watchdog libahci libata nvme_core igb bnxt_en usbcore scsi_mod nvme_keyring i2c_algo_bit nvme_auth i2c_piix4 hkdf dca usb_common i2c_smbus scsi_common wmi aesni_intel
1788807747122	2026-09-07T19:02:27.122Z	[  401.413996] watchdog: CPU34: Watchdog detected hard LOCKUP on cpu 34
1788807747122	2026-09-07T19:02:27.122Z	[  401.372193]  </TASK>
1788807747122	2026-09-07T19:02:27.122Z	[  401.372187]  common_startup_64+0x13e/0x141
1788807747111	2026-09-07T19:02:27.111Z	[  401.372183]  start_secondary+0x128/0x170
1788807747111	2026-09-07T19:02:27.111Z	[  401.372180]  cpu_startup_entry+0x29/0x30
1788807747111	2026-09-07T19:02:27.111Z	[  401.372175]  do_idle+0x16c/0x2a0
1788807747111	2026-09-07T19:02:27.111Z	[  401.372172]  schedule_idle+0x23/0x40
1788807747111	2026-09-07T19:02:27.111Z	[  401.372167]  __schedule+0
x4ec/0xfe0
1788807747111	2026-09-07T19:02:27.111Z	[  401.372163]  finish_task_switch.isra.0+0x238/0x2c0
1788807747101	2026-09-07T19:02:27.101Z	[  401.372158]  cgroup_task_dead+0x29/0x140
1788807747101	2026-09-07T19:02:27.101Z	[  401.372155]  _raw_spin_lock_irqsave+0x3d/0x50
1788807747101	2026-09-07T19:02:27.101Z	[  401.372150]  <TASK>
1788807747101	2026-09-07T19:02:27.101Z	[  401.372148] Call Trace:
1788807747101	2026-09-07T19:02:27.101Z	[  401.372147] PKRU: 55555554
1788807747101	2026-09-07T19:02:27.101Z	[  401.372145] CR2: 000000c000e87010 CR3: 000000027dfc6006 CR4: 0000000000f71ef0
1788807747092	2026-09-07T19:02:27.092Z	[  401.372144] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
1788807747092	2026-09-07T19:02:27.092Z	[  401.372143] FS:  0000000000000000(0000) GS:ff35266ea36e3000(0000) knlGS:0000000000000000
1788807747092	2026-09-07T19:02:27.092Z	[  401.372142] R13: 0000000001400000 R14: 0000000000000068 R15: 0000000000000000
1788807746992	2026-09-07T19:02:26.992Z	[  
401.372141] R10: 0000000000000000 R11: ff35266e4b9dd180 R12: ff35266e4c033400
1788807746992	2026-09-07T19:02:26.992Z	[  401.372140] RBP: ff35266e4b9f3400 R08: 00000056bb9a7838 R09: 0000000000000001
1788807746981	2026-09-07T19:02:26.981Z	[  401.372138] RDX: 0000000000000069 RSI: 0000000001a40101 RDI: ffffffffa83b3ee4
1788807746981	2026-09-07T19:02:26.981Z	[  401.372137] RAX: 0000000000000000 RBX: ffffffffa83b3ee4 RCX: 0000000000000000
1788807746981	2026-09-07T19:02:26.981Z	[  401.372136] RSP: 0018:ff500c2fc0677d90 EFLAGS: 00000046
1788807746972	2026-09-07T19:02:26.972Z	[  401.372134] Code: 63 f6 4c 8d a0 00 04 31 a8 49 81 fe 00 20 00 00 73 45 4e 03 24 f5 e0 60 ed a6 49 89 2c 24 8b 45 08 85 c0 75 09 f3 90 8b 45 08 <85> c0 74 f7 48 8b 55 00 48 85 d2 0f 84 6b ff ff ff 0f 0d 0a e9 63
1788807746972	2026-09-07T19:02:26.972Z	[  401.372129] RIP: 0010:native_queued_spin_lock_slowpath+0x2aa/0x2f0
1788807746962	2026-09-07T19:02:26.962Z	[  401.372127] Hardware name: ASUSTeK COMPUTER INC. RS5
00A-E12-RS12U/K14PA-U24 Series, BIOS 1201 08/25/2023
1788807746962	2026-09-07T19:02:26.962Z	[  401.372126] Tainted: [P]=PROPRIETARY_MODULE, [O]=OOT_MODULE, [E]=UNSIGNED_MODULE, [L]=SOFTLOCKUP
1788807746951	2026-09-07T19:02:26.951Z	[  401.372122] CPU: 79 UID: 0 PID: 0 Comm: swapper/79 Tainted: P           OEL      7.0.13+deb13-amd64 #1 PREEMPT(lazy)  Debian 7.0.13-1~bpo13+1
1788807746931	2026-09-07T19:02:26.931Z	[  401.372077]  nvme_tcp br_netfilter bridge stp llc overlay nvme_fabrics drm efi_pstore configfs nfnetlink efivarfs ip_tables x_tables autofs4 isofs virtio_net net_failover failover nls_ascii nls_cp437 vfat fat sr_mod cdrom sd_mod zfs(POE) spl(OE) drbd(OE) lru_cache uas hid_generic usbhid cdc_ether usbnet hid usb_storage mii xhci_pci sp5100_tco xhci_hcd ahci nvme watchdog libahci libata nvme_core igb bnxt_en usbcore scsi_mod nvme_keyring i2c_algo_bit nvme_auth i2c_piix4 hkdf dca usb_common i2c_smbus scsi_common wmi aesni_intel
1788807746782	2026-09-07T19:02:26.782Z	[  401.3
72007] watchdog: CPU79: Watchdog detected hard LOCKUP on cpu 79
1788807746782	2026-09-07T19:02:26.782Z	[  401.284135]  </TASK>
1788807746782	2026-09-07T19:02:26.782Z	[  401.284129]  common_startup_64+0x13e/0x141
1788807746782	2026-09-07T19:02:26.782Z	[  401.284125]  start_secondary+0x128/0x170
1788807746782	2026-09-07T19:02:26.782Z	[  401.284122]  cpu_startup_entry+0x29/0x30
1788807746771	2026-09-07T19:02:26.771Z	[  401.284118]  do_idle+0x16c/0x2a0
1788807746771	2026-09-07T19:02:26.771Z	[  401.284115]  schedule_idle+0x23/0x40
1788807746771	2026-09-07T19:02:26.771Z	[  401.284110]  __schedule+0x4ec/0xfe0
1788807746771	2026-09-07T19:02:26.771Z	[  401.284106]  finish_task_switch.isra.0+0x238/0x2c0
1788807746771	2026-09-07T19:02:26.771Z	[  401.284101]  cgroup_task_dead+0x29/0x140
1788807746762	2026-09-07T19:02:26.762Z	[  401.284097]  _raw_spin_lock_irqsave+0x3d/0x50
1788807746762	2026-09-07T19:02:26.762Z	[  401.284091]  <TASK>
1788807746762	2026-09-07T19:02:26.762Z	[  401.284088
] Call Trace:
1788807746762	2026-09-07T19:02:26.762Z	[  401.284087] PKRU: 55555554
1788807746762	2026-09-07T19:02:26.762Z	[  401.284086] CR2: 00007f7929664000 CR3: 00000010cc12c03f CR4: 0000000000f71ef0
1788807746762	2026-09-07T19:02:26.762Z	[  401.284085] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
1788807746752	2026-09-07T19:02:26.752Z	[  401.284083] FS:  0000000000000000(0000) GS:ff35266ea4123000(0000) knlGS:0000000000000000
1788807746752	2026-09-07T19:02:26.752Z	[  401.284082] R13: 0000000001e40000 R14: 00000000000000b8 R15: 0000000000000000
1788807746752	2026-09-07T19:02:26.752Z	[  401.284080] R10: 0000000000000000 R11: ff35266e4c41d180 R12: ff35266e4d433400
1788807746742	2026-09-07T19:02:26.742Z	[  401.284079] RBP: ff35266e4c433400 R08: 00000056bb9d3166 R09: 0000000000000001
1788807746742	2026-09-07T19:02:26.742Z	[  401.284078] RDX: 00000000000000b9 RSI: 0000000002e40101 RDI: ffffffffa83b3ee4
1788807746742	2026-09-07T19:02:26.742Z	[  401.284076] RAX: 00000000000000
00 RBX: ffffffffa83b3ee4 RCX: 0000000000000000
1788807746642	2026-09-07T19:02:26.642Z	[  401.284074] RSP: 0018:ff500c2fc07bfd90 EFLAGS: 00000046
1788807746631	2026-09-07T19:02:26.631Z	[  401.284072] Code: 63 f6 4c 8d a0 00 04 31 a8 49 81 fe 00 20 00 00 73 45 4e 03 24 f5 e0 60 ed a6 49 89 2c 24 8b 45 08 85 c0 75 09 f3 90 8b 45 08 <85> c0 74 f7 48 8b 55 00 48 85 d2 0f 84 6b ff ff ff 0f 0d 0a e9 63
1788807746631	2026-09-07T19:02:26.631Z	[  401.284066] RIP: 0010:native_queued_spin_lock_slowpath+0x2aa/0x2f0
1788807746621	2026-09-07T19:02:26.621Z	[  401.284065] Hardware name: ASUSTeK COMPUTER INC. RS500A-E12-RS12U/K14PA-U24 Series, BIOS 1201 08/25/2023
1788807746621	2026-09-07T19:02:26.621Z	[  401.284063] Tainted: [P]=PROPRIETARY_MODULE, [O]=OOT_MODULE, [E]=UNSIGNED_MODULE, [L]=SOFTLOCKUP
1788807746611	2026-09-07T19:02:26.611Z	[  401.284059] CPU: 120 UID: 0 PID: 0 Comm: swapper/120 Tainted: P           OEL      7.0.13+deb13-amd64 #1 PREEMPT(lazy)  Debian 7.0.13-1~bpo13+1
1788807746591
	2026-09-07T19:02:26.591Z	[  401.284013]  nvme_tcp br_netfilter bridge stp llc overlay nvme_fabrics drm efi_pstore configfs nfnetlink efivarfs ip_tables x_tables autofs4 isofs virtio_net net_failover failover nls_ascii nls_cp437 vfat fat sr_mod cdrom sd_mod zfs(POE) spl(OE) drbd(OE) lru_cache uas hid_generic usbhid cdc_ether usbnet hid usb_storage mii xhci_pci sp5100_tco xhci_hcd ahci nvme watchdog libahci libata nvme_core igb bnxt_en usbcore scsi_mod nvme_keyring i2c_algo_bit nvme_auth i2c_piix4 hkdf dca usb_common i2c_smbus scsi_common wmi aesni_intel
1788807746462	2026-09-07T19:02:26.462Z	[  401.283943] watchdog: CPU120: Watchdog detected hard LOCKUP on cpu 120
1788807746462	2026-09-07T19:02:26.462Z	[  401.275996]  </TASK>
1788807746452	2026-09-07T19:02:26.452Z	[  401.275990] R13: 000000c000681808 R14: 000000c000a021c0 R15: 00ffffffffffffff
1788807746452	2026-09-07T19:02:26.452Z	[  401.275989] R10: 0000000000000000 R11: 0000000000000206 R12: 00000000004761c0
1788807746452	2026-
09-07T19:02:26.452Z	[  401.275988] RBP: 000000c000a13d78 R08: 000000c000681898 R09: 000000c000478c40
1788807746442	2026-09-07T19:02:26.442Z	[  401.275987] RDX: 0000000000000000 RSI: 000000c0006d6000 RDI: 00000000000d0f00
1788807746442	2026-09-07T19:02:26.442Z	[  401.275986] RAX: ffffffffffffffda RBX: 0000000000000005 RCX: 0000000000479f92
1788807746442	2026-09-07T19:02:26.442Z	[  401.275984] RSP: 002b:000000c000a13d40 EFLAGS: 00000206 ORIG_RAX: 0000000000000038
1788807746432	2026-09-07T19:02:26.432Z	[  401.275983] Code: 4c 8b 64 24 28 49 83 fd 00 74 18 49 83 f9 00 74 12 4d 8d 85 88 00 00 00 49 83 c0 08 48 81 cf 00 00 08 00 b8 38 00 00 00 0f 05 <48> 83 f8 00 74 05 89 44 24 30 c3 48 89 f4 49 83 fd 00 74 26 49 83
1788807746432	2026-09-07T19:02:26.432Z	[  401.275970] RIP: 0033:0x479f92
1788807746422	2026-09-07T19:02:26.422Z	[  401.275968]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
1788807746422	2026-09-07T19:02:26.422Z	[  401.275966]  ? srso_alias_return_thunk+0x5/0xfbef5
1788807746
422	2026-09-07T19:02:26.422Z	[  401.275964]  ? irqentry_exit+0x85/0x6a0
1788807746422	2026-09-07T19:02:26.422Z	[  401.275962]  ? srso_alias_return_thunk+0x5/0xfbef5
1788807746412	2026-09-07T19:02:26.412Z	[  401.275958]  ? do_user_addr_fault+0x2c3/0x7f0
1788807746412	2026-09-07T19:02:26.412Z	[  401.275956]  ? srso_alias_return_thunk+0x5/0xfbef5
1788807746412	2026-09-07T19:02:26.412Z	[  401.275953]  ? do_syscall_64+0x10a/0x15f0
1788807746412	2026-09-07T19:02:26.412Z	[  401.275951]  ? srso_alias_return_thunk+0x5/0xfbef5
1788807746412	2026-09-07T19:02:26.412Z	[  401.275949]  ? trace_syscall_exit+0x62/0x90
1788807746402	2026-09-07T19:02:26.402Z	[  401.275947]  ? srso_alias_return_thunk+0x5/0xfbef5
1788807746402	2026-09-07T19:02:26.402Z	[  401.275946]  ? srso_alias_return_thunk+0x5/0xfbef5
1788807746402	2026-09-07T19:02:26.402Z	[  401.275942]  ? bpf_trace_run2+0xdf/0x1e0
1788807746402	2026-09-07T19:02:26.402Z	[  401.275940]  ? srso_alias_return_thunk+0x5/0xfbef5
1788807746402	2026
-09-07T19:02:26.402Z	[  401.275938]  ? srso_alias_return_thunk+0x5/0xfbef5
1788807746302	2026-09-07T19:02:26.302Z	[  401.275936]  ? bpf_prog_05cbe5ca7b74dd09_sys_enter+0x40/0xa6
1788807746302	2026-09-07T19:02:26.302Z	[  401.275933]  ? srso_alias_return_thunk+0x5/0xfbef5
1788807746291	2026-09-07T19:02:26.291Z	[  401.275929]  ? lookup_nulls_elem_raw+0x4d/0x90
1788807746291	2026-09-07T19:02:26.291Z	[  401.275928]  ? srso_alias_return_thunk+0x5/0xfbef5
1788807746291	2026-09-07T19:02:26.291Z	[  401.275926]  ? __handle_mm_fault+0xb27/0xf70
1788807746291	2026-09-07T19:02:26.291Z	[  401.275924]  ? srso_alias_return_thunk+0x5/0xfbef5
1788807746291	2026-09-07T19:02:26.291Z	[  401.275921]  ? __pte_offset_map+0x1b/0x100
1788807746282	2026-09-07T19:02:26.282Z	[  401.275919]  ? srso_alias_return_thunk+0x5/0xfbef5
1788807746282	2026-09-07T19:02:26.282Z	[  401.275917]  ? do_anonymous_page+0xfc/0x950
1788807746282	2026-09-07T19:02:26.282Z	[  401.275915]  ? srso_alias_return_thunk+0x5/0xfbef5

1788807746282	2026-09-07T19:02:26.282Z	[  401.275912]  ? set_ptes.isra.0+0x36/0x80
1788807746282	2026-09-07T19:02:26.282Z	[  401.275911]  ? srso_alias_return_thunk+0x5/0xfbef5
1788807746272	2026-09-07T19:02:26.272Z	[  401.275908]  ? srso_alias_return_thunk+0x5/0xfbef5
1788807746272	2026-09-07T19:02:26.272Z	[  401.275906]  ? lruvec_stat_mod_folio+0x83/0xd0
1788807746272	2026-09-07T19:02:26.272Z	[  401.275903]  ? srso_alias_return_thunk+0x5/0xfbef5
1788807746272	2026-09-07T19:02:26.272Z	[  401.275900]  do_syscall_64+0xcd/0x15f0
1788807746272	2026-09-07T19:02:26.272Z	[  401.275895]  __do_sys_clone+0x65/0x90
1788807746262	2026-09-07T19:02:26.262Z	[  401.275891]  kernel_clone+0xbc/0x490
1788807746262	2026-09-07T19:02:26.262Z	[  401.275886]  copy_process+0x146f/0x1d00
1788807746262	2026-09-07T19:02:26.262Z	[  401.275881]  cgroup_can_fork+0x72/0x5c0
1788807746262	2026-09-07T19:02:26.262Z	[  401.275879]  _raw_spin_lock_irq+0x2f/0x40
1788807746262	2026-09-07T19:02:26.262Z	[  401.275
876]  <TASK>
1788807746262	2026-09-07T19:02:26.262Z	[  401.275875] Call Trace:
1788807746262	2026-09-07T19:02:26.262Z	[  401.275874] PKRU: 55555554
1788807746252	2026-09-07T19:02:26.252Z	[  401.275872] CR2: 00007ff5fc6e0000 CR3: 0000000290bb8005 CR4: 0000000000f71ef0
1788807746252	2026-09-07T19:02:26.252Z	[  401.275871] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
1788807746252	2026-09-07T19:02:26.252Z	[  401.275870] FS:  000000c000a00098(0000) GS:ff35266ea4ea3000(0000) knlGS:0000000000000000
1788807746242	2026-09-07T19:02:26.242Z	[  401.275869] R13: 0000000002bc0000 R14: 0000000000000024 R15: ff3525b22e818000
1788807746242	2026-09-07T19:02:26.242Z	[  401.275868] R10: 0000000000000000 R11: 0000000000000000 R12: ff35266e4af33400
1788807746242	2026-09-07T19:02:26.242Z	[  401.275867] RBP: ff35266e4d1b3400 R08: 000000000000361b R09: 0000000000000000
1788807746232	2026-09-07T19:02:26.232Z	[  401.275866] RDX: 0000000000000025 RSI: 0000000000940101 RDI: ffffffffa83b3ee4
1788807
746232	2026-09-07T19:02:26.232Z	[  401.275864] RAX: 0000000000000000 RBX: ffffffffa83b3ee4 RCX: 00000000000033af
1788807746232	2026-09-07T19:02:26.232Z	[  401.275863] RSP: 0018:ff500c304774ba78 EFLAGS: 00000046
1788807746122	2026-09-07T19:02:26.122Z	[  401.275861] Code: 63 f6 4c 8d a0 00 04 31 a8 49 81 fe 00 20 00 00 73 45 4e 03 24 f5 e0 60 ed a6 49 89 2c 24 8b 45 08 85 c0 75 09 f3 90 8b 45 08 <85> c0 74 f7 48 8b 55 00 48 85 d2 0f 84 6b ff ff ff 0f 0d 0a e9 63
1788807746111	2026-09-07T19:02:26.111Z	[  401.275857] RIP: 0010:native_queued_spin_lock_slowpath+0x2aa/0x2f0
1788807746111	2026-09-07T19:02:26.111Z	[  401.275856] Hardware name: ASUSTeK COMPUTER INC. RS500A-E12-RS12U/K14PA-U24 Series, BIOS 1201 08/25/2023
1788807746111	2026-09-07T19:02:26.111Z	[  401.275855] Tainted: [P]=PROPRIETARY_MODULE, [O]=OOT_MODULE, [E]=UNSIGNED_MODULE, [L]=SOFTLOCKUP
1788807746102	2026-09-07T19:02:26.102Z	[  401.275851] CPU: 174 UID: 0 PID: 14414 Comm: node-driver-reg Tainted: P           OEL      7
.0.13+deb13-amd64 #1 PREEMPT(lazy)  Debian 7.0.13-1~bpo13+1
1788807746081	2026-09-07T19:02:26.081Z	[  401.275812]  nvme_tcp br_netfilter bridge stp llc overlay nvme_fabrics drm efi_pstore configfs nfnetlink efivarfs ip_tables x_tables autofs4 isofs virtio_net net_failover failover nls_ascii nls_cp437 vfat fat sr_mod cdrom sd_mod zfs(POE) spl(OE) drbd(OE) lru_cache uas hid_generic usbhid cdc_ether usbnet hid usb_storage mii xhci_pci sp5100_tco xhci_hcd ahci nvme watchdog libahci libata nvme_core igb bnxt_en usbcore scsi_mod nvme_keyring i2c_algo_bit nvme_auth i2c_piix4 hkdf dca usb_common i2c_smbus scsi_common wmi aesni_intel
1788807745942	2026-09-07T19:02:25.942Z	[  401.275754] watchdog: CPU174: Watchdog detected hard LOCKUP on cpu 174
1788807745942	2026-09-07T19:02:25.942Z	[  401.255503]  </TASK>
1788807745931	2026-09-07T19:02:25.931Z	[  401.255497] R13: 000000c000631808 R14: 000000c0002821c0 R15: 007fffffffffffff
1788807745931	2026-09-07T19:02:25.931Z	[  401.255496] R10: 0000000
000000000 R11: 0000000000000206 R12: 000000000046f680
1788807745931	2026-09-07T19:02:25.931Z	[  401.255495] RBP: 000000c000293d78 R08: 000000c000631898 R09: 000000c000632e00
1788807745922	2026-09-07T19:02:25.922Z	[  401.255494] RDX: 0000000000000000 RSI: 000000c000542000 RDI: 00000000000d0f00
1788807745922	2026-09-07T19:02:25.922Z	[  401.255493] RAX: ffffffffffffffda RBX: 0000000000000005 RCX: 0000000000473412
1788807745922	2026-09-07T19:02:25.922Z	[  401.255491] RSP: 002b:000000c000293d40 EFLAGS: 00000206 ORIG_RAX: 0000000000000038
1788807745912	2026-09-07T19:02:25.912Z	[  401.255490] Code: 4c 8b 64 24 28 49 83 fd 00 74 18 49 83 f9 00 74 12 4d 8d 85 88 00 00 00 49 83 c0 08 48 81 cf 00 00 08 00 b8 38 00 00 00 0f 05 <48> 83 f8 00 74 05 89 44 24 30 c3 48 89 f4 49 83 fd 00 74 26 49 83
1788807745912	2026-09-07T19:02:25.912Z	[  401.255464] RIP: 0033:0x473412
1788807745912	2026-09-07T19:02:25.912Z	[  401.255461]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
1788807745901	2026-09-07T19:02
:25.901Z	[  401.255459]  ? srso_alias_return_thunk+0x5/0xfbef5
1788807745901	2026-09-07T19:02:25.901Z	[  401.255457]  ? irqentry_exit+0x85/0x6a0
1788807745901	2026-09-07T19:02:25.901Z	[  401.255455]  ? srso_alias_return_thunk+0x5/0xfbef5
1788807745901	2026-09-07T19:02:25.901Z	[  401.255451]  ? do_user_addr_fault+0x2c3/0x7f0
1788807745901	2026-09-07T19:02:25.901Z	[  401.255448]  ? srso_alias_return_thunk+0x5/0xfbef5
1788807745891	2026-09-07T19:02:25.891Z	[  401.255444]  do_syscall_64+0xcd/0x15f0
1788807745891	2026-09-07T19:02:25.891Z	[  401.255439]  __do_sys_clone+0x65/0x90
1788807745891	2026-09-07T19:02:25.891Z	[  401.255435]  kernel_clone+0xbc/0x490
1788807745891	2026-09-07T19:02:25.891Z	[  401.255429]  copy_process+0x146f/0x1d00
1788807745891	2026-09-07T19:02:25.891Z	[  401.255424]  cgroup_can_fork+0x72/0x5c0
1788807745882	2026-09-07T19:02:25.882Z	[  401.255422]  _raw_spin_lock_irq+0x2f/0x40
1788807745882	2026-09-07T19:02:25.882Z	[  401.255417]  <TASK>
1788807745882	2026-
09-07T19:02:25.882Z	[  401.255415] Call Trace:
1788807745882	2026-09-07T19:02:25.882Z	[  401.255414] PKRU: 55555554
1788807745882	2026-09-07T19:02:25.882Z	[  401.255413] CR2: 00007f49aca028a8 CR3: 000000036f843003 CR4: 0000000000f71ef0
1788807745882	2026-09-07T19:02:25.882Z	[  401.255411] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
1788807745783	2026-09-07T19:02:25.783Z	[  401.255410] FS:  000000c000280098(0000) GS:ff35266ea4d23000(0000) knlGS:0000000000000000
1788807745783	2026-09-07T19:02:25.783Z	[  401.255409] R13: 0000000002a40000 R14: 00000000000000b5 R15: ff3525b5084a2180
1788807745772	2026-09-07T19:02:25.772Z	[  401.255408] R10: 0000000000000000 R11: 0000000000000000 R12: ff35266e4d373400
1788807745772	2026-09-07T19:02:25.772Z	[  401.255407] RBP: ff35266e4d033400 R08: 00000000000035cf R09: 0000000000000000
1788807745772	2026-09-07T19:02:25.772Z	[  401.255406] RDX: 00000000000000b6 RSI: 0000000002d80101 RDI: ffffffffa83b3ee4
1788807745762	2026-09-07T19:02:25.762Z	[
  401.255404] RAX: 0000000000000000 RBX: ffffffffa83b3ee4 RCX: 00000000000033ae
1788807745762	2026-09-07T19:02:25.762Z	[  401.255403] RSP: 0018:ff500c30680bfc68 EFLAGS: 00000046
1788807745751	2026-09-07T19:02:25.751Z	[  401.255401] Code: 63 f6 4c 8d a0 00 04 31 a8 49 81 fe 00 20 00 00 73 45 4e 03 24 f5 e0 60 ed a6 49 89 2c 24 8b 45 08 85 c0 75 09 f3 90 8b 45 08 <85> c0 74 f7 48 8b 55 00 48 85 d2 0f 84 6b ff ff ff 0f 0d 0a e9 63
1788807745751	2026-09-07T19:02:25.751Z	[  401.255396] RIP: 0010:native_queued_spin_lock_slowpath+0x2aa/0x2f0
1788807745742	2026-09-07T19:02:25.742Z	[  401.255394] Hardware name: ASUSTeK COMPUTER INC. RS500A-E12-RS12U/K14PA-U24 Series, BIOS 1201 08/25/2023
1788807745742	2026-09-07T19:02:25.742Z	[  401.255393] Tainted: [P]=PROPRIETARY_MODULE, [O]=OOT_MODULE, [E]=UNSIGNED_MODULE, [L]=SOFTLOCKUP
1788807745732	2026-09-07T19:02:25.732Z	[  401.255389] CPU: 168 UID: 0 PID: 13815 Comm: csi-driver Tainted: P           OEL      7.0.13+deb13-amd64 #1 PREEMPT(lazy)  De
bian 7.0.13-1~bpo13+1
1788807745711	2026-09-07T19:02:25.711Z	[  401.255345]  nvme_tcp br_netfilter bridge stp llc overlay nvme_fabrics drm efi_pstore configfs nfnetlink efivarfs ip_tables x_tables autofs4 isofs virtio_net net_failover failover nls_ascii nls_cp437 vfat fat sr_mod cdrom sd_mod zfs(POE) spl(OE) drbd(OE) lru_cache uas hid_generic usbhid cdc_ether usbnet hid usb_storage mii xhci_pci sp5100_tco xhci_hcd ahci nvme watchdog libahci libata nvme_core igb bnxt_en usbcore scsi_mod nvme_keyring i2c_algo_bit nvme_auth i2c_piix4 hkdf dca usb_common i2c_smbus scsi_common wmi aesni_intel
1788807745582	2026-09-07T19:02:25.582Z	[  401.255275] watchdog: CPU168: Watchdog detected hard LOCKUP on cpu 168
1788807745582	2026-09-07T19:02:25.582Z	[  401.163279]  </TASK>
1788807745571	2026-09-07T19:02:25.571Z	[  401.163275] R13: 0000000000000000 R14: 000000c00b8161c0 R15: 0003ffffffffffff
1788807745571	2026-09-07T19:02:25.571Z	[  401.163274] R10: 0000000000000000 R11: 0000000000000212 R12: 0
00000c00a989b60
1788807745571	2026-09-07T19:02:25.571Z	[  401.163273] RBP: 000000c00a989a30 R08: 0000000000000000 R09: 0000000000000000
1788807745561	2026-09-07T19:02:25.561Z	[  401.163272] RDX: 0000000000000200 RSI: 000000c00a929a00 RDI: 0000000000000021
1788807745561	2026-09-07T19:02:25.561Z	[  401.163271] RAX: ffffffffffffffda RBX: 0000000000000021 RCX: 00000000004085ae
1788807745561	2026-09-07T19:02:25.561Z	[  401.163269] RSP: 002b:000000c00a9899f0 EFLAGS: 00000212 ORIG_RAX: 0000000000000000
1788807745552	2026-09-07T19:02:25.552Z	[  401.163268] Code: 48 83 ec 38 e8 13 00 00 00 48 83 c4 38 5d c3 cc cc cc cc cc cc cc cc cc cc cc cc cc 49 89 f2 48 89 fa 48 89 ce 48 89 df 0f 05 <48> 3d 01 f0 ff ff 76 15 48 f7 d8 48 89 c1 48 c7 c0 ff ff ff ff 48
1788807745552	2026-09-07T19:02:25.552Z	[  401.163251] RIP: 0033:0x4085ae
1788807745541	2026-09-07T19:02:25.541Z	[  401.163249]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
1788807745541	2026-09-07T19:02:25.541Z	[  401.163246]  ? do_syscall_
64+0x10a/0x15f0
1788807745541	2026-09-07T19:02:25.541Z	[  401.163244]  ? srso_alias_return_thunk+0x5/0xfbef5
1788807745541	2026-09-07T19:02:25.541Z	[  401.163242]  ? trace_syscall_exit+0x62/0x90
1788807745431	2026-09-07T19:02:25.431Z	[  401.163241]  ? srso_alias_return_thunk+0x5/0xfbef5
1788807745431	2026-09-07T19:02:25.431Z	[  401.163239]  ? srso_alias_return_thunk+0x5/0xfbef5
1788807745431	2026-09-07T19:02:25.431Z	[  401.163236]  ? bpf_trace_run2+0xdf/0x1e0
1788807745422	2026-09-07T19:02:25.422Z	[  401.163234]  ? srso_alias_return_thunk+0x5/0xfbef5
1788807745422	2026-09-07T19:02:25.422Z	[  401.163231]  ? vfs_readlink+0x139/0x150
1788807745422	2026-09-07T19:02:25.422Z	[  401.163229]  ? srso_alias_return_thunk+0x5/0xfbef5
1788807745422	2026-09-07T19:02:25.422Z	[  401.163227]  ? do_syscall_64+0x10a/0x15f0
1788807745422	2026-09-07T19:02:25.422Z	[  401.163225]  ? srso_alias_return_thunk+0x5/0xfbef5
1788807745411	2026-09-07T19:02:25.411Z	[  401.163223]  ? trace_syscall_exit+0x62
/0x90
1788807745411	2026-09-07T19:02:25.411Z	[  401.163221]  ? srso_alias_return_thunk+0x5/0xfbef5
1788807745411	2026-09-07T19:02:25.411Z	[  401.163220]  ? srso_alias_return_thunk+0x5/0xfbef5
1788807745411	2026-09-07T19:02:25.411Z	[  401.163215]  ? bpf_trace_run2+0xdf/0x1e0
1788807745411	2026-09-07T19:02:25.411Z	[  401.163213]  ? do_syscall_64+0x10a/0x15f0
1788807745402	2026-09-07T19:02:25.402Z	[  401.163211]  ? srso_alias_return_thunk+0x5/0xfbef5
1788807745402	2026-09-07T19:02:25.402Z	[  401.163209]  ? trace_syscall_exit+0x62/0x90
1788807745402	2026-09-07T19:02:25.402Z	[  401.163207]  ? srso_alias_return_thunk+0x5/0xfbef5
1788807745402	2026-09-07T19:02:25.402Z	[  401.163205]  ? srso_alias_return_thunk+0x5/0xfbef5
1788807745402	2026-09-07T19:02:25.402Z	[  401.163201]  ? bpf_trace_run2+0xdf/0x1e0
1788807745391	2026-09-07T19:02:25.391Z	[  401.163200]  ? srso_alias_return_thunk+0x5/0xfbef5
1788807745391	2026-09-07T19:02:25.391Z	[  401.163194]  do_syscall_64+0xcd/0x15f0
1788807
745391	2026-09-07T19:02:25.391Z	[  401.163191]  ksys_read+0x6b/0xe0
1788807745391	2026-09-07T19:02:25.391Z	[  401.163186]  vfs_read+0x25d/0x370
1788807745391	2026-09-07T19:02:25.391Z	[  401.163183]  ? rw_verify_area+0x54/0x180
1788807745382	2026-09-07T19:02:25.382Z	[  401.163180]  ? srso_alias_return_thunk+0x5/0xfbef5
1788807745382	2026-09-07T19:02:25.382Z	[  401.163177]  seq_read_iter+0x100/0x480
1788807745382	2026-09-07T19:02:25.382Z	[  401.163174]  kernfs_seq_start+0x56/0xb0
1788807745382	2026-09-07T19:02:25.382Z	[  401.163171]  __cgroup_procs_start+0x7b/0xf0
1788807745382	2026-09-07T19:02:25.382Z	[  401.163167]  css_task_iter_start+0x50/0xd0
1788807745382	2026-09-07T19:02:25.382Z	[  401.163163]  _raw_spin_lock_irqsave+0x3d/0x50
1788807745372	2026-09-07T19:02:25.372Z	[  401.163160]  <TASK>
1788807745372	2026-09-07T19:02:25.372Z	[  401.163158] Call Trace:
1788807745372	2026-09-07T19:02:25.372Z	[  401.163157] PKRU: 55555554
1788807745372	2026-09-07T19:02:25.372Z	[  401.163
156] CR2: 00007ff293eaeaf8 CR3: 00000002a8080041 CR4: 0000000000f71ef0
1788807745372	2026-09-07T19:02:25.372Z	[  401.163155] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
1788807745361	2026-09-07T19:02:25.361Z	[  401.163154] FS:  00007f7e6f7fe6c0(0000) GS:ff35266ea5023000(0000) knlGS:0000000000000000
1788807745361	2026-09-07T19:02:25.361Z	[  401.163152] R13: 0000000002d40000 R14: 000000000000000d R15: ff3525b4aada9000
1788807745361	2026-09-07T19:02:25.361Z	[  401.163151] R10: 0000000000000000 R11: 0000000000000000 R12: ff35266e4a973400
1788807745261	2026-09-07T19:02:25.261Z	[  401.163150] RBP: ff35266e4d333400 R08: ff3525b4cc3f9240 R09: 000000000000000b
1788807745261	2026-09-07T19:02:25.261Z	[  401.163149] RDX: 000000000000000e RSI: 0000000000380101 RDI: ffffffffa83b3ee4
1788807745251	2026-09-07T19:02:25.251Z	[  401.163148] RAX: 0000000000000000 RBX: ffffffffa83b3ee4 RCX: 0000000000000000
1788807745251	2026-09-07T19:02:25.251Z	[  401.163146] RSP: 0018:ff500c309bc77b08 EFLAG
S: 00000046
1788807745241	2026-09-07T19:02:25.241Z	[  401.163144] Code: 63 f6 4c 8d a0 00 04 31 a8 49 81 fe 00 20 00 00 73 45 4e 03 24 f5 e0 60 ed a6 49 89 2c 24 8b 45 08 85 c0 75 09 f3 90 8b 45 08 <85> c0 74 f7 48 8b 55 00 48 85 d2 0f 84 6b ff ff ff 0f 0d 0a e9 63
1788807745241	2026-09-07T19:02:25.241Z	[  401.163140] RIP: 0010:native_queued_spin_lock_slowpath+0x2aa/0x2f0
1788807745231	2026-09-07T19:02:25.231Z	[  401.163139] Hardware name: ASUSTeK COMPUTER INC. RS500A-E12-RS12U/K14PA-U24 Series, BIOS 1201 08/25/2023
1788807745231	2026-09-07T19:02:25.231Z	[  401.163138] Tainted: [P]=PROPRIETARY_MODULE, [O]=OOT_MODULE, [E]=UNSIGNED_MODULE, [L]=SOFTLOCKUP
1788807745222	2026-09-07T19:02:25.222Z	[  401.163134] CPU: 180 UID: 0 PID: 74396 Comm: kubelet Tainted: P           OEL      7.0.13+deb13-amd64 #1 PREEMPT(lazy)  Debian 7.0.13-1~bpo13+1
1788807745201	2026-09-07T19:02:25.201Z	[  401.163093]  nvme_tcp br_netfilter bridge stp llc overlay nvme_fabrics drm efi_pstore configfs nfnetlink 
efivarfs ip_tables x_tables autofs4 isofs virtio_net net_failover failover nls_ascii nls_cp437 vfat fat sr_mod cdrom sd_mod zfs(POE) spl(OE) drbd(OE) lru_cache uas hid_generic usbhid cdc_ether usbnet hid usb_storage mii xhci_pci sp5100_tco xhci_hcd ahci nvme watchdog libahci libata nvme_core igb bnxt_en usbcore scsi_mod nvme_keyring i2c_algo_bit nvme_auth i2c_piix4 hkdf dca usb_common i2c_smbus scsi_common wmi aesni_intel
1788807745071	2026-09-07T19:02:25.071Z	[  401.163028] watchdog: CPU180: Watchdog detected hard LOCKUP on cpu 180
1788807745071	2026-09-07T19:02:25.071Z	[  401.114853]  </TASK>
1788807745061	2026-09-07T19:02:25.061Z	[  401.114847] R13: 00007fc1037fda0f R14: 00007fc1037fdc00 R15: 00007fc0dcff8fc0
1788807745061	2026-09-07T19:02:25.061Z	[  401.114846] R10: 00007fc0dcff99d0 R11: 0000000000000202 R12: 00007fc1037fda0e
1788807745061	2026-09-07T19:02:25.061Z	[  401.114845] RBP: 00007fc1037fdc00 R08: 00007fc0dcff9700 R09: 00007fc0dcff9700
1788807745051	2026-09-07T19:02:2
5.051Z	[  401.114844] RDX: 00007fc0dcff99d0 RSI: 00007fc0dcff8fb0 RDI: 00000000003d0f00
1788807745051	2026-09-07T19:02:25.051Z	[  401.114843] RAX: ffffffffffffffda RBX: 00007fc0dcff9700 RCX: 00007fc162c3e8c5
1788807745051	2026-09-07T19:02:25.051Z	[  401.114841] RSP: 002b:00007fc1037fd968 EFLAGS: 00000202 ORIG_RAX: 0000000000000038
1788807745041	2026-09-07T19:02:25.041Z	[  401.114839] Code: 48 85 ff 74 3d 48 85 f6 74 38 48 83 ee 10 48 89 4e 08 48 89 3e 48 89 d7 4c 89 c2 4d 89 c8 4c 8b 54 24 08 b8 38 00 00 00 0f 05 <48> 85 c0 7c 13 74 01 c3 31 ed 58 5f ff d0 48 89 c7 b8 3c 00 00 00
1788807745031	2026-09-07T19:02:25.031Z	[  401.114808] RIP: 0033:0x7fc162c3e8c5
1788807745031	2026-09-07T19:02:25.031Z	[  401.114806]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
1788807745031	2026-09-07T19:02:25.031Z	[  401.114803]  ? srso_alias_return_thunk+0x5/0xfbef5
1788807745031	2026-09-07T19:02:25.031Z	[  401.114801]  ? irqentry_exit+0x85/0x6a0
1788807745031	2026-09-07T19:02:25.031Z	[  401.114799]  
? srso_alias_return_thunk+0x5/0xfbef5
1788807745022	2026-09-07T19:02:25.022Z	[  401.114795]  ? do_user_addr_fault+0x2c3/0x7f0
1788807745022	2026-09-07T19:02:25.022Z	[  401.114793]  ? srso_alias_return_thunk+0x5/0xfbef5
1788807745022	2026-09-07T19:02:25.022Z	[  401.114789]  ? handle_mm_fault+0x212/0x320
1788807745022	2026-09-07T19:02:25.022Z	[  401.114786]  ? srso_alias_return_thunk+0x5/0xfbef5
1788807745022	2026-09-07T19:02:25.022Z	[  401.114783]  do_syscall_64+0xcd/0x15f0
1788807744922	2026-09-07T19:02:24.922Z	[  401.114778]  __do_sys_clone+0x65/0x90
1788807744922	2026-09-07T19:02:24.922Z	[  401.114773]  kernel_clone+0xbc/0x490
1788807744922	2026-09-07T19:02:24.922Z	[  401.114767]  copy_process+0x146f/0x1d00
1788807744922	2026-09-07T19:02:24.922Z	[  401.114762]  cgroup_can_fork+0x72/0x5c0
1788807744911	2026-09-07T19:02:24.911Z	[  401.114759]  _raw_spin_lock_irq+0x2f/0x40
1788807744911	2026-09-07T19:02:24.911Z	[  401.114753]  <TASK>
1788807744911	2026-09-07T19:02:24.911Z	[ 
 401.114751] Call Trace:
1788807744911	2026-09-07T19:02:24.911Z	[  401.114750] PKRU: 55555554
1788807744911	2026-09-07T19:02:24.911Z	[  401.114748] CR2: 00007fc0dcff8fb8 CR3: 00000001fc42c001 CR4: 0000000000f71ef0
1788807744901	2026-09-07T19:02:24.901Z	[  401.114747] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
1788807744901	2026-09-07T19:02:24.901Z	[  401.114746] FS:  00007fc1037fe700(0000) GS:ff35266ea5263000(0000) knlGS:0000000000000000
1788807744901	2026-09-07T19:02:24.901Z	[  401.114744] R13: 0000000002f80000 R14: 00000000000000a9 R15: ff3525b263300000
1788807744892	2026-09-07T19:02:24.892Z	[  401.114743] R10: 0000000000000000 R11: 0000000000000000 R12: ff35266e4d073400
1788807744892	2026-09-07T19:02:24.892Z	[  401.114741] RBP: ff35266e4d573400 R08: 0000000000003511 R09: 0000000000000000
1788807744892	2026-09-07T19:02:24.892Z	[  401.114740] RDX: 00000000000000aa RSI: 0000000002a80101 RDI: ffffffffa83b3ee4
1788807744881	2026-09-07T19:02:24.881Z	[  401.114739] RAX: 000
0000000000000 RBX: ffffffffa83b3ee4 RCX: 00000000000033ad
1788807744881	2026-09-07T19:02:24.881Z	[  401.114737] RSP: 0018:ff500c30361f7c18 EFLAGS: 00000046
1788807744871	2026-09-07T19:02:24.871Z	[  401.114735] Code: 63 f6 4c 8d a0 00 04 31 a8 49 81 fe 00 20 00 00 73 45 4e 03 24 f5 e0 60 ed a6 49 89 2c 24 8b 45 08 85 c0 75 09 f3 90 8b 45 08 <85> c0 74 f7 48 8b 55 00 48 85 d2 0f 84 6b ff ff ff 0f 0d 0a e9 63
1788807744871	2026-09-07T19:02:24.871Z	[  401.114729] RIP: 0010:native_queued_spin_lock_slowpath+0x2aa/0x2f0
1788807744871	2026-09-07T19:02:24.871Z	[  401.114727] Hardware name: ASUSTeK COMPUTER INC. RS500A-E12-RS12U/K14PA-U24 Series, BIOS 1201 08/25/2023
1788807744861	2026-09-07T19:02:24.861Z	[  401.114726] Tainted: [P]=PROPRIETARY_MODULE, [O]=OOT_MODULE, [E]=UNSIGNED_MODULE, [L]=SOFTLOCKUP
1788807744861	2026-09-07T19:02:24.861Z	[  401.114721] CPU: 189 UID: 0 PID: 13671 Comm: calico-node Tainted: P           OEL      7.0.13+deb13-amd64 #1 PREEMPT(lazy)  Debian 7.0.13-1~bpo13+1

1788807744852	2026-09-07T19:02:24.852Z	generic usbhid cdc_ether usbnet hid usb_storage mii xhci_pci sp5100_tco xhci_hcd ahci nvme watchdog libahci libata nvme_core igb bnxt_en usbcore scsi_mod nvme_keyring i2c_algo_bit nvme_auth i2c_piix4 hkdf dca usb_common i2c_smbus scsi_common wmi aesni_intel
1788807744732	2026-09-07T19:02:24.732Z	[  401.114676]  nvme_tcp br_netfilter bridge stp llc overlay nvme_fabrics drm efi_pstore configfs nfnetlink efivarfs ip_tables x_tables autofs4 isofs virtio_net net_failover failover nls_ascii nls_cp437 vfat fat sr_mod cdrom sd_mod zfs(POE) spl(OE) drbd(OE) lru_cache uas hid_
------=_cgroup_lockup_20260907
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="publickey - noah@feldt.systems -
 0x9B02BBB4.asc"; name="publickey - noah@feldt.systems - 0x9B02BBB4.asc"
Content-Type: application/pgp-keys; filename="publickey - noah@feldt.systems
 - 0x9B02BBB4.asc"; name="publickey - noah@feldt.systems - 0x9B02BBB4.asc"

LS0tLS1CRUdJTiBQR1AgUFVCTElDIEtFWSBCTE9DSy0tLS0tCkNvbW1lbnQ6IGh0dHBzOi8vZ29w
ZW5wZ3Aub3JnClZlcnNpb246IEdvcGVuUEdQIDIuMTAuMAoKeGpNRVpuV2ZveFlKS3dZQkJBSGFS
dzhCQVFkQWpjOWlieHJoOExkN2E3YjdBM1hXUnZSdGt6V2cwcEZUaUpDTgoza3J1ZnM3TkoyNXZZ
V2hBWm1Wc1pIUXVjM2x6ZEdWdGN5QThibTloYUVCbVpXeGtkQzV6ZVhOMFpXMXpQc0tNCkJCQVdD
Z0ErQllKbWRaK2pCQXNKQndnSmtFQlN1OWFxLzJDcUF4VUlDZ1FXQUFJQkFoa0JBcHNEQWg0QkZp
RUUKbXdLN3RGM0s0QUt5ZXdZWVFGSzcxcXIvWUtvQUFFSjdBUURaRlZLOGpTa3FDSk9oS1NsTVp6
T01Ibk4vQjhyYwpHZzlXei9UdW1lejVwQUQvV2l6V2xGem4xT3NibzBzV0U3L25FLzRMaXRKS2k0
bjlObUVGczRob01BVE9PQVJtCmRaK2pFZ29yQmdFRUFaZFZBUVVCQVFkQTc4U0JLZkc1Ymd6SjQw
bVZxTmNGUnhqc0lTT0ovVW4rZU1TaC83MkQKVUVJREFRZ0h3bmdFR0JZS0FDb0ZnbVoxbjZNSmtF
QlN1OWFxLzJDcUFwc01GaUVFbXdLN3RGM0s0QUt5ZXdZWQpRRks3MXFyL1lLb0FBTWJHQVA0anZ3
YlBacnFSY3dzRk5VdWI3aSthSFVTY2pwQTJIazFUdTBKTG5HWTlMQUVBCjRBOGQrWGNsdEVhUEtp
Vi9sbzh2RFdPaFBBQVBhbTFuQi8wQWhlenh1UTA9Cj1jQkVoCi0tLS0tRU5EIFBHUCBQVUJMSUMg
S0VZIEJMT0NLLS0tLS0=
------=_cgroup_lockup_20260907--

--------d6f859215e7a76ea2c8b0c10696b6ee0365c72ed613f24189a8699040c1255d0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: ProtonMail

wqsEARYIAF0FgmqfECEJEEBSu9aq/2CqNRQAAAAAABwAEHNhbHRAbm90YXRp
b25zLm9wZW5wZ3Bqcy5vcmfSndsuPliyge2mXScajYB/FiEEmwK7tF3K4AKy
ewYYQFK71qr/YKoAACs5AQCQjW/P64PZ9Cz+CuPBaDA/Za5RjWqTqvIDUYhU
FoEskQEA0LOUeEFbCEaiXMEq5Kaf3gjlsaDMWVE6e9F3j6ieegs=
=ioOB
-----END PGP SIGNATURE-----


--------d6f859215e7a76ea2c8b0c10696b6ee0365c72ed613f24189a8699040c1255d0--

