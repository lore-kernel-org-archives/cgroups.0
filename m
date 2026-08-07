Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68E673B8D70
	for <cgroups@vger.kernel.org>; Fri,  7 Aug 2026 07:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786087307; cv=none; b=YA3Im2PferD+KYS8qbqnHCvcYDVG4RQw3nvxHhXa/b7BnP3/eZIU9tTYQmM2rNvE1OeJeuzkBpY5DqzRmXUB/Juhwdatv7aoktbuop+rTftZMH9z6nizGDtpCPZpFXfG1RXCfF5fULGg65NfedSrdgefMQRXw/nUPkC9PZwZ1vY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786087307; c=relaxed/simple;
	bh=sODOpdzjCpH/tq/ElSBVsdqLUkhfKBufQNYjtkcKSoY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=U7lQYteEBDAIgumIsJsdlwyJXyeH7B3wqJ9wqSfE8Vgs/v4Gk7cOH+sV0aGJ8SePGgkRKKm38NOC12HvkeHVcN0qgCQoPjMcrftXXpsn9PlSf9SLJImJc2JzZNjiz0M5S7QJ5gt+i9NciorlTRGwxIfGpbcetinvbT5XKEGsiPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HNRCUnbF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HNRCUnbF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 359521F00ADF
	for <cgroups@vger.kernel.org>; Fri,  7 Aug 2026 07:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786087305;
	bh=6knPXuawpByGmHYtyjqi3P0YpFZD/HtTUFoZPvYRqx8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=HNRCUnbFaam/k5LgBTYP/e6dtJ7kDEWtYzOhDewwe8Er1hfweJSQYSRyo6dzVkgJQ
	 eRnrcNOVLNuuVWsQ1aqV5NJ0uAIEDfHGGh+d3ylc39ThDzBeTR0teEYM8wCIJp+SV6
	 zQ1xH5NBr/Pcs6NuIT1ZoteqSlS8sATsjlD5a+zsl7d/W6wsJjx9AR5C8YfpXVixTq
	 IYg/kMlenwslbTydnxz5YRtD1jbi6IgpmhtBeYK8h+1oG+UKtsZYeO8kDpPCmJ1w4n
	 HEXdAMYl6Yio7PLL4ivbbqGxn1hCEXhwMQm8OjUD620gFi38aNjmn+FMP0NRD9VCHm
	 OSJOF8KAVMxjQ==
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-80e24970f1dso25596897b3.0
        for <cgroups@vger.kernel.org>; Fri, 07 Aug 2026 00:21:45 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RoL18rl6eufgnRbKMfhK6yEsgHJqJ6B5hpUG585bPuVS7sHJa0AmqTZAad5MzH2EMJDj0Q6GFKW@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6hqH5IJq+AjQpe2GlGyD/Imk9uBAvCwB5GY/xV247qRz2wWND
	wwpHDsg2Id41YMDJBkPZOHfS8SrNzfrXiQ6pE08BptamJYC+zhyl+3tHPNaLhxz2iVuEwQOu8dH
	fY6R0gA/jqAWUxJRpDtereGqxBCowZgrz8dOUwbjbaQ==
X-Received: by 2002:a05:690c:b98:b0:820:b24:27c7 with SMTP id
 00721157ae682-82258a8f2e6mr43057887b3.14.1786087304379; Fri, 07 Aug 2026
 00:21:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260806184254.3790858-1-nphamcs@gmail.com> <6a756c71.01d0871a.3a0d52.003a.GAE@google.com>
In-Reply-To: <6a756c71.01d0871a.3a0d52.003a.GAE@google.com>
From: Chris Li <chrisl@kernel.org>
Date: Fri, 7 Aug 2026 00:21:33 -0700
X-Gmail-Original-Message-ID: <CACePvbVKpkyV7KpUoiYPTUN0MgEcRUzZL71qTL5ePyjHTA3Kbg@mail.gmail.com>
X-Gm-Features: AUfX_mztVbvHM-WKo6lxh0LLm1G5XKwrWW650OzZbqB3e06Q5YutiaN72WNICvM
Message-ID: <CACePvbVKpkyV7KpUoiYPTUN0MgEcRUzZL71qTL5ePyjHTA3Kbg@mail.gmail.com>
Subject: Re: [syzbot ci] Re: Virtual Swap Space (Swap Table Edition)
To: Nhat Pham <nphamcs@gmail.com>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, baohua@kernel.org, 
	baoquan.he@linux.dev, cgroups@vger.kernel.org, chengming.zhou@linux.dev, 
	corbet@lwn.net, david@kernel.org, gourry@gourry.net, hannes@cmpxchg.org, 
	haowenchao22@gmail.com, kasong@tencent.com, kernel-team@meta.com, 
	liam@infradead.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, ljs@kernel.org, mhocko@kernel.org, muchun.song@linux.dev, 
	qi.zheng@linux.dev, riel@surriel.com, roman.gushchin@linux.dev, 
	rppt@kernel.org, shakeel.butt@linux.dev, shikemeng@huaweicloud.com, 
	surenb@google.com, vbabka@kernel.org, weixugc@google.com, yosry@kernel.org, 
	youngjun.park@lge.com, yuanchu@google.com, syzbot@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Nhat,

