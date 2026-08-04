Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B88142E0B71
	for <cgroups@vger.kernel.org>; Tue,  4 Aug 2026 05:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785821180; cv=none; b=kbeU9hr0iAMLuqz+piozDPzhrJwZw/iauH0owCqxlv4g/Dvpd9DfpxoBvxhdQbKPeiFqkc+NY9WL0RiTdEoRJgEhANCEhP5+3Y36eCv2zUqDgD3g/rxmI7pwa85GLOgMdiftCIgX+kA4JL8Us32886QAl8+xg/AeMIR5qoQ7OV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785821180; c=relaxed/simple;
	bh=WyAXmSV206IYtCsc0weeFchpACEUZHocngoPTQafG20=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=ChY7PL4PZRhQQS8nBMX+Ro6fAbsrdlBRsr0+NHCKfgbpaIHb1A8TxLJ4no7VZztMTMFffduy+ufewkd0RKgamE1RgXPp3yZVcpydJLUp/p8ZBdf/42Seyxt1yvwlLosLKh6r2E1hbhL+h8JV/a//CdvnYMpiNOAb8dLW6C0sZDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-4a41e3d6fe9so5928881b6e.2
        for <cgroups@vger.kernel.org>; Mon, 03 Aug 2026 22:26:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785821177; x=1786425977;
        h=content-type:cc:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=mlb8BHqezSQJOj0/rfvN11ZINMgU2iSwA5QuVq7wAv0=;
        b=eN3EMhieQmmvkIO9nDr/Umob2xtpme4bGxe/vwG0bM+ZZhuiUio9ekFqX1483+G/1x
         DxMZUSbD0xwxrgOarwzxE5RgmLqTbZGwsD/zJLl/tZgkQnCZLQws622vl9YE3sRKS+wK
         II6U2mjjRA0UtyyJ3R38ib5wAqORMljV2rGIu80YHf5XsBMSABQR3w2nm6DCngMvdgEX
         9DS02qJKLdj2XsOJmvhKqZydBjojSPV7zTd5JDMx2s9riQ6NJFgVIze1R78xsOrkuwTu
         kfZO/kHv0eCyZyMfh7UAPPZgZju26iJNwirrCQZSabbUcc9xYweCCXkJ49w0xYUguux+
         k8HQ==
X-Forwarded-Encrypted: i=1; AHgh+Rpqg1OqxfEDQZuUx9Qx/AbPpRS3J87Y859F54o7aku/bEN/+c+N5G7rbwUfAqZW9QTYS+Wj0RSV@vger.kernel.org
X-Gm-Message-State: AOJu0Yxd3vgT2p6c1hyx4P1Z3UKvUFtZcUUKS+SVW5yPqTmYaUqZb9M1
	wnsHEJzUFB8+MiqSY+qbEH1FIXTS1cIEyW5hXgNDaE8JTFBObJiNO385aDb6d4SC2fxv95bplnY
	luwyeeO0CxnnEnIRAsWhR657AW+mNgtmlFJumekeYJZ5cXJCEdzX0dFKQePg=
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:c1f3:b0:4a3:cea7:4ab4 with SMTP id
 5614622812f47-4af5e20b822mr20331960b6e.14.1785821177718; Mon, 03 Aug 2026
 22:26:17 -0700 (PDT)
Date: Mon, 03 Aug 2026 22:26:17 -0700
In-Reply-To: <20260804-mglru-fg-v1-0-4d8dad39dad6@tencent.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a7177f9.d35e88fd.de8b.000b.GAE@google.com>
Subject: [syzbot ci] Re: mm/mglru: frequency guided promotion (MGLRU-FG) and
 flag cleanup
From: syzbot ci <syzbot+ci218ae24e07bfb1fa@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, axelrasmussen@google.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, baoquan.he@linux.dev, cgroups@vger.kernel.org, 
	chenridong@xiaomi.com, chrisl@kernel.org, david@kernel.org, dev.jain@arm.com, 
	devnull@kernel.org, gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, 
	kasong@tencent.com, lance.yang@linux.dev, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, ljs@kernel.org, mhocko@kernel.org, muchun.song@linux.dev, 
	nico.pache@linux.dev, nphamcs@gmail.com, qi.zheng@linux.dev, 
	rientjes@google.com, roman.gushchin@linux.dev, ryan.roberts@arm.com, 
	ryncsn@gmail.com, shakeel.butt@linux.dev, shikemeng@huaweicloud.com, 
	sj@kernel.org, surenb@google.com, tz2294@columbia.edu, usama.arif@linux.dev, 
	vbabka@kernel.org, vernon2gm@gmail.com, wangzicheng@honor.com, 
	weixugc@google.com, willy@infradead.org, ying.huang@linux.alibaba.com, 
	youngjun.park@lge.com, yuanchu@google.com, yuzhao@google.com, ziy@nvidia.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] mm/mglru: frequency guided promotion (MGLRU-FG) and flag cleanup
