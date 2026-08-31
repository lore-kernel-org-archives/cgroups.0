Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FFC33C661A
	for <cgroups@vger.kernel.org>; Mon, 31 Aug 2026 11:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788174727; cv=none; b=kaldIKNHBIZWzCvnCN8fJe3OOl2BRnsgov7atCrs+bL7ixCAZMASnfcmjC9KL5dZHYQUPlW6FryIsWU8JYa04JMYcOjtnZU+VVH3pqSXm5ekN+K+E3AERtlP9picCByiUaLciIkK8q9YRubKOwceIQLbj793TXNRwEEoYG5mF2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788174727; c=relaxed/simple;
	bh=jx6m7TDAy3n2H1KmnOT50dstkrbrIEfHThU3enjgJ+s=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=AQXtY9101SOej1eHUbeJUV0Mfy/SlI84f5fIsupj67Q2bv0G60E2u3TQKWRnjVDJr+mJatRrzN74wG9i/rB9OqDExJVvla9nne1SgkfS7BTdVV5VN/mJWLBo2VHh7YiLwTf6LQ9SY8muUg5pRE0JmPPVHEinHvxpvdPKnmsXD8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-4b28db6c77aso5087852b6e.3
        for <cgroups@vger.kernel.org>; Mon, 31 Aug 2026 04:12:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788174724; x=1788779524;
        h=content-transfer-encoding:content-type:to:from:subject:message-id
         :in-reply-to:date:mime-version:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6AHpiCqC3lUjekaa7pzFDioIiCAl1doBUmmbvzVJYRo=;
        b=C7HWw2NKJwPCOXptOFkI3lhux1i+4QvzzcyBymw0+ft/3+3Rqr1fbd214shvJkH1gm
         +7N5qTTyImSIBoniiHApMq0vdldivd4K0UaeqSm7F/WmfuWoVemzLBU1TM/mQ5/xsWhu
         ScKjLAVgz00dHiQyFV2H+OsCEm8UeG+5aszxdUC5SqH5axtTMfAb4WGOlCHevDnpE/Wc
         lxvI308Bo4sNITaS+oBdV8r49ManEc5QfzR0QZJPqnYWGBqTDZdE2d83bKYo8f3ge+uW
         Y5Kcyaw5wgzeJ3xXiEamjlI02i3IuReCAgpBHGD67lwo/D0cjVymWoHR2txg/kYcF/+d
         tIlA==
X-Forwarded-Encrypted: i=1; AHgh+Rqhue45dpzu3s7kF1rCYE9u4O/qyJ2CzmVywjRageIeeBa6VH8iZ+vriQojV5wfvPGkI4Z83h8b@vger.kernel.org
X-Gm-Message-State: AFuF++n2ReSbQUZaVjS1ZAWXfeLQevlP6Ga746eiP395qz2meFpJyoai
	hUTYGrlLwawtuDKC/LUJtdgBeB1oJUejnBkOEhTqSKLHS5bX6b2G/ayEavwJ6P99LEbroLK3Wip
	r3kdvKhA0+7UNoRbcSUs4ViTHiNGa/541RkHdUkaT1MDk0w4VBpGikWD/8QI=
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:4f47:b0:4b2:21e2:82c6 with SMTP id
 5614622812f47-4b3982a9a00mr26600352b6e.10.1788174724066; Mon, 31 Aug 2026
 04:12:04 -0700 (PDT)
Date: Mon, 31 Aug 2026 04:12:04 -0700
In-Reply-To: <20260831084131.410457-1-junjie.cao@intel.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a956184.4d659fcc.734b4.004d.GAE@google.com>
Subject: Re: [syzbot] [mm?] INFO: rcu detected stall in exit_to_user_mode_loop
From: syzbot <syzbot+2642f347f7309b4880dc@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, cgroups@vger.kernel.org, davem@davemloft.net, 
	edumazet@google.com, hannes@cmpxchg.org, hdanton@sina.com, horms@kernel.org, 
	jackmanb@google.com, jhs@mojatatu.com, jiri@resnulli.us, junjie.cao@intel.com, 
	kuba@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	mhocko@kernel.org, mhocko@suse.com, muchun.song@linux.dev, 
	netdev@vger.kernel.org, pabeni@redhat.com, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, surenb@google.com, syzkaller-bugs@googlegroups.com, 
	vbabka@suse.cz, vinicius.gomes@intel.com, ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

