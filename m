Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEA2233F58D
	for <cgroups@vger.kernel.org>; Sun, 26 Jul 2026 07:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785049685; cv=none; b=Tc+HjpPo3kw812AmIaKF8foHXsnKYBO6fCMwYceHAt1W88B3EVOkrlT7mdOj6SWlq1ppkwrchScP4y+0kCn0HJtqnpLRC8axVxw6cUHK5CJbnldYdkUMK8SWQ4Br/WmmQLYx6hBXoXzgqOVt24yQeyDUawbzivCFWvFluELcVQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785049685; c=relaxed/simple;
	bh=MHoGe+90hZ9L09syldld3iRrVB9477XinVV/vSsaNLE=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=pOSKb5yRlo2hPhB8R7dD9EUixutqPnocv7f6cANoqlHrBtCNWvUlSAElOT4/rcs6zwFmZRV8fdyGwCC6/2msN24H9YVXeeG5Xe1CzaRHAavrbrVi0uKewdTpmD1tO5Vj9eQM3wNjxQPN5KYRW+8gCiJX0fBYD/130EaMTvy346A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-49001defc4dso2032859b6e.3
        for <cgroups@vger.kernel.org>; Sun, 26 Jul 2026 00:08:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785049682; x=1785654482;
        h=content-type:cc:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=XKW6kq58maKYt/2lW6GoOr8xzvWAewxyPhVuBDRpRgw=;
        b=E2PXAD1hFSwISSNj8ncZqHAYJaa8Vpm8VCe9++ttuV3CBWJOyvxRIqe832owgPpiAT
         +ZyCRRyeMWLTpWwqNDaz+h40X6jxxlUL+r0ti1hOywOKr+Xx646nSupqC8NfBJQsxf8L
         kfTrFRLriBwSu9IV4qtAtmS1XXq4j6oANafyVkkzU8F6YLVtrvU7O/MwudWkt4zjC7g9
         J4dRCJ7U6He496FRipKJpbTGDyr0zeLPixsA/Z3dOKzA2OZo0xErR2o8gk7LKB4CU5M+
         +Au5jo6bfELBVClE6jKcZE6T55sdhIT2UcqycDkQ2N64u8DPQ1MBhU6LbeIs7EgO7liH
         o7Dw==
X-Forwarded-Encrypted: i=1; AHgh+RoGIqrn2m53wtQvWToGEXVozz8hgphgwnikyLAdkYqThKoOVH/ti0d3LQu+CtwecZs6GLqe60Ab@vger.kernel.org
X-Gm-Message-State: AOJu0YyBkLhoI9t+KebIq05fJWQcg7TJ1rcYnghBXvaHlc1HHCVxK1zs
	ll3lST/awufNwUiEa9wBW94NYl6dylnYDVmDOoUOEclyKAn1ngfbco1pZz9fGamc5q+SSQZlbm0
	nJ/KR3cbOCqHHS7GQFeV+1yHcZPe0C9ZfUOfO8IjI3DwH45IsTbAsuvREbjY=
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1385:b0:4a3:d383:b3ea with SMTP id
 5614622812f47-4ab6a24e0cdmr4071021b6e.27.1785049681809; Sun, 26 Jul 2026
 00:08:01 -0700 (PDT)
Date: Sun, 26 Jul 2026 00:08:01 -0700
In-Reply-To: <20260724123037.3004560-1-yukuai@kernel.org>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a65b251.073198cf.94f0f.0024.GAE@google.com>
Subject: [syzbot ci] Re: blk-cgroup: protect blkgs with blkcg_mutex
From: syzbot ci <syzbot+cic2326f0718d065ef@syzkaller.appspotmail.com>
To: axboe@kernel.dk, cengku@gmail.com, cgroups@vger.kernel.org, 
	dongsheng.yang@linux.dev, hch@lst.de, josef@toxicpanda.com, 
	linux-block@vger.kernel.org, ming.lei@redhat.com, nilay@linux.ibm.com, 
	tj@kernel.org, yukuai@fygo.io, yukuai@kernel.org
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v2] blk-cgroup: protect blkgs with blkcg_mutex
https://lore.kernel.org/all/20260724123037.3004560-1-yukuai@kernel.org
* [RFC PATCH v2 1/8] block: associate blkg in submit_bio instead of bio_set_dev
* [RFC PATCH v2 2/8] blk-throttle: protect throttle state with td lock
* [RFC PATCH v2 3/8] blk-cgroup: protect blkgs with blkcg_mutex
* [RFC PATCH v2 4/8] blk-cgroup: remove blkg radix tree preloading
* [RFC PATCH v2 5/8] blk-cgroup: allocate blkgs in blkg_create
* [RFC PATCH v2 6/8] blk-cgroup: share blkg creation between lookup and config prep
* [RFC PATCH v2 7/8] bfq: avoid blkg lookup from locked cgroup update
* [RFC PATCH v2 8/8] block: fail nowait bio submit if blkg allocation can't sleep

and found the following issue:
general protection fault in blkcg_punt_bio_submit