https://lore.kernel.org/all/20260804-mglru-fg-v1-0-4d8dad39dad6@tencent.com
* [PATCH RFC 01/15] mm/memcontrol: make lru_zone_size atomic and simplify sanity check
* [PATCH RFC 02/15] mm/memcontrol: allow update of LRU statistic without holding LRU lock
* [PATCH RFC 03/15] mm/mglru: introduce and always use helpers for manipulating page flags
* [PATCH RFC 04/15] mm/mglru: make generation page counters atomic
* [PATCH RFC 05/15] mm/mglru: move max_seq read into walk_update_folio
* [PATCH RFC 06/15] mm/mglru: use explicit tier range in read_ctrl_pos()
* [PATCH RFC 07/15] mm/mglru: move refault workingset activation into lru_gen_refault
* [PATCH RFC 08/15] mm/memcg: add folio-based lruvec live helper
* [PATCH RFC 09/15] mm/mglru: frequency guided workingset promotion (MGLRU-FG)
* [PATCH RFC 10/15] mm/mglru: make folio lru referenced times count a generic API
* [PATCH RFC 11/15] mm/mglru: replace folio workinset check and update with new helper
* [PATCH RFC 12/15] mm/smap: report workingset folios as referenced
* [PATCH RFC 13/15] mm/huge_memory: mark file folio as accessed more accurately on split
* [PATCH RFC 14/15] mm/khugepaged: consider workingset folios as referenced
* [PATCH RFC 15/15] mm/madvise: convert to new lru refs API and better support for MGLRU

and found the following issue:
WARNING in folio_inc_lru_refs

Full report is available here:
https://ci.syzbot.org/series/5db36d1d-9faa-4882-9f0d-1a8f52132274

***

WARNING in folio_inc_lru_refs

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
base:      94f9b3980dd446b56acf1dfed649e9b32a9f3813
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/9f324367-2b95-4fd0-9025-fef1ff1f605a/config

page: refcount:3 mapcount:2 mapping:0000000000000000 index:0x0 pfn:0xe4ee
flags: 0xfff00000002000(reserved|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000002000 ffffea0000393b88 ffffea0000393b88 0000000000000000
raw: 0000000000000000 0000000000000000 0000000300000001 0000000000000000
page dumped because: VM_WARN_ON_ONCE_FOLIO(!memcg && !mem_cgroup_disabled())
page_owner info is not present (never set?)
------------[ cut here ]------------
1
WARNING: ./include/linux/memcontrol.h:745 at folio_inc_lru_refs+0xb4f/0xc10, CPU#0: mount/5025
Modules linked in:
CPU: 0 UID: 0 PID: 5025 Comm: mount Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:folio_inc_lru_refs+0xb4f/0xc10
Code: ff 4c 89 e7 e8 c2 ae fd ff e9 e9 fc ff ff e8 18 91 ba ff 4c 89 e7 48 c7 c6 20 90 f8 8b e8 99 b0 1b ff c6 05 a6 a9 34 0e 01 90 <0f> 0b 90 e9 85 f6 ff ff e8 f4 90 ba ff e9 29 f8 ff ff 44 89 f1 80
RSP: 0018:ffffc9000324f4c0 EFLAGS: 00010246
RAX: 8e914a919570c700 RBX: 0000000000000000 RCX: 0000000000000001
RDX: 0000000000000000 RSI: ffffffff8e4b4187 RDI: ffff888174f53c00
RBP: ffffc9000324f5d0 R08: 0000000000000003 R09: 0000000000000004
R10: dffffc0000000000 R11: fffffbfff1d3ca24 R12: ffffea0000393b80
R13: 1ffffd4000072770 R14: 1ffff92000649ea8 R15: dffffc0000000000
FS:  0000000000000000(0000) GS:ffff88818d949000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fb77b215440 CR3: 000000000e946000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 __zap_vma_range+0x20f5/0x4f70
 unmap_vmas+0x390/0x550
 exit_mmap+0x293/0x9f0
 __mmput+0x118/0x420
 exit_mm+0x221/0x2d0
 do_exit+0x6cd/0x2360
 do_group_exit+0x22d/0x2f0
 __x64_sys_exit_group+0x3f/0x40
 x64_sys_call+0x221a/0x2240
 do_syscall_64+0x174/0x580
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fb77b2d3a90
Code: Unable to access opcode bytes at 0x7fb77b2d3a66.
RSP: 002b:00007ffe32d58618 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 00007fb77b3c4860 RCX: 00007fb77b2d3a90
RDX: 00000000000000e7 RSI: 000000000000003c RDI: 0000000000000000
RBP: 00007fb77b3c4860 R08: 00007ffe32d58490 R09: 00007ffe32d58570
R10: 00007ffe32d584d0 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007fb77b3c8658 R15: 0000000000000001
 </TASK>


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