syzbot tried to test the proposed patch but the build/boot failed:

 2.992004][    T1] Mandatory Access Control activated.
[    2.993509][    T1] pnp: PnP ACPI init
[    3.023863][    T1] pnp: PnP ACPI: found 6 devices
[    3.105394][    T1] clocksource: acpi_pm: mask: 0xffffff max_cycles: 0xf=
fffff, max_idle_ns: 2085701024 ns
[    3.113910][    T1] NET: Registered PF_INET protocol family
[    3.116610][    T1] IP idents hash table entries: 131072 (order: 8, 1048=
576 bytes, vmalloc)
[    3.128889][    T1] tcp_listen_portaddr_hash hash table entries: 4096 (o=
rder: 7, 294912 bytes, vmalloc)
[    3.130899][    T1] Table-perturb hash table entries: 65536 (order: 6, 2=
62144 bytes, vmalloc)
[    3.133075][    T1] TCP established hash table entries: 65536 (order: 7,=
 524288 bytes, vmalloc)
[    3.144444][    T1] TCP bind hash table entries: 65536 (order: 12, 94371=
84 bytes, vmalloc hugepage)
[    3.151706][    T1] TCP: Hash tables configured (established 65536 bind =
65536)
[    3.155107][    T1] MPTCP token hash table entries: 8192 (order: 8, 7208=
96 bytes, vmalloc)
[    3.158207][    T1] UDP hash table entries: 4096 (order: 8, 1048576 byte=
s, vmalloc)
[    3.161213][    T1] NET: Registered PF_UNIX/PF_LOCAL protocol family
[    3.166692][    T1] RPC: Registered named UNIX socket transport module.
[    3.167740][    T1] RPC: Registered udp transport module.
[    3.168610][    T1] RPC: Registered tcp transport module.
[    3.169492][    T1] RPC: Registered tcp-with-tls transport module.
[    3.170446][    T1] RPC: Registered tcp NFSv4.1 backchannel transport mo=
dule.
[    3.187812][    T1] NET: Registered PF_XDP protocol family
[    3.189221][    T1] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7 windo=
w]
[    3.190367][    T1] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff windo=
w]
[    3.191848][    T1] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bff=
ff window]
[    3.193134][    T1] pci_bus 0000:00: resource 7 [mem 0xc0000000-0xfebfef=
ff window]
[    3.195979][    T1] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    3.197272][    T1] PCI: CLS 0 bytes, default 64
[    3.198358][    T1] PCI-DMA: Using software bounce buffering for IO (SWI=
OTLB)
[    3.199469][    T1] software IO TLB: mapped [mem 0x00000000b4400000-0x00=
000000b8400000] (64MB)
[    3.201954][    T1] ACPI: bus type thunderbolt registered
[    3.211140][    T1] RAPL PMU: API unit is 2^-32 Joules, 0 fixed counters=
, 10737418240 ms ovfl timer
[    3.216011][   T61] kworker/u8:1 (61) used greatest stack depth: 27880 b=
ytes left
[    3.236610][    T1] kvm_amd: CPU 0 isn't AMD or Hygon
[    3.236649][    T1] clocksource: tsc: mask: 0xffffffffffffffff max_cycle=
s: 0x285d5483c8d, max_idle_ns: 440795228937 ns
[    3.239738][    T1] clocksource: Switched to clocksource tsc
[    3.247879][   T67] kworker/u8:3 (67) used greatest stack depth: 27160 b=
ytes left
[    3.274579][    T1] Initialise system trusted keyrings
[    3.278300][    T1] workingset: timestamp_bits=3D40 (anon: 35) max_order=
=3D21 bucket_order=3D0 (anon: 0)
[    3.286066][    T1] DLM installed
[    3.291910][    T1] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    3.299536][    T1] NFS: Registering the id_resolver key type
[    3.299710][    T1] Key type id_resolver registered
[    3.299721][    T1] Key type id_legacy registered
[    3.299981][    T1] nfs4filelayout_init: NFSv4 File Layout Driver Regist=
ering...
[    3.300091][    T1] nfs4flexfilelayout_init: NFSv4 Flexfile Layout Drive=
r Registering...
[    3.304030][    T1] smbdirect: subsystem loading...
[    3.312200][    T1] smbdirect: subsystem loaded
[    3.342789][    T1] Key type cifs.spnego registered
[    3.343043][    T1] Key type cifs.idmap registered
[    3.346819][    T1] ntfs3: Enabled Linux POSIX ACLs support
[    3.346847][    T1] ntfs3: Read-only LZX/Xpress compression included
[    3.347118][    T1] jffs2: version 2.2. (NAND) (SUMMARY)  =C2=A9 2001-20=
06 Red Hat, Inc.
[    3.349230][    T1] romfs: ROMFS MTD (C) 2007 Red Hat, Inc.
[    3.349425][    T1] QNX4 filesystem 0.2.3 registered.
[    3.349531][    T1] qnx6: QNX6 filesystem 1.0.0 registered.
[    3.350763][    T1] fuse: init (API version 7.46)
[    3.354681][    T1] orangefs_debugfs_init: called with debug mask: :none=
: :0:
[    3.355943][    T1] orangefs_init: module version upstream loaded
[    3.356821][    T1] JFS: nTxBlock =3D 8192, nTxLock =3D 65536
[    3.369044][    T1] SGI XFS with ACLs, security attributes, realtime, sc=
rub, repair, quota, no debug enabled
[    3.378590][    T1] 9p: Installing v9fs 9p2000 file system support
[    3.380623][    T1] NILFS version 2 loaded
[    3.381303][    T1] befs: version: 0.9.3
[    3.382815][    T1] ocfs2: Registered cluster interface o2cb
[    3.384592][    T1] ocfs2: Registered cluster interface user
[    3.386061][    T1] OCFS2 User DLM kernel interface loaded
[    3.408890][    T1] gfs2: GFS2 installed
[    3.423843][    T1] ceph: loaded (mds proto 32)
[    3.437963][    T1] NET: Registered PF_ALG protocol family
[    3.439495][    T1] async_tx: api initialized (async)
[    3.440455][    T1] Key type asymmetric registered
[    3.441477][    T1] Asymmetric key parser 'x509' registered
[    3.442418][    T1] Asymmetric key parser 'pkcs8' registered
[    3.443295][    T1] Key type pkcs7_test registered
[    3.444626][    T1] Block layer SCSI generic (bsg) driver version 0.4 lo=
aded (major 239)
[    3.448227][    T1] io scheduler mq-deadline registered
[    3.449247][    T1] io scheduler kyber registered
[    3.450679][    T1] io scheduler bfq registered
[    3.452609][    T1] raid6: skipped pq benchmark and selected avx512x4
[    3.470190][    T1] input: Power Button as /devices/platform/LNXPWRBN:00=
/input/input0
[    3.473842][    T1] ACPI: button: Power Button [PWRF]
[    3.477749][    T1] input: Sleep Button as /devices/platform/LNXSLPBN:00=
/input/input1
[    3.480757][    T1] ACPI: button: Sleep Button [SLPF]
[    3.501883][    T1] ioatdma: Intel(R) QuickData Technology Driver 5.00
[    3.538986][    T1] ACPI: \_SB_.LNKC: Enabled at IRQ 11
[    3.540120][    T1] virtio-pci 0000:00:03.0: virtio_pci: leaving for leg=
acy driver
[    3.573242][    T1] ACPI: \_SB_.LNKD: Enabled at IRQ 10
[    3.574257][    T1] virtio-pci 0000:00:04.0: virtio_pci: leaving for leg=
acy driver
[    3.611123][    T1] ACPI: \_SB_.LNKB: Enabled at IRQ 10
[    3.612311][    T1] virtio-pci 0000:00:06.0: virtio_pci: leaving for leg=
acy driver
[    4.026288][  T629] kworker/u8:6 (629) used greatest stack depth: 26904 =
bytes left
[    4.103079][    T1] N_HDLC line discipline registered with maxframe=3D40=
96
[    4.105350][    T1] Serial: 8250/16550 driver, 4 ports, IRQ sharing enab=
led
[    4.114516][    T1] 00:02: ttyS0 I/O:0x3f8 (irq =3D 4, base_baud =3D 115=
200) is a 16550A
[    4.129686][    T1] 00:03: ttyS1 I/O:0x2f8 (irq =3D 3, base_baud =3D 115=
200) is a 16550A
[    4.144792][    T1] 00:04: ttyS2 I/O:0x3e8 (irq =3D 6, base_baud =3D 115=
200) is a 16550A
[    4.169157][    T1] 00:05: ttyS3 I/O:0x2e8 (irq =3D 7, base_baud =3D 115=
200) is a 16550A
[    4.206372][    T1] Non-volatile memory driver v1.3
[    4.228763][    T1] usbcore: registered new interface driver xillyusb
[    4.234701][    T1] ACPI: bus type drm_connector registered
[    4.245698][    T1] [drm] Initialized vgem 1.0.0 for vgem on minor 0
[    4.252028][    T1] ------------[ cut here ]------------
[    4.252067][    T1] [PLANE:35:plane-0] pixel format with alpha exposed b=
ut blend mode not setup
[    4.252085][    T1] WARNING: drivers/gpu/drm/drm_mode_config.c:872 at dr=
m_mode_config_validate+0xfb4/0x1be0, CPU#0: swapper/0/1
[    4.256488][    T1] Modules linked in:
[    4.257080][    T1] CPU: 0 UID: 0 PID: 1 Comm: swapper/0 Not tainted syz=
kaller #0 PREEMPT(full)=20
[    4.258850][    T1] Hardware name: Google Google Compute Engine/Google C=
ompute Engine, BIOS Google 08/05/2026
[    4.260606][    T1] RIP: 0010:drm_mode_config_validate+0xfbb/0x1be0
[    4.261603][    T1] Code: 00 49 8b 57 18 48 89 f8 48 c1 e8 03 0f b6 04 2=
8 84 c0 74 08 3c 03 0f 8e 00 0b 00 00 48 8d 3d 5c 1f 7e 0b 41 8b b7 c8 00 0=
0 00 <67> 48 0f b9 3a e9 fa fd ff ff 48 8b 5c 24 20 e8 d1 aa 39 fc 48 8d
[    4.264757][    T1] RSP: 0000:ffffc90000067c18 EFLAGS: 00010246
[    4.265631][    T1] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 000=
0000000000000
[    4.266846][    T1] RDX: ffff88802708ff80 RSI: 0000000000000023 RDI: fff=
fffff91504ba0
[    4.268445][    T1] RBP: dffffc0000000000 R08: 0000000000000001 R09: 000=
0000000000000
[    4.269744][    T1] R10: 0000000000000001 R11: 0000000000000000 R12: fff=
fed1004ea1e23
[    4.270879][    T1] R13: ffffed1004ea1e24 R14: 0000000000000001 R15: fff=
f88802750f028
[    4.272125][    T1] FS:  0000000000000000(0000) GS:ffff888123b65000(0000=
) knlGS:0000000000000000
[    4.273520][    T1] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    4.274598][    T1] CR2: ffff88823ffff000 CR3: 000000000eb96000 CR4: 000=
00000003526f0
[    4.275805][    T1] Call Trace:
[    4.276304][    T1]  <TASK>
[    4.276744][    T1]  drm_dev_register+0x56e/0x7b0
[    4.277432][    T1]  vkms_create+0x491/0x5b0
[    4.278450][    T1]  ? __pfx_vkms_init+0x10/0x10
[    4.279187][    T1]  vkms_init+0x98/0xe0
[    4.279870][    T1]  do_one_initcall+0x11c/0x6f0
[    4.280657][    T1]  ? __pfx_do_one_initcall+0x10/0x10
[    4.281473][    T1]  ? kernel_init_freeable+0x4ca/0x7b0
[    4.282372][    T1]  kernel_init_freeable+0x6ea/0x7b0
[    4.283205][    T1]  ? __pfx_kernel_init+0x10/0x10
[    4.283952][    T1]  kernel_init+0x21/0x1e0
[    4.284623][    T1]  ? __pfx_kernel_init+0x10/0x10
[    4.285469][    T1]  ret_from_fork+0x730/0xd60
[    4.286179][    T1]  ? __pfx_ret_from_fork+0x10/0x10
[    4.286964][    T1]  ? __switch_to+0x800/0x10f0
[    4.288061][    T1]  ? __pfx_kernel_init+0x10/0x10
[    4.288883][    T1]  ret_from_fork_asm+0x1a/0x30
[    4.289745][    T1]  </TASK>
[    4.290229][    T1] Kernel panic - not syncing: kernel: panic_on_warn se=
t ...
[    4.291328][    T1] CPU: 0 UID: 0 PID: 1 Comm: swapper/0 Not tainted syz=
kaller #0 PREEMPT(full)=20
[    4.292619][    T1] Hardware name: Google Google Compute Engine/Google C=
ompute Engine, BIOS Google 08/05/2026
[    4.294006][    T1] Call Trace:
[    4.294490][    T1]  <TASK>
[    4.294982][    T1]  dump_stack_lvl+0x100/0x190
[    4.295673][    T1]  vpanic+0x553/0x970
[    4.296729][    T1]  ? __pfx_vpanic+0x10/0x10
[    4.297560][    T1]  panic+0xd1/0xe0
[    4.297698][    T1]  ? __pfx_panic+0x10/0x10
[    4.297698][    T1]  check_panic_on_warn.cold+0x19/0x34
[    4.297698][    T1]  ? drm_mode_config_validate+0xfb4/0x1be0
[    4.297698][    T1]  __warn.cold+0x191/0x318
[    4.297698][    T1]  __report_bug+0x30f/0x440
[    4.297698][    T1]  ? drm_mode_config_validate+0xfb4/0x1be0
[    4.297698][    T1]  ? __pfx___report_bug+0x10/0x10
[    4.297698][    T1]  ? reacquire_held_locks+0xdd/0x1f0
[    4.297698][    T1]  report_bug_entry+0xe2/0x290
[    4.297698][    T1]  ? drm_mode_config_validate+0xfbb/0x1be0
[    4.297698][    T1]  handle_bug+0x1cd/0x2a0
[    4.297698][    T1]  exc_invalid_op+0x17/0x50
[    4.297698][    T1]  asm_exc_invalid_op+0x1a/0x20
[    4.297698][    T1] RIP: 0010:drm_mode_config_validate+0xfbb/0x1be0
[    4.297698][    T1] Code: 00 49 8b 57 18 48 89 f8 48 c1 e8 03 0f b6 04 2=
8 84 c0 74 08 3c 03 0f 8e 00 0b 00 00 48 8d 3d 5c 1f 7e 0b 41 8b b7 c8 00 0=
0 00 <67> 48 0f b9 3a e9 fa fd ff ff 48 8b 5c 24 20 e8 d1 aa 39 fc 48 8d
[    4.297698][    T1] RSP: 0000:ffffc90000067c18 EFLAGS: 00010246
[    4.297698][    T1] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 000=
0000000000000
[    4.297698][    T1] RDX: ffff88802708ff80 RSI: 0000000000000023 RDI: fff=
fffff91504ba0
[    4.297698][    T1] RBP: dffffc0000000000 R08: 0000000000000001 R09: 000=
0000000000000
[    4.297698][    T1] R10: 0000000000000001 R11: 0000000000000000 R12: fff=
fed1004ea1e23
[    4.297698][    T1] R13: ffffed1004ea1e24 R14: 0000000000000001 R15: fff=
f88802750f028
[    4.297698][    T1]  ? drm_mode_config_validate+0xf76/0x1be0
[    4.297698][    T1]  drm_dev_register+0x56e/0x7b0
[    4.297698][    T1]  vkms_create+0x491/0x5b0
[    4.297698][    T1]  ? __pfx_vkms_init+0x10/0x10
[    4.297698][    T1]  vkms_init+0x98/0xe0
[    4.297698][    T1]  do_one_initcall+0x11c/0x6f0
[    4.297698][    T1]  ? __pfx_do_one_initcall+0x10/0x10
[    4.297698][    T1]  ? kernel_init_freeable+0x4ca/0x7b0
[    4.297698][    T1]  kernel_init_freeable+0x6ea/0x7b0
[    4.297698][    T1]  ? __pfx_kernel_init+0x10/0x10
[    4.297698][    T1]  kernel_init+0x21/0x1e0
[    4.297698][    T1]  ? __pfx_kernel_init+0x10/0x10
[    4.297698][    T1]  ret_from_fork+0x730/0xd60
[    4.297698][    T1]  ? __pfx_ret_from_fork+0x10/0x10
[    4.297698][    T1]  ? __switch_to+0x800/0x10f0
[    4.297698][    T1]  ? __pfx_kernel_init+0x10/0x10
[    4.297698][    T1]  ret_from_fork_asm+0x1a/0x30
[    4.297698][    T1]  </TASK>
[    4.297698][    T1] Kernel Offset: disabled
[    4.297698][    T1] Rebooting in 86400 seconds..


