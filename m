From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] memcg: css_alloc should return an ERR_PTR value on error
Date: Tue, 21 Jun 2016 14:10:02 -0400
Message-ID: <20160621181002.GA4501@cmpxchg.org>
References: <20160621165740.GJ3262@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160621165740.GJ3262@mtj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov@virtuozzo.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Tue, Jun 21, 2016 at 12:57:40PM -0400, Tejun Heo wrote:
> mem_cgroup_css_alloc() was returning NULL on failure while cgroup core
> expected it to return an ERR_PTR value leading to the following NULL
> deref after a css allocation failure.  Fix it by return
> ERR_PTR(-ENOMEM) instead.  I'll also update cgroup core so that it
> can handle NULL returns.
> 
>   mkdir: page allocation failure: order:6, mode:0x240c0c0(GFP_KERNEL|__GFP_COMP|__GFP_ZERO)
>   CPU: 0 PID: 8738 Comm: mkdir Not tainted 4.7.0-rc3+ #123
>   ...
>   Call Trace:
>    [<ffffffff81321937>] dump_stack+0x68/0xa1
>    [<ffffffff811522f6>] warn_alloc_failed+0xd6/0x130
>    [<ffffffff81152816>] __alloc_pages_nodemask+0x4c6/0xf20
>    [<ffffffff8119df86>] alloc_pages_current+0x66/0xe0
>    [<ffffffff81153564>] alloc_kmem_pages+0x14/0x80
>    [<ffffffff811705ca>] kmalloc_order_trace+0x2a/0x1a0
>    [<ffffffff811a7a61>] __kmalloc+0x291/0x310
>    [<ffffffff811718dc>] memcg_update_all_caches+0x6c/0x130
>    [<ffffffff818d0290>] mem_cgroup_css_alloc+0x590/0x610
>    [<ffffffff810f4c7b>] cgroup_apply_control_enable+0x18b/0x370
>    [<ffffffff810f8afe>] cgroup_mkdir+0x1de/0x2e0
>    [<ffffffff8123cf35>] kernfs_iop_mkdir+0x55/0x80
>    [<ffffffff811c6599>] vfs_mkdir+0xb9/0x150
>    [<ffffffff811cc666>] SyS_mkdir+0x66/0xd0
>    [<ffffffff81002df3>] do_syscall_64+0x53/0x120
>    [<ffffffff818d719a>] entry_SYSCALL64_slow_path+0x25/0x25
>   ...
>   BUG: unable to handle kernel NULL pointer dereference at 00000000000000d0
>   IP: [<ffffffff810f2ca7>] init_and_link_css+0x37/0x220
>   PGD 34b1e067 PUD 3a109067 PMD 0 
>   Oops: 0002 [#1] SMP
>   Modules linked in:
>   CPU: 0 PID: 8738 Comm: mkdir Not tainted 4.7.0-rc3+ #123
>   Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.9.2-20160422_131301-anatol 04/01/2014
>   task: ffff88007cbc5200 ti: ffff8800666d4000 task.ti: ffff8800666d4000
>   RIP: 0010:[<ffffffff810f2ca7>]  [<ffffffff810f2ca7>] init_and_link_css+0x37/0x220
>   RSP: 0018:ffff8800666d7d90  EFLAGS: 00010246
>   RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
>   RDX: ffffffff810f2499 RSI: 0000000000000000 RDI: 0000000000000008
>   RBP: ffff8800666d7db8 R08: 0000000000000003 R09: 0000000000000000
>   R10: 0000000000000001 R11: 0000000000000000 R12: ffff88005a5fb400
>   R13: ffffffff81f0f8a0 R14: ffff88005a5fb400 R15: 0000000000000010
>   FS:  00007fc944689700(0000) GS:ffff88007fc00000(0000) knlGS:0000000000000000
>   CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>   CR2: 00007f3aed0d2b80 CR3: 000000003a1e8000 CR4: 00000000000006f0
>   DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>   DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>   Stack:
>    ffffffff81f0f8a0 ffffffff81f0f8a0 ffff88005a5fb400 0000000000000000
>    ffff88005a5fb400 ffff8800666d7e18 ffffffff810f4c9c ffff88005a5fb400
>    ffffffff82d23470 ffff88007cbc57f0 ffff88007cbc5200 ffff88007d013000
>   Call Trace:
>    [<ffffffff810f4c9c>] cgroup_apply_control_enable+0x1ac/0x370
>    [<ffffffff810f8afe>] cgroup_mkdir+0x1de/0x2e0
>    [<ffffffff8123cf35>] kernfs_iop_mkdir+0x55/0x80
>    [<ffffffff811c6599>] vfs_mkdir+0xb9/0x150
>    [<ffffffff811cc666>] SyS_mkdir+0x66/0xd0
>    [<ffffffff81002df3>] do_syscall_64+0x53/0x120
>    [<ffffffff818d719a>] entry_SYSCALL64_slow_path+0x25/0x25
>   Code: 89 f5 48 89 fb 49 89 d4 48 83 ec 08 8b 05 72 3b d8 00 85 c0 0f 85 60 01 00 00 4c 89 e7 e8 72 f7 ff ff 48 8d 7b 08 48 89 d9 31 c0 <48> c7 83 d0 00 00 00 00 00 00 00 48 83 e7 f8 48 29 f9 81 c1 d8 
>   RIP  [<ffffffff810f2ca7>] init_and_link_css+0x37/0x220
>    RSP <ffff8800666d7d90>
>   CR2: 00000000000000d0
>   ---[ end trace a2d8836ae1e852d1 ]---
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: Johannes Weiner <hannes@cmpxchg.org>
> Cc: stable@vger.kernel.org

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

Btw, Vladimir, the order 6 allocation from kmemcg is interesting. I
thought we are freeing the index and shrinking the cache array during
offline, but it seems that isn't happening for some reason - until the
array grows to 256k. Any idea what could be pinning the index?