On Thu, Aug 6, 2026 at 10:26=E2=80=AFPM syzbot ci
<syzbot+cif942a042aaa8793c@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v3] Virtual Swap Space (Swap Table Edition)
> https://lore.kernel.org/all/20260806184254.3790858-1-nphamcs@gmail.com
> * [PATCH v3 01/11] mm, swap: add virtual swap device infrastructure
> * [PATCH v3 02/11] mm, swap: support zswap and zeroswap as vswap backends
> * [PATCH v3 03/11] mm, swap: prepare the swap IO path for vswap
> * [PATCH v3 04/11] mm, swap: support physical swap as a vswap backend
> * [PATCH v3 05/11] mm, swap: enable THP swapin for vswap entries
> * [PATCH v3 06/11] mm, swap: write back vswap zswap entries to physical s=
wap
> * [PATCH v3 07/11] mm, swap: reclaim physical slots backing cache-only vs=
wap entries
> * [PATCH v3 08/11] mm, swap: only charge physical swap entries
> * [PATCH v3 09/11] mm, swap: add debugfs counters for vswap
> * [PATCH v3 10/11] mm, swap: defer memcg_table allocation for physical sw=
ap clusters
> * [PATCH v3 11/11] mm, swap: widen swap_info_struct max/pages to unsigned=
 long
>
> and found the following issue:
> KASAN: null-ptr-deref Read in swap_entry_backend_has_flag
>
> Full report is available here:
> https://ci.syzbot.org/series/e7da1097-3230-4e50-80cb-1dfafeebea40

Please take a look at the syzbot report and let us know what you think.

Chris

>
> ***
>
> KASAN: null-ptr-deref Read in swap_entry_backend_has_flag
>
> tree:      linux-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/=
linux-next
> base:      bacc32cc7de65ffff70080a48eb294f89e434d5e
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~e=
xp1~20260613092250.77), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/4f943657-9481-4637-9b1f-9be1bff18=
f92/config
> syz repro: https://ci.syzbot.org/findings/f6c4f1ab-951c-4759-b397-e22c23c=
3bf32/syz_repro
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KASAN: null-ptr-deref in instrument_atomic_read include/linux/instru=
mented.h:82 [inline]
> BUG: KASAN: null-ptr-deref in atomic_long_read include/linux/atomic/atomi=
c-instrumented.h:3188 [inline]
> BUG: KASAN: null-ptr-deref in __vtable_get mm/vswap.h:147 [inline]
> BUG: KASAN: null-ptr-deref in vswap_to_phys mm/vswap.h:197 [inline]
> BUG: KASAN: null-ptr-deref in swap_entry_backend_has_flag+0xfe/0x220 mm/v=
swap.h:441
> Read of size 8 at addr 0000000000000000 by task syz.2.20/5818
>
> CPU: 1 UID: 0 PID: 5818 Comm: syz.2.20 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  kasan_report+0x117/0x150 mm/kasan/report.c:595
>  check_region_inline mm/kasan/generic.c:-1 [inline]
>  kasan_check_range+0x264/0x2c0 mm/kasan/generic.c:200
>  instrument_atomic_read include/linux/instrumented.h:82 [inline]
>  atomic_long_read include/linux/atomic/atomic-instrumented.h:3188 [inline=
]
>  __vtable_get mm/vswap.h:147 [inline]
>  vswap_to_phys mm/vswap.h:197 [inline]
>  swap_entry_backend_has_flag+0xfe/0x220 mm/vswap.h:441
>  do_swap_page+0x3c0/0x5620 mm/memory.c:4975
>  __collapse_huge_page_swapin mm/khugepaged.c:1202 [inline]
>  collapse_huge_page mm/khugepaged.c:1325 [inline]
>  mthp_collapse mm/khugepaged.c:1524 [inline]
>  collapse_scan_pmd mm/khugepaged.c:1786 [inline]
>  collapse_single_pmd+0x24c6/0x3da0 mm/khugepaged.c:2803
>  madvise_collapse+0x2cf/0x790 mm/khugepaged.c:3237
>  madvise_vma_behavior+0x115f/0x4170 mm/madvise.c:1363
>  madvise_walk_vmas+0x576/0xb00 mm/madvise.c:1712
>  madvise_do_behavior+0x385/0x540 mm/madvise.c:1907
>  do_madvise+0x327/0x3a0 mm/madvise.c:2005
>  __do_sys_madvise mm/madvise.c:2014 [inline]
>  __se_sys_madvise mm/madvise.c:2012 [inline]
>  __x64_sys_madvise+0xa6/0xc0 mm/madvise.c:2012
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fbcad79e019
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fbcae5c4028 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
> RAX: ffffffffffffffda RBX: 00007fbcada25fa0 RCX: 00007fbcad79e019
> RDX: 0000000000000019 RSI: 0000000000c00000 RDI: 0000200000000000
> RBP: 00007fbcad83500c R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fbcada26038 R14: 00007fbcada25fa0 R15: 00007fff095fa0b8
>  </TASK>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>
> ***
>
> If these findings have caused you to resend the series or submit a
> separate fix, please add the following tag to your commit message:
>   Tested-by: syzbot@syzkaller.appspotmail.com
>
> ---
> This report is generated by a bot. It may contain errors.
> syzbot ci engineers can be reached at syzkaller@googlegroups.com.
>
> To test a patch for this bug, please reply with `#syz test`
> (should be on a separate line).
>
> The patch should be attached to the email.
> Note: arguments like custom git repos and branches are not supported.
