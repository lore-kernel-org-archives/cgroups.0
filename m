Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EE033B9DAB
	for <cgroups@vger.kernel.org>; Wed, 12 Aug 2026 12:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786537586; cv=none; b=XQdPR761dYjYpgWSJ/wv5zfDE//xGCxImDQFIx/e5EmpjU3PmKf22crps1PgOS46BhB4WoY9hq1oI81hrpEBNvakIKmUcxcHgrA3u3pmVhFANZpkBYqrYnXOFuZaLFpFlqdabpj3rzDKgVQKWgopncNDiLMXpzBBQ1pJPMu1+hQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786537586; c=relaxed/simple;
	bh=7ZduRDunxHw1mtqWL3NsN5nl9wm9FP+HW5oAwo3ok+4=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=bSKfFLzxSswguvXr3NgwdkVnvx/Q9ZjWYsoDYJDt2a0282XAaJ59BpU5TMwFny/ueq92lZAUoHXHcmPpciQTluZX6Ad1TxR+OWUvfS9tZscc6mkZ9utLzNx1neXoOhDOuPaUk258LgdXh6f0vMYynKaKALU8mkoONnkDTz3u4TA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-4b1bc2e44e0so1058066b6e.0
        for <cgroups@vger.kernel.org>; Wed, 12 Aug 2026 05:26:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786537584; x=1787142384;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=KwBwo9L8xQyqtv/i2/6defD8MNdrwToASIU8rpL79rQ=;
        b=sdcUn4tvmYLr9n5BMAMgkxIEWXliz8+Yf4UhqwnZO9XFf31v0shR1XpK07Tcy5lwdS
         iRI4mckkK+/08v6PUj6MMDqbY62k98biBj3c+KRZDDH4yP5TiZGKCczpsTtRtBet4k06
         1WjwBXXh+1/OeWzNCNwFdhcgOccqP7xNS8pYdC/7ujBwXMXyntWa4JbF7UwUF8Pj0J0M
         KZlJElKgPkNc9RXHMEFvKh0k+otTaTit1f7H/yXwWX/EWTQOa4YbTn5D0s9DK5I0nGRe
         VxO+/Oy2lOnzpQQ+6pvzQuERT37SCbJVtm0aBlWQ4FJKhm6Fi7H4kM/n9K0PU6c+M1W1
         ITBA==
X-Forwarded-Encrypted: i=1; AHgh+RrhCOgDCaSokQ4skcjxRN83nOLnlxhEva5tEb1GXjMggAVgn2N7g9z5zBUwEurZnJQadbiEgaWH@vger.kernel.org
X-Gm-Message-State: AOJu0Yy8qcCPYX9L/GSUKD8SD82esdNFpUP5yRgMADVvFQ8oF1y2O8QC
	KoKkZUE/vQi2SkZxF00nDrjjGytxYA7AFGnT1z+KE77CCQUJBW4X4KAU1Qr+YK2aBSoEsffHcuP
	eGGNykcPiI0WfqBtJoQXkfO3cnoWt3aGRtiPfUdy9BO5m3D4hgUzvDZBVBd4=
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:c97:b0:69e:98c0:4bd6 with SMTP id
 006d021491bc7-6b0b2490e00mr3827700eaf.1.1786537584398; Wed, 12 Aug 2026
 05:26:24 -0700 (PDT)
Date: Wed, 12 Aug 2026 05:26:24 -0700
In-Reply-To: <6a7a6929.b50370da.49fe0.005e.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a7c6670.3668565d.e8814.0012.GAE@google.com>
Subject: Re: [syzbot] [mm?] WARNING in set_mm_walk
From: syzbot <syzbot+12ee2725d5fde63a9c96@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, axelrasmussen@google.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, cgroups@vger.kernel.org, david@kernel.org, 
	hannes@cmpxchg.org, kasong@tencent.com, kernel-team@meta.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org, 
	mhocko@kernel.org, mhocko@suse.com, muchun.song@linux.dev, qi.zheng@linux.dev, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
	syzkaller-bugs@googlegroups.com, weixugc@google.com, yuanchu@google.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    f5bbbfec59b4 Merge tag 'probes-fixes-v7.2-rc7' of git://gi..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11f44c79580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c44651ea7dd2f307
dashboard link: https://syzkaller.appspot.com/bug?extid=12ee2725d5fde63a9c96
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10d11149580000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+12ee2725d5fde63a9c96@syzkaller.appspotmail.com

------------[ cut here ]------------
current_is_kswapd()
WARNING: mm/vmscan.c:3800 at set_mm_walk+0x210/0x270 mm/vmscan.c:3800, CPU#2: kswapd0/111
Modules linked in:
CPU: 2 UID: 0 PID: 111 Comm: kswapd0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:set_mm_walk+0x210/0x270 mm/vmscan.c:3800
Code: 13 00 00 4d 8d 7d 08 e9 f7 fe ff ff e8 19 f7 2a 00 e9 b7 fe ff ff e8 7f 68 ba ff 90 0f 0b 90 e9 d2 fe ff ff e8 71 68 ba ff 90 <0f> 0b 90 e9 74 ff ff ff 4c 89 ff e8 20 f7 2a 00 e9 4e fe ff ff 48
RSP: 0018:ffffc9000272f2b8 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffff888023f04a80 RCX: ffffffff82500a88
RDX: ffff888023f04a80 RSI: ffffffff82500b0f RDI: ffff888023f04a80
RBP: 0000000000020000 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000000020000 R11: 0000000000000000 R12: 0000000000000000
R13: ffffc9000272fc38 R14: 0000000000000001 R15: ffffc9000272fc40
FS:  0000000000000000(0000) GS:ffff8880d5fec000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005643a2ed4168 CR3: 000000003c7ec000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 try_to_inc_max_seq+0xf0/0x1090 mm/vmscan.c:4023
 try_to_shrink_lruvec+0x4bd/0x6b0 mm/vmscan.c:4977
 lru_gen_shrink_lruvec mm/vmscan.c:5128 [inline]
 shrink_lruvec+0x31e/0x25b0 mm/vmscan.c:5888
 mem_cgroup_shrink_node+0x227/0x6a0 mm/vmscan.c:6753
 mem_cgroup_soft_reclaim mm/memcontrol-v1.c:312 [inline]
 memcg1_soft_limit_reclaim+0x2d5/0x830 mm/memcontrol-v1.c:362
 balance_pgdat+0xa11/0x1f00 mm/vmscan.c:7177
 kswapd+0x556/0xb50 mm/vmscan.c:7462
 kthread+0x370/0x450 kernel/kthread.c:436
 ret_from_fork+0x72b/0xd50 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
