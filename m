From: Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/6] sched/deadline: Allow DL tasks on empty (cgroup v2)
 cpusets
Date: Fri, 22 Jan 2021 09:08:51 +0100
Message-ID: <20210122080851.GK10569@localhost.localdomain>
References: <cover.1610463999.git.bristot@redhat.com>
 <8380113688bd64a6deb3241ff6a0fff62b157f47.1610463999.git.bristot@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611302937;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1r1C6b8Yt+X+h4kUeUrmzS4UC5HaV/EkqiwbM/xr4OU=;
        b=NtZzJ9KD84xarm0pWCQ7v+CDNl8scVldVnC6hqfVri6m7kjg9ers2NmH73VEcloGMgTtaG
        38+Sbl3OspUwbuvZ8YMN9VDQ5t/5Ntrx0Nfmmk0VSRiJP5CbnS/fsZos5E+vNyY5d28puM
        BdEcwoymDiZaSZaAG5a4MHB2hKLHnhQ=
Content-Disposition: inline
In-Reply-To: <8380113688bd64a6deb3241ff6a0fff62b157f47.1610463999.git.bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Marco Perronet <perronet-41PbBDiSz5tAfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Valentin Schneider <valentin.schneider-5wv7dgnIgG8@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

On 12/01/21 16:53, Daniel Bristot de Oliveira wrote:
> cgroups v2 allows the cpuset controller to be enabled/disabled on
> demand. On Fedora 32, cpuset is disabled by default. To enable it,
> a user needs to:
> 
>   # cd /sys/fs/cgroup/
>   # echo +cpuset > cgroup.subtree_control
> 
> Existing cgroups will expose the cpuset interface (e.g., cpuset.cpus
> file). By default, cpuset.cpus has no CPU assigned, which means that
> existing tasks will move to a cpuset without cpus.

This is kind of confusing, though. Isn't it?

> Initially, I thought about returning an error and blocking the
> operation. However, that is indeed not needed. The cpuset without
> CPUs assigned will be a non-root cpuset, hence its cpu mask will
> be the same as the root one. So, the bandwidth was already accounted,
> and the task can proceed.
> 
> Signed-off-by: Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> Cc: Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> Cc: Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>
> Cc: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
> Cc: Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Cc: Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>
> Cc: Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Cc: Valentin Schneider <valentin.schneider-5wv7dgnIgG8@public.gmane.org>
> Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> ---
>  kernel/sched/deadline.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
> index 943aa32cc1bc..788a391657a5 100644
> --- a/kernel/sched/deadline.c
> +++ b/kernel/sched/deadline.c
> @@ -2871,6 +2871,13 @@ int dl_task_can_attach(struct task_struct *p,
>  	bool overflow;
>  	int ret;
>  
> +	/*
> +	 * The cpuset has no cpus assigned, so the thread will not
> +	 * change its affinity.

Is this always the case also in the presence of deeper hierarchies?

Thanks,
Juri

