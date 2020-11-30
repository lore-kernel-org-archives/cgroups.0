From: Naresh Kamboju <naresh.kamboju-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: BUG: KASAN: null-ptr-deref in workingset_eviction+0xf2/0x1e0
Date: Tue, 1 Dec 2020 01:22:19 +0530
Message-ID: <CA+G9fYtk3fKy7ct-rT=T8iFDhE4CbjGgdfxsOBrKT9y8ntwXyg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=X3Vr4E8wMiXiu3IrKPCoWETeTkfDfowMAdH4jJJqcSs=;
        b=J7onZtiB8FF/YfyJqSV4J4xoMMpY0muTQW5BekU8QlURrIk7y2RjX0At1f4im7h2vA
         rH60zwQQ8WHrpr+HQM81ryOIAJwtT6V5ZMcJopCQiwQ4vNw8NMUQtRd2liXr8AOkdDO2
         2NlhykdHR3GAruQTIBsfOllVHtTJtFafyPkicsF3RYX511VD5Ku1Pg1zL9VzOc0p6JBD
         VHc6O1SAiUmNpwXM2af7pNB4cjOTYwOMXCHXvnGt591rBsXVzqg6iOw2IQe7EilgQPVc
         b0rT5IJs0eFXrAVWMIxQ4bBzCYVBEmHoOSf26CWWB1kKjo9tnWF04YQs1TGf3I8zO4mH
         ylFQ==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: inux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux-Next Mailing List <linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkft-triage-cunTk1MwBs8s++Sfvej+rw@public.gmane.org
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, alexander.h.duyck-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, richard.weiyang-Re5JQEeQqe8@public.gmane.org, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>

While running LTP syscalls ioctl_sg01 test case this kernel crash reported on
x86_64 and i386 running today's Linux next tag 20201130.

Steps to reproduce:
--------------------
# TuxMake is a command line tool and Python library that provides
# portable and repeatable Linux kernel builds across a variety of
# architectures, toolchains, kernel configurations, and make targets.
#
# TuxMake supports the concept of runtimes.
# See https://docs.tuxmake.org/runtimes/, for that to work it requires
# that you install podman or docker on your system.
#
# To install tuxmake on your system globally:
# sudo pip3 install -U tuxmake
#
# See https://docs.tuxmake.org/ for complete documentation.

# tuxmake --runtime docker --target-arch x86 --toolchain gcc-9
--kconfig defconfig --kconfig-add
https://builds.tuxbuild.com/1l0FDtgxYSNunuG5ERIXtvPjZ7R/config
# run LTP
# cd /opt/ltp
# ./runltp -s ioctl_sg01
# you see below crash

