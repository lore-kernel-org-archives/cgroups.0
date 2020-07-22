From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: BUG at mm/vmalloc.c:3089! - invalid opcode: 0000 [#1] SMP
 KASAN PTI
Date: Wed, 22 Jul 2020 10:55:14 +0200
Message-ID: <CAK8P3a3br1bDc8C6UjRWzdmwzVV26YYe3ixHV7LH5Z0-OiqPQQ@mail.gmail.com>
References: <CA+G9fYuj3bHUMz8XQztbmTgF0c5+rZ5-FkUjFyvEftej2jLT+Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <ltp-bounces+glt-ltp-list=m.gmane-mx.org-cunTk1MwBs91InPhgRC9rw@public.gmane.org>
In-Reply-To: <CA+G9fYuj3bHUMz8XQztbmTgF0c5+rZ5-FkUjFyvEftej2jLT+Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.linux.it/options/ltp>,
 <mailto:ltp-request-cunTk1MwBs91InPhgRC9rw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linux.it/pipermail/ltp/>
List-Post: <mailto:ltp-cunTk1MwBs91InPhgRC9rw@public.gmane.org>
List-Help: <mailto:ltp-request-cunTk1MwBs91InPhgRC9rw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linux.it/listinfo/ltp>,
 <mailto:ltp-request-cunTk1MwBs91InPhgRC9rw@public.gmane.org?subject=subscribe>
Errors-To: ltp-bounces+glt-ltp-list=m.gmane-mx.org-cunTk1MwBs91InPhgRC9rw@public.gmane.org
Sender: "ltp" <ltp-bounces+glt-ltp-list=m.gmane-mx.org-cunTk1MwBs91InPhgRC9rw@public.gmane.org>
To: Naresh Kamboju <naresh.kamboju-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>, "Uladzislau Rezki (Sony)" <urezki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Hildenbrand <david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkft-triage-cunTk1MwBs8s++Sfvej+rw@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Linux-Next Mailing List <linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Joerg Roedel <jroedel-l3A5Bk7waGM@public.gmane.org>, Dennis Zhou <dennis-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Joel Fernandes <joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Mike Rapoport <rppt-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, Oleksiy Avramchenko <oleksiy.avramchenko-/MT0OVThwyLZJqsBc5GL+g@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, LTP List <ltp-cunTk1MwBs91InPhgRC9rw@public.gmane.org>

Adding Roman Gushchin to Cc, he touched that code recently.

Naresh, if nobody has any immediate ideas, you could double-check by
reverting these commits:

e0b8d00b7561 mm: memcg/percpu: per-memcg percpu memory statistics
99411af13595 mm/percpu: fix 'defined but not used' warning
9398ce6306b6 mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix-fix
54116d471779 mm-memcg-percpu-account-percpu-memory-to-memory-cgroups-fix
ec518e090843 mm: memcg/percpu: account percpu memory to memory cgroups
9bc897d18dc3 percpu: return number of released bytes from pcpu_free_area()

       Arnd

On Wed, Jul 22, 2020 at 10:12 AM Naresh Kamboju
<naresh.kamboju-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
>
> Kernel BUG at mm/vmalloc.c:3089! on x86_64 Kasan configured kernel reported
> this while testing LTP cgroup_fj_stress_memory_4_4_none test cases.
>
> Also found on arm64 and i386 devices and qemu.
>
> metadata:
>   git branch: master
>   git repo: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
>   git commit: de2e69cfe54a8f2ed4b75f09d3110c514f45d38e
>   git describe: next-20200721
>   make_kernelversion: 5.8.0-rc6
>   kernel-config:
> https://builds.tuxbuild.com/zU-I3LEfC1AaKQ59Er60ZQ/kernel.config
>
> crash log,
> [ 1421.080221] ------------[ cut here ]------------
> [ 1421.084874] kernel BUG at mm/vmalloc.c:3089!
> [ 1421.090356] invalid opcode: 0000 [#1] SMP KASAN PTI
> [ 1421.096009] CPU: 1 PID: 19100 Comm: kworker/1:1 Not tainted
> 5.8.0-rc6-next-20200721 #1
> [ 1421.103933] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
> 2.0b 07/27/2017
> [ 1421.111418] Workqueue: events pcpu_balance_workfn
> [ 1421.116138] RIP: 0010:free_vm_area+0x2d/0x30
> [ 1421.120413] Code: e5 41 54 49 89 fc 48 83 c7 08 e8 9e 5e 04 00 49
> 8b 7c 24 08 e8 74 f8 ff ff 49 39 c4 75 0c 4c 89 e7 e8 97 d2 03 00 41
> 5c 5d c3 <0f> 0b 90 48 b8 00 00 00 00 00 fc ff df 55 48 89 e5 41 56 49
> 89 fe
> [ 1421.139154] RSP: 0018:ffff88840142fc80 EFLAGS: 00010282
> [ 1421.144381] RAX: 0000000000000000 RBX: ffff88841b843738 RCX: ffffffff86ca1d78
> [ 1421.151515] RDX: dffffc0000000000 RSI: 0000000000000004 RDI: ffff8883bfacd630
> [ 1421.158647] RBP: ffff88840142fc88 R08: 0000000000000001 R09: ffffed1080285f7e
> [ 1421.165780] R10: 0000000000000003 R11: ffffed1080285f7d R12: ffff888409e89880
> [ 1421.172913] R13: ffff88841b843730 R14: 0000000000000080 R15: 0000000000000080
> [ 1421.180045] FS:  0000000000000000(0000) GS:ffff88841fa80000(0000)
> knlGS:0000000000000000
> [ 1421.188132] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 1421.193876] CR2: 00007f1230b41080 CR3: 000000025d40e002 CR4: 00000000003706e0
> [ 1421.201008] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [ 1421.208132] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [ 1421.215255] Call Trace:
> [ 1421.217703]  pcpu_free_vm_areas+0x30/0x44
> [ 1421.221714]  pcpu_balance_workfn+0x7bd/0x8f0
> [ 1421.225987]  ? pcpu_create_chunk+0x2f0/0x2f0
> [ 1421.230261]  ? read_word_at_a_time+0x12/0x20
> [ 1421.234531]  ? strscpy+0xc1/0x190
> [ 1421.237842]  process_one_work+0x474/0x7b0
> [ 1421.241856]  worker_thread+0x7b/0x6a0
> [ 1421.245521]  ? wake_up_process+0x10/0x20
> [ 1421.249448]  ? process_one_work+0x7b0/0x7b0
> [ 1421.253635]  kthread+0x1aa/0x200
> [ 1421.256867]  ? kthread_create_on_node+0xd0/0xd0
> [ 1421.261400]  ret_from_fork+0x22/0x30
> [ 1421.264978] Modules linked in: x86_pkg_temp_thermal
> [ 1421.269869] ---[ end trace 6352cf97284f07da ]---
> [ 1421.274955] RIP: 0010:free_vm_area+0x2d/0x30
> [ 1421.281026] Code: e5 41 54 49 89 fc 48 83 c7 08 e8 9e 5e 04 00 49
> 8b 7c 24 08 e8 74 f8 ff ff 49 39 c4 75 0c 4c 89 e7 e8 97 d2 03 00 41
> 5c 5d c3 <0f> 0b 90 48 b8 00 00 00 00 00 fc ff df 55 48 89 e5 41 56 49
> 89 fe
> [ 1421.300553] RSP: 0018:ffff88840142fc80 EFLAGS: 00010282
> [ 1421.307051] RAX: 0000000000000000 RBX: ffff88841b843738 RCX: ffffffff86ca1d78
> [ 1421.314184] RDX: dffffc0000000000 RSI: 0000000000000004 RDI: ffff8883bfacd630
> [ 1421.321317] RBP: ffff88840142fc88 R08: 0000000000000001 R09: ffffed1080285f7e
> [ 1421.328477] R10: 0000000000000003 R11: ffffed1080285f7d R12: ffff888409e89880
> [ 1421.335639] R13: ffff88841b843730 R14: 0000000000000080 R15: 0000000000000080
> [ 1421.342777] FS:  0000000000000000(0000) GS:ffff88841fa80000(0000)
> knlGS:0000000000000000
> [ 1421.350870] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 1421.356643] CR2: 00007f1230b41080 CR3: 000000025d40e002 CR4: 00000000003706e0
> [ 1421.363811] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [ 1421.370951] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
>
> Full test log,
> https://qa-reports.linaro.org/lkft/linux-next-oe/build/next-20200721/testrun/2972982/suite/linux-log-parser/test/check-kernel-bug-1594684/log
>
> --
> Linaro LKFT
> https://lkft.linaro.org

-- 
Mailing list info: https://lists.linux.it/listinfo/ltp
