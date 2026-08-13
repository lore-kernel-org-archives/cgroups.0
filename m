Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com [209.85.161.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EF573955D8
	for <cgroups@vger.kernel.org>; Thu, 13 Aug 2026 13:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786627613; cv=none; b=FkDQpspLOvwQHCvBsW/p/GIl3cWLoyNNhJqgeR3ikRLCA6tRUCsauCb6W5EhHwgxcvYTdXue/jOgXKQz32+5f5rmYPIW8un6j097KBB6y+jjYb5o/9EBGqsNn+lvO4dG3hKPhUBVmyZFPXXFV4xk57ydgQ7oEr5rpjS7qraPYWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786627613; c=relaxed/simple;
	bh=91VFEyR730CFFriaRG1xcbvss2B72b52TiWmGlqXSiU=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=uiRyvlnMx/dfhPC7/czK6izjsAvwU0guzKBhv+5w4+QAQ4OLP2FvZruoe6K2oyz5an81+9TDDhjAMTN1DYSGi3KwDOl3OKMCEetLFdxkDNSsJSLR0UPs3Z46kxJn/S90cYyovGRI7Pr0TAUfMHnKJIgCU3XZWZAwOpWxragbOtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f71.google.com with SMTP id 006d021491bc7-6b026a31eb9so1269832eaf.1
        for <cgroups@vger.kernel.org>; Thu, 13 Aug 2026 06:26:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786627611; x=1787232411;
        h=content-type:cc:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=hABxMDJF3aW+EgiaAYYhCDRtl3tqj0WVMhGSSJF258M=;
        b=sSl2teGz1vIvMKgTwegKca1cU9tn0iVfKRAwZpA/MkIgshsDO68Ly8ieTGh2eR5OrP
         Eal7P8jME+TFM7nxlr0uOUZzf2grdx8Zur8FP2r9WjpsJyJ8nl3agNXu59P+KyYeiMAW
         Tosg5ecKhzl4cxh92/5bYqcoaQAK7JnbhaQZmfwY2Nsi7xsMPcxRGH8l6n9Y/fIFTTzk
         NYNZOTgbGx5Jqzdpbw9ucUh3nJIAJ+T4NOpAIJx4wI5iC5ENllK3oA3FM6qOYPd6KuKA
         2YsDY1FSokFxc0bAg9ABnV5tZIpZmUKVSZNrd0VM4AsAqYdW/PzIbkMG8+lUW/O6HHYM
         Y/Iw==
X-Forwarded-Encrypted: i=1; AHgh+RprOgNkpgZsRLGzdeC9xj09Lonaj5CgPdukTlRlRcEyVAxlvhLgWiNUi4WZvQ1pc3CXeruyOGbN@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/4Xgmvpi/Pk7hA1l3hcaFx8HzPWtUy/My69i05JbqrosKjd8x
	127lp5tkWCmJ7cB34AZ8J0SOpxn0EFIKIQAe6JjeEbQ3anWQY7mznuEcyG9p4p2zE0tzKpcNd1t
	s+buctKk2Aej5Oc5BSLhj0b7XDezbJdsUYkf1OTGRBUytxK8r7iMfTNuN1eU=
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:f033:b0:6a3:c1a2:bd4 with SMTP id
 006d021491bc7-6b0c42f759dmr4956829eaf.20.1786627610938; Thu, 13 Aug 2026
 06:26:50 -0700 (PDT)
Date: Thu, 13 Aug 2026 06:26:50 -0700
In-Reply-To: <20260813-memcgid-objcg-v1-0-83d21c685b77@tencent.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a7dc61a.ec5dc6cc.21cb3f.00b7.GAE@google.com>
Subject: [syzbot ci] Re: memcg: fix dying memcg pinned by swapped out shmem pages
From: syzbot ci <syzbot+ci49bb3ed471ef5f9f@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, axelrasmussen@google.com, baohua@kernel.org, 
	bfguo@icloud.com, bingfangguo@tencent.com, cgroups@vger.kernel.org, 
	david@fromorbit.com, david@kernel.org, devnull@kernel.org, hannes@cmpxchg.org, 
	kasong@tencent.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	ljs@kernel.org, mhocko@kernel.org, muchun.song@linux.dev, qi.zheng@linux.dev, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, weixugc@google.com, 
	yuanchu@google.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] memcg: fix dying memcg pinned by swapped out shmem pages
https://lore.kernel.org/all/20260813-memcgid-objcg-v1-0-83d21c685b77@tencent.com
* [PATCH RFC 1/5] memcg: move memcg private ID refcount to objcg
* [PATCH RFC 2/5] memcg: get stable memcg first before getting memcgid reference
* [PATCH RFC 3/5] memcg: remove retry logic in mem_cgroup_private_id_get_online
* [PATCH RFC 4/5] memcg: add a helper to get online memcg from memcgid
* [PATCH RFC 5/5] memcg: filter out reparented memcgs got using memcgid

and found the following issue:
WARNING: refcount bug in __mem_cgroup_uncharge_swap

Full report is available here:
https://ci.syzbot.org/series/3a8a2a5f-8b6d-4abf-954e-a1a18ee62748

***

WARNING: refcount bug in __mem_cgroup_uncharge_swap

tree:      linux-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/linux-next
base:      288058d8db5d35623228d84f48d9bea3707d5c85
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/35dac6f6-b44a-4ea8-9adf-2cdda5584e45/config
syz repro: https://ci.syzbot.org/findings/6e117c0b-d6e2-44a6-8e35-161cb33f2aff/syz_repro

