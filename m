Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFDB84A0129
	for <cgroups@vger.kernel.org>; Mon, 21 Sep 2026 13:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789998139; cv=none; b=pHSN5jYAEI4sqHdkEEP7UwRzfZOPyaIWJsb/FpEt2Ecpx6t2oSxi+AWk8F6MYWrR2myzpafr8Y2jwciIqyLatWkOw/mJhpp0BhDf9v9p0XVw3/6vQVtuXUR3GJaI3bXiA61Tnucll9RXc3W9I3StQkgS4SWiNT17N49DwLvHZXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789998139; c=relaxed/simple;
	bh=Vims1zCPU9AefAmxXrQvYsrW+nsLqVr9UDQIK6OqpfA=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=t1HIXkNVIRt3grMkSWU8pDLrvlTw1OUF5456z3VYiKKZE2Af/wnynJFa+SEzXz+HIiipmVXn/p44/IwSbAD8glchp0LEcICpXMxAquuEEsOVN6JGKRnYV6QNEycSLlynTn1q1dBUDD5lnHojVHQN5YsxhYB+k1tVFNTNpr58VD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-4b2d1eb484aso4798047b6e.2
        for <cgroups@vger.kernel.org>; Mon, 21 Sep 2026 06:42:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789998136; x=1790602936;
        h=content-type:cc:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=z0xyx2CKUzUlO7trGYHo+WhwXNQQH0QF0bBAisIrr6k=;
        b=MJg7lNgOTKcFelkODA8IGTKElzsO8wn4ej5B7Oqh8bMJuvJKp4I4hPl2embyjmI7nu
         zhas5zuwS9pMSi13GB5BA7E8jikdgJS0o36hSZAxRS3Of/GkywNzRbDFhQiLhDQuF6Un
         3fMDH+KJJ3KLVqyj8JHFJkdyuXda41HJHBxb/O5UxN7/coYBat0ReHNlS5jn+sbxLDlN
         x7WwFBfNOEt+CdRXqWDi8UNXxoFNqXwh+yloIf0c391k5Qn8E6woH6QSBzIbsGr47W8w
         5HlMMELq4tjSmcc5vYqFLiaLkAoVb9ivHksN59tJby4Scg7jmocACWa7mQbXqHyrF4pz
         ucRg==
X-Forwarded-Encrypted: i=1; AKwUvBzCfwvSpIHRFaWuEtWuq3K2/6HsQt8Pmj9KyRrHj7hi+X9KwLlbpcDsdFWtRhclJEBI76un3uM/@vger.kernel.org
X-Gm-Message-State: AFuF++kxIcUKgffMmy/KES/gTrSItAbBRB3h9LCq6ee44qUKqqPNcXB2
	OGq9QnjyGY0dry+j5JTyrGvuF6XnJUTR7BgGukfrBiYJdm2pXBXPjxHfOVXztfiQBmGLdSgODeG
	uQEtij+nEXt3r85Qcp0YZZ/GtRobjORXtqMUExWE5OhKbGCdOSHqosryrA58=
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:2084:b0:6c2:6f93:389f with SMTP id
 006d021491bc7-6ca9bd48180mr11162028eaf.37.1789998136361; Mon, 21 Sep 2026
 06:42:16 -0700 (PDT)
Date: Mon, 21 Sep 2026 06:42:16 -0700
In-Reply-To: <20260918180241.3424851-1-nphamcs@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ab13438.71f81b7d.15fa6d.002c.GAE@google.com>
Subject: [syzbot ci] Re: Virtual Swap Space (Swap Table Edition)
From: syzbot ci <syzbot+cid08c37b8dadb4c43@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, axelrasmussen@google.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, baoquan.he@linux.dev, cgroups@vger.kernel.org, 
	chengming.zhou@linux.dev, chrisl@kernel.org, corbet@lwn.net, david@kernel.org, 
	gourry@gourry.net, hannes@cmpxchg.org, haowenchao22@gmail.com, 
	hughd@google.com, kasong@tencent.com, kernel-team@meta.com, 
	kunwu.chan@linux.dev, liam@infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org, 
	mhocko@kernel.org, mkoutny@suse.com, muchun.song@linux.dev, nphamcs@gmail.com, 
	qi.zheng@linux.dev, riel@surriel.com, roman.gushchin@linux.dev, 
	rppt@kernel.org, shakeel.butt@linux.dev, shikemeng@huaweicloud.com, 
	skhan@linuxfoundation.org, surenb@google.com, tj@kernel.org, 
	vbabka@kernel.org, weixugc@google.com, yosry@kernel.org, 
	youngjun.park@lge.com, yuanchu@google.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v5] Virtual Swap Space (Swap Table Edition)
