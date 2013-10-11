From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: Possible regression with cgroups in 3.11
Date: Fri, 11 Oct 2013 21:06:22 +0800
Message-ID: <5257F7CE.90702@huawei.com>
References: <4431690.ZqnBIdaGMg@akheu22.uni-muenster.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4431690.ZqnBIdaGMg-fhzw3bAB8VLGE+7tAf435K1T39T6GgSB@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Markus Blank-Burian <burian-iYtK5bfT9M8b1SvskN2V4Q@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2013/10/10 16:50, Markus Blank-Burian wrote:
> Hi,
> 

Thanks for the report.

> I have upgraded all nodes on our computing cluster to 3.11.3 last week (from 
> 3.10.9) and experience deadlocks in kernel threads connected to cgroups. They 
> appear sometimes, when our queuing system (slurm 2.6.0) tries to clean up its 
> cgroups (using freezer, cpuset, memory and devices subsets). I have attached 
> the associated kernel messages as well als the cleanup script.
> 

We've changed the cgroup destroy path dramatically including using per-cpu
ref, so those changes probably introduced this bug.

> Oct 10 00:39:48 kaa-14 kernel: [169967.617545] INFO: task kworker/7:0:5201 blocked for more than 120 seconds.
> Oct 10 00:39:48 kaa-14 kernel: [169967.617557] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Oct 10 00:39:48 kaa-14 kernel: [169967.617563] kworker/7:0     D ffff88077e873328     0  5201      2 0x00000000
> Oct 10 00:39:48 kaa-14 kernel: [169967.617583] Workqueue: events cgroup_offline_fn
> Oct 10 00:39:48 kaa-14 kernel: [169967.617590]  ffff8804a4129d70 0000000000000002 ffff8804adc60000 ffff8804a4129fd8
> Oct 10 00:39:48 kaa-14 kernel: [169967.617599]  ffff8804a4129fd8 0000000000011c40 ffff88077e872ee0 ffffffff81634ae0
> Oct 10 00:39:48 kaa-14 kernel: [169967.617608]  ffffffff81634ae4 ffff88077e872ee0 ffffffff81634ae8 00000000ffffffff
> Oct 10 00:39:48 kaa-14 kernel: [169967.617617] Call Trace:
> Oct 10 00:39:48 kaa-14 kernel: [169967.617634]  [<ffffffff813c57e4>] schedule+0x60/0x62
> Oct 10 00:39:48 kaa-14 kernel: [169967.617645]  [<ffffffff813c5a6b>] schedule_preempt_disabled+0x13/0x1f
> Oct 10 00:39:48 kaa-14 kernel: [169967.617654]  [<ffffffff813c4987>] __mutex_lock_slowpath+0x143/0x1d4
> Oct 10 00:39:48 kaa-14 kernel: [169967.617665]  [<ffffffff8105a3e8>] ? arch_vtime_task_switch+0x6a/0x6f
> Oct 10 00:39:48 kaa-14 kernel: [169967.617673]  [<ffffffff813c3b58>] mutex_lock+0x12/0x22
> Oct 10 00:39:48 kaa-14 kernel: [169967.617681]  [<ffffffff81084f4f>] cgroup_offline_fn+0x36/0x137

All the tasks are blocked in cgroup mutex, but it doesn't tell us who's
holding this lock, which is vital.

Is there any other kernel warnings in the kernel log?
