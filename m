Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com [209.85.161.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5008D3BE14A
	for <cgroups@vger.kernel.org>; Tue, 18 Aug 2026 08:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787041499; cv=none; b=isFzXUv+YT7uXUf6W5pjPgED9RZxMv8v3xP2UDCFUjD/I6mfI9jhkexhPF/t1BbCvjH7clQ0pX/Uu/WcuwOql93/LTn0GrnuKtWiKDv7VU1lj+nOtEKOk7jQrXJ/v/XRWnwaBiJFxlng5Huq7w3KMyZfcrzh/CSox+rAw5/bvB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787041499; c=relaxed/simple;
	bh=UMr1CLopxxuJm7wYCh2Fq3SXhAnNT3ZAigk8SIR7qkA=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=Evlpe4xnhol04+fElT0whK+x8Pco0BY3kNb1uxthyHKC0PlN9ne9SWFixNQK6kbp9Sw+wZy8obqPVKyhGYS79OgIioGl/Z+VvfX3BIhXo6Dx5hMq0eGJIuBbhiIZmfeaFO5NofsuRgpMcsmMPhknc9K2uS4Kp8r0GH8NODAOL64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f71.google.com with SMTP id 006d021491bc7-6acaccb8b0cso1581174eaf.0
        for <cgroups@vger.kernel.org>; Tue, 18 Aug 2026 01:24:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787041497; x=1787646297;
        h=content-type:cc:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=O58fmBB+gdrGTSPuDeyTUQq/CrJ5CHQIBvvW90VjttQ=;
        b=Qjgo/nnKMVjGMiZRje/9LcpY8IH5uIYjQ3zNRrUo95yuVvBy1SSnOQGro9+F66sn+e
         t6eHgnG5uThlMDLhnHjcGwM58/FI13NrsMwzEuOrumradTnKW+riQz6KLAkaHb+Ha1dj
         eB+LEDkwFqbAx1glPRMj3o2w3J3qmu508Xy8JpSnW1vcIHVp1zPUF4xZASr9SdBhtW1z
         NOnIOsXUSjvSGF74+AG7If5obQMTB39kDZa9yiMNgWKih3eZACGXE/Mm192bEfp9kzgT
         ZVH0TiFzUu43SGQLoD5V1MIpIu1ZcsX5h25DIHu014ai9FHfBI/IXhQjswCMADdkbnwM
         V/eA==
X-Forwarded-Encrypted: i=1; AHgh+RoFIM3QoE2zzHFFUQvHaJgpw+s3OPMzG7UWlkCV3XNh0MRC7MI8UINlxiamFJcF2OKnpn7NMYnj@vger.kernel.org
X-Gm-Message-State: AOJu0YxEw+R0zy45NaCM1aZ9rtNw3VtJ67fIKtneX5f/pKDilMtYsuPk
	tyU9v+Ul+HX7EziqjpIQd4CFo+13OGFirnQ5DYp8gTjBRhY+f4rjyxV57JRBLvs/1yjUemc5k6n
	N1T9ld7OX8v/GDCPumYMzKAt3HMulQuOGo0P7nRS3T8ddEnrKB06NDdK4YKs=
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1c8a:b0:6b0:f389:da5a with SMTP id
 006d021491bc7-6b11dd3244amr5374544eaf.8.1787041497264; Tue, 18 Aug 2026
 01:24:57 -0700 (PDT)
Date: Tue, 18 Aug 2026 01:24:57 -0700
In-Reply-To: <20260818023121.100613-1-liuqiqi@kylinos.cn>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a8416d9.f7a79266.2f965f.0033.GAE@google.com>
Subject: [syzbot ci] Re: mm/memcontrol: introduce per-tier memory accounting
 and control
From: syzbot ci <syzbot+cid780730586e082da@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, cgroups@vger.kernel.org, hannes@cmpxchg.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, liuqiqi@kylinos.cn, 
	mhocko@kernel.org, mkoutny@suse.com, muchun.song@linux.dev, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, tj@kernel.org
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] mm/memcontrol: introduce per-tier memory accounting and control
https://lore.kernel.org/all/20260818023121.100613-1-liuqiqi@kylinos.cn
* [RFC PATCH 1/8] mm/memory-tiers: add node_to_tier_id and tier_id_to_nodemask
* [RFC PATCH 2/8] mm/vmscan: add try_to_free_mem_cgroup_pages_nodemask
* [RFC PATCH 3/8] mm/memcontrol: add per-tier page counter infrastructure and lifecycle
* [RFC PATCH 4/8] mm/memcontrol: add per-tier charge and uncharge
* [RFC PATCH 5/8] mm/memcontrol: add per-cpu stock for tier charge/uncharge
* [RFC PATCH 6/8] mm/memcontrol: add memory.tier control file
* [RFC PATCH 7/8] mm/memcontrol: auto-derive tier high/max from memory.high/max
* [RFC PATCH 8/8] cgroup: add memory_tiered_limits cgroup mount option