syzkaller build log:
go env (err=3D<nil>)
AR=3D'ar'
CC=3D'gcc'
CGO_CFLAGS=3D'-O2 -g'
CGO_CPPFLAGS=3D''
CGO_CXXFLAGS=3D'-O2 -g'
CGO_ENABLED=3D'1'
CGO_FFLAGS=3D'-O2 -g'
CGO_LDFLAGS=3D'-O2 -g'
CXX=3D'g++'
GCCGO=3D'gccgo'
GO111MODULE=3D'auto'
GOAMD64=3D'v1'
GOARCH=3D'amd64'
GOAUTH=3D'netrc'
GOBIN=3D''
GOCACHE=3D'/syzkaller/.cache/go-build'
GOCACHEPROG=3D''
GODEBUG=3D''
GOENV=3D'/syzkaller/.config/go/env'
GOEXE=3D''
GOEXPERIMENT=3D''
GOFIPS140=3D'off'
GOFLAGS=3D''
GOGCCFLAGS=3D'-fPIC -m64 -pthread -Wl,--no-gc-sections -fmessage-length=3D0=
 -ffile-prefix-map=3D/tmp/go-build1798266567=3D/tmp/go-build -gno-record-gc=
c-switches'
GOHOSTARCH=3D'amd64'
GOHOSTOS=3D'linux'
GOINSECURE=3D''
GOMOD=3D'/syzkaller/jobs-2/linux/gopath/src/github.com/google/syzkaller/go.=
mod'
GOMODCACHE=3D'/syzkaller/jobs-2/linux/gopath/pkg/mod'
GONOPROXY=3D''
GONOSUMDB=3D''
GOOS=3D'linux'
GOPATH=3D'/syzkaller/jobs-2/linux/gopath'
GOPRIVATE=3D''
GOPROXY=3D'https://proxy.golang.org,direct'
GOROOT=3D'/usr/local/go'
GOSUMDB=3D'sum.golang.org'
GOTELEMETRY=3D'local'
GOTELEMETRYDIR=3D'/syzkaller/.config/go/telemetry'
GOTMPDIR=3D''
GOTOOLCHAIN=3D'auto'
GOTOOLDIR=3D'/usr/local/go/pkg/tool/linux_amd64'
GOVCS=3D''
GOVERSION=3D'go1.26.0'
GOWORK=3D''
PKG_CONFIG=3D'pkg-config'