Crash log:
-----------
ioctl_sg01.c:81: TINFO: Found SCSI device /dev/sg1
[  285.862123] ==================================================================
[  285.863025] BUG: KASAN: null-ptr-deref in workingset_eviction+0xf2/0x1e0
[  285.863025] Read of size 4 at addr 00000000000000c8 by task kswapd0/245
[  285.863025]
[  285.863025] CPU: 1 PID: 245 Comm: kswapd0 Not tainted
5.10.0-rc5-next-20201130 #2
[  285.863025] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS 1.12.0-1 04/01/2014
[  285.863025] Call Trace:
[  285.863025]  dump_stack+0xa4/0xd9
[  285.863025]  ? workingset_eviction+0xf2/0x1e0
[  285.863025]  kasan_report.cold+0x108/0x10a
[  285.863025]  ? workingset_eviction+0xf2/0x1e0
[  285.863025]  __asan_load4+0x88/0xb0
[  285.863025]  workingset_eviction+0xf2/0x1e0
[  285.863025]  ? __kasan_check_read+0x11/0x20
[  285.863025]  __remove_mapping+0x2b6/0x350
[  285.863025]  shrink_page_list+0xcfb/0x16e0
[  285.863025]  ? pageout+0x670/0x670
[  285.863025]  ? __kasan_check_write+0x14/0x20
[  285.863025]  ? shrink_inactive_list+0x2cc/0x6b0
[  285.863025]  ? shrink_lruvec+0x680/0x9b0
[  285.863025]  shrink_inactive_list+0x361/0x6b0
[  285.863025]  ? isolate_lru_pages+0x710/0x710
[  285.863025]  ? lruvec_lru_size+0xab/0x130
[  285.863025]  shrink_lruvec+0x680/0x9b0
[  285.863025]  ? shrink_active_list+0x810/0x810
[  285.863025]  ? __update_load_avg_cfs_rq+0x1b7/0x560
[  285.863025]  ? mem_cgroup_iter+0xde/0x4d0
[  285.863025]  shrink_node+0x753/0xcc0
[  285.863025]  balance_pgdat+0x42a/0x7b0
[  285.863025]  ? __node_reclaim+0x3d0/0x3d0
[  285.863025]  ? __schedule+0x6cc/0x11d0
[  285.863025]  ? find_next_bit+0x14/0x20
[  285.863025]  ? cpumask_next+0x1a/0x20
[  285.863025]  kswapd+0x3a8/0x650
[  285.863025]  ? balance_pgdat+0x7b0/0x7b0
[  285.863025]  ? _raw_spin_unlock_irqrestore+0x34/0x40
[  285.863025]  ? __kthread_parkme+0x6d/0xb0
[  285.863025]  ? wait_woken+0x120/0x120
[  285.863025]  ? __kasan_check_read+0x11/0x20
[  285.863025]  ? balance_pgdat+0x7b0/0x7b0
[  285.863025]  kthread+0x1bd/0x210
[  285.863025]  ? kthread_create_on_node+0xd0/0xd0
[  285.863025]  ret_from_fork+0x22/0x30
[  285.863025] ==================================================================
[  285.863025] Disabling lock debugging due to kernel taint
[  285.863025] BUG: kernel NULL pointer dereference, address: 00000000000000c8
[  285.863025] #PF: supervisor read access in kernel mode
[  285.863025] #PF: error_code(0x0000) - not-present page
[  285.863025] PGD 1060fd067 P4D 1060fd067 PUD 108d6e067 PMD 0
[  285.863025] Oops: 0000 [#1] SMP KASAN NOPTI
[  285.863025] CPU: 1 PID: 245 Comm: kswapd0 Tainted: G    B
  5.10.0-rc5-next-20201130 #2
[  285.863025] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS 1.12.0-1 04/01/2014
[  285.863025] RIP: 0010:workingset_eviction+0xf2/0x1e0
[  285.863025] Code: 0f 1f 44 00 00 49 8d bf a8 02 00 00 e8 f7 ee 07
00 4d 8b a7 a8 02 00 00 0f 1f 44 00 00 49 8d bc 24 c8 00 00 00 e8 7e
ed 07 00 <41> 0f b7 94 24 c8 00 00 00 4d 8d 67 68 be 08 00 00 00 48 89
55 d0
[  285.863025] RSP: 0018:ffff8881021e7550 EFLAGS: 00010082
[  285.863025] RAX: 0000000000000001 RBX: ffffea000429c200 RCX: ffffffff980ac1d7
[  285.863025] RDX: 1ffffffff33692dc RSI: 0000000000000046 RDI: ffffffff99b496e0
[  285.863025] RBP: ffff8881021e7580 R08: 0000000000000001 R09: fffffbfff335d4d9
[  285.863025] R10: ffffffff99aea6c7 R11: fffffbfff335d4d8 R12: 0000000000000000
[  285.863025] R13: ffff88813fffa000 R14: ffff88813fffd440 R15: ffff88813fffd520
[  285.863025] FS:  0000000000000000(0000) GS:ffff88811b480000(0000)
knlGS:0000000000000000
[  285.863025] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  285.863025] CR2: 00000000000000c8 CR3: 000000010a998000 CR4: 00000000003506e0
[  285.863025] Call Trace:
[  285.863025]  ? __kasan_check_read+0x11/0x20
[  285.863025]  __remove_mapping+0x2b6/0x350
[  285.863025]  shrink_page_list+0xcfb/0x16e0
[  285.863025]  ? pageout+0x670/0x670
[  285.863025]  ? __kasan_check_write+0x14/0x20
[  285.863025]  ? shrink_inactive_list+0x2cc/0x6b0
[  285.863025]  ? shrink_lruvec+0x680/0x9b0
[  285.863025]  shrink_inactive_list+0x361/0x6b0
[  285.863025]  ? isolate_lru_pages+0x710/0x710
[  285.863025]  ? lruvec_lru_size+0xab/0x130
[  285.863025]  shrink_lruvec+0x680/0x9b0
[  285.863025]  ? shrink_active_list+0x810/0x810
[  285.863025]  ? __update_load_avg_cfs_rq+0x1b7/0x560
[  285.863025]  ? mem_cgroup_iter+0xde/0x4d0
[  285.863025]  shrink_node+0x753/0xcc0
[  285.863025]  balance_pgdat+0x42a/0x7b0
[  285.863025]  ? __node_reclaim+0x3d0/0x3d0
[  285.863025]  ? __schedule+0x6cc/0x11d0
[  285.863025]  ? find_next_bit+0x14/0x20
[  285.863025]  ? cpumask_next+0x1a/0x20
[  285.863025]  kswapd+0x3a8/0x650
[  285.863025]  ? balance_pgdat+0x7b0/0x7b0
[  285.863025]  ? _raw_spin_unlock_irqrestore+0x34/0x40
[  285.863025]  ? __kthread_parkme+0x6d/0xb0
[  285.863025]  ? wait_woken+0x120/0x120
[  285.863025]  ? __kasan_check_read+0x11/0x20
[  285.863025]  ? balance_pgdat+0x7b0/0x7b0
[  285.863025]  kthread+0x1bd/0x210
[  285.863025]  ? kthread_create_on_node+0xd0/0xd0
[  285.863025]  ret_from_fork+0x22/0x30
[  285.863025] Modules linked in: tun
[  285.863025] CR2: 00000000000000c8
[  285.863025] ---[ end trace 060018eba39c640c ]---
[  285.863025] RIP: 0010:workingset_eviction+0xf2/0x1e0
[  285.863025] Code: 0f 1f 44 00 00 49 8d bf a8 02 00 00 e8 f7 ee 07
00 4d 8b a7 a8 02 00 00 0f 1f 44 00 00 49 8d bc 24 c8 00 00 00 e8 7e
ed 07 00 <41> 0f b7 94 24 c8 00 00 00 4d 8d 67 68 be 08 00 00 00 48 89
55 d0
[  285.863025] RSP: 0018:ffff8881021e7550 EFLAGS: 00010082
[  285.863025] RAX: 0000000000000001 RBX: ffffea000429c200 RCX: ffffffff980ac1d7
[  285.863025] RDX: 1ffffffff33692dc RSI: 0000000000000046 RDI: ffffffff99b496e0
[  285.863025] RBP: ffff8881021e7580 R08: 0000000000000001 R09: fffffbfff335d4d9
[  285.863025] R10: ffffffff99aea6c7 R11: fffffbfff335d4d8 R12: 0000000000000000
[  285.863025] R13: ffff88813fffa000 R14: ffff88813fffd440 R15: ffff88813fffd520
[  285.863025] FS:  0000000000000000(0000) GS:ffff88811b480000(0000)
knlGS:0000000000000000
[  285.863025] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  285.863025] CR2: 00000000000000c8 CR3: 000000010a998000 CR4: 00000000003506e0
[  285.863025] note: kswapd0[245] exited with preempt_count 1

Reported-by: Naresh Kamboju <naresh.kamboju-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

Full test log link,
https://lkft.validation.linaro.org/scheduler/job/1993290#L7948
https://lkft.validation.linaro.org/scheduler/job/1993236#L8528

metadata:
  git branch: master
  git repo: https://gitlab.com/Linaro/lkft/mirrors/next/linux-next
  git commit: c6b11acc5f85b6e11d128fad8e0b7b223aa7e33f
  git describe: next-20201130
  make_kernelversion: 5.10.0-rc5
  kernel-config: https://builds.tuxbuild.com/1l0FDtgxYSNunuG5ERIXtvPjZ7R/config


-- 
Linaro LKFT
https://lkft.linaro.org
