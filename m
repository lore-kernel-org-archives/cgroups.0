From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [cgroup] BUG: unable to handle kernel NULL pointer dereference
 at 0000001c
Date: Thu, 20 Feb 2014 10:32:57 +0800
Message-ID: <53056959.2070501@huawei.com>
References: <20140219122537.GD7735@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140219122537.GD7735@localhost>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Fengguang Wu <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On 2014/2/19 20:25, Fengguang Wu wrote:
> Greetings,
> 
> I got the below dmesg and the first bad commit is
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-next
> 
> commit ace2bee8135a3dc725958b8d08c55ee9df813d39
> Author:     Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> AuthorDate: Tue Feb 11 11:52:47 2014 -0500
> Commit:     Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> CommitDate: Tue Feb 11 11:52:47 2014 -0500
> 
>     cgroup: introduce cgroup_tree_mutex
>     
>     Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>     Acked-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> 

Thanks for the report. It was introduced by

e61734c55c24cdf11b07e52a74aec4dc4a7f4bd0 cgroup: remove cgroup->name

And It has been fixed by

cc045e3952175e84c38dad22dea14465b9fc8fb5 cgroup: deal with dummp_top in cgroup_name() and cgroup_path()

The fix has been in for-next fox about a week, so I'm curious why
you still hit this bug.

> [   97.464167] BUG: unable to handle kernel NULL pointer dereference at 0000001c
> [   97.464897] IP: [<8130f33d>] kernfs_path_locked+0x7d/0xc0
> [   97.465519] *pde = 00000000
> [   97.465960] Oops: 0000 [#1] SMP
> [   97.466936] CPU: 0 PID: 24 Comm: kworker/0:1 Tainted: G S      W    3.14.0-rc2-01592-g97162c1 #6
> [   97.467818] Workqueue: events_freezable_power_ disk_events_workfn
> [   97.468342] task: 801c7560 ti: 801d6000 task.ti: 801d6000
> [   97.468836] EIP: 0060:[<8130f33d>] EFLAGS: 00000046 CPU: 0
> [   97.469291] EIP is at kernfs_path_locked+0x7d/0xc0
> [   97.469636] EAX: 00000000 EBX: 00000000 ECX: 801d7c34 EDX: 801d7bb4
> [   97.470024] ESI: 00000046 EDI: 801d7c33 EBP: 801d7b68 ESP: 801d7b58
> [   97.470505]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> [   97.470929] CR0: 8005003b CR2: 0000001c CR3: 03b92000 CR4: 00300690
> [   97.471550] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> [   97.472155] DR6: 00000000 DR7: 00000000
> [   97.472397] Stack:
> [   97.472397]  801d7bb4 00000000 00000046 801d7bb4 801d7b80 8130fe59 00000080 929c0ce0
> [   97.472397]  929ae498 00000018 801d7c40 8199b88a 00000002 00000001 00000000 8199b650
> [   97.472397]  929ae498 00000000 00000001 801c7560 929ae5e4 929b46f8 929c0ca0 819978d0
> [   97.472397] Call Trace:
> [   97.472397]  [<8130fe59>] kernfs_path+0x49/0x80
> [   97.472397]  [<8199b88a>] cfq_find_alloc_queue+0x3fa/0x620
> [   97.472397]  [<8199b650>] ? cfq_find_alloc_queue+0x1c0/0x620
> [   97.472397]  [<819978d0>] ? cfq_put_request+0x220/0x220
> [   97.472397]  [<8199bca5>] ? cfq_set_request+0x85/0x740
> [   97.472397]  [<8111e5ce>] ? do_raw_spin_lock+0xe/0x2e0
> [   97.472397]  [<8199bb35>] cfq_get_queue+0x85/0x170
> [   97.472397]  [<8199bff7>] cfq_set_request+0x3d7/0x740
> 