git status (err=3D<nil>)
HEAD detached at 4cb2b096987
nothing to commit, working tree clean


tput: No value for $TERM and no -T specified
tput: No value for $TERM and no -T specified
Makefile:31: run command via tools/syz-env for best compatibility, see:
Makefile:32: https://github.com/google/syzkaller/blob/master/docs/contribut=
ing.md#using-syz-env
go list -f '{{.Stale}}' -ldflags=3D"-s -w -X github.com/google/syzkaller/pr=
og.GitRevision=3D4cb2b096987c8122dc6b37eb51200b1ca7991e0f -X github.com/goo=
gle/syzkaller/prog.gitRevisionDate=3D20260727-130118"  ./sys/syz-sysgen | g=
rep -q false || go install -ldflags=3D"-s -w -X github.com/google/syzkaller=
/prog.GitRevision=3D4cb2b096987c8122dc6b37eb51200b1ca7991e0f -X github.com/=
google/syzkaller/prog.gitRevisionDate=3D20260727-130118"  ./sys/syz-sysgen
make .descriptions
tput: No value for $TERM and no -T specified
tput: No value for $TERM and no -T specified
Makefile:31: run command via tools/syz-env for best compatibility, see:
Makefile:32: https://github.com/google/syzkaller/blob/master/docs/contribut=
ing.md#using-syz-env
bin/syz-sysgen
touch .descriptions
GOOS=3Dlinux GOARCH=3Damd64 go build -ldflags=3D"-s -w -X github.com/google=
/syzkaller/prog.GitRevision=3D4cb2b096987c8122dc6b37eb51200b1ca7991e0f -X g=
ithub.com/google/syzkaller/prog.gitRevisionDate=3D20260727-130118"  -o ./bi=
n/linux_amd64/syz-execprog github.com/google/syzkaller/tools/syz-execprog
mkdir -p ./bin/linux_amd64
g++ -o ./bin/linux_amd64/syz-executor executor/executor.cc \
	-m64 -O2 -pthread -Wall -Werror -Wparentheses -Wunused-const-variable -Wfr=
