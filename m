Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C3103CC7DB
	for <cgroups@vger.kernel.org>; Tue,  4 Aug 2026 05:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785823012; cv=none; b=pj7Whwkr5W7tczVgOXqKQdKoXMAUFdIJpEUUTyMiztVYU9advVRYI0g0BHWTnhwUCXOF7KGA7GBViKxIW1o1BN5UWKnamqSZQsoD3T2NmJDJ6xOZFNBGZ/ecqjy5uZp8Ig8XdpZTYoLZmB7Gp4tSzt4Uz/C8wwMqSvlAdDuUJMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785823012; c=relaxed/simple;
	bh=XIpcj3r3YcWKiqcpXlC6N+Gs3AESCVhWad1VgzeDsQE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Yhu0moMb03P7GN/psHVOc05lUrTARCPjCQj2PPFKpXA2nw5l26gx5zL+IpjcQx16wquBhOI8Igu0Lgwg6SIXzC5uWmSBliX4RyHuOKLzj5TBOA2R7olair8FlYSlmrjQMpttwN6lBC27fWSuY6RkKJmqJkf7H5ReedvGIBgLXew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rN3DXuby; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rN3DXuby"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-384930ca5e2so3588683a91.3
        for <cgroups@vger.kernel.org>; Mon, 03 Aug 2026 22:56:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785823011; x=1786427811; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=WkkhbIXoG8axKsH27helYvVd967WpJzV0kiVofr/iko=;
        b=rN3DXubya70p72k65TlajjxzUyZY6hRl3ftnucAtNlvZWRRn1u5Aaff4RXj6+aLD8O
         q5dXAmzTwUs4wwCioOkysneQMFLqWtICiyKSfeH9ppBFiHQy9pEv0K5vSErzFXpd8AgN
         5uJXsdkqFeBvd4CpU5w6pb+0z/OWyF12cJK9kUkCAkZaOZKH4uu9f/dCxw5d5zmzDQ8/
         Vbj6TSQCCD7rCqYY9htuKPuw3QY3ItMoYnCNWssMqIqDF574Cu/M4lCh3FXSnh21Mdu8
         dbV4zQvStCwVfINxv2LN/lW2HShBCjW16kve4DZRVNrZNx3CirV7f8IqK2QxmR9/rMWQ
         8Zaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785823011; x=1786427811;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WkkhbIXoG8axKsH27helYvVd967WpJzV0kiVofr/iko=;
        b=oN7NQ2OBqgpzfZ9rY7jXlp3rzXmPrQW23k1Ay7jHQ8MQqHPsj6LFLY0EcPky1SWnKL
         VRe0q8JJv/PO3LBmox15WtokiwmE24shMnj+hNZvZhRNN+mQGBbo4cDGb/2qYOuUIWuI
         D25vZhdJDOx/oM6ZW6OkbWRcKp/eqYWwXzpZ8nXn72iVP0pqLFFrHecjtfqth11QXA1E
         k1evvCmDu8HGyknBpCXBovbXsLjeYHuLWN9wwyeMkyx2+1CAsKM0wHnMV+SkWvCXuvGi
         EDCGlRsSrTaS2otHW+1t3vZnLzihxvh9++jZiduiBV3zrHN0EDpmmIC18PYO3FS94z7p
         D3Lw==
X-Forwarded-Encrypted: i=1; AHgh+RrGzmMaRq0IfrERnuyelmFe6cz6Q5oumJhBmqY+nXY6LaR1Tny8rt418c3+u6YJLSpBi8Dy+0FB@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/zDTp17yYSIGAbpm2g+T3zjjS2vgWvw9IW59HN1/BaKtQZaqO
	2N/aZveAriQT/UPaUaHJxkn9YRa1M5RxKXjC3/cztAjAoR7ih67DYYq6
