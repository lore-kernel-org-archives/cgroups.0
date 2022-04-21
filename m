From: Marco Elver <elver-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [syzbot] WARNING in __kfence_free
Date: Thu, 21 Apr 2022 11:12:17 +0200
Message-ID: <YmEf8dpSXJeZ2813@elver.google.com>
References: <000000000000f46c6305dd264f30@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=wrZJAQCvZMNBHOHFxhe/p/8wX8+3w7RNtn7JZy9xcqM=;
        b=HmW83QhkXJPKoQKy3XuO/cRmsKgkVnGWnfYpDhgW61A+z6dWs87PL0jlz8iLGGOec1
         vaI7tJF73I0UQIuIUbdbsTK/fTZe+8GqriBAJftiOrXby9f6TWciCB9Y4B/o+AQO1Poh
         yHxj1b8Dg9m54GlyOmNZotHpQpV0q+vY//48J78vMTl55TwWrkJ3SNrnH6VZSzKxjv+N
         GY82em7XcnAAI1t/rr50dBtIBx+YEZS2REedTF+nIKEXLWu4pkirMAndljTz0jJioQRN
         RraP84hXc91Fo6NElKnSBc7W9MW9akOTu6KjwVzynNc/yMnLCAaQ6oqc6otClWXmRVpJ
         Yhdg==
Content-Disposition: inline
In-Reply-To: <000000000000f46c6305dd264f30-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: syzbot <syzbot+ffe71f1ff7f8061bcc98-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, kasan-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, syzkaller-bugs-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Apr 21, 2022 at 01:58AM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    559089e0a93d vmalloc: replace VM_NO_HUGE_VMAP with VM_ALLO..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=10853220f00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=2e1f9b9947966f42
> dashboard link: https://syzkaller.appspot.com/bug?extid=ffe71f1ff7f8061bcc98
> compiler:       aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> userspace arch: arm64
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+ffe71f1ff7f8061bcc98-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org
> 
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 2216 at mm/kfence/core.c:1022 __kfence_free+0x84/0xc0 mm/kfence/core.c:1022

That's this warning in __kfence_free:

	#ifdef CONFIG_MEMCG
		KFENCE_WARN_ON(meta->objcg);
	#endif

introduced in 8f0b36497303 ("mm: kfence: fix objcgs vector allocation").

Muchun, are there any circumstances where the assumption may be broken?
Or a new bug elsewhere?

> Modules linked in:
> CPU: 0 PID: 2216 Comm: syz-executor.0 Not tainted 5.18.0-rc3-syzkaller-00007-g559089e0a93d #0
> Hardware name: linux,dummy-virt (DT)
> pstate: 80400009 (Nzcv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> pc : __kfence_free+0x84/0xc0 mm/kfence/core.c:1022
> lr : kfence_free include/linux/kfence.h:186 [inline]
> lr : __slab_free+0x2e4/0x4d4 mm/slub.c:3315
> sp : ffff80000a9fb980
> x29: ffff80000a9fb980 x28: ffff80000a280040 x27: f2ff000002c01c00
> x26: ffff00007b694040 x25: ffff00007b694000 x24: 0000000000000001
> x23: ffff00007b694000 x22: ffff00007b694000 x21: f2ff000002c01c00
> x20: ffff80000821accc x19: fffffc0001eda500 x18: 0000000000000002
> x17: 0000000000000000 x16: 0000000000000000 x15: 0000000000000000
> x14: 0000000000000001 x13: 000000000005eb7f x12: f7ff000007a08024
> x11: f7ff000007a08000 x10: 0000000000000000 x9 : 0000000000000014
> x8 : 0000000000000001 x7 : 0000000000094000 x6 : ffff80000a280000
> x5 : ffff80000821accc x4 : ffff80000a50e078 x3 : ffff80000a280348
> x2 : f0ff00001e325c00 x1 : ffff80000a522b40 x0 : ffff00007b694000
> Call trace:
>  __kfence_free+0x84/0xc0 mm/kfence/core.c:1022
>  kfence_free include/linux/kfence.h:186 [inline]
>  __slab_free+0x2e4/0x4d4 mm/slub.c:3315
>  do_slab_free mm/slub.c:3498 [inline]
>  slab_free mm/slub.c:3511 [inline]
>  kfree+0x320/0x37c mm/slub.c:4552
>  kvfree+0x3c/0x50 mm/util.c:615
>  xt_free_table_info+0x78/0x90 net/netfilter/x_tables.c:1212
>  __do_replace+0x240/0x330 net/ipv6/netfilter/ip6_tables.c:1104
>  do_replace net/ipv6/netfilter/ip6_tables.c:1157 [inline]
>  do_ip6t_set_ctl+0x374/0x4e0 net/ipv6/netfilter/ip6_tables.c:1639
>  nf_setsockopt+0x68/0x94 net/netfilter/nf_sockopt.c:101
>  ipv6_setsockopt+0xa8/0x220 net/ipv6/ipv6_sockglue.c:1026
>  tcp_setsockopt+0x38/0xdb4 net/ipv4/tcp.c:3696
>  sock_common_setsockopt+0x1c/0x30 net/core/sock.c:3505
>  __sys_setsockopt+0xa0/0x1c0 net/socket.c:2180
>  __do_sys_setsockopt net/socket.c:2191 [inline]
>  __se_sys_setsockopt net/socket.c:2188 [inline]
>  __arm64_sys_setsockopt+0x2c/0x40 net/socket.c:2188
>  __invoke_syscall arch/arm64/kernel/syscall.c:38 [inline]
>  invoke_syscall+0x48/0x114 arch/arm64/kernel/syscall.c:52
>  el0_svc_common.constprop.0+0x44/0xec arch/arm64/kernel/syscall.c:142
>  do_el0_svc+0x6c/0x84 arch/arm64/kernel/syscall.c:181
>  el0_svc+0x44/0xb0 arch/arm64/kernel/entry-common.c:616
>  el0t_64_sync_handler+0x1a4/0x1b0 arch/arm64/kernel/entry-common.c:634
>  el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:581
> ---[ end trace 0000000000000000 ]---
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