ame-larger-than=3D16384 -Wno-stringop-overflow -Wno-array-bounds -Wno-forma=
t-overflow -Wno-unused-but-set-variable -Wno-unused-command-line-argument -=
static-pie -std=3Dc++17 -I. -Iexecutor/_include   -DGOOS_linux=3D1 -DGOARCH=
_amd64=3D1 \
	-DHOSTGOOS_linux=3D1 -DGIT_REVISION=3D\"4cb2b096987c8122dc6b37eb51200b1ca7=
991e0f\"
/usr/bin/ld: /tmp/ccZHlTeq.o: in function `Connection::Connect(char const*,=
 char const*)':
executor.cc:(.text._ZN10Connection7ConnectEPKcS1_[_ZN10Connection7ConnectEP=
KcS1_]+0x386): warning: Using 'gethostbyname' in statically linked applicat=
ions requires at runtime the shared libraries from the glibc version used f=
or linking
./tools/check-syzos.sh 2>/dev/null


Error text is too large and was truncated, full error text is at:
https://syzkaller.appspot.com/x/error.txt?x=3D14ce4349580000


Tested on:

commit:         a8455260 ipvlan: unregister upper devices outside pnod..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.gi=
t
kernel config:  https://syzkaller.appspot.com/x/.config?x=3D9cc692b98d9b4fd=
b
dashboard link: https://syzkaller.appspot.com/bug?extid=3D2642f347f7309b488=
0dc
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Deb=
ian) 2.44
patch:          https://syzkaller.appspot.com/x/patch.diff?x=3D11aef3795800=
00