Full report is available here:
https://ci.syzbot.org/series/eece31b0-1f5d-4840-8a12-407d9a4d1c57

***

general protection fault in blkcg_punt_bio_submit

tree:      axboe
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/axboe/linux.git
base:      093fbffe03f5c1bb9c10a9e5aa65b23250844403
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/2cc06765-4cf6-4329-9c0a-9fe326a5338e/config
syz repro: https://ci.syzbot.org/findings/38efdd1d-4179-4903-8ade-04afbce263b2/syz_repro

Oops: general protection fault, probably for non-canonical address 0xdffffc0000000006: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000030-0x0000000000000037]
CPU: 0 UID: 0 PID: 26 Comm: kworker/u9:0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Workqueue: btrfs-worker btrfs_work_helper
RIP: 0010:blkcg_punt_bio_submit+0x47/0x130 block/blk-cgroup.c:243
Code: ae 13 fd 4c 8d 73 50 4c 89 f0 48 c1 e8 03 80 3c 28 00 74 08 4c 89 f7 e8 07 06 7f fd 4d 8b 36 4d 8d 7e 30 4c 89 f8 48 c1 e8 03 <80> 3c 28 00 74 08 4c 89 ff e8 eb 05 7f fd 49 83 3f 00 0f 84 ab 00
RSP: 0000:ffffc90000a17a28 EFLAGS: 00010206
RAX: 0000000000000006 RBX: ffff888117071348 RCX: ffff8881032f5940
RDX: 0000000000000000 RSI: 0000000004000000 RDI: ffff888117071348
RBP: dffffc0000000000 R08: ffff8881bb74406f R09: 1ffff110376e880d
R10: dffffc0000000000 R11: ffffed10376e880e R12: ffff88816c5e6f08
R13: dffffc0000000000 R14: 0000000000000000 R15: 0000000000000030
FS:  0000000000000000(0000) GS:ffff88818d9cb000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f05d5660000 CR3: 0000000172eb2000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 run_ordered_work fs/btrfs/async-thread.c:243 [inline]
 btrfs_work_helper+0x577/0xc50 fs/btrfs/async-thread.c:322
 process_one_work kernel/workqueue.c:3314 [inline]
 process_scheduled_works+0xa8e/0x14e0 kernel/workqueue.c:3397
 worker_thread+0xa47/0xfb0 kernel/workqueue.c:3478
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:blkcg_punt_bio_submit+0x47/0x130 block/blk-cgroup.c:243
Code: ae 13 fd 4c 8d 73 50 4c 89 f0 48 c1 e8 03 80 3c 28 00 74 08 4c 89 f7 e8 07 06 7f fd 4d 8b 36 4d 8d 7e 30 4c 89 f8 48 c1 e8 03 <80> 3c 28 00 74 08 4c 89 ff e8 eb 05 7f fd 49 83 3f 00 0f 84 ab 00
RSP: 0000:ffffc90000a17a28 EFLAGS: 00010206
RAX: 0000000000000006 RBX: ffff888117071348 RCX: ffff8881032f5940
RDX: 0000000000000000 RSI: 0000000004000000 RDI: ffff888117071348
RBP: dffffc0000000000 R08: ffff8881bb74406f R09: 1ffff110376e880d
R10: dffffc0000000000 R11: ffffed10376e880e R12: ffff88816c5e6f08
R13: dffffc0000000000 R14: 0000000000000000 R15: 0000000000000030
FS:  0000000000000000(0000) GS:ffff8882a8fcb000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007efceadf26a8 CR3: 0000000115190000 CR4: 00000000000006f0
----------------
Code disassembly (best guess):
   0:	ae                   	scas   %es:(%rdi),%al
   1:	13 fd                	adc    %ebp,%edi
   3:	4c 8d 73 50          	lea    0x50(%rbx),%r14
   7:	4c 89 f0             	mov    %r14,%rax
   a:	48 c1 e8 03          	shr    $0x3,%rax
   e:	80 3c 28 00          	cmpb   $0x0,(%rax,%rbp,1)
  12:	74 08                	je     0x1c
  14:	4c 89 f7             	mov    %r14,%rdi
  17:	e8 07 06 7f fd       	call   0xfd7f0623
  1c:	4d 8b 36             	mov    (%r14),%r14
  1f:	4d 8d 7e 30          	lea    0x30(%r14),%r15
  23:	4c 89 f8             	mov    %r15,%rax
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	80 3c 28 00          	cmpb   $0x0,(%rax,%rbp,1) <-- trapping instruction
  2e:	74 08                	je     0x38
  30:	4c 89 ff             	mov    %r15,%rdi
  33:	e8 eb 05 7f fd       	call   0xfd7f0623
  38:	49 83 3f 00          	cmpq   $0x0,(%r15)
  3c:	0f                   	.byte 0xf
  3d:	84                   	.byte 0x84
  3e:	ab                   	stos   %eax,%es:(%rdi)


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

To test a patch for this bug, please reply with `#syz test`
(should be on a separate line).

The patch should be attached to the email.
Note: arguments like custom git repos and branches are not supported.