and found the following issue:
WARNING in uncharge_folio

Full report is available here:
https://ci.syzbot.org/series/9db711d8-d389-45d1-b245-7e8b316a8432

***

WARNING in uncharge_folio

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      dcacab904fe78d60840ba947a104993ee9ded887
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/bf213e6f-1b40-41fa-a938-385807688eec/config

------------[ cut here ]------------
debug_locks && !(rcu_read_lock_held() || lock_is_held(&(&cgroup_mutex)->dep_map))
WARNING: ./include/linux/memcontrol.h:391 at uncharge_folio+0x459/0x5b0, CPU#1: udevd/5681
Modules linked in:
CPU: 1 UID: 0 PID: 5681 Comm: udevd Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:uncharge_folio+0x459/0x5b0
Code: c4 18 5b 41 5c 41 5d 41 5e 41 5f 5d c3 cc cc cc cc cc 48 8b 3c 24 48 83 c4 18 5b 41 5c 41 5d 41 5e 41 5f 5d e9 88 79 00 00 90 <0f> 0b 90 e9 c9 fe ff ff 89 e9 80 e1 07 80 c1 03 38 c1 0f 8c 49 fc
RSP: 0018:ffffc90004ff7210 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffffc90004ff72a0 RCX: 0000000080000001
RDX: 0000000000000000 RSI: ffffffff8e4a6d0d RDI: ffffffff8c4bb280
RBP: ffffc90004ff72a8 R08: ffffea0006e7a7c7 R09: 1ffffd4000dcf4f8
R10: dffffc0000000000 R11: fffff94000dcf4f9 R12: ffffea0006e7a7f8
R13: 1ffffd4000dcf4f8 R14: 0000000000000001 R15: ffffea0006e7a7c0
FS:  00007f1ec7ce0c80(0000) GS:ffff8882a8f6a000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f0cdf670000 CR3: 000000017358a000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 __mem_cgroup_uncharge_folios+0xfd/0x1d0
 folio_batch_move_lru+0x86f/0xa60
 lru_add_drain_cpu+0xbc/0x750
 lru_add_drain+0x121/0x3e0
 __folio_batch_release+0x48/0x90
 shmem_undo_range+0x4e6/0x15d0
 shmem_evict_inode+0x280/0xa80
 evict+0x624/0xb50
 dentry_kill+0x1b9/0x880
 finish_dput+0x1a/0x260
 filename_renameat2+0x61b/0x9a0
 __se_sys_rename+0x55/0x2c0
 do_syscall_64+0x174/0x580
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f1ec789a93b
Code: 48 8b 15 f0 64 15 00 83 c8 ff 64 83 3a 15 75 0e 48 8b 7c 24 08 e8 d5 d4 07 00 f7 d8 19 c0 48 83 c4 18 c3 b8 52 00 00 00 0f 05 <48> 3d 00 f0 ff ff 76 10 48 8b 15 be 64 15 00 f7 d8 64 89 02 48 83
RSP: 002b:00007ffcb336cd08 EFLAGS: 00000202 ORIG_RAX: 0000000000000052
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f1ec789a93b
RDX: 0000558c622ea032 RSI: 00007ffcb336cd28 RDI: 00007ffcb336d128
RBP: 000055893abc0910 R08: 0000000000000006 R09: f80f8ce6f311cb22
R10: 00000000000001b6 R11: 0000000000000202 R12: 000055893aba2730
R13: 00007ffcb336cd28 R14: 00007ffcb336d128 R15: 0000558926efb160
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

To test a fix for this bug, please reply with `#syz test`
(on a separate line) and attach the patch to the email.

Notes:
- The patch will be applied on top of the tested series (as an
  incremental fix).
- To test a new version of the whole series, please send it directly
  to syzbot@lists.linux.dev.
- Arguments like custom git repos and branches are not supported.