X-Gm-Gg: AR+sD11XzTQqvgRBxhQHyRw3dHEA6cHLhIHYT4o02ZEu9hTrNXxZYPSqsYgUCxuuJcF
	E7oQbJY8PcShSnf52ktucit9Tk6uLkgfEuj0ivqGInqDuOUi6IUQi15+syqUFQgLKCecbz9GcHA
	f7rmCDn0r40tqJUrFSpCYNJoNE/bpXM0VBJHxILyUqUuq0hQHpx9tlYOktYOD0g2Dv0IDGFJ7bP
	aVyg2Grn5XShG6C9hg0W/QI2R4oW68K0ZFWcBMNfj3rlF/moN3o4osIY32dI0EeE9LDkt5SF96a
	JyAZHwvtzRPQu3FRfyuAyErASbsUOLTLALA7DqzR5KBDS61A2aUllACWkCkHP2j5P9IogVIgzDS
	NEKibWxtabE/vkX2+KheC0uRZZAglvvpisprBU3jB88V9C+hMupAunoUkESzfjym1Ti1VMLGkrt
	5/CyNpQ7w/UB/SnckZh1LKVvpE5rU5Zu8j4WTy4Y2OIXEjMvDo+IDYdZT8T3shWn50RJXFqNR41
	760P2M9kiHtWOJJuNi4LV9lv3Mh8eAFNik=
X-Received: by 2002:a17:90b:2dc7:b0:37f:9ce2:348c with SMTP id 98e67ed59e1d1-38fbc4eead6mr12029409a91.29.1785823010828;
        Mon, 03 Aug 2026 22:56:50 -0700 (PDT)
