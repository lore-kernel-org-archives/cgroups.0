Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB099379C5F;
	Wed, 12 Aug 2026 21:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786568640; cv=none; b=lVRjPEoTYQh8iuX6xA/3j+345+bMC0ZfDM3Q6RczNr8K/oY4/i7BoIFv4PYT8nA1MQXDdM7xj691bFCpbPe12Yll6wcx+vFL4/42QT0/b2+IKKMvwyfWAm1tqNJo2DtJM6SpNDe/LPBEWMntDKleh3Ypaexa4WYrNjw4AcM5A/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786568640; c=relaxed/simple;
	bh=Z5EXKxTMBRU3JypOU6kzTx3hK+C/r5M/JNXfz6YmGAg=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=Hqac/MLfK8iSuBOOgWOaaeQq8ZNEYmzZU8xnt8PQV80NukqMXUbKLhTVwXeuFIGAjWwjVyj7+ov4dhiIbD9vOarqVXdXSW0blMIOfZy+uhsPvqJfKv7fMJSm/memThsIeaojrkampTUIJX6/IpoNzVk+2/sAb/mlPrA+D3NaLdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=M7L/CM2k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="M7L/CM2k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 951761F000E9;
	Wed, 12 Aug 2026 21:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786568639;
	bh=kjntp49iT9Wxm1cuWnwjCVqtDnt7W8/fWzirIfwxfgY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=M7L/CM2k5o4Ik35mAzj3NgcfHzwZQf6D1hc7uET1/UnSKnP7AKT2juBm3Bvlso8kN
	 cRNA7/EvQwBAc6qwMlcJggMbUrw1oxKpiBKp5ZRZus38UshDBOW7V1uOqjP1OtQUf5
	 boGRAVO0JuJGU8VWcTWjX4TYLFQeImnlLMw3AknE=
Date: Wed, 12 Aug 2026 14:03:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: syzbot <syzbot+12ee2725d5fde63a9c96@syzkaller.appspotmail.com>
Cc: axelrasmussen@google.com, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, cgroups@vger.kernel.org, david@kernel.org,
 hannes@cmpxchg.org, kasong@tencent.com, kernel-team@meta.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org,
 mhocko@kernel.org, mhocko@suse.com, muchun.song@linux.dev,
 qi.zheng@linux.dev, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 syzkaller-bugs@googlegroups.com, weixugc@google.com, yuanchu@google.com
Subject: Re: [syzbot] [mm?] WARNING in set_mm_walk
Message-Id: <20260812140358.343927ad8d0955b67c4e7ad5@linux-foundation.org>
In-Reply-To: <6a7c6670.3668565d.e8814.0012.GAE@google.com>
References: <6a7a6929.b50370da.49fe0.005e.GAE@google.com>
	<6a7c6670.3668565d.e8814.0012.GAE@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 12 Aug 2026 05:26:24 -0700 syzbot <syzbot+12ee2725d5fde63a9c96@syzkaller.appspotmail.com> wrote:

> syzbot has found a reproducer for the following issue on:
> 
> HEAD commit:    f5bbbfec59b4 Merge tag 'probes-fixes-v7.2-rc7' of git://gi..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=11f44c79580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=c44651ea7dd2f307
> dashboard link: https://syzkaller.appspot.com/bug?extid=12ee2725d5fde63a9c96
> compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10d11149580000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+12ee2725d5fde63a9c96@syzkaller.appspotmail.com
> 
> ------------[ cut here ]------------
> current_is_kswapd()
> WARNING: mm/vmscan.c:3800 at set_mm_walk+0x210/0x270 mm/vmscan.c:3800, CPU#2: kswapd0/111

Thanks.  Shakeel is working on a series which will fix this by removing
the calling code.  But it isn't a minor patch.

Shakeel, it would be good to have a backportable quick-fix to make this
warning go away?

> Modules linked in:
> CPU: 2 UID: 0 PID: 111 Comm: kswapd0 Not tainted syzkaller #0 PREEMPT(full) 
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
> RIP: 0010:set_mm_walk+0x210/0x270 mm/vmscan.c:3800
> Code: 13 00 00 4d 8d 7d 08 e9 f7 fe ff ff e8 19 f7 2a 00 e9 b7 fe ff ff e8 7f 68 ba ff 90 0f 0b 90 e9 d2 fe ff ff e8 71 68 ba ff 90 <0f> 0b 90 e9 74 ff ff ff 4c 89 ff e8 20 f7 2a 00 e9 4e fe ff ff 48
> RSP: 0018:ffffc9000272f2b8 EFLAGS: 00010293
> RAX: 0000000000000000 RBX: ffff888023f04a80 RCX: ffffffff82500a88
> RDX: ffff888023f04a80 RSI: ffffffff82500b0f RDI: ffff888023f04a80
> RBP: 0000000000020000 R08: 0000000000000005 R09: 0000000000000000
> R10: 0000000000020000 R11: 0000000000000000 R12: 0000000000000000
> R13: ffffc9000272fc38 R14: 0000000000000001 R15: ffffc9000272fc40
> FS:  0000000000000000(0000) GS:ffff8880d5fec000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00005643a2ed4168 CR3: 000000003c7ec000 CR4: 0000000000352ef0
> Call Trace:
>  <TASK>
>  try_to_inc_max_seq+0xf0/0x1090 mm/vmscan.c:4023
>  try_to_shrink_lruvec+0x4bd/0x6b0 mm/vmscan.c:4977
>  lru_gen_shrink_lruvec mm/vmscan.c:5128 [inline]
>  shrink_lruvec+0x31e/0x25b0 mm/vmscan.c:5888
>  mem_cgroup_shrink_node+0x227/0x6a0 mm/vmscan.c:6753
>  mem_cgroup_soft_reclaim mm/memcontrol-v1.c:312 [inline]
>  memcg1_soft_limit_reclaim+0x2d5/0x830 mm/memcontrol-v1.c:362
>  balance_pgdat+0xa11/0x1f00 mm/vmscan.c:7177
>  kswapd+0x556/0xb50 mm/vmscan.c:7462
>  kthread+0x370/0x450 kernel/kthread.c:436
>  ret_from_fork+0x72b/0xd50 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>  </TASK>

