From: Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] sched, cpuset: Fix dl_cpu_busy() panic due to empty
 cs->cpus_allowed
Date: Wed, 3 Aug 2022 07:57:21 +0200
Message-ID: <YuoOQRiZH4R0UZ6q@localhost.localdomain>
References: <20220803015451.2219567-1-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659506252;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=syL/2eT8W871dMcS7JXPVuHY+ucOOO9cLIJgDqnS+3w=;
        b=hSwqls5+kpKUxfYEqTxh8BhKdy+kiYWA3KoHjKW6sQsWiXiTs/luj2pKVt8ozWQwqHQzzQ
        odn9Eg0hFqDlHUGSFLrMyySy6zViyrOOZmSBu3ddGmgEA2DqymmHqPb9O+7AzftxLA7zMq
        AVXml/xZ8F4kmWrfWOlHTLhMRD1qOb0=
Content-Disposition: inline
In-Reply-To: <20220803015451.2219567-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Valentin Schneider <vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

On 02/08/22 21:54, Waiman Long wrote:
> With cgroup v2, the cpuset's cpus_allowed mask can be empty indicating
> that the cpuset will just use the effective cpus of its parent. So
> cpuset_can_attach() can call task_can_attach() with an empty mask.
> This can lead to cpumask_any_and() returns nr_cpu_ids causing the call
> to dl_bw_of() to crash due to percpu value access of an out of bound
> cpu value. For example,
> 
> [80468.182258] BUG: unable to handle page fault for address: ffffffff8b6648b0
>   :
> [80468.191019] RIP: 0010:dl_cpu_busy+0x30/0x2b0
>   :
> [80468.207946] Call Trace:
> [80468.208947]  cpuset_can_attach+0xa0/0x140
> [80468.209953]  cgroup_migrate_execute+0x8c/0x490
> [80468.210931]  cgroup_update_dfl_csses+0x254/0x270
> [80468.211898]  cgroup_subtree_control_write+0x322/0x400
> [80468.212854]  kernfs_fop_write_iter+0x11c/0x1b0
> [80468.213777]  new_sync_write+0x11f/0x1b0
> [80468.214689]  vfs_write+0x1eb/0x280
> [80468.215592]  ksys_write+0x5f/0xe0
> [80468.216463]  do_syscall_64+0x5c/0x80
> [80468.224287]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> Fix that by using effective_cpus instead. For cgroup v1, effective_cpus
> is the same as cpus_allowed. For v2, effective_cpus is the real cpumask
> to be used by tasks within the cpuset anyway.
> 
> Also update task_can_attach()'s 2nd argument name to cs_effective_cpus to
> reflect the change. In addition, a check is added to task_can_attach()
> to guard against the possibility that cpumask_any_and() may return a
> value >= nr_cpu_ids.
> 
> Fixes: 7f51412a415d ("sched/deadline: Fix bandwidth check/update when migrating tasks between exclusive cpusets")
> Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---

Looks good to me. Thanks for looking into it!

Acked-by: Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Best,
Juri