https://lore.kernel.org/all/20260918180241.3424851-1-nphamcs@gmail.com
* [PATCH v5 01/11] mm, swap: add virtual swap device infrastructure
* [PATCH v5 02/11] mm, swap: support zswap and zero-filled swap pages as vswap backends
* [PATCH v5 03/11] mm, swap: prepare the swap IO path for vswap
* [PATCH v5 04/11] mm, swap: support physical swap as a vswap backend
* [PATCH v5 05/11] mm, swap: enable THP swapin for vswap entries
* [PATCH v5 06/11] mm, swap: write back vswap zswap entries to physical swap
* [PATCH v5 07/11] mm, swap: reclaim physical slots backing cache-only vswap entries
* [PATCH v5 08/11] mm, swap: only charge physical swap entries
* [PATCH v5 09/11] mm, swap: add debugfs counters for vswap
* [PATCH v5 10/11] mm, swap: defer memcg_table allocation for physical swap clusters
* [RFC PATCH v5 11/11] mm, swap: back vswap clusters with a VM_SPARSE array

and found the following issue:
KASAN: null-ptr-deref Read in swap_entry_backend_has_flag

Full report is available here:
https://ci.syzbot.org/series/713f2473-328a-4c16-8bce-63005d15a338

***

KASAN: null-ptr-deref Read in swap_entry_backend_has_flag

tree:      linux-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/linux-next
base:      27e4e1835109ef599d72abe6c09711e0b1916033
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/26b06329-3b1c-4c73-8ee3-64c53b995186/config
syz repro: https://ci.syzbot.org/findings/f743742b-1934-4b4e-a590-9a36592da902/syz_repro

==================================================================
BUG: KASAN: null-ptr-deref in instrument_atomic_read include/linux/instrumented.h:82 [inline]
BUG: KASAN: null-ptr-deref in atomic_long_read include/linux/atomic/atomic-instrumented.h:3188 [inline]
BUG: KASAN: null-ptr-deref in __vtable_get mm/vswap.h:163 [inline]
BUG: KASAN: null-ptr-deref in vswap_to_phys mm/vswap.h:202 [inline]
BUG: KASAN: null-ptr-deref in swap_entry_backend_has_flag+0xea/0x210 mm/vswap.h:409
Read of size 8 at addr 0000000000000e00 by task syz.1.38/5916

CPU: 1 UID: 0 PID: 5916 Comm: syz.1.38 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 kasan_report+0x117/0x150 mm/kasan/report.c:595
 check_region_inline mm/kasan/generic.c:-1 [inline]
 kasan_check_range+0x264/0x2c0 mm/kasan/generic.c:200
 instrument_atomic_read include/linux/instrumented.h:82 [inline]
 atomic_long_read include/linux/atomic/atomic-instrumented.h:3188 [inline]
 __vtable_get mm/vswap.h:163 [inline]
 vswap_to_phys mm/vswap.h:202 [inline]
 swap_entry_backend_has_flag+0xea/0x210 mm/vswap.h:409
 do_swap_page+0x767/0x5a20 mm/memory.c:5042
 __collapse_huge_page_swapin mm/khugepaged.c:1152 [inline]
 collapse_huge_page mm/khugepaged.c:1271 [inline]
 mthp_collapse mm/khugepaged.c:1469 [inline]
 collapse_run_pmd+0xaf1/0x5d90 mm/khugepaged.c:2811
 madvise_collapse mm/madvise.c:1026 [inline]
 madvise_vma_behavior+0x17cf/0x4d80 mm/madvise.c:1548
 madvise_walk_vmas+0x576/0xb00 mm/madvise.c:1896
 madvise_do_behavior+0x385/0x540 mm/madvise.c:2091
 do_madvise+0x26f/0x330 mm/madvise.c:2189
 __do_sys_madvise mm/madvise.c:2198 [inline]
 __se_sys_madvise mm/madvise.c:2196 [inline]
 __x64_sys_madvise+0xa6/0xc0 mm/madvise.c:2196
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f7b5939e159
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f7b5a1ff028 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
RAX: ffffffffffffffda RBX: 00007f7b59625fa0 RCX: 00007f7b5939e159
RDX: 0000000000000019 RSI: 0000000000c00000 RDI: 0000200000000000
RBP: 00007f7b5943506b R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f7b59626038 R14: 00007f7b59625fa0 R15: 00007ffe5f2d8d38
 </TASK>
==================================================================


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