Received: from KASONG-MC4 ([43.132.141.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38febfd8fecsm759984a91.2.2026.08.03.22.56.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2026 22:56:50 -0700 (PDT)
Date: Tue, 4 Aug 2026 13:56:39 +0800
From: Kairui Song <ryncsn@gmail.com>
To: syzbot ci <syzbot+ci218ae24e07bfb1fa@syzkaller.appspotmail.com>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, baoquan.he@linux.dev, cgroups@vger.kernel.org, 
	chenridong@xiaomi.com, chrisl@kernel.org, david@kernel.org, dev.jain@arm.com, 
	devnull@kernel.org, gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, 
	kasong@tencent.com, lance.yang@linux.dev, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, ljs@kernel.org, mhocko@kernel.org, muchun.song@linux.dev, 
	nico.pache@linux.dev, nphamcs@gmail.com, qi.zheng@linux.dev, rientjes@google.com, 
	roman.gushchin@linux.dev, ryan.roberts@arm.com, shakeel.butt@linux.dev, 
	shikemeng@huaweicloud.com, sj@kernel.org, surenb@google.com, tz2294@columbia.edu, 
	usama.arif@linux.dev, vbabka@kernel.org, vernon2gm@gmail.com, wangzicheng@honor.com, 
	weixugc@google.com, willy@infradead.org, ying.huang@linux.alibaba.com, 
	youngjun.park@lge.com, yuanchu@google.com, yuzhao@google.com, ziy@nvidia.com, 
	syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot ci] Re: mm/mglru: frequency guided promotion (MGLRU-FG)
 and flag cleanup
Message-ID: <anF9cewVHJ-MYdP6@KASONG-MC4>
References: <20260804-mglru-fg-v1-0-4d8dad39dad6@tencent.com>
 <6a7177f9.d35e88fd.de8b.000b.GAE@google.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6a7177f9.d35e88fd.de8b.000b.GAE@google.com>

On Mon, Aug 03, 2026 at 10:26:17PM +0800, syzbot ci wrote:
> syzbot ci has tested the following series
> 
> [v1] mm/mglru: frequency guided promotion (MGLRU-FG) and flag cleanup
> https://lore.kernel.org/all/20260804-mglru-fg-v1-0-4d8dad39dad6@tencent.com
> * [PATCH RFC 01/15] mm/memcontrol: make lru_zone_size atomic and simplify sanity check
> * [PATCH RFC 02/15] mm/memcontrol: allow update of LRU statistic without holding LRU lock
> * [PATCH RFC 03/15] mm/mglru: introduce and always use helpers for manipulating page flags
> * [PATCH RFC 04/15] mm/mglru: make generation page counters atomic
> * [PATCH RFC 05/15] mm/mglru: move max_seq read into walk_update_folio
> * [PATCH RFC 06/15] mm/mglru: use explicit tier range in read_ctrl_pos()
> * [PATCH RFC 07/15] mm/mglru: move refault workingset activation into lru_gen_refault
> * [PATCH RFC 08/15] mm/memcg: add folio-based lruvec live helper
> * [PATCH RFC 09/15] mm/mglru: frequency guided workingset promotion (MGLRU-FG)
> * [PATCH RFC 10/15] mm/mglru: make folio lru referenced times count a generic API
> * [PATCH RFC 11/15] mm/mglru: replace folio workinset check and update with new helper
> * [PATCH RFC 12/15] mm/smap: report workingset folios as referenced
> * [PATCH RFC 13/15] mm/huge_memory: mark file folio as accessed more accurately on split
> * [PATCH RFC 14/15] mm/khugepaged: consider workingset folios as referenced
> * [PATCH RFC 15/15] mm/madvise: convert to new lru refs API and better support for MGLRU
> 
> and found the following issue:
> WARNING in folio_inc_lru_refs
> 
> Full report is available here:
> https://ci.syzbot.org/series/5db36d1d-9faa-4882-9f0d-1a8f52132274
> 
> ***
> 
> WARNING in folio_inc_lru_refs
> 
> tree:      mm-new
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
> base:      94f9b3980dd446b56acf1dfed649e9b32a9f3813
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/9f324367-2b95-4fd0-9025-fef1ff1f605a/config
> 
> page: refcount:3 mapcount:2 mapping:0000000000000000 index:0x0 pfn:0xe4ee
> flags: 0xfff00000002000(reserved|node=0|zone=1|lastcpupid=0x7ff)
> raw: 00fff00000002000 ffffea0000393b88 ffffea0000393b88 0000000000000000
> raw: 0000000000000000 0000000000000000 0000000300000001 0000000000000000
> page dumped because: VM_WARN_ON_ONCE_FOLIO(!memcg && !mem_cgroup_disabled())
> page_owner info is not present (never set?)
> ------------[ cut here ]------------
> 1
> WARNING: ./include/linux/memcontrol.h:745 at folio_inc_lru_refs+0xb4f/0xc10, CPU#0: mount/5025
> Modules linked in:
> CPU: 0 UID: 0 PID: 5025 Comm: mount Not tainted syzkaller #0 PREEMPT(full) 
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
> RIP: 0010:folio_inc_lru_refs+0xb4f/0xc10
> Code: ff 4c 89 e7 e8 c2 ae fd ff e9 e9 fc ff ff e8 18 91 ba ff 4c 89 e7 48 c7 c6 20 90 f8 8b e8 99 b0 1b ff c6 05 a6 a9 34 0e 01 90 <0f> 0b 90 e9 85 f6 ff ff e8 f4 90 ba ff e9 29 f8 ff ff 44 89 f1 80
> RSP: 0018:ffffc9000324f4c0 EFLAGS: 00010246
> RAX: 8e914a919570c700 RBX: 0000000000000000 RCX: 0000000000000001
> RDX: 0000000000000000 RSI: ffffffff8e4b4187 RDI: ffff888174f53c00
> RBP: ffffc9000324f5d0 R08: 0000000000000003 R09: 0000000000000004
> R10: dffffc0000000000 R11: fffffbfff1d3ca24 R12: ffffea0000393b80
> R13: 1ffffd4000072770 R14: 1ffff92000649ea8 R15: dffffc0000000000
> FS:  0000000000000000(0000) GS:ffff88818d949000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fb77b215440 CR3: 000000000e946000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  __zap_vma_range+0x20f5/0x4f70
>  unmap_vmas+0x390/0x550
>  exit_mmap+0x293/0x9f0
>  __mmput+0x118/0x420
>  exit_mm+0x221/0x2d0
>  do_exit+0x6cd/0x2360
>  do_group_exit+0x22d/0x2f0
>  __x64_sys_exit_group+0x3f/0x40
>  x64_sys_call+0x221a/0x2240
>  do_syscall_64+0x174/0x580
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fb77b2d3a90
> Code: Unable to access opcode bytes at 0x7fb77b2d3a66.
> RSP: 002b:00007ffe32d58618 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
> RAX: ffffffffffffffda RBX: 00007fb77b3c4860 RCX: 00007fb77b2d3a90
> RDX: 00000000000000e7 RSI: 000000000000003c RDI: 0000000000000000
> RBP: 00007fb77b3c4860 R08: 00007ffe32d58490 R09: 00007ffe32d58570
> R10: 00007ffe32d584d0 R11: 0000000000000246 R12: 0000000000000000
> R13: 0000000000000000 R14: 00007fb77b3c8658 R15: 0000000000000001
>  </TASK>

OK, so we might hit a uncharged folio in folio_mark_access, which isn't
strange, right now it will just skip the gen bump and work as expected,
problem is it's triggering this warning, and doing redundant work for
lruvec lookup. To fix that, checking flags first then the lruvec should
be good.

Will do in V2.