------------[ cut here ]------------
refcount_t: underflow; use-after-free.
WARNING: lib/refcount.c:28 at refcount_warn_saturate+0xb2/0x110 lib/refcount.c:28, CPU#0: syz.2.19/5863
Modules linked in:
CPU: 0 UID: 0 PID: 5863 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:refcount_warn_saturate+0xb2/0x110 lib/refcount.c:28
Code: 64 84 8e 0b 67 48 0f b9 3a eb 4a e8 58 fa f2 fc 48 8d 3d 61 84 8e 0b 67 48 0f b9 3a eb 37 e8 45 fa f2 fc 48 8d 3d 5e 84 8e 0b <67> 48 0f b9 3a eb 24 e8 32 fa f2 fc 48 8d 3d 5b 84 8e 0b 67 48 0f
RSP: 0018:ffffc90003bbf1d0 EFLAGS: 00010293
RAX: ffffffff84d3ed9b RBX: 0000000000000003 RCX: ffff8881bdf58000
RDX: 0000000000000000 RSI: ffffffff8f363380 RDI: ffffffff90627200
RBP: 1ffffffff20ae968 R08: ffff8881bdf58000 R09: 0000000000000005
R10: 0000000000000004 R11: 0000000000000000 R12: ffff8881026f8000
R13: ffff88810a914100 R14: ffff88810a914134 R15: 1ffff110204df009
FS:  00007fe2ee63d6c0(0000) GS:ffff88818d960000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000056066247f0b8 CR3: 000000000e946000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 mem_cgroup_take_from_private_id mm/memcontrol.c:4049 [inline]
 __mem_cgroup_uncharge_swap+0x204/0x2a0 mm/memcontrol.c:5707
 mem_cgroup_uncharge_swap include/linux/swap.h:520 [inline]
 __swap_cluster_free_entries+0x735/0xc50 mm/swapfile.c:1955
 swap_put_entries_cluster+0x3b1/0x4b0 mm/swapfile.c:1629
 swap_put_entries_direct+0x137/0x210 mm/swapfile.c:2139
 zap_nonpresent_ptes mm/memory.c:1838 [inline]
 do_zap_pte_range mm/memory.c:1905 [inline]
 zap_pte_range mm/memory.c:2003 [inline]
 zap_pmd_range mm/memory.c:2089 [inline]
 zap_pud_range mm/memory.c:2117 [inline]
 zap_p4d_range mm/memory.c:2138 [inline]
 __zap_vma_range+0x1d9d/0x4f10 mm/memory.c:2178
 unmap_vmas+0x390/0x550 mm/memory.c:2247
 exit_mmap+0x293/0x9f0 mm/mmap.c:1315
 __mmput+0x118/0x420 kernel/fork.c:1187
 exit_mm+0x221/0x2d0 kernel/exit.c:615
 do_exit+0x6cd/0x2360 kernel/exit.c:997
 do_group_exit+0x22d/0x2f0 kernel/exit.c:1152
 get_signal+0x121b/0x12c0 kernel/signal.c:3046
 arch_do_signal_or_restart+0xbb/0x860 arch/x86/kernel/signal.c:337
 __exit_to_user_mode_loop kernel/entry/common.c:66 [inline]
 exit_to_user_mode_loop+0x104/0x730 kernel/entry/common.c:101
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:207 [inline]
 syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:230 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:318 [inline]
 do_syscall_64+0x353/0x580 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fe2ed79e0d9
Code: Unable to access opcode bytes at 0x7fe2ed79e0af.
RSP: 002b:00007fe2ee63d0e8 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
RAX: fffffffffffffe00 RBX: 00007fe2eda25fa8 RCX: 00007fe2ed79e0d9
RDX: 0000000000000000 RSI: 0000000000000080 RDI: 00007fe2eda25fa8
RBP: 00007fe2eda25fa0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fe2eda26038 R14: 00007fff0bed41b0 R15: 00007fff0bed4298
 </TASK>
----------------
Code disassembly (best guess):
   0:	64 84 8e 0b 67 48 0f 	test   %cl,%fs:0xf48670b(%rsi)
   7:	b9 3a eb 4a e8       	mov    $0xe84aeb3a,%ecx
   c:	58                   	pop    %rax
   d:	fa                   	cli
   e:	f2 fc                	repnz cld
  10:	48 8d 3d 61 84 8e 0b 	lea    0xb8e8461(%rip),%rdi        # 0xb8e8478
  17:	67 48 0f b9 3a       	ud1    (%edx),%rdi
  1c:	eb 37                	jmp    0x55
  1e:	e8 45 fa f2 fc       	call   0xfcf2fa68
  23:	48 8d 3d 5e 84 8e 0b 	lea    0xb8e845e(%rip),%rdi        # 0xb8e8488
* 2a:	67 48 0f b9 3a       	ud1    (%edx),%rdi <-- trapping instruction
  2f:	eb 24                	jmp    0x55
  31:	e8 32 fa f2 fc       	call   0xfcf2fa68
  36:	48 8d 3d 5b 84 8e 0b 	lea    0xb8e845b(%rip),%rdi        # 0xb8e8498
  3d:	67                   	addr32
  3e:	48                   	rex.W
  3f:	0f                   	.byte 0xf


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
