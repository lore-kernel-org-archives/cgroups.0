From: Daniel Wagner <daniel.wagner-98C5kh4wR6ohFhg+JK9F0w@public.gmane.org>
Subject: Re: [PATCH cgroup/for-4.4-fixes 2/3] cgroup: fix handling of
 multi-destination migration from subtree_control enabling
Date: Tue, 1 Dec 2015 08:02:23 +0100
Message-ID: <565D45FF.1030804@bmw-carit.de>
References: <20151123195541.GA19072@mtj.duckdns.org>
 <56543C76.2050008@bmw-carit.de> <20151124144418.GB17033@mtj.duckdns.org>
 <56547B22.2020802@bmw-carit.de> <20151124145945.GF17033@mtj.duckdns.org>
 <20151130224205.GA9039@mtj.duckdns.org>
 <20151130224431.GB9039@mtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151130224431.GB9039-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Jones <davej-rdkfGonbjUTCLXcRTR1eJlpr/1R2p/CL@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>

Hi Tejun,

On 11/30/2015 11:44 PM, Tejun Heo wrote:
>  WARNING: CPU: 1 PID: 1 at kernel/cgroup_pids.c:97 pids_cancel.constprop.6+0x31/0x40()
>  Modules linked in:
>  CPU: 1 PID: 1 Comm: systemd Not tainted 4.4.0-rc1+ #29
>  ...
>   ffffffff81f65382 ffff88007c043b90 ffffffff81551ffc 0000000000000000
>   ffff88007c043bc8 ffffffff810de202 ffff88007a752000 ffff88007a29ab00
>   ffff88007c043c80 ffff88007a1d8400 0000000000000001 ffff88007c043bd8
>  Call Trace:
>   [<ffffffff81551ffc>] dump_stack+0x4e/0x82
>   [<ffffffff810de202>] warn_slowpath_common+0x82/0xc0
>   [<ffffffff810de2fa>] warn_slowpath_null+0x1a/0x20
>   [<ffffffff8118e031>] pids_cancel.constprop.6+0x31/0x40
>   [<ffffffff8118e0fd>] pids_can_attach+0x6d/0xf0
>   [<ffffffff81188a4c>] cgroup_taskset_migrate+0x6c/0x330
>   [<ffffffff81188e05>] cgroup_migrate+0xf5/0x190
>   [<ffffffff81189016>] cgroup_attach_task+0x176/0x200
>   [<ffffffff8118949d>] __cgroup_procs_write+0x2ad/0x460
>   [<ffffffff81189684>] cgroup_procs_write+0x14/0x20
>   [<ffffffff811854e5>] cgroup_file_write+0x35/0x1c0
>   [<ffffffff812e26f1>] kernfs_fop_write+0x141/0x190
>   [<ffffffff81265f88>] __vfs_write+0x28/0xe0
>   [<ffffffff812666fc>] vfs_write+0xac/0x1a0
>   [<ffffffff81267019>] SyS_write+0x49/0xb0
>   [<ffffffff81bcef32>] entry_SYSCALL_64_fastpath+0x12/0x76
> 
> This patch fixes the bug by removing @css parameter from the three
> migration methods, ->can_attach, ->cancel_attach() and ->attach() and
> updating cgroup_taskset iteration helpers also return the destination
> css in addition to the task being migrated.  All controllers are
> updated accordingly.

I was not able to verify if these two patches are fixing it. I don't see
the call trace on mainline only when using cgroup/review-xt_cgroup2
review branch.

So I ported it to review-xt_croup2 with only a small merge conflict for
in netclassid_cgroup.c. No fun though, I still see it.

Is there a patch missing? The subject indicates there should be 3 patches.

cheers,
daniel
